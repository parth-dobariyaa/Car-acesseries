import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/carvora_provider.dart';
import '../theme/carvora_theme.dart';
import 'admin_login_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLogin = false;
  bool _obscurePassword = true;
  String? _message;
  bool _messageIsError = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final provider = context.read<CarvoraProvider>();
    final success = _isLogin
        ? provider.loginUser(_emailController.text, _passwordController.text)
        : provider.registerUser(_emailController.text, _passwordController.text);

    if (!success) {
      setState(() {
        _message = _isLogin
            ? 'Email or password is incorrect.'
            : 'Registration could not be completed.';
        _messageIsError = true;
      });
      return;
    }

    if (!_isLogin) {
      setState(() {
        _isLogin = true;
        _message = 'Registration complete. Please log in to continue.';
        _messageIsError = false;
        _passwordController.clear();
      });
    }
  }

  void _openAdminLogin() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const AdminLoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.sizeOf(context).width > 800;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 980),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isDesktop) ...[
                  const Expanded(child: _BrandPanel()),
                  const SizedBox(width: 48),
                ],
                SizedBox(width: isDesktop ? 400 : 500, child: _buildForm()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() => Card(
        color: CarvoraColors.surface,
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (!MediaQuery.sizeOf(context).width.isFinite ||
                    MediaQuery.sizeOf(context).width <= 800)
                  const _CarvoraLogo(),
                Text(_isLogin ? 'Welcome back' : 'Create your account',
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(
                  _isLogin
                      ? 'Sign in to continue to your CARVORA atelier.'
                      : 'Register first to explore bespoke automotive upgrades.',
                  style: const TextStyle(color: CarvoraColors.textSecondary),
                ),
                const SizedBox(height: 24),
                if (!_isLogin) ...[
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Full name',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Enter your name'
                        : null,
                  ),
                  const SizedBox(height: 14),
                ],
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email address',
                    prefixIcon: Icon(Icons.alternate_email),
                  ),
                  validator: (value) => value == null || !value.contains('@')
                      ? 'Enter a valid email'
                      : null,
                ),
                const SizedBox(height: 14),
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
                  validator: (value) => value == null || value.length < 6
                      ? 'Use at least 6 characters'
                      : null,
                  onFieldSubmitted: (_) => _submit(),
                ),
                if (_message != null) ...[
                  const SizedBox(height: 14),
                  Text(_message!,
                      style: TextStyle(
                          color: _messageIsError ? CarvoraColors.error : CarvoraColors.success)),
                ],
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _submit,
                  child: Text(_isLogin ? 'SIGN IN' : 'REGISTER'),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => setState(() {
                    _isLogin = !_isLogin;
                    _message = null;
                    _passwordController.clear();
                  }),
                  child: Text(_isLogin
                      ? 'New to CARVORA? Register here'
                      : 'Already registered? Sign in'),
                ),
                const Divider(height: 28),
                OutlinedButton.icon(
                  onPressed: _openAdminLogin,
                  icon: const Icon(Icons.admin_panel_settings_outlined),
                  label: const Text('ADMIN LOGIN'),
                ),
              ],
            ),
          ),
        ),
      );
}

class _BrandPanel extends StatelessWidget {
  const _BrandPanel();

  @override
  Widget build(BuildContext context) => const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CarvoraLogo(),
          SizedBox(height: 28),
          Text('BESPOKE AUTOMOTIVE ENHANCEMENTS',
              style: TextStyle(color: CarvoraColors.gold, letterSpacing: 2, fontSize: 12)),
          SizedBox(height: 14),
          Text('Your car.\nYour signature.',
              style: TextStyle(fontSize: 42, fontWeight: FontWeight.w800, height: 1.05)),
          SizedBox(height: 18),
          Text('A refined Windows experience for discovering, designing and ordering premium car accessories.',
              style: TextStyle(color: CarvoraColors.textSecondary, height: 1.6)),
        ],
      );
}

class _CarvoraLogo extends StatelessWidget {
  const _CarvoraLogo();

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52,
            height: 52,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: CarvoraColors.surfaceHighlight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: CarvoraColors.gold, width: 1.5),
            ),
            child: const Text('C',
                style: TextStyle(color: CarvoraColors.gold, fontSize: 30, fontWeight: FontWeight.w900)),
          ),
          const SizedBox(width: 14),
          const Text('CARVORA',
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: 4)),
        ],
      );
}
