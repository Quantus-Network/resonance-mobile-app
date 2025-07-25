class AppConstants {
  static const String appName = 'Quantus Wallet';
  static const String tokenSymbol = 'QUAN';

  // static const String rpcEndpoint = 'ws://127.0.0.1:9944'; // local testing
  // static const String graphQlEndpoint = 'http://127.0.0.1:4350'; // local testing

  static const String rpcEndpoint = 'wss://a.t.res.fm:443';
  static const String graphQlEndpoint = 'https://gql.res.fm';
  static const String explorerEndpoint = 'https://explorer.quantus.com';
  static const String helpAndSupportUrl = 'https://t.me/quantustechsupport';
  static const String termsOfServiceUrl =
      'https://quantus.com/terms-and-privacy.html';

  // Development accounts
  static const String crystalAlice = '//Crystal Alice';
  static const String crystalBob = '//Crystal Bob';
  static const String crystalCharlie = '//Crystal Charlie';

  // Shared Preferences keys
  static const String hasWalletKey = 'has_wallet';
  static const String mnemonicKey = 'mnemonic';
  static const String accountIdKey = 'account_id';

  // Reversible time settings
  static const int defaultReversibleTimeSeconds = 600; // 10 minutes

  // Digits of precision
  static const int decimals = 12;
  static const int ss58prefix = 189;

  // Default sheet height in percentage of screen height
  static const double sendingSheetHeightFraction = 0.72;
}
