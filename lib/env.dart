abstract class Env {
  static const String ttsSubscriptionKey = String.fromEnvironment(
    "TTS_SUBSCRIPTION_KEY",
  );

  static const String resendApiKey = String.fromEnvironment(
    "RESEND_API_KEY",
  );
}
