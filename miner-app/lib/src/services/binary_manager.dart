import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;

class DownloadProgress {
  final int downloadedBytes;
  final int totalBytes;

  DownloadProgress(this.downloadedBytes, this.totalBytes);
}

class BinaryManager {
  static const _repoOwner = 'Quantus-Network';
  static const _repoName = 'chain';
  static const _binary = 'quantus-node';

  // External miner constants
  static const _minerRepoName = 'quantus-miner';
  static const _minerBinary = 'external-miner';
  static const _minerReleaseBinary =
      'quantus-miner'; // The actual binary name in releases

  static Future<String> getQuantusHomeDirectoryPath() async {
    final dir = Directory(p.join(_home(), '.quantus'));
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir.path;
  }

  static Future<String> getNodeBinaryFilePath() async {
    final cacheDir = await _getCacheDir();
    return p.join(cacheDir.path, _binary);
  }

  static Future<String> getExternalMinerBinaryFilePath() async {
    final cacheDir = await _getCacheDir();
    return p.join(cacheDir.path, _minerBinary);
  }

  static Future<bool> hasBinary() async {
    final binPath = await getNodeBinaryFilePath();
    return File(binPath).exists();
  }

  static Future<bool> hasExternalMinerBinary() async {
    final binPath = await getExternalMinerBinaryFilePath();
    return File(binPath).exists();
  }

  static Future<File> ensureNodeBinary({
    void Function(DownloadProgress progress)? onProgress,
  }) async {
    final binPath = await getNodeBinaryFilePath();
    final binFile = File(binPath);

    if (await binFile.exists()) {
      // If file exists, report 100% progress and return
      onProgress?.call(
        DownloadProgress(1, 1),
      ); // Simulate 100% if already downloaded
      return binFile;
    }

    // 2. find latest tag on GitHub
    final rel = await http.get(
      Uri.parse(
        'https://api.github.com/repos/$_repoOwner/$_repoName/releases/latest',
      ),
    );
    final tag = jsonDecode(rel.body)['tag_name'] as String;

    print('found latest tag: $tag');

    // 3. pick asset name like the shell script
    final target = _targetTriple();
    final asset = '$_binary-$tag-$target.tar.gz';
    final url =
        'https://github.com/$_repoOwner/$_repoName/releases/download/$tag/$asset';

    // 4. download
    final cacheDir = await _getCacheDir();
    final tgz = File(p.join(cacheDir.path, asset));

    final client = http.Client();
    try {
      final request = http.Request('GET', Uri.parse(url));
      final response = await client.send(request);

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to download binary: ${response.statusCode} ${response.reasonPhrase}',
        );
      }

      final totalBytes = response.contentLength ?? -1;
      int downloadedBytes = 0;
      List<int> allBytes = [];

