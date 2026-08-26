import 'package:flutter/material.dart';

import 'root/theme.dart';
import 'ui/splash.dart';

void main() {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  bool temaEscuro = false;

  void trocarTema(bool valor) {
    setState(() {
      temaEscuro = valor;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Abastecimentos',
      debugShowCheckedModeBanner: true,

      theme: AppTheme.appTheme,
      darkTheme: AppTheme.darkTheme,

      themeMode:
          temaEscuro ? ThemeMode.dark : ThemeMode.light,

      home: Splash(
        temaEscuro: temaEscuro,
        trocarTema: trocarTema,
      ),
    );
  }
}