import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Sign in with email and password
  Future<AuthResponse> signInWithEmailPassword(
    String email,
    String password,
  ) async {
    final response = await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
    return response;
  }

  // Sign up with email and password
  Future<AuthResponse> signUpWithEmailPassword(
    String email,
    String password,
  ) async {
    final response = await _supabase.auth.signUp(
      email: email,
      password: password,
    );
    return response;
  }

  // Sign out
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  // Get user email
  String? getCurrentUserEmail() {
    final session = _supabase.auth.currentSession;
    final user = session?.user;
    return user?.email;
  }

  // Mengambil data profil user
  Future<Map<String, dynamic>> getUserProfile() async {
    final user = _supabase.auth.currentUser;
    return await _supabase
        .from('profiles')
        .select()
        .eq('id', user!.id)
        .single();
  }

  // features/auth/auth_service.dart

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    final email = _supabase.auth.currentUser?.email;

    // 1. Verifikasi password lama dengan mencoba login ulang
    await _supabase.auth.signInWithPassword(
      email: email!,
      password: oldPassword,
    );

    // 2. Jika login berhasil (tidak throw error), lakukan update password
    await _supabase.auth.updateUser(UserAttributes(password: newPassword));
  }

  Stream<Map<String, dynamic>> getProfileStream() {
    final userId = _supabase.auth.currentUser!.id;
    return _supabase
        .from('profiles')
        .stream(primaryKey: ['id'])
        .eq('id', userId)
        .map((data) => data.isNotEmpty ? data.first : {});
  }

  Future<String> uploadAvatar({
    required Uint8List fileBytes,
    required String fileName,
    required String extension,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw 'User tidak ditemukan';

    // Buat path unik
    final filePath =
        'public/${user.id}_${DateTime.now().millisecondsSinceEpoch}.$extension';

    // Gunakan uploadBinary untuk mengunggah byte
    await _supabase.storage.from('avatars').uploadBinary(filePath, fileBytes);

    // Dapatkan URL Publik
    return _supabase.storage.from('avatars').getPublicUrl(filePath);
  }

  // Update data profil (username, full_name, avatar_url, currency)
  Future<void> updateProfile({
    required String username,
    required String fullName,
    required String avatarUrl,
    required String currency,
  }) async {
    final user = _supabase.auth.currentUser;
    await _supabase.from('profiles').upsert({
      'id': user!.id,
      'username': username,
      'full_name': fullName,
      'avatar_url': avatarUrl,
      'currency': currency,
      'updated_at': DateTime.now().toIso8601String(),
    });
  }
}
