import 'package:flutter/material.dart';
import 'package:pizzaria_app/providers/CartProvider.dart';
import 'package:pizzaria_app/screens/CartScreen.dart';
import 'package:pizzaria_app/screens/home_screen.dart';
import 'package:pizzaria_app/screens/login_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        // Configurando o estado global do carrinho
        ChangeNotifierProvider<CartProvider>(
          create: (_) => CartProvider(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Remove o banner de depuração
      title: 'Pizzaria App', // Nome do aplicativo
      theme: ThemeData(
        primarySwatch: Colors.orange, // Define a cor principal como laranja
      ),
      initialRoute: '/login', // Define a rota inicial
      routes: {
        '/login': (context) => LoginScreen(), // Tela de login
        '/': (context) => HomeScreen(), // Tela inicial após o login
        '/cart': (context) => CartScreen(),
      },
    );
  }
}
