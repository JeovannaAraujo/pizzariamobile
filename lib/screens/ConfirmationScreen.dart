import 'package:flutter/material.dart';
import 'package:pizzaria_app/screens/CartScreen.dart';
import 'package:provider/provider.dart';
import '../providers/CartProvider.dart';

class ConfirmationScreen extends StatefulWidget {
  final String pizzaName;
  final double pizzaPrice;
  final int quantity;
  final String observation;
  final String pizzaSize;

  ConfirmationScreen({
    required this.pizzaName,
    required this.pizzaPrice,
    required this.quantity,
    required this.observation,
    required this.pizzaSize,
  });

  @override
  _ConfirmationScreenState createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
  late int _quantity;
  late String _observation;

  @override
  void initState() {
    super.initState();
    _quantity = widget.quantity;
    _observation = widget.observation;
  }

  @override
  Widget build(BuildContext context) {
    double totalPrice = widget.pizzaPrice * _quantity;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 30, 1, 117),
        title: const Text(
          'Confirmação',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nome da pizza
            Center(
              child: Text(
                widget.pizzaName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Tamanho da pizza
            Center(
              child: Text(
                'Tamanho: ${widget.pizzaSize}',
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Controle de quantidade
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Quantidade:',
                  style: TextStyle(fontSize: 16),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: _quantity > 1
                          ? () {
                              setState(() {
                                _quantity--;
                              });
                            }
                          : null, // Desabilitar o botão se a quantidade for 1
                    ),
                    Text(
                      '$_quantity',
                      style: const TextStyle(fontSize: 20, color: Colors.red),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          _quantity++;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Preço total
            Text(
              'Preço Total: R\$ ${totalPrice.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Campo de observações
            const Text(
              'Observações:',
              style: TextStyle(fontSize: 16),
            ),
            TextField(
              maxLength: 200,
              decoration: const InputDecoration(
                hintText: 'Ex: Tirar cebola, ovo, etc',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _observation = value;
                });
              },
            ),

            const Spacer(),

            // Botões de navegação
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Continuar Comprando'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Adiciona o item ao carrinho global
                    Provider.of<CartProvider>(context, listen: false).addItem({
                      'name': widget.pizzaName.isNotEmpty
                          ? widget.pizzaName
                          : 'Sabor não disponível',
                      'price': widget.pizzaPrice,
                      'quantity': _quantity,
                      'observation': _observation,
                      'size': widget.pizzaSize.isNotEmpty
                          ? widget.pizzaSize
                          : 'Tamanho não disponível',
                    });

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CartScreen(),
                      ),
                    );
                  },
                  child: const Text('Avançar para o Carrinho'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
