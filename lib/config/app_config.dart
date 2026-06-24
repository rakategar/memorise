import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Thin wrapper around the values loaded from `.env` (via flutter_dotenv).
/// Call [AppConfig.load] once at startup before reading any field.
class AppConfig {
  const AppConfig._();

  static Future<void> load() => dotenv.load(fileName: '.env');

  static String get clerkPublishableKey => dotenv.maybeGet('CLERK_PUBLISHABLE_KEY') ?? '';

  /// Google Cloud OAuth **Web** client ID, used by the native Google sign-in
  /// (`google_sign_in`) as `serverClientId` so Clerk can verify the id-token.
  static String get googleServerClientId => dotenv.maybeGet('GOOGLE_SERVER_CLIENT_ID') ?? '';

  /// Whether the native Google account-picker flow is configured.
  static bool get isGoogleNativeConfigured => googleServerClientId.trim().isNotEmpty;

  static String get spreadsheetId => dotenv.maybeGet('GOOGLE_SHEETS_SPREADSHEET_ID') ?? '';

  static String get sheetsCredentials => dotenv.maybeGet('GOOGLE_SHEETS_CREDENTIALS') ?? '';

  /// Whether the Google Sheets sync is configured (both id + credentials present).
  static bool get isSheetsConfigured =>
      spreadsheetId.trim().isNotEmpty && sheetsCredentials.trim().isNotEmpty;

  /// Whether Clerk auth is configured.
  static bool get isClerkConfigured => clerkPublishableKey.trim().isNotEmpty;
}
