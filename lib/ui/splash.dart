import 'package:flutter/material.dart';

import 'home.dart';

class Splash extends StatelessWidget {
  final bool temaEscuro;
  final Function(bool) trocarTema;

  const Splash({
    super.key,
    required this.temaEscuro,
    required this.trocarTema,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(
                Icons.local_gas_station,
                size: 60,
              ),
            ),

            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Tema escuro',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),

                const SizedBox(width: 10),

                Switch(
                  value: temaEscuro,
                  onChanged: trocarTema,
                ),
              ],
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: 130,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Home(),
                    ),
                  );
                },
                child: const Text('Entrar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}