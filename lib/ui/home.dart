import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Map<String, dynamic>> abastecimentos = [];

  @override
  void initState() {
    super.initState();
    carregar();
  }

  Future<void> salvar() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      'abastecimentos',
      jsonEncode(abastecimentos),
    );
  }

  Future<void> carregar() async {
    final prefs = await SharedPreferences.getInstance();

    final dados = prefs.getString('abastecimentos');

    if (dados != null) {
      final lista = jsonDecode(dados);

      if (!mounted) return;

      setState(() {
        abastecimentos =
            List<Map<String, dynamic>>.from(
          lista.map(
            (item) => Map<String, dynamic>.from(item),
          ),
        );
      });
    }
  }

  double precoPorLitro(Map<String, dynamic> item) {
    double litros = (item['litros'] as num).toDouble();
    double valor = (item['valor'] as num).toDouble();

    if (litros == 0) {
      return 0;
    }

    return valor / litros;
  }

  double precoMedio() {
    if (abastecimentos.isEmpty) {
      return 0;
    }

    double totalLitros = 0;
    double totalPago = 0;

    for (var item in abastecimentos) {
      totalLitros +=
          (item['litros'] as num).toDouble();

      totalPago +=
          (item['valor'] as num).toDouble();
    }

    if (totalLitros == 0) {
      return 0;
    }

    return totalPago / totalLitros;
  }

  double consumoDoAbastecimento(int index) {
    if (index == 0) {
      return 0;
    }

    double kmAtual =
        (abastecimentos[index]['quilometragem'] as num)
            .toDouble();

    double kmAnterior =
        (abastecimentos[index - 1]['quilometragem']
                as num)
            .toDouble();

    double litros =
        (abastecimentos[index]['litros'] as num)
            .toDouble();

    double distancia = kmAtual - kmAnterior;

    if (distancia <= 0 || litros <= 0) {
      return 0;
    }

    return distancia / litros;
  }

  double consumoMedio() {
    if (abastecimentos.length < 2) {
      return 0;
    }

    double soma = 0;
    int quantidade = 0;

    for (int i = 1; i < abastecimentos.length; i++) {
      double consumo = consumoDoAbastecimento(i);

      if (consumo > 0) {
        soma += consumo;
        quantidade++;
      }
    }

    if (quantidade == 0) {
      return 0;
    }

    return soma / quantidade;
  }

  void excluir(int index) async {
    setState(() {
      abastecimentos.removeAt(index);
    });

    await salvar();
  }

  void abrirModal({int? index}) {
    bool editando = index != null;

    final data = TextEditingController(
      text: editando
          ? abastecimentos[index]['data']
          : '',
    );

    final combustivel = TextEditingController(
      text: editando
          ? abastecimentos[index]['combustivel']
          : '',
    );

    final litros = TextEditingController(
      text: editando
          ? abastecimentos[index]['litros'].toString()
          : '',
    );

    final valor = TextEditingController(
      text: editando
          ? abastecimentos[index]['valor'].toString()
          : '',
    );

    final quilometragem = TextEditingController(
      text: editando
          ? abastecimentos[index]['quilometragem']
              .toString()
          : '',
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            editando
                ? 'Editar abastecimento'
                : 'Novo abastecimento',
          ),

          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: data,
                  decoration: const InputDecoration(
                    labelText: 'Data',
                    hintText: 'dd/mm/aaaa',
                  ),
                ),

                const SizedBox(height: 10),

                TextField(
                  controller: combustivel,
                  decoration: const InputDecoration(
                    labelText: 'Combustível',
                    hintText: 'Gasolina, Etanol...',
                  ),
                ),

                const SizedBox(height: 10),

                TextField(
                  controller: litros,
                  keyboardType:
                      const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Litros',
                  ),
                ),

                const SizedBox(height: 10),

                TextField(
                  controller: valor,
                  keyboardType:
                      const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Valor pago',
                  ),
                ),

                const SizedBox(height: 10),

                TextField(
                  controller: quilometragem,
                  keyboardType:
                      const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Quilometragem',
                  ),
                ),
              ],
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),

            ElevatedButton(
              onPressed: () async {
                double? litrosValor =
                    double.tryParse(
                  litros.text.replaceAll(',', '.'),
                );

                double? valorPago =
                    double.tryParse(
                  valor.text.replaceAll(',', '.'),
                );

                double? km =
                    double.tryParse(
                  quilometragem.text
                      .replaceAll(',', '.'),
                );

                if (data.text.isEmpty ||
                    combustivel.text.isEmpty ||
                    litrosValor == null ||
                    valorPago == null ||
                    km == null) {
                  return;
                }

                final novo = {
                  'data': data.text,
                  'combustivel': combustivel.text,
                  'litros': litrosValor,
                  'valor': valorPago,
                  'quilometragem': km,
                };

                setState(() {
                  if (editando) {
                    abastecimentos[index] = novo;
                  } else {
                    abastecimentos.add(novo);
                  }
                });

                await salvar();

                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
              child: Text(
                editando ? 'Salvar' : 'Adicionar',
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Abastecimentos',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [
          IconButton(
            onPressed: () {
              abrirModal();
            },
            icon: const Icon(
              Icons.add_circle,
              size: 35,
            ),
          ),

          const SizedBox(width: 10),
        ],
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding:
                          const EdgeInsets.all(15),
                      child: Column(
                        children: [
                          const Text(
                            'Preço médio',
                            style: TextStyle(
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            'R\$ ${precoMedio().toStringAsFixed(2)}/L',
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: Card(
                    child: Padding(
                      padding:
                          const EdgeInsets.all(15),
                      child: Column(
                        children: [
                          const Text(
                            'Consumo médio',
                            style: TextStyle(
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            '${consumoMedio().toStringAsFixed(1)} km/L',
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: abastecimentos.isEmpty
                ? const Center(
                    child: Text(
                      'Nenhum abastecimento cadastrado',
                    ),
                  )
                : ListView.separated(
                    itemCount:
                        abastecimentos.length,

                    separatorBuilder:
                        (context, index) {
                      return const Divider();
                    },

                    itemBuilder:
                        (context, index) {
                      final item =
                          abastecimentos[index];

                      double preco =
                          precoPorLitro(item);

                      double consumo =
                          consumoDoAbastecimento(
                        index,
                      );

                      return ListTile(
                        onTap: () {
                          abrirModal(
                            index: index,
                          );
                        },

                        leading: const Icon(
                          Icons.local_gas_station,
                          size: 35,
                        ),

                        title: Text(
                          '${item['combustivel']} - ${item['data']}',
                          style: const TextStyle(
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        subtitle: Text(
                          '${(item['litros'] as num).toStringAsFixed(1)} L'
                          ' • R\$ ${(item['valor'] as num).toStringAsFixed(2)}\n'
                          '${(item['quilometragem'] as num).toStringAsFixed(0)} km\n'
                          'R\$ ${preco.toStringAsFixed(2)}/L'
                          '${index > 0 ? ' • ${consumo.toStringAsFixed(1)} km/L' : ''}',
                        ),

                        trailing: IconButton(
                          onPressed: () {
                            excluir(index);
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}