import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:flutter/material.dart';

import '../widgets/bubble_title.dart';
import '../widgets/sky_meadow_background.dart';
import '../widgets/smiling_brain.dart';

/// Branded sign-in screen. The actual auth UI is Clerk's prebuilt
/// [ClerkAuthentication] widget — configure the Clerk Dashboard to enable only
/// the Google social connection so it shows a single "Continue with Google".
class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SkyMeadowBackground(
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
              const SizedBox(height: 4),
              const Text(
                'Masuk untuk menyimpan progresmu!',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF4F46E5)),
              ),
              const SizedBox(height: 24),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
                ),
                padding: const EdgeInsets.all(16),
                child: const ClerkAuthentication(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
