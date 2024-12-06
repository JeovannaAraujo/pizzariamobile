import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pizzaria_app/providers/CartProvider.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    double totalPrice = cartProvider.items
        .fold(0, (sum, item) => sum + (item['price'] * item['quantity']));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 30, 1, 117),
        title: const Text(
          'Carrinho',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.white),
            onPressed: () {
              cartProvider.clearCart();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Carrinho limpo com sucesso!'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: cartProvider.items.isEmpty
                ? const Center(
                    child: Text(
                      'Seu carrinho está vazio!',
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : ListView.builder(
                    itemCount: cartProvider.items.length,
                    itemBuilder: (context, index) {
                      final item = cartProvider.items[index];
                      bool isBeverage = item.containsKey('namebebida');
                      String imagePath = '';

                      // Defina as imagens de acordo com o tipo de item
                      if (isBeverage) {
                        // Bebidas
                        if (item['namebebida'] == 'Coca Cola - 2 litros') {
                          imagePath = 'assets/coca_cola_2l.png';
                        } else if (item['namebebida'] ==
                            'Coca Cola - Lata 350 ml') {
                          imagePath = 'assets/coca_cola_lata.png';
                        } else if (item['namebebida'] == 'Mineiro - 2 litros') {
                          imagePath = 'assets/mineiro_2l.png';
                        } else if (item['namebebida'] ==
                            'Água com gás - 500ml') {
                          imagePath = 'assets/agua_com_gas.png';
                        } else if (item['namebebida'] ==
                            'Suco de laranja Natural - 500ml') {
                          imagePath = 'assets/suco_laranja.png';
                        }
                      } else {
                        // Pizzas
                        if (item['size'] == 'Pizza Pequena') {
                          imagePath = 'assets/pizza_peque.png';
                        } else if (item['size'] == 'Pizza Média') {
                          imagePath = 'assets/pizza_media.png';
                        } else if (item['size'] == 'Pizza Grande') {
                          imagePath = 'assets/pizza_grande.png';
                        } else if (item['size'] == 'Pizza Gigante') {
                          imagePath = 'assets/pizza_gigante.png';
                        } else if (item['size'] == 'Pizza Extra GG') {
                          imagePath = 'assets/pizza_gg.png';
                        }
                      }

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Exibe a imagem do item
                                Image.asset(
                                  imagePath,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Exibição de bebidas
                                      if (isBeverage) ...[
                                        Text(
                                          '${item['namebebida']}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ] else ...[
                                        // Exibição de pizzas
                                        Text(
                                          '${item['size']}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          'Sabor: ${item['name']}',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                      const SizedBox(height: 5),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove,
                                          color: Colors.red),
                                      onPressed: () {
                                        cartProvider.updateQuantity(
                                          item['namebebida'] ?? item['name'],
                                          item['size'] ?? '',
                                          item['quantity'] - 1,
                                          namebebida: item['namebebida'],
                                        );
                                      },
                                    ),
                                    Text(
                                      '${item['quantity']}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.add),
                                      onPressed: () {
                                        cartProvider.updateQuantity(
                                          item['namebebida'] ?? item['name'],
                                          item['size'] ?? '',
                                          item['quantity'] + 1,
                                          namebebida: item['namebebida'],
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            // Exibição do preço
                            Text(
                              'R\$ ${(item['price'] * item['quantity']).toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (item['observation']?.isNotEmpty ?? false)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  'Observações: ${item['observation']}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            GestureDetector(
                              onTap: () async {
                                String observation = item['observation'] ?? '';
                                TextEditingController textController =
                                    TextEditingController(text: observation);

                                String? newObservation =
                                    await showDialog<String>(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title:
                                          const Text('Adicionar Observações'),
                                      content: TextField(
                                        controller: textController,
                                        maxLength: 200,
                                        decoration: const InputDecoration(
                                          hintText:
                                              'Ex: Tirar cebola, ovo, etc',
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(
                                                context, textController.text);
                                          },
                                          child: const Text('Salvar'),
                                        ),
                                      ],
                                    );
                                  },
                                );

                                if (newObservation != null &&
                                    newObservation.isNotEmpty) {
                                  cartProvider.updateObservation(
                                    item['namebebida'] ?? item['name'],
                                    item['size'] ?? '',
                                    newObservation,
                                    namebebida: item['namebebida'],
                                  );
                                } else {
                                  // Remove a observação se o texto for vazio
                                  cartProvider.updateObservation(
                                    item['namebebida'] ?? item['name'],
                                    item['size'] ?? '',
                                    null,
                                    namebebida: item['namebebida'],
                                  );
                                }
                              },
                              child: const Text(
                                'Adicionar Observações',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                            const Divider(thickness: 1),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          // Exibindo o total de todos os itens no carrinho
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'R\$ ${totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          // Botão "Adicionar mais itens"
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 30, 1, 117),
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/');
              },
              child: const Text('Adicionar mais itens'),
            ),
          ),
          // Botão "Finalizar pedido"
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 30, 1, 117),
              ),
              onPressed: () {
                // Exibe a primeira mensagem de pedido finalizado
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Pedido Finalizado'),
                    content: const Text(
                        'Obrigado! Seu pedido está sendo preparado.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          cartProvider.clearCart(); // Limpa o carrinho
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/', // Navega para a tela inicial
                            (route) => false,
                          );
                        },
                        child: const Text("OK"),
                      ),
                    ],
                  ),
                );
              },
              child: const Text(
                'Finalizar pedido',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
