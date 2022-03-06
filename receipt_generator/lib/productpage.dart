import "package:flutter/material.dart";
import "package:sprintf/sprintf.dart";
import "package:provider/provider.dart";
import 'package:tuple/tuple.dart';
import "./models.dart";

class ProductPage extends StatelessWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Products"),
          actions: [
            IconButton(
              icon: const Icon(Icons.add_shopping_cart),
              onPressed: () => {Navigator.of(context).pushNamed("/cart")},
            ),
          ],
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                const _ProductList(),
                _FormSection(
                  containerSize: constraints.biggest,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ProductList extends StatefulWidget {
  const _ProductList({Key? key}) : super(key: key);

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<_ProductList> {
  Widget? _buildProductList() {
    if (Provider.of<ProductList>(context, listen: true).isEmpty) return null;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: Provider.of<ProductList>(context, listen: true)
          .getKeys()
          .map((item) => _buildRow(item))
          .toList(),
    );
  }

  Widget _buildRow(Product item) {
    final row = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(child: Text(item.name)),
        Expanded(child: Text(sprintf("%.2f SGD", [item.price]))),
        Expanded(
          child: Checkbox(
            value: Provider.of<ProductList>(context).getItem(item)!.item2,
            onChanged: (bool? isChecked) {
              if (isChecked!) {
                Provider.of<ProductList>(context, listen: false)
                    .setItem(item, const Tuple2(null, true));
              } else {
                Provider.of<ProductList>(context, listen: false)
                    .setItem(item, const Tuple2(null, false));
              }
            },
          ),
        ),
      ],
    );

    return Padding(
      padding: const EdgeInsets.all(6),
      child: Dismissible(
        key: UniqueKey(),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.only(left: 15),
            child: row,
          ),
          elevation: 5,
          margin: const EdgeInsets.all(0),
        ),
        onDismissed: (direction) {
          Provider.of<ProductList>(context, listen: false).removeAll([item]);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Item Removed"),
            ),
          );
        },
        background: Container(
          decoration: const BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.all(Radius.circular(5))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Expanded(flex: 1, child: Icon(Icons.delete)),
              Expanded(flex: 5, child: Container()),
            ],
          ),
        ),
        secondaryBackground: Container(
          decoration: const BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.all(Radius.circular(5))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(flex: 5, child: Container()),
              const Expanded(flex: 1, child: Icon(Icons.delete))
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildProductList() ?? Container();
  }
}

class _FormSection extends StatefulWidget {
  final Size containerSize;

  const _FormSection({Key? key, required this.containerSize}) : super(key: key);

  @override
  _FormSectionState createState() => _FormSectionState();
}

class _FormSectionState extends State<_FormSection>
    with SingleTickerProviderStateMixin {
  static const double _buttonRadius = 30;
  static const double _formWidth = 400;
  static const double _formHeight = 500;

  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 700),
  )..addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        setState(() {
          _isDone = true;
        });
      } else {
        setState(() {
          _isDone = false;
        });
      }
    });

  final TextEditingController _productNameFieldController =
      TextEditingController();
  final TextEditingController _productPriceFieldController =
      TextEditingController();

  Product _product = Product();
  final _formKey = GlobalKey<FormState>();

  bool _isTapped = false;
  bool _isDone = true; // status control for the transition animation

  Widget _buildButton() {
    return GestureDetector(
      onTap: () {
        if (!_isTapped) {
          setState(() {
            _isTapped = true;
          });
          _animationController.forward();
        }
      },
      child: Card(
        elevation: 15,
        color: _isDone && !_isTapped ? Colors.blue : Colors.white,
        shape: _isDone && !_isTapped
            ? const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(_buttonRadius),
                ),
              )
            : null,
        child: _isDone && !_isTapped
            ? const Icon(
                Icons.add,
                color: Colors.white,
              )
            : _isDone && _isTapped
                ? _buildForm()
                : null,
      ),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10),
        // Form section
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // title
              Container(
                alignment: Alignment.center,
                constraints: const BoxConstraints.expand(height: 100),
                child: const Text("Enter your product"),
              ),

              // Name Field
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    TextFormField(
                      // controller: _productNameFieldController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Name",
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Name cannot be empty";
                        }
                        try {
                          _product.name = value.trim();
                        } catch (e) {
                          return "Invalid Name";
                        }

                        return null;
                      },
                    ),
                  ],
                ),
              ),

              // Price Field
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.all(10),
                child: TextFormField(
                  // controller: _productPriceFieldController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Price",
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Price cannot be empty";
                    }
                    try {
                      _product.price = double.parse(value.trim());
                    } catch (e) {
                      return "Invalid Price";
                    }

                    return null;
                  },
                ),
              ),

              Consumer<ProductList>(builder: (context, productlist, _) {
                return Container(
                  alignment: Alignment.bottomCenter,
                  constraints:
                      const BoxConstraints.expand(height: 200, width: 200),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (_isTapped) {
                              _animationController.reverse();

                              if (_formKey.currentState!.validate()) {
                                productlist.addAll({
                                  _product: const Tuple2(null, false),
                                });
                                _product = Product();
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Error"),
                                  ),
                                );
                              }
                              setState(() {
                                _isTapped = false;
                              });
                            }
                          },
                          child: const Text("Submit"),
                        ),
                      ),
                    ],
                  ),
                );
              }),

              // Submit Button
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
    _productNameFieldController.dispose();
    _productPriceFieldController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Offset origin = Offset(
      widget.containerSize.width / 2,
      widget.containerSize.height - 50,
    );
    final Offset targetPosition = Offset(
      widget.containerSize.width / 2,
      widget.containerSize.height / 2,
    );

    return PositionedTransition(
      rect: RelativeRectTween(
        begin: RelativeRect.fromSize(
          Rect.fromCircle(
            center: origin,
            radius: _buttonRadius,
          ),
          widget.containerSize,
        ),
        end: RelativeRect.fromSize(
          Rect.fromCenter(
            center: targetPosition,
            width: _formWidth,
            height: _formHeight,
          ),
          widget.containerSize,
        ),
      ).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Curves.ease,
        ),
      ),
      child: _buildButton(),
    );
  }
}
