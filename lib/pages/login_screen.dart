import 'package:flutter/material.dart';
import 'package:ombe/services/auth_services.dart';
import 'home_screen.dart';
import 'create_account_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  int _page = 0;

  final _emailC = TextEditingController();
  final _passC = TextEditingController();

  static const _green = Color(0xFF007344);
  static const _blueFb = Color(0xFF2F6FE8);
  static const _cream = Color(0xFFF4D9A4);

  static const double _maxWidth = 392;

  final AuthService _authService = AuthService();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailC.dispose();
    _passC.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final email = _emailC.text.trim();
    final password = _passC.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email dan password wajib diisi')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final res = await _authService.login(email: email, password: password);

      if (!mounted) return;

      if (res['success'] == true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } else {
        final msg = res['message']?.toString() ?? 'Login gagal';
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(msg)));
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Login gagal: $e')));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _maxWidth),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              child: _page == 0
                  ? _buildChoose()
                  : _page == 1
                  ? _buildSignIn()
                  : _buildForgot(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChoose() {
    return SingleChildScrollView(
      key: const ValueKey('choose'),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const _CenterLogo(),
            const SizedBox(height: 48),
            const Text(
              'Morning begins with Ombe\ncoffee',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF121212),
                height: 1.3,
              ),
            ),
            const SizedBox(height: 60),
            _ActionBtn(
              label: 'Login With Email',
              bg: _green,
              labelColor: Colors.white,
              icon: Icons.mail_outline,
              iconBg: Colors.white,
              iconColor: _green,
              onTap: () => setState(() => _page = 1),
            ),
            const SizedBox(height: 32),
            _ActionBtn(
              label: 'Login With Facebook',
              bg: _blueFb,
              labelColor: Colors.white,
              icon: Icons.facebook,
              iconBg: Colors.white,
              iconColor: _blueFb,
              onTap: () => setState(() => _page = 1),
            ),
            const SizedBox(height: 16),
            _GoogleBtn(onTap: () => setState(() => _page = 1)),
          ],
        ),
      ),
    );
  }

  // ========================== PAGE 1 ==========================
  Widget _buildSignIn() {
    return Align(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        key: const ValueKey('signin'),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(child: _TopLogoCentered()),
              const SizedBox(height: 40),
              const Text(
                'Sign in',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF121212),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Lorem ipsum dolor sit amet, consectetur\nadipiscing elit, sed do eiusmod tempor',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF7A7A7A),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Username',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF9E9E9E),
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _emailC,
                decoration: const InputDecoration(
                  hintText: 'info@example.com',
                  hintStyle: TextStyle(color: Color(0xFF121212)),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: _green),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 8),
                ),
                style: const TextStyle(fontSize: 16, color: Color(0xFF121212)),
              ),
              const SizedBox(height: 28),
              const Text(
                'Password',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF9E9E9E),
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _passC,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Password',
                  hintStyle: TextStyle(color: Color(0xFFBDBDBD)),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: _green),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 8),
                  suffixIcon: Icon(
                    Icons.visibility_outlined,
                    color: _green,
                    size: 22,
                  ),
                ),
                style: const TextStyle(fontSize: 16, color: Color(0xFF121212)),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'LOGIN',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Forgot Password?  ',
                    style: TextStyle(color: Color(0xFF757575), fontSize: 14),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => _page = 2),
                    child: const Text(
                      'Reset Password',
                      style: TextStyle(
                        color: _green,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              const Center(
                child: Text(
                  'Dont have any account?',
                  style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 14),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CreateAccountScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _cream,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'CREATE AN ACCOUNT',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF121212),
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForgot() {
    return Align(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        key: const ValueKey('forgot'),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(child: _TopLogoCentered()),
              const SizedBox(height: 40),
              const Text(
                'Forget Password',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF121212),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Lorem ipsum dolor sit amet, consectetur\nadipiscing elit, sed do eiusmod tempor',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF7A7A7A),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Password',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF9E9E9E),
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _passC,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Password',
                  hintStyle: TextStyle(color: Color(0xFFBDBDBD)),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: _green),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 8),
                  suffixIcon: Icon(
                    Icons.visibility_outlined,
                    color: _green,
                    size: 22,
                  ),
                ),
                style: const TextStyle(fontSize: 16, color: Color(0xFF121212)),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () => setState(() => _page = 0),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'SUBMIT',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Sign in to your registered  ',
                    style: TextStyle(color: Color(0xFF757575), fontSize: 14),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => _page = 1),
                    child: const Text(
                      'Login here',
                      style: TextStyle(
                        color: _green,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class _CenterLogo extends StatelessWidget {
  const _CenterLogo();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset('assets/images/coffee_logo.png', height: 90),
        const SizedBox(height: 16),
        Container(
          width: 100,
          height: 6,
          decoration: const BoxDecoration(
            color: Color(0xFFF4D9A4),
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Ombe',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: Color(0xFF121212),
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Coffee Shop App',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF9E9E9E),
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }
}

class _TopLogoCentered extends StatelessWidget {
  const _TopLogoCentered();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/images/coffee_logo.png', height: 72),
        const SizedBox(width: 14),
        const Text(
          'Ombe',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: Color(0xFF121212),
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final String label;
  final Color bg;
  final Color labelColor;
  final Color iconBg;
  final Color iconColor;
  final IconData icon;
  final VoidCallback onTap;

  const _ActionBtn({
    required this.label,
    required this.bg,
    required this.labelColor,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: onTap,
        child: Ink(
          height: 56,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(28),
          ),
          child: Row(
            children: [
              const SizedBox(width: 20),
              Container(
                height: 32,
                width: 32,
                decoration: BoxDecoration(
                  color: iconBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 18),
              ),
              Expanded(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: labelColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: 52),
            ],
          ),
        ),
      ),
    );
  }
}

class _GoogleBtn extends StatelessWidget {
  final VoidCallback onTap;
  const _GoogleBtn({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: onTap,
        child: Ink(
          height: 56,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFFE0E0E0), width: 1.5),
            borderRadius: BorderRadius.circular(28),
          ),
          child: Row(
            children: [
              const SizedBox(width: 20),
              Container(
                height: 32,
                width: 32,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Image.asset(
                    'assets/images/google_icon.png',
                    height: 18,
                  ),
                ),
              ),
              const Expanded(
                child: Text(
                  'Login With Google',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF007344),
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: 52),
            ],
          ),
        ),
      ),
    );
  }
}
