// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:typed_data' as _i2;

import 'package:polkadart/scale_codec.dart' as _i1;

/// Errors that can be returned by this pallet.
///
/// Errors tell users that something went wrong so it's important that their naming is
/// informative. Similar to events, error documentation is added to a node's metadata so it's
/// equally important that they have helpful documentation associated with them.
///
/// This type of runtime error can be up to 4 bytes in size should you want to return additional
/// information.
enum Error {
  /// The value retrieved was `None` as no value was previously set.
  noneValue('NoneValue', 0),

  /// There was an attempt to increment the value in storage over `u32::MAX`.
  storageOverflow('StorageOverflow', 1);

  const Error(
    this.variantName,
    this.codecIndex,
  );

  factory Error.decode(_i1.Input input) {
    return codec.decode(input);
  }

  final String variantName;

  final int codecIndex;

  static const $ErrorCodec codec = $ErrorCodec();

  String toJson() => variantName;
  _i2.Uint8List encode() {
    return codec.encode(this);
  }
}

class $ErrorCodec with _i1.Codec<Error> {
  const $ErrorCodec();

  @override
  Error decode(_i1.Input input) {
    final index = _i1.U8Codec.codec.decode(input);
    switch (index) {
      case 0:
        return Error.noneValue;
      case 1:
        return Error.storageOverflow;
      default:
        throw Exception('Error: Invalid variant index: "$index"');
    }
  }

  @override
  void encodeTo(
    Error value,
    _i1.Output output,
  ) {
    _i1.U8Codec.codec.encodeTo(
      value.codecIndex,
      output,
    );
  }
}
