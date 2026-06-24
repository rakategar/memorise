import 'package:clerk_auth/clerk_auth.dart' as clerk;
import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../config/app_config.dart';
import '../widgets/bubble_title.dart';
import '../widgets/sky_meadow_background.dart';
import '../widgets/smiling_brain.dart';

/// Branded sign-in screen with a single custom "Lanjut dengan Google" button.
///
/// Login and sign-up both go through the same Google flow, so there is no
/// separate sign-up UI. When [AppConfig.isGoogleNativeConfigured] is set it uses
/// the native account picker (`google_sign_in` + Clerk id-token sign-in);
/// otherwise it falls back to Clerk's web OAuth flow.
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _loading = false;

  ClerkAuthState get _authState => ClerkAuth.of(context, listen: false);

  Future<void> _signInWithGoogle() async {
    if (_loading) return;
    setState(() => _loading = true);
    try {
      if (AppConfig.isGoogleNativeConfigured) {
        await _nativeGoogleSignIn();
      } else {
        await _authState.ssoSignIn(context, clerk.Strategy.oauthGoogle);
      }
    } catch (e) {
      _showError(e);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  /// Native Google account picker → exchange the id-token with Clerk.
  Future<void> _nativeGoogleSignIn() async {
    final google = GoogleSignIn.instance;
    await _authState.resetClient();
    await google.initialize(serverClientId: AppConfig.googleServerClientId);
    final account = await google.authenticate(
      scopeHint: const ['openid', 'email', 'profile'],
    );
    final token = account.authentication.idToken;
    if (token == null || !mounted) return;

    final nameParts = account.displayName?.trim().split(' ') ?? const [];
    await _authState.safelyCall(context, () async {
      await _authState.idTokenSignIn(
        provider: clerk.IdTokenProvider.google,
        token: token,
      );
      // First-time users arrive as a SignUp that may need a few fields filled.
      if (_authState.signUp case clerk.SignUp signUp
          when signUp.missingFields.isNotEmpty) {
        await _authState.attemptSignUp(
          legalAccepted: signUp.missing(clerk.Field.legalAccepted) ? true : null,
          firstName: signUp.missing(clerk.Field.firstName)
              ? (nameParts.isNotEmpty ? nameParts.first : 'Player')
              : null,
          lastName: signUp.missing(clerk.Field.lastName)
              ? (nameParts.length > 1 ? nameParts.skip(1).join(' ') : '-')
              : null,
        );
      }
    });
  }

  void _showError(Object error) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Gagal masuk: $error')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SkyMeadowBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 24),
                const SmilingBrain(size: 130),
                const SizedBox(height: 14),
                const BubbleTitle(),
                const SizedBox(height: 6),
                const Text(
                  'Masuk untuk menyimpan progresmu!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4F46E5),
                    decoration: TextDecoration.none,
                  ),
                ),
                const SizedBox(height: 32),
                FractionallySizedBox(
                  widthFactor: 0.92,
                  child: _GoogleButton(
                    loading: _loading,
                    onPressed: _signInWithGoogle,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A wide, branded "Lanjut dengan Google" button with the multicolor G mark.
class _GoogleButton extends StatelessWidget {
  const _GoogleButton({required this.loading, required this.onPressed});

  final bool loading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 58,
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF1F2937),
          elevation: 4,
          shadowColor: Colors.black.withValues(alpha: 0.18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: const BorderSide(color: Color(0xFFE2E8F0), width: 1.5),
          ),
        ),
        child: loading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2.5),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const _GoogleLogo(size: 24),
                  const SizedBox(width: 12),
                  const Text(
                    'Lanjut dengan Google',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

/// The Google "G" rendered as a simple multicolor mark (no asset needed).
class _GoogleLogo extends StatelessWidget {
  const _GoogleLogo({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Text(
      'G',
      style: TextStyle(
        fontSize: size,
        fontWeight: FontWeight.w900,
        color: const Color(0xFF4285F4),
        decoration: TextDecoration.none,
        height: 1,
      ),
    );
  }
}
