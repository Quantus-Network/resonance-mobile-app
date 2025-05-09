// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:polkadart/scale_codec.dart' as _i1;

typedef ReverseQueueIndex = int;

class ReverseQueueIndexCodec with _i1.Codec<ReverseQueueIndex> {
  const ReverseQueueIndexCodec();

  @override
  ReverseQueueIndex decode(_i1.Input input) {
    return _i1.U32Codec.codec.decode(input);
  }

  @override
  void encodeTo(
    ReverseQueueIndex value,
    _i1.Output output,
  ) {
    _i1.U32Codec.codec.encodeTo(
      value,
      output,
    );
  }

  @override
  int sizeHint(ReverseQueueIndex value) {
    return _i1.U32Codec.codec.sizeHint(value);
  }
}
