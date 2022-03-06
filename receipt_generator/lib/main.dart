import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "./theme.dart";
import "./models.dart";
import "./productpage.dart";
import "./cartpage.dart";

void main() => runApp(const Root());

class Root extends StatelessWidget {
  const Root({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProductList(),
      child: MaterialApp(
        title: 'Welcome to Receipt Generator',
        theme: myTheme,
        initialRoute: '/',
        routes: <String, WidgetBuilder>{
          '/': (context) => const ProductPage(),
          '/cart': (context) => const CartPage(),
        },
      ),
    );
  }
}
