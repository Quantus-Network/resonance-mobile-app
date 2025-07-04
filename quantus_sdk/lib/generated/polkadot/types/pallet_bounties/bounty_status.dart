// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:typed_data' as _i2;

import 'package:polkadart/scale_codec.dart' as _i1;
import 'package:quiver/collection.dart' as _i4;

import '../sp_core/crypto/account_id32.dart' as _i3;

abstract class BountyStatus {
  const BountyStatus();

  factory BountyStatus.decode(_i1.Input input) {
    return codec.decode(input);
  }

  static const $BountyStatusCodec codec = $BountyStatusCodec();

  static const $BountyStatus values = $BountyStatus();

  _i2.Uint8List encode() {
    final output = _i1.ByteOutput(codec.sizeHint(this));
    codec.encodeTo(this, output);
    return output.toBytes();
  }

  int sizeHint() {
    return codec.sizeHint(this);
  }

  Map<String, dynamic> toJson();
}

class $BountyStatus {
  const $BountyStatus();

  Proposed proposed() {
    return Proposed();
  }

  Approved approved() {
    return Approved();
  }

  Funded funded() {
    return Funded();
  }

  CuratorProposed curatorProposed({required _i3.AccountId32 curator}) {
    return CuratorProposed(curator: curator);
  }

  Active active({
    required _i3.AccountId32 curator,
    required int updateDue,
  }) {
    return Active(
      curator: curator,
      updateDue: updateDue,
    );
  }

  PendingPayout pendingPayout({
    required _i3.AccountId32 curator,
    required _i3.AccountId32 beneficiary,
    required int unlockAt,
  }) {
    return PendingPayout(
      curator: curator,
      beneficiary: beneficiary,
      unlockAt: unlockAt,
    );
  }

  ApprovedWithCurator approvedWithCurator({required _i3.AccountId32 curator}) {
    return ApprovedWithCurator(curator: curator);
  }
}

class $BountyStatusCodec with _i1.Codec<BountyStatus> {
  const $BountyStatusCodec();

  @override
  BountyStatus decode(_i1.Input input) {
    final index = _i1.U8Codec.codec.decode(input);
    switch (index) {
      case 0:
        return const Proposed();
      case 1:
        return const Approved();
      case 2:
        return const Funded();
      case 3:
        return CuratorProposed._decode(input);
      case 4:
        return Active._decode(input);
      case 5:
        return PendingPayout._decode(input);
      case 6:
        return ApprovedWithCurator._decode(input);
      default:
        throw Exception('BountyStatus: Invalid variant index: "$index"');
    }
  }

  @override
  void encodeTo(
    BountyStatus value,
    _i1.Output output,
  ) {
    switch (value.runtimeType) {
      case Proposed:
        (value as Proposed).encodeTo(output);
        break;
      case Approved:
        (value as Approved).encodeTo(output);
        break;
      case Funded:
        (value as Funded).encodeTo(output);
        break;
      case CuratorProposed:
        (value as CuratorProposed).encodeTo(output);
        break;
      case Active:
        (value as Active).encodeTo(output);
        break;
      case PendingPayout:
        (value as PendingPayout).encodeTo(output);
        break;
      case ApprovedWithCurator:
        (value as ApprovedWithCurator).encodeTo(output);
        break;
      default:
        throw Exception(
            'BountyStatus: Unsupported "$value" of type "${value.runtimeType}"');
    }
  }

  @override
  int sizeHint(BountyStatus value) {
    switch (value.runtimeType) {
      case Proposed:
        return 1;
      case Approved:
        return 1;
      case Funded:
        return 1;
      case CuratorProposed:
        return (value as CuratorProposed)._sizeHint();
      case Active:
        return (value as Active)._sizeHint();
      case PendingPayout:
        return (value as PendingPayout)._sizeHint();
      case ApprovedWithCurator:
        return (value as ApprovedWithCurator)._sizeHint();
      default:
        throw Exception(
            'BountyStatus: Unsupported "$value" of type "${value.runtimeType}"');
    }
  }
}

class Proposed extends BountyStatus {
  const Proposed();

  @override
  Map<String, dynamic> toJson() => {'Proposed': null};

  void encodeTo(_i1.Output output) {
    _i1.U8Codec.codec.encodeTo(
      0,
      output,
    );
  }

  @override
  bool operator ==(Object other) => other is Proposed;

  @override
  int get hashCode => runtimeType.hashCode;
}

class Approved extends BountyStatus {
  const Approved();

  @override
  Map<String, dynamic> toJson() => {'Approved': null};

  void encodeTo(_i1.Output output) {
    _i1.U8Codec.codec.encodeTo(
      1,
      output,
    );
  }

  @override
  bool operator ==(Object other) => other is Approved;

  @override
  int get hashCode => runtimeType.hashCode;
}

class Funded extends BountyStatus {
  const Funded();

  @override
  Map<String, dynamic> toJson() => {'Funded': null};

  void encodeTo(_i1.Output output) {
    _i1.U8Codec.codec.encodeTo(
      2,
      output,
    );
  }

  @override
  bool operator ==(Object other) => other is Funded;

  @override
  int get hashCode => runtimeType.hashCode;
}

class CuratorProposed extends BountyStatus {
  const CuratorProposed({required this.curator});

