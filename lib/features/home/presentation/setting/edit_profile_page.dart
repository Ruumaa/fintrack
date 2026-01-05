import 'package:fintrack/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:fintrack/features/auth/auth_service.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _authService = AuthService();
  final _usernameController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _avatarController = TextEditingController();
  final _emailController = TextEditingController();
  String _selectedCurrency = 'IDR';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  void _loadProfileData() async {
    try {
      final data = await _authService.getUserProfile();
      setState(() {
        _usernameController.text = data['username'] ?? '';
        _fullNameController.text = data['full_name'] ?? '';
        _avatarController.text = data['avatar_url'] ?? '';
        _emailController.text = data['email'] ?? '';
        _selectedCurrency = data['currency'] ?? 'IDR';
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Gagal memuat profil: $e")));
      }
    }
  }

  void _saveProfile() async {
    setState(() => _isLoading = true);
    try {
      await _authService.updateProfile(
        username: _usernameController.text,
        fullName: _fullNameController.text,
        avatarUrl: _avatarController.text,
        currency: _selectedCurrency,
      );
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Profil diperbarui!")));
        Navigator.pop(context);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  bool _isUploading = false; // Untuk loading indikator khusus foto

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    if (image != null) {
      setState(() => _isUploading = true);
      try {
        // PERBAIKAN: Baca gambar sebagai Bytes (Uint8List), bukan File
        final bytes = await image.readAsBytes();
        final extension = image.name.split('.').last;

        // 1. Upload ke Storage menggunakan bytes
        final url = await _authService.uploadAvatar(
          fileBytes: bytes,
          fileName: image.name,
          extension: extension,
        );

        setState(() {
          _avatarController.text = url;
          _isUploading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Foto berhasil diunggah!")),
        );
      } catch (e) {
        setState(() => _isUploading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Gagal unggah foto: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profil")),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Bagian Foto Profil
                    Center(
                      child: Stack(
                        // Stack hanya digunakan untuk foto + icon kamera
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.grey[200],
                            backgroundImage:
                                _avatarController.text.isNotEmpty
                                    ? NetworkImage(_avatarController.text)
                                    : const NetworkImage(
                                      "https://via.placeholder.com/150",
                                    ),
                            child:
                                _isUploading
                                    ? const CircularProgressIndicator()
                                    : null,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: _isUploading ? null : _pickImage,
                              child: CircleAvatar(
                                radius: 18,
                                backgroundColor: AppColor.primary,
                                child: const Icon(
                                  Icons.camera_alt,
                                  size: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Bagian Form
                    _buildTextField(_usernameController, "Username"),
                    const SizedBox(height: 16),
                    _buildTextField(_fullNameController, "Nama Lengkap"),
                    const SizedBox(height: 16),
                    _buildTextField(
                      _emailController,
                      "Email",
                      readOnly: true,
                      isEmail: true,
                    ),
                    const SizedBox(height: 16),

                    // _buildTextField(
                    //   _avatarController,
                    //   "URL Avatar",
                    //   readOnly: true,
                    // ),
                    // const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedCurrency,
                      decoration: const InputDecoration(
                        labelText: "Mata Uang",
                        border: OutlineInputBorder(),
                      ),
                      items:
                          ['IDR', 'USD', 'EUR', 'JPY']
                              .map(
                                (c) =>
                                    DropdownMenuItem(value: c, child: Text(c)),
                              )
                              .toList(),
                      onChanged:
                          (val) => setState(() => _selectedCurrency = val!),
                    ),
                    const SizedBox(height: 32),

                    ElevatedButton(
                      onPressed: _saveProfile,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: AppColor.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Simpan Perubahan",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }

  Widget _buildTextField(
    TextEditingController ctrl,
    String label, {
    bool readOnly = false,
    bool isEmail = false,
  }) {
    return TextField(
      controller: ctrl,
      readOnly: readOnly,
      enabled: !isEmail,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: isEmail ? Colors.grey : AppColor.primary),
        border: const OutlineInputBorder(),
        filled: isEmail,
        // Warna background abu-abu samar jika email
        fillColor: isEmail ? Colors.grey[200] : Colors.transparent,
        // Menghilangkan kursor jika disabled
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
      ),
    );
  }
}
