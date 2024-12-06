import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pizzaria_app/screens/BeverageConfirmationScreen.dart';
import 'PizzaDetailsScreen.dart'; // Tela de detalhes da pizza
import 'CartScreen.dart'; // Tela do carrinho
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, dynamic>> pizzas = [
    {
      'type': 'pizza',
      'tamanhopizza': 'Pizza Pequena',
      'description': 'Pizza com 4 fatias - 1 sabor',
      'price': 53.00,
      'image': 'assets/pizza_peque.png',
      'maxFlavors': 1,
    },
    {
      'type': 'pizza',
      'tamanhopizza': 'Pizza Média',
      'description': 'Pizza com 6 fatias - 2 sabores',
      'price': 58.00,
      'image': 'assets/pizza_media.png',
      'maxFlavors': 2,
    },
    {
      'type': 'pizza',
      'tamanhopizza': 'Pizza Grande',
      'description': 'Pizza com 8 fatias - 2 sabores',
      'price': 64.00,
      'image': 'assets/pizza_grande.png',
      'maxFlavors': 2,
    },
    {
      'type': 'pizza',
      'tamanhopizza': 'Pizza Gigante',
      'description': 'Pizza com 12 fatias - 3 sabores',
      'price': 77.00,
      'image': 'assets/pizza_gigante.png',
      'maxFlavors': 3,
    },
    {
      'type': 'pizza',
      'tamanhopizza': 'Pizza Extra GG',
      'description': 'Pizza com 16 fatias - 4 sabores',
      'price': 90.00,
      'image': 'assets/pizza_gg.png',
      'maxFlavors': 4,
    },
  ];

  final List<Map<String, dynamic>> bebidas = [
    {
      'type': 'beverage',
      'namebebida': 'Coca Cola - 2 litros',
      'price': 10.00,
      'image': 'assets/coca_cola_2l.png',
    },
    {
      'type': 'beverage',
      'namebebida': 'Coca Cola - Lata 350 ml',
      'price': 5.00,
      'image': 'assets/coca_cola_lata.png',
    },
    {
      'type': 'beverage',
      'namebebida': 'Mineiro - 2 litros',
      'price': 8.00,
      'image': 'assets/mineiro_2l.png',
    },
    {
      'type': 'beverage',
      'namebebida': 'Água com gás - 500ml',
      'price': 3.00,
      'image': 'assets/agua_com_gas.png',
    },
    {
      'type': 'beverage',
      'namebebida': 'Suco de laranja Natural - 500ml',
      'price': 10.00,
      'image': 'assets/suco_laranja.png',
    },
  ];

  List<Map<String, dynamic>> _cartItems = [];
  bool isPizzaSelected =
      true; // Variável para controlar se a seção de pizzas ou bebidas está ativa
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  List<Map<String, dynamic>> get _filteredItems {
    List<Map<String, dynamic>> items = isPizzaSelected ? pizzas : bebidas;
    if (_searchQuery.isNotEmpty) {
      return items.where((item) {
        return (isPizzaSelected ? item['tamanhopizza'] : item['namebebida'])
            .toLowerCase()
            .contains(_searchQuery.toLowerCase());
      }).toList();
    }
    return items;
  }

  @override
  void initState() {
    super.initState();
    _loadCart();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  Future<void> _loadCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cartData = prefs.getString('cart');
    if (cartData != null) {
      setState(() {
        _cartItems = List<Map<String, dynamic>>.from(jsonDecode(cartData));
      });
    }
  }

  Future<void> _saveCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('cart', jsonEncode(_cartItems));
  }

  void _addToCart(Map<String, dynamic> item) {
    setState(() {
      _cartItems.add(item);
      _saveCart();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 30, 1, 117),
        iconTheme: const IconThemeData(
          color: Colors.white, // Define a cor da seta de voltar
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ClipOval(
              child: Image.asset(
                'assets/logo.png',
                height: 55,
                width: 55,
                fit: BoxFit.cover,
              ),
            ),
            const Text(
              'COSMIC SLICE',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Comic Sans MS',
                color: Colors.white,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartScreen(),
                  ),
                );
              },
              child: Stack(
                children: [
                  const Icon(
                    Icons.shopping_cart,
                    size: 30,
                    color: Colors.white,
                  ),
                  if (_cartItems.isNotEmpty)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: CircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.red,
                        child: Text(
                          '${_cartItems.length}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Campo de pesquisa
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          // Botões Pizza e Bebidas
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isPizzaSelected = true;
                  });
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: isPizzaSelected
                        ? const Color.fromARGB(255, 30, 1, 117)
                        : Colors.white, // Altera a cor de fundo
                    foregroundColor: isPizzaSelected
                        ? Colors.white
                        : const Color.fromARGB(
                            255, 30, 1, 117) // Altera a cor do texto
                    ),
                child: Text('Pizzas'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isPizzaSelected = false;
                  });
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: !isPizzaSelected
                        ? const Color.fromARGB(255, 30, 1, 117)
                        : Colors.white, // Altera a cor de fundo
                    foregroundColor: !isPizzaSelected
                        ? Colors.white
                        : const Color.fromARGB(
                            255, 30, 1, 117) // Altera a cor do texto
                    ),
                child: Text('Bebidas'),
              ),
            ],
          ),
          // Exibição dos itens dependendo da seleção
          Expanded(
            child: ListView.builder(
              itemCount: _filteredItems.length,
              itemBuilder: (context, index) {
                var item = _filteredItems[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(25.0),
                      child: Image.asset(
                        item['image'],
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      isPizzaSelected
                          ? item['tamanhopizza']
                          : item['namebebida'],
                    ),
                    subtitle: Text(
                      isPizzaSelected
                          ? item['description']
                          : 'Preço: R\$ ${item['price'].toStringAsFixed(2)}',
                    ),
                    trailing: isPizzaSelected
                        ? Text('R\$ ${item['price'].toStringAsFixed(2)}')
                        : null,
                    onTap: () {
                      if (item['type'] == 'pizza') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PizzaDetailsScreen(
                              pizzaName: item['tamanhopizza'],
                              pizzaDescription: item['description'],
                              pizzaImage: item['image'],
                              pizzaPrice: item['price'],
                              maxFlavors: item['maxFlavors'],
                            ),
                          ),
                        ).then((selectedPizza) {
                          if (selectedPizza != null) {
                            _addToCart(selectedPizza);
                          }
                        });
                      } else if (item['type'] == 'beverage') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BeverageConfirmationScreen(
                              beverageName: item[
                                  'namebebida'], // Passando o nome da bebida correto
                              beveragePrice: item['price'],
                              quantity: 1,
                            ),
                          ),
                        );
                      }
                    },
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
