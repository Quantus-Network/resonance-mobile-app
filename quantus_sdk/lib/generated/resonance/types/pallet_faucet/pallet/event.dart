// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:typed_data' as _i2;

import 'package:polkadart/scale_codec.dart' as _i1;
import 'package:quiver/collection.dart' as _i4;

import '../../sp_core/crypto/account_id32.dart' as _i3;

/// The `Event` enum of this pallet
abstract class Event {
  const Event();

  factory Event.decode(_i1.Input input) {
    return codec.decode(input);
  }

  static const $EventCodec codec = $EventCodec();

  static const $Event values = $Event();

  _i2.Uint8List encode() {
    final output = _i1.ByteOutput(codec.sizeHint(this));
    codec.encodeTo(this, output);
    return output.toBytes();
  }

  int sizeHint() {
    return codec.sizeHint(this);
  }

  Map<String, Map<String, dynamic>> toJson();
}

class $Event {
  const $Event();

  TokensMinted tokensMinted({
    required _i3.AccountId32 recipient,
    required BigInt amount,
  }) {
    return TokensMinted(
      recipient: recipient,
      amount: amount,
    );
  }
}

class $EventCodec with _i1.Codec<Event> {
  const $EventCodec();

  @override
  Event decode(_i1.Input input) {
    final index = _i1.U8Codec.codec.decode(input);
    switch (index) {
      case 0:
        return TokensMinted._decode(input);
      default:
        throw Exception('Event: Invalid variant index: "$index"');
    }
  }

  @override
  void encodeTo(
    Event value,
    _i1.Output output,
  ) {
    switch (value.runtimeType) {
      case TokensMinted:
        (value as TokensMinted).encodeTo(output);
        break;
      default:
        throw Exception(
            'Event: Unsupported "$value" of type "${value.runtimeType}"');
    }
  }

  @override
  int sizeHint(Event value) {
    switch (value.runtimeType) {
      case TokensMinted:
        return (value as TokensMinted)._sizeHint();
      default:
        throw Exception(
            'Event: Unsupported "$value" of type "${value.runtimeType}"');
    }
  }
}

/// Tokens were successfully transferred
class TokensMinted extends Event {
  const TokensMinted({
    required this.recipient,
    required this.amount,
  });

  factory TokensMinted._decode(_i1.Input input) {
    return TokensMinted(
      recipient: const _i1.U8ArrayCodec(32).decode(input),
      amount: _i1.U128Codec.codec.decode(input),
    );
  }

  /// T::AccountId
  final _i3.AccountId32 recipient;

  /// BalanceOf<T>
  final BigInt amount;

  @override
  Map<String, Map<String, dynamic>> toJson() => {
        'TokensMinted': {
          'recipient': recipient.toList(),
          'amount': amount,
        }
      };

  int _sizeHint() {
    int size = 1;
    size = size + const _i3.AccountId32Codec().sizeHint(recipient);
    size = size + _i1.U128Codec.codec.sizeHint(amount);
    return size;
  }

  void encodeTo(_i1.Output output) {
    _i1.U8Codec.codec.encodeTo(
      0,
      output,
    );
    const _i1.U8ArrayCodec(32).encodeTo(
      recipient,
      output,
    );
    _i1.U128Codec.codec.encodeTo(
      amount,
      output,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(
        this,
        other,
      ) ||
      other is TokensMinted &&
          _i4.listsEqual(
            other.recipient,
            recipient,
          ) &&
          other.amount == amount;

  @override
  int get hashCode => Object.hash(
        recipient,
        amount,
      );
}
