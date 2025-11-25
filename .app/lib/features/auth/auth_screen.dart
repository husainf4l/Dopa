import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _loginEmail = TextEditingController();
  final _loginPassword = TextEditingController();
  final _registerEmail = TextEditingController();
  final _registerPassword = TextEditingController();
  final _registerName = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _loginEmail.dispose();
    _loginPassword.dispose();
    _registerEmail.dispose();
    _registerPassword.dispose();
    _registerName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to DOPA'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: 'Login'), Tab(text: 'Register')],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _AuthForm(
            emailController: _loginEmail,
            passwordController: _loginPassword,
            actionLabel: 'Login',
            loading: state.isLoading,
            onSubmit: () => ref.read(authControllerProvider.notifier).login(
                  email: _loginEmail.text,
                  password: _loginPassword.text,
                ),
          ),
          _AuthForm(
            emailController: _registerEmail,
            passwordController: _registerPassword,
            extraField: TextField(
              controller: _registerName,
              decoration: const InputDecoration(labelText: 'Full name'),
            ),
            actionLabel: 'Register',
            loading: state.isLoading,
            onSubmit: () => ref.read(authControllerProvider.notifier).register(
                  email: _registerEmail.text,
                  password: _registerPassword.text,
                  name: _registerName.text,
                ),
          ),
        ],
      ),
    );
  }
}

class _AuthForm extends StatelessWidget {
  const _AuthForm({
    required this.emailController,
    required this.passwordController,
    required this.actionLabel,
    required this.onSubmit,
    required this.loading,
    this.extraField,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final String actionLabel;
  final VoidCallback onSubmit;
  final bool loading;
  final Widget? extraField;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          TextField(
            controller: emailController,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: passwordController,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Password'),
          ),
          const SizedBox(height: 12),
          if (extraField != null) extraField!,
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: loading ? null : onSubmit,
              child: loading
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : Text(actionLabel),
            ),
          ),
        ],
      ),
    );
  }
}
