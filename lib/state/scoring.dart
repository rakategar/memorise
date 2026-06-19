/// Gamified scoring rules shared by the summary screen and the remote sync.
/// Ported 1:1 from the original Compose `SummaryScreen` calculation.
class Scoring {
  const Scoring._();

  static int baseScore(bool isSuccess) => isSuccess ? 500 : 0;

  static int starBonus(bool isSuccess, int stars) {
    if (!isSuccess) return 0;
    switch (stars) {
      case 3:
        return 500;
      case 2:
        return 300;
      case 1:
        return 150;
      default:
        return 0;
    }
  }

  static int timeBonus(bool isSuccess, int timeSpentMs) =>
      isSuccess ? ((15000 - timeSpentMs) ~/ 20).clamp(0, 500) : 0;

  static int total(bool isSuccess, int stars, int timeSpentMs) =>
      baseScore(isSuccess) + starBonus(isSuccess, stars) + timeBonus(isSuccess, timeSpentMs);

  /// "100%" / "95%" / "90%" / "0%" — mirrors the summary accuracy label.
  static String accuracyLabel(bool isSuccess, int stars) {
    if (!isSuccess) return '0%';
    if (stars == 3) return '100%';
    if (stars == 2) return '95%';
    return '90%';
  }
}
