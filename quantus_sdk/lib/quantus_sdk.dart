library;

import 'package:quantus_sdk/src/rust/api/crypto.dart';
import 'package:quantus_sdk/src/services/settings_service.dart';

import 'src/rust/frb_generated.dart';

export 'generated/resonance/types/quantus_runtime/runtime_call.dart';
export 'src/constants/app_constants.dart';
export 'src/extensions/color_extensions.dart';
export 'src/extensions/decimal_input_filter.dart';
export 'src/extensions/keypair_extensions.dart';
export 'src/extensions/string_extensions.dart';
export 'src/models/account.dart';
export 'src/models/event_type.dart';
export 'src/models/reversible_transfer_status.dart';
export 'src/models/sorted_transactions.dart';
export 'src/models/transaction_event.dart';
export 'src/models/transaction_state.dart';
// note we have to hide some things here because they're exported by substrate service
// should probably expise all of crypto.dart through substrateservice instead
export 'src/rust/api/crypto.dart' hide crystalAlice, crystalCharlie, crystalBob;
export 'src/services/accounts_service.dart';
export 'src/services/address_formatting_service.dart';
export 'src/services/datetime_formatting_service.dart';
export 'src/services/balances_service.dart';
export 'src/services/chain_history_service.dart';
export 'src/services/hd_wallet_service.dart';
export 'src/services/human_readable_checksum_service.dart';
export 'src/services/number_formatting_service.dart';
export 'src/services/recent_addresses_service.dart';
export 'src/services/recovery_service.dart';
export 'src/services/reversible_transfers_service.dart';
export 'src/services/settings_service.dart';
export 'src/services/substrate_service.dart';

class QuantusSdk {
  /// Initialise the SDK (loads Rust FFI, etc).
  static Future<void> init() async {
    await RustLib.init();
    await SettingsService().initialize();
    setDefaultSs58Prefix(prefix: 189);
  }
}
