import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/carvora_provider.dart';
import '../theme/carvora_theme.dart';
import 'admin_dashboard_screen.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'admin@carvora.com');
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final success = context.read<CarvoraProvider>().loginAsAdmin(
          _emailController.text,
          _passwordController.text,
        );
    if (!success) {
      setState(() => _errorMessage = 'Invalid admin credentials.');
      return;
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const AdminDashboardScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Card(
              color: CarvoraColors.surface,
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Icon(Icons.admin_panel_settings_outlined,
                          color: CarvoraColors.gold, size: 52),
                      const SizedBox(height: 20),
                      Text('ADMIN CONSOLE',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 8),
                      const Text('Sign in to manage the Carvora atelier.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: CarvoraColors.textSecondary)),
                      const SizedBox(height: 28),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Admin email',
                          prefixIcon: Icon(Icons.alternate_email),
                        ),
                        validator: (value) =>
                            value == null || !value.contains('@') ? 'Enter a valid email' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                            icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                          ),
                        ),
                        validator: (value) =>
                            value == null || value.isEmpty ? 'Enter your password' : null,
                        onFieldSubmitted: (_) => _login(),
                      ),
                      if (_errorMessage != null) ...[
                        const SizedBox(height: 12),
                        Text(_errorMessage!, style: const TextStyle(color: CarvoraColors.error)),
                      ],
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: _login,
                        icon: const Icon(Icons.login),
                        label: const Text('ENTER CONSOLE'),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Demo access: admin@carvora.com / admin123',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: CarvoraColors.textMuted, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
