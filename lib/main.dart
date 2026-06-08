import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router.dart';
import 'shared/providers/isar_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: SonidoApp(),
    ),
  );
}

class SonidoApp extends ConsumerWidget {
  const SonidoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final isarAsync = ref.watch(isarProvider);

    return isarAsync.when(
      error: (error, stack) => MaterialApp(
        home: Scaffold(
          body: Center(child: Text('Error al iniciar: $error')),
        ),
      ),
      loading: () => MaterialApp(
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Inicializando...'),
              ],
            ),
          ),
        ),
      ),
      data: (_) => MaterialApp.router(
        title: 'Sonido',
        theme: ThemeData(
          colorSchemeSeed: Colors.indigo,
          useMaterial3: true,
        ),
        routerConfig: router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
