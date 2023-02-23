import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providers/auth_provider.dart';
import '../providers/login_user_provider.dart';
import 'list_page.dart';

class LoginPage extends HookConsumerWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController(text: '');
    final passwordController = useTextEditingController(text: '');

    return Scaffold(
      appBar: AppBar(title: const Text('ログイン')),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 24,
          horizontal: 32,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.mail),
                label: Text('メールアドレス'),
                hintText: 'test@gmail.com',
              ),
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            TextFormField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.lock),
                label: Text('パスワード'),
                hintText: 'password',
              ),
              controller: passwordController,
              obscureText: true,
            ),
            const SizedBox(
              height: 48,
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                minimumSize:
                    MaterialStateProperty.all<Size>(const Size(128, 32)),
              ),
              onPressed: () async {
                try {
                  if (emailController.text.isEmpty) {
                    throw 'メールアドレスを入力してください';
                  }
                  if (passwordController.text.isEmpty) {
                    throw 'パスワードを入力してください';
                  }
                  await ref.read(authControllerProvider.notifier).signIn(
                        emailController.text,
                        passwordController.text,
                      );
                  ref
                      .read(loginUserStateProvider.notifier)
                      .loadLoginUser(ref.read(authControllerProvider));
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const ListPage()),
                    (_) => false,
                  );
                } catch (e) {
                  rethrow;
                }
              },
              child: const Text('ログイン'),
            ),
          ],
        ),
      ),
    );
  }
}
