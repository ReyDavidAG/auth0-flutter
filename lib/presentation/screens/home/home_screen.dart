import 'package:auth0_app/presentation/providers/auth0/auth0_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = 'home_screen';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE5E5E5),
      appBar: AppBar(
        title: const Text("Auth0 App"),
      ),
      body: _HomeScreenView(),
    );
  }
}

class _HomeScreenView extends ConsumerStatefulWidget {
  const _HomeScreenView();

  @override
  _HomeScreenViewState createState() => _HomeScreenViewState();
}

class _HomeScreenViewState extends ConsumerState<_HomeScreenView> {
  @override
  void initState() {
    super.initState();

    ref.read(auth0Provider.notifier).checkSession();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(auth0Provider).isLoading;
    final isAuthenticated = ref.watch(auth0Provider).isAuthenticated;
    final credentials = ref.watch(auth0Provider).credentials;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isLoading)
            const CircularProgressIndicator()
          else if (isAuthenticated && credentials != null)
            Column(
              children: [
                Text("Bienvenido ${credentials.user.nickname}"),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    ref.read(auth0Provider.notifier).logoutAction();
                  },
                  child: const Text("Cerrar sesión"),
                ),
              ],
            )
          else
            ElevatedButton(
              onPressed: () {
                ref.read(auth0Provider.notifier).loginAction();
              },
              child: const Text("Iniciar sesión"),
            ),
        ],
      ),
    );
  }
}
