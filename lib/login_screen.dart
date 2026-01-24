import 'package:flutter/material.dart';
import 'services/auth_service.dart';
import 'kurs_uebersicht.dart';
import 'core/app_styles.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;
  bool _isLoading = false;
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return "Bitte gib deine E-Mail ein.";
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) return "Bitte gib eine gültige E-Mail-Adresse ein.";
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return "Bitte gib dein Passwort ein.";
    if (value.length < 6) return "Das Passwort muss mindestens 6 Zeichen lang sein.";
    return null;
  }

  Future<void> _resetPassword() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Bitte gib erst deine E-Mail ein."), backgroundColor: AppStyles.primaryOrange));
      _emailFocusNode.requestFocus();
      return;
    }
    setState(() => _isLoading = true);
    try {
      await AuthService().sendPasswordResetEmail(email: email);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("E-Mail zum Passwort-Reset wurde gesendet!"), backgroundColor: AppStyles.sageGreen));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Fehler: $e"), backgroundColor: Colors.red));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      await AuthService().login(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      await AuthService().authStateChanges.first;
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const KursUebersicht()),
        );
      }
    } catch (e) {
      if (mounted) {
        String errorMsg = e.toString();
        if (errorMsg.contains('XMLHttpRequest error')) {
          errorMsg =
              "Verbindungsfehler (CORS). Bitte stelle sicher, dass die neue Domain in Appwrite unter 'Platforms' hinzugefügt wurde.";
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMsg),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 8),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.bgColor,
      appBar: AppBar(
        title: Text("Anmeldung", style: AppStyles.headingStyle.copyWith(fontSize: 18)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppStyles.softBrown, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: AppStyles.screenPadding,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: AppStyles.spacingL - AppStyles.spacingS), // 20px
              const Icon(Icons.lock_outline, size: 80, color: AppStyles.primaryOrange),
              SizedBox(height: AppStyles.spacingXL + AppStyles.spacingS), // 40px
              Text("Willkommen zurück", style: AppStyles.titleStyle, textAlign: TextAlign.center),
              SizedBox(height: AppStyles.spacingM - AppStyles.spacingS), // 12px
              Text("Melde dich mit deinem Kurs-Account an.", style: AppStyles.bodyStyle, textAlign: TextAlign.center),
              AppStyles.spacingXXLBox,
              
              _buildTextField(
                controller: _emailController,
                focusNode: _emailFocusNode,
                label: "E-Mail",
                icon: Icons.email_outlined,
                validator: _validateEmail,
                textInputAction: TextInputAction.next,
                onSubmitted: (_) => _passwordFocusNode.requestFocus(),
              ),
              SizedBox(height: AppStyles.spacingL - AppStyles.spacingS), // 20px
              _buildTextField(
                controller: _passwordController,
                focusNode: _passwordFocusNode,
                label: "Passwort",
                icon: Icons.lock_outlined,
                isPassword: true,
                validator: _validatePassword,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _login(),
              ),
              
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _isLoading ? null : _resetPassword,
                  child: Text("Passwort vergessen?", style: AppStyles.bodyStyle.copyWith(color: AppStyles.primaryOrange, fontWeight: FontWeight.bold)),
                ),
              ),
              SizedBox(height: AppStyles.spacingXL + AppStyles.spacingS), // 40px
              
              ElevatedButton(
                onPressed: _isLoading ? null : _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppStyles.primaryOrange,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: AppStyles.spacingL - AppStyles.spacingS), // 20px
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                  elevation: 0,
                ),
                child: _isLoading
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)))
                    : const Text("Einloggen", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    required IconData icon,
    bool isPassword = false,
    String? Function(String?)? validator,
    void Function(String)? onSubmitted,
    TextInputAction? textInputAction,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      obscureText: isPassword && !_passwordVisible,
      validator: validator,
      onFieldSubmitted: onSubmitted,
      textInputAction: textInputAction,
      style: AppStyles.bodyStyle.copyWith(fontWeight: FontWeight.bold),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppStyles.softBrown.withOpacity(0.5)),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _passwordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey,
                ),
                onPressed:
                    () => setState(() => _passwordVisible = !_passwordVisible),
              )
            : null,
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppStyles.spacingL,
          vertical: AppStyles.spacingL - AppStyles.spacingS, // 20px
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(color: Colors.grey.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide:
              const BorderSide(color: AppStyles.primaryOrange, width: 1.5),
        ),
      ),
    );
  }
}