  factory CuratorProposed._decode(_i1.Input input) {
    return CuratorProposed(curator: const _i1.U8ArrayCodec(32).decode(input));
  }

  /// AccountId
  final _i3.AccountId32 curator;

  @override
  Map<String, Map<String, List<int>>> toJson() => {
        'CuratorProposed': {'curator': curator.toList()}
      };

  int _sizeHint() {
    int size = 1;
    size = size + const _i3.AccountId32Codec().sizeHint(curator);
    return size;
  }

  void encodeTo(_i1.Output output) {
    _i1.U8Codec.codec.encodeTo(
      3,
      output,
    );
    const _i1.U8ArrayCodec(32).encodeTo(
      curator,
      output,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(
        this,
        other,
      ) ||
      other is CuratorProposed &&
          _i4.listsEqual(
            other.curator,
            curator,
          );

  @override
  int get hashCode => curator.hashCode;
}

class Active extends BountyStatus {
  const Active({
    required this.curator,
    required this.updateDue,
  });

  factory Active._decode(_i1.Input input) {
    return Active(
      curator: const _i1.U8ArrayCodec(32).decode(input),
      updateDue: _i1.U32Codec.codec.decode(input),
    );
  }

  /// AccountId
  final _i3.AccountId32 curator;

  /// BlockNumber
  final int updateDue;

  @override
  Map<String, Map<String, dynamic>> toJson() => {
        'Active': {
          'curator': curator.toList(),
          'updateDue': updateDue,
        }
      };

  int _sizeHint() {
    int size = 1;
    size = size + const _i3.AccountId32Codec().sizeHint(curator);
    size = size + _i1.U32Codec.codec.sizeHint(updateDue);
    return size;
  }

  void encodeTo(_i1.Output output) {
    _i1.U8Codec.codec.encodeTo(
      4,
      output,
    );
    const _i1.U8ArrayCodec(32).encodeTo(
      curator,
      output,
    );
    _i1.U32Codec.codec.encodeTo(
      updateDue,
      output,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(
        this,
        other,
      ) ||
      other is Active &&
          _i4.listsEqual(
            other.curator,
            curator,
          ) &&
          other.updateDue == updateDue;

  @override
  int get hashCode => Object.hash(
        curator,
        updateDue,
      );
}

class PendingPayout extends BountyStatus {
  const PendingPayout({
    required this.curator,
    required this.beneficiary,
    required this.unlockAt,
  });

  factory PendingPayout._decode(_i1.Input input) {
    return PendingPayout(
      curator: const _i1.U8ArrayCodec(32).decode(input),
      beneficiary: const _i1.U8ArrayCodec(32).decode(input),
      unlockAt: _i1.U32Codec.codec.decode(input),
    );
  }

  /// AccountId
  final _i3.AccountId32 curator;

  /// AccountId
  final _i3.AccountId32 beneficiary;

  /// BlockNumber
  final int unlockAt;

  @override
  Map<String, Map<String, dynamic>> toJson() => {
        'PendingPayout': {
          'curator': curator.toList(),
          'beneficiary': beneficiary.toList(),
          'unlockAt': unlockAt,
        }
      };

  int _sizeHint() {
    int size = 1;
    size = size + const _i3.AccountId32Codec().sizeHint(curator);
    size = size + const _i3.AccountId32Codec().sizeHint(beneficiary);
    size = size + _i1.U32Codec.codec.sizeHint(unlockAt);
    return size;
  }

  void encodeTo(_i1.Output output) {
    _i1.U8Codec.codec.encodeTo(
      5,
      output,
    );
    const _i1.U8ArrayCodec(32).encodeTo(
      curator,
      output,
    );
    const _i1.U8ArrayCodec(32).encodeTo(
      beneficiary,
      output,
    );
    _i1.U32Codec.codec.encodeTo(
      unlockAt,
      output,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(
        this,
        other,
      ) ||
      other is PendingPayout &&
          _i4.listsEqual(
            other.curator,
            curator,
          ) &&
          _i4.listsEqual(
            other.beneficiary,
            beneficiary,
          ) &&
          other.unlockAt == unlockAt;

  @override
  int get hashCode => Object.hash(
        curator,
        beneficiary,
        unlockAt,
      );
}

class ApprovedWithCurator extends BountyStatus {
  const ApprovedWithCurator({required this.curator});

  factory ApprovedWithCurator._decode(_i1.Input input) {
    return ApprovedWithCurator(
        curator: const _i1.U8ArrayCodec(32).decode(input));
  }

  /// AccountId
  final _i3.AccountId32 curator;

  @override
  Map<String, Map<String, List<int>>> toJson() => {
        'ApprovedWithCurator': {'curator': curator.toList()}
      };

  int _sizeHint() {
    int size = 1;
    size = size + const _i3.AccountId32Codec().sizeHint(curator);
    return size;
  }

  void encodeTo(_i1.Output output) {
    _i1.U8Codec.codec.encodeTo(
      6,
      output,
    );
    const _i1.U8ArrayCodec(32).encodeTo(
      curator,
      output,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(
        this,
        other,
      ) ||
      other is ApprovedWithCurator &&
          _i4.listsEqual(
            other.curator,
            curator,
          );

  @override
  int get hashCode => curator.hashCode;
}
