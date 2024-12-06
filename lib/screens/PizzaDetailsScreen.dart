import 'package:flutter/material.dart';
import 'ConfirmationScreen.dart';

class PizzaDetailsScreen extends StatefulWidget {
  final String pizzaName;
  final String pizzaDescription;
  final String pizzaImage;
  final double pizzaPrice;
  final int maxFlavors;

  PizzaDetailsScreen({
    required this.pizzaName,
    required this.pizzaDescription,
    required this.pizzaImage,
    required this.pizzaPrice,
    required this.maxFlavors,
  });

  @override
  _PizzaDetailScreenState createState() => _PizzaDetailScreenState();
}

class _PizzaDetailScreenState extends State<PizzaDetailsScreen> {
  List<String> _selectedFlavors = [];
  String _searchQuery = '';

  final List<Map<String, String>> flavors = [
    {
      'name': 'Calabresa',
      'description': 'Presunto, tomate, mussarela, calabresa, cebola e orégano'
    },
    {
      'name': 'Bacon',
      'description': 'Presunto, tomate, mussarela, bacon, cebola e orégano'
    },
    {
      'name': 'Carne Seca',
      'description': 'Carne seca, creme de leite, mussarela, cebola e orégano'
    },
    {
      'name': 'Frango com Catupiry',
      'description': 'Mussarela, frango, tomate, bacon, cebola e orégano'
    },
    {
      'name': '4 Queijos',
      'description':
          'Molho 4 queijos, mussarela, catupiry, queijo parmesão e provolone'
    },
  ];

  void _toggleFlavor(String flavor) {
    setState(() {
      if (_selectedFlavors.contains(flavor)) {
        _selectedFlavors.remove(flavor);
      } else if (_selectedFlavors.length < widget.maxFlavors) {
        _selectedFlavors.add(flavor);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Você pode selecionar no máximo ${widget.maxFlavors} sabor(es)!'),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredFlavors = flavors
        .where((flavor) =>
            flavor['name']!.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 30, 1, 117),
        title: const Text(
          'Sabores',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.4,
                width: double.infinity,
                child: Image.network(
                  widget.pizzaImage,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.white.withOpacity(0.9),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.pizzaName,
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Pesquise o sabor',
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                          prefixIcon: Icon(Icons.search),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredFlavors.length,
              itemBuilder: (context, index) {
                final flavor = filteredFlavors[index];
                return ListTile(
                  title: Text(flavor['name']!),
                  subtitle: Text(flavor['description']!),
                  trailing: GestureDetector(
                    onTap: () => _toggleFlavor(flavor['name']!),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: _selectedFlavors.contains(flavor['name'])
                          ? Colors.green
                          : Colors.grey[300],
                      child: Icon(
                        _selectedFlavors.contains(flavor['name'])
                            ? Icons.check
                            : Icons.radio_button_unchecked,
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_selectedFlavors.length == widget.maxFlavors)
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'R\$ ${widget.pizzaPrice.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton(
                    onPressed: _selectedFlavors.length == widget.maxFlavors
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ConfirmationScreen(
                                  pizzaName: _selectedFlavors.join(' + '),
                                  pizzaPrice: widget.pizzaPrice,
                                  quantity: 1,
                                  observation: '',
                                  pizzaSize: widget.pizzaName,
                                ),
                              ),
                            );
                          }
                        : null,
                    child: Text('Avançar'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
