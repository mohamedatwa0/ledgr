enum BiometricAvailability {
  available,
  notEnrolled,
  unsupported,
}

abstract class BiometricAuthenticator {
  Future<BiometricAvailability> availability();

  Future<bool> authenticate({required String reason});
}
