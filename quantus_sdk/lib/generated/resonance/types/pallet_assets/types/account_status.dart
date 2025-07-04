// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:typed_data' as _i2;

import 'package:polkadart/scale_codec.dart' as _i1;

enum AccountStatus {
  liquid('Liquid', 0),
  frozen('Frozen', 1),
  blocked('Blocked', 2);

  const AccountStatus(
    this.variantName,
    this.codecIndex,
  );

  factory AccountStatus.decode(_i1.Input input) {
    return codec.decode(input);
  }

  final String variantName;

  final int codecIndex;

  static const $AccountStatusCodec codec = $AccountStatusCodec();

  String toJson() => variantName;
  _i2.Uint8List encode() {
    return codec.encode(this);
  }
}

class $AccountStatusCodec with _i1.Codec<AccountStatus> {
  const $AccountStatusCodec();

  @override
  AccountStatus decode(_i1.Input input) {
    final index = _i1.U8Codec.codec.decode(input);
    switch (index) {
      case 0:
        return AccountStatus.liquid;
      case 1:
        return AccountStatus.frozen;
      case 2:
        return AccountStatus.blocked;
      default:
        throw Exception('AccountStatus: Invalid variant index: "$index"');
    }
  }

  @override
  void encodeTo(
    AccountStatus value,
    _i1.Output output,
  ) {
    _i1.U8Codec.codec.encodeTo(
      value.codecIndex,
      output,
    );
  }
}