      await for (var chunk in response.stream) {
        allBytes.addAll(chunk);
        downloadedBytes += chunk.length;
        if (totalBytes > 0) {
          onProgress?.call(DownloadProgress(downloadedBytes, totalBytes));
        } else {
          // If totalBytes is unknown, we can't show a percentage,
          // but we can still report bytes downloaded if needed, or just a generic progress.
          // For now, let's report progress with totalBytes as 0 if unknown.
          onProgress?.call(DownloadProgress(downloadedBytes, 0));
        }
      }
      await tgz.writeAsBytes(allBytes);
      // Ensure 100% is reported at the end if not already due to chunking.
      if (totalBytes > 0 && downloadedBytes < totalBytes) {
        // This case should ideally not happen if stream ends correctly.
        onProgress?.call(DownloadProgress(totalBytes, totalBytes));
      } else if (totalBytes <= 0 && downloadedBytes > 0) {
        // If total was unknown, still send a final "completed" with what we got.
        onProgress?.call(DownloadProgress(downloadedBytes, downloadedBytes));
      }
    } finally {
      client.close();
    }

    // 5. extract
    await Process.run('tar', ['-xzf', tgz.path, '-C', cacheDir.path]);
    if (!Platform.isWindows) await Process.run('chmod', ['+x', binPath]);

    return binFile;
  }

  static Future<File> ensureExternalMinerBinary({
    void Function(DownloadProgress progress)? onProgress,
  }) async {
    final binPath = await getExternalMinerBinaryFilePath();
    final binFile = File(binPath);

    print('DEBUG: Checking for external miner at path: $binPath');

    if (await binFile.exists()) {
      // If file exists, report 100% progress and return
      print('DEBUG: External miner binary already exists at $binPath');
      onProgress?.call(
        DownloadProgress(1, 1),
      ); // Simulate 100% if already downloaded
      return binFile;
    }

    print(
      'DEBUG: External miner binary not found, starting download process...',
    );

    // 2. find latest tag on GitHub
    final releaseUrl =
        'https://api.github.com/repos/$_repoOwner/$_minerRepoName/releases/latest';
    print('DEBUG: Fetching latest release from: $releaseUrl');

    final rel = await http.get(Uri.parse(releaseUrl));
    // print('DEBUG: GitHub API response status: ${rel.statusCode}');
    // print('DEBUG: GitHub API response body: ${rel.body}');

    final releaseData = jsonDecode(rel.body);
    final tag = releaseData['tag_name'] as String;

    print('DEBUG: Found latest external miner tag: $tag');

    // 3. pick asset name to match actual GitHub releases
    // The releases use: quantus-miner-{platform}-{arch}
    String platform;
    String arch;

    if (Platform.isMacOS) {
      platform = 'macos';
    } else if (Platform.isLinux) {
      platform = 'linux';
    } else if (Platform.isWindows) {
      platform = 'windows';
    } else {
      throw Exception('Unsupported platform: ${Platform.operatingSystem}');
    }

    if (Platform.version.contains('arm64') ||
        Platform.version.contains('aarch64')) {
      arch = 'aarch64';
    } else {
      arch = 'x86_64';
    }

    final asset = Platform.isWindows
        ? '$_minerReleaseBinary-$platform-$arch.exe'
        : '$_minerReleaseBinary-$platform-$arch';

    print('DEBUG: Looking for asset: $asset');

    final url =
        'https://github.com/$_repoOwner/$_minerRepoName/releases/download/$tag/$asset';
    // print('DEBUG: Download URL: $url');

    // Check if the asset exists in the release
    final assets = releaseData['assets'] as List;
    print('DEBUG: Available assets in release:');
    bool assetFound = false;
    for (var assetInfo in assets) {
      print('  - ${assetInfo['name']} (${assetInfo['browser_download_url']})');
      if (assetInfo['name'] == asset) {
        assetFound = true;
      }
    }

    if (!assetFound) {
      throw Exception(
        'Asset $asset not found in release. Available assets: ${assets.map((a) => a['name']).join(', ')}',
      );
    }

    // 4. download the binary directly (no compression)
    final cacheDir = await _getCacheDir();
    final tempBinaryFile = File(p.join(cacheDir.path, asset));
    print('DEBUG: Will download to: ${tempBinaryFile.path}');

    final client = http.Client();
    try {
      final request = http.Request('GET', Uri.parse(url));
      final response = await client.send(request);

      print('DEBUG: Download response status: ${response.statusCode}');
      if (response.statusCode != 200) {
        throw Exception(
          'Failed to download external miner binary: ${response.statusCode} ${response.reasonPhrase}',
        );
      }

      final totalBytes = response.contentLength ?? -1;
      print('DEBUG: Expected download size: $totalBytes bytes');
      int downloadedBytes = 0;
      List<int> allBytes = [];

      await for (var chunk in response.stream) {
        allBytes.addAll(chunk);
        downloadedBytes += chunk.length;
        if (totalBytes > 0) {
          onProgress?.call(DownloadProgress(downloadedBytes, totalBytes));
        } else {
          // If totalBytes is unknown, we can't show a percentage,
          // but we can still report bytes downloaded if needed, or just a generic progress.
          // For now, let's report progress with totalBytes as 0 if unknown.
          onProgress?.call(DownloadProgress(downloadedBytes, 0));
        }
      }
      await tempBinaryFile.writeAsBytes(allBytes);
      print(
        'DEBUG: Downloaded ${allBytes.length} bytes to ${tempBinaryFile.path}',
      );

      // Ensure 100% is reported at the end if not already due to chunking.
      if (totalBytes > 0 && downloadedBytes < totalBytes) {
        // This case should ideally not happen if stream ends correctly.
        onProgress?.call(DownloadProgress(totalBytes, totalBytes));
      } else if (totalBytes <= 0 && downloadedBytes > 0) {
        // If total was unknown, still send a final "completed" with what we got.
        onProgress?.call(DownloadProgress(downloadedBytes, downloadedBytes));
      }
    } finally {
      client.close();
    }

    // 5. Move the downloaded binary to the expected location and make executable
    print('DEBUG: Moving binary from ${tempBinaryFile.path} to $binPath');
    await tempBinaryFile.rename(binPath);

    // List contents of cache dir to see what we have
    print('DEBUG: Contents of cache directory after download:');
    final cacheDirContents = await cacheDir.list().toList();
    for (var item in cacheDirContents) {
      print('  - ${item.path}');
    }

    if (!Platform.isWindows) {
      print('DEBUG: Setting executable permissions on $binPath');
      final chmodResult = await Process.run('chmod', ['+x', binPath]);
      print('DEBUG: chmod exit code: ${chmodResult.exitCode}');
      if (chmodResult.exitCode != 0) {
        print('DEBUG: chmod stderr: ${chmodResult.stderr}');
      }
    }

    // Final check
    if (await binFile.exists()) {
      print('DEBUG: External miner binary successfully created at $binPath');
    } else {
      print(
        'DEBUG: ERROR - External miner binary still not found at $binPath after download!',
      );
      throw Exception(
        'External miner binary not found after download at $binPath',
      );
    }

    return binFile;
  }

  static Future<File> getNodeKeyFile() async {
    final quantusHome = await getQuantusHomeDirectoryPath();
    final nodeKeyFile = File(p.join(quantusHome, 'node_key.p2p'));
    return nodeKeyFile;
  }

  static Future<File> ensureNodeKeyFile() async {
    final nodeKeyFile = await getNodeKeyFile();

    // Crude check: if file exists and is not empty or dummy, assume it's ok.
    // A more robust check would be to try to parse it, but that's complex.
    if (await nodeKeyFile.exists()) {
      final content = await nodeKeyFile.readAsString();
      if (content.trim().isNotEmpty &&
          content.trim() != 'dummy_node_key_content_for_testing') {
        print('Node key file already exists and seems valid: $content');
        return nodeKeyFile;
      }
    }

    print('Node key file not found or invalid. Generating new key...');
    final nodeBinaryPath = await getNodeBinaryFilePath();
    if (!await File(nodeBinaryPath).exists()) {
      throw Exception(
        'Cannot generate node key: quantus-node binary not found at $nodeBinaryPath. Run ensureNodeBinary first.',
      );
    }

    try {
      final processResult = await Process.run(
        nodeBinaryPath,
        ['key', 'generate-node-key'], // Common Substrate command
      );

      if (processResult.exitCode == 0) {
        final outputLines = processResult.stdout.toString().trim().split('\n');
        // if (outputLines.length < 2) {
        //   throw Exception(
        //       'Failed to generate node key: command output did not contain enough lines. Output: ${processResult.stdout}');
        // }
        final nodeKey = outputLines.last
            .trim(); // The secret key is the last line

        if (nodeKey.isEmpty) {
          throw Exception(
            'Failed to generate node key: extracted secret key was empty. Stderr: ${processResult.stderr}',
          );
        }
        await nodeKeyFile.writeAsString(nodeKey);
        print('Successfully generated and saved node key: $nodeKey');
        return nodeKeyFile;
      } else {
        throw Exception(
          'Failed to generate node key. Exit code: ${processResult.exitCode}\nStderr: ${processResult.stderr}\nStdout: ${processResult.stdout}',
        );
      }
    } catch (e) {
      print('Error generating node key: $e');
      rethrow; // Rethrow the exception to be handled by the caller
    }
  }

  /* helpers */
  static Future<Directory> _getCacheDir() async => Directory(
    p.join(await getQuantusHomeDirectoryPath(), 'bin'),
  ).create(recursive: true);

  static String _home() =>
      Platform.environment['HOME'] ?? Platform.environment['USERPROFILE']!;

  static String _targetTriple() {
    final os = Platform.isMacOS ? 'apple-darwin' : 'unknown-linux-gnu';
    final arch =
        Platform.version.contains('arm64') ||
            Platform.version.contains('aarch64')
        ? 'aarch64'
        : 'x86_64';
    return '$arch-$os';
  }
}
