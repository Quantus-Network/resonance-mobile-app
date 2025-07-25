import 'dart:async';

import 'package:polkadart/polkadart.dart';
import 'package:quantus_sdk/generated/resonance/resonance.dart';
import 'package:quantus_sdk/quantus_sdk.dart';
import 'package:quantus_sdk/generated/resonance/types/sp_runtime/multiaddress/multi_address.dart'
    as multi_address;
import 'package:quantus_sdk/src/rust/api/crypto.dart' as crypto;

class BalancesService {
  static final BalancesService _instance = BalancesService._internal();
  factory BalancesService() => _instance;
  BalancesService._internal();

  final SubstrateService _substrateService = SubstrateService();

  Future<StreamSubscription<ExtrinsicStatus>> balanceTransfer(
    Account account,
    String targetAddress,
    BigInt amount,
    void Function(ExtrinsicStatus)? onStatus,
  ) async {
    try {
      final resonanceApi = Resonance(_substrateService.provider!);
      final multiDest = const multi_address.$MultiAddress().id(
        crypto.ss58ToAccountId(s: targetAddress),
      );
      final runtimeCall = resonanceApi.tx.balances.transferKeepAlive(
        dest: multiDest,
        value: amount,
      );
      // Submit the extrinsic and return its result
      return await _substrateService.submitExtrinsic(
        account,
        runtimeCall,
        onStatus:
            onStatus ??
            (data) async {
              print('type: ${data.type}, value: ${data.value}');
            },
      );
    } catch (e, stackTrace) {
      print('Failed to transfer balance: $e');
      print('Failed to transfer balance: $stackTrace');
      throw Exception('Failed to transfer balance: $e');
    }
  }
}
