enum AuthState {
  unauthenticated, loading, authenticated;
}

abstract interface class ContactAuthApi {
  Stream<AuthState> get authState;
  
  Future<void> loginWithGoogle();
  Future<void> logout();
}