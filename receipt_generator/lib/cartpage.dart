import 'package:flutter/material.dart';
import 'package:receipt_generator/models.dart';
import 'package:sprintf/sprintf.dart';
import "package:provider/provider.dart";

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage>
    with SingleTickerProviderStateMixin {
  late final Map<Product, Qty?> _inCart;
  late final AnimationController _animationController;

  late bool _isQtyEditorFadeOut;

  @override
  void initState() {
    super.initState();
    _inCart = Provider.of<ProductList>(context, listen: false).getAllSaved();
    _isQtyEditorFadeOut = false;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text("Cart"),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return FadeTransition(
      opacity: Tween<double>(
        begin: 1.0,
        end: 0.0,
      ).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Curves.linear,
        ),
      ),
      child: _isQtyEditorFadeOut ? _cart() : _qtyEditor(),
    );
  }

  Widget _cart() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 10,
            child: ListView(
              children: [
                for (var entry in _inCart.entries) ...{
                  _ItemRow(
                    currentItem: entry.key,
                    qty: entry.value!,
                  )
                }
              ],
            ),
          ),
          Expanded(
            child: _generateReciptButton(),
          ),
        ],
      ),
    );
  }

  Widget _qtyEditor() {
    return Center(
      child: Card(
        elevation: 10,
        child: SizedBox(
          height: 500,
          width: 400,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    // decoration: BoxDecoration(
                    //   borderRadius: BorderRadius.circular(10),
                    //   color: Colors.black87,
                    // ),
                    alignment: Alignment.center,
                    child: const Text(
                      "Indicate your amount",
                      // style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Expanded(
                  flex: 10,
                  child: ListView(
                    children: [
                      for (var entry in _inCart.entries) ...{
                        _qtyEditorInner(entry.key, entry.value)
                      }
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: OutlinedButton(
                      onPressed: () {
                        _inCart.removeWhere(
                          (_, q) => q == null || q.amount == 0,
                        );
                        _animationController.forward().whenComplete(() {
                          _animationController.reverse();
                          setState(() {
                            _isQtyEditorFadeOut = true;
                          });
                        });
                      },
                      child: const Text("Confirm"),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _qtyEditorInner(
    Product product,
    Qty? amount,
  ) {
    return ListTile(
      title: Text(product.name),
      trailing: Container(
        constraints: const BoxConstraints(maxHeight: 30, maxWidth: 100),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ButtonStyle(
                  alignment: Alignment.center,
                  padding: MaterialStateProperty.all(EdgeInsets.zero),
                ),
                onPressed: () {
                  amount ??= Qty(0);
                  amount = amount!.deduct(Qty(1));
                  setState(() {
                    _inCart[product] = amount;
                  });
                },
                child: const FittedBox(
                  child: Icon(Icons.arrow_drop_down_rounded),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: () {
                  amount ??= Qty(0);
                  return Text("${amount!.amount}");
                }(),
              ),
            ),
            Expanded(
              child: ElevatedButton(
                style: ButtonStyle(
                  alignment: Alignment.center,
                  padding: MaterialStateProperty.all(EdgeInsets.zero),
                ),
                onPressed: () {
                  amount ??= Qty(0);
                  amount = amount!.add(Qty(1));
                  setState(() {
                    _inCart[product] = amount;
                  });
                },
                child: const FittedBox(
                  child: Icon(Icons.arrow_drop_up_rounded),
                  // child: Text("+"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _generateReciptButton() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ElevatedButton(
        onPressed: () {},
        child: const Text("Generate Recipt"),
      ),
    );
  }
}

class _ItemRow extends StatefulWidget {
  final Product currentItem;
  final Qty qty;
  const _ItemRow({Key? key, required this.currentItem, required this.qty})
      : super(key: key);
  @override
  _ItemRowState createState() => _ItemRowState();
}

class _ItemRowState extends State<_ItemRow> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 4,
          child: Card(
            child: ListTile(
              title: Text(widget.currentItem.name),
              subtitle: Text(sprintf("%.2f SGD", [widget.currentItem.price])),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Center(
            child: Text("X ${widget.qty.amount}"),
          ),
        ),
      ],
    );
  }
}
