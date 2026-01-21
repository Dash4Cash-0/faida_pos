import 'package:faida_pos/l10n/app_localizations.dart';
import 'package:faida_pos/models/product.dart';
import 'package:faida_pos/models/sale_item.dart';
import 'package:faida_pos/services/database_service.dart';
import 'package:faida_pos/widgets/checkout_widgets/checkout_bottom_sheet.dart';
import 'package:faida_pos/widgets/checkout_widgets/checkout_button_widget.dart';
import 'package:faida_pos/widgets/checkout_widgets/favorites_tab/favorites_widget.dart';
import 'package:faida_pos/widgets/checkout_widgets/inventory_tab/inventory_widget.dart';
import 'package:faida_pos/widgets/checkout_widgets/numpad_tab_widget.dart';
import 'package:faida_pos/widgets/shared/tab_config.dart';
import 'package:faida_pos/widgets/shared/tabs_widget.dart';
import 'package:flutter/material.dart';
import 'package:faida_pos/utils/checkout_utils/charge_button_text.dart';
import '../widgets/checkout_widgets/receipt_widget.dart';


class Checkout extends StatefulWidget {
  const Checkout({super.key});

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  String input = "";
  String partValues = "";
  int _currentIndex = 0;
  String currentSale = "";
  final storedValueNotifier = ValueNotifier<double>(0);
  final controller = TextEditingController();
  late final l10n = AppLocalizations.of(context)!;
  final ValueNotifier <List<SaleItem>> _currentSaleList = ValueNotifier<List<SaleItem>>([]);
  List<Product> _favoriteProducts = [];
  bool _isLoadingProducts = true;

  @override
  void initState(){
    super.initState();
    _loadFavoriteProducts();
  }

  Future<void> _loadFavoriteProducts() async {
    final products = await DatabaseService.instance.getFavoriteProducts();
    setState(() {
      _favoriteProducts = products;
      _isLoadingProducts = false;
    });
  }

  void _onProductTapped(Product product) {
    final quantity = TextEditingController();
      showDialog(context: context, builder: (_) => Dialog(
        backgroundColor: Colors.white,
        child: SizedBox(width: 200, height: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: quantity,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(border: OutlineInputBorder(),
              labelText: l10n.enterQuantity),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white, side: BorderSide(color: Colors.black, width: 1, style: BorderStyle.solid)),
                onPressed: (){
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:Text("${product.name} ${l10n.added}"),
                      duration: Duration(seconds: 2),
                    ),
                  );
                setState(() {
                  _currentSaleList.value = [
                    ..._currentSaleList.value,
                    SaleItem(productId: product.id, name: product.name, price: product.price, quantity: double.parse(quantity.text))
                  ];
                  storedValueNotifier.value += product.price * double.parse(quantity.text);
                  Navigator.pop(context);
                });
            }, child: Text(l10n.add))
          ],
        ),
        ),
      ));
  }

  void _onAddProductComplete() {
    _loadFavoriteProducts();
  }

  late final tabs = [
    () => NumpadTabWidget(
        onNumPressed: onNumPressed,
        onClear: onClear,
        onPlusPressed: onPlusPressed,
        value: input,
        partValues: partValues,
        storedValue: storedValueNotifier.value),
    () => InventoryWidget(
        onProductTap: _onProductTapped,
        refreshOnAddedFavorite: _onAddProductComplete,),
    () => FavoritesWidget(
      products: _favoriteProducts,
      isLoading: _isLoadingProducts,
      onProductTap: _onProductTapped,
      onProductAdded: _onAddProductComplete,
    ),
  ];


  void onNumPressed(String digit){
    setState (() {
      input += digit;
    });
  }

  void onClear() {
    setState(() {
      input = "";
      storedValueNotifier.value = 0;
      partValues = "";
      _currentSaleList.value = [];
    });
  }

  void onPlusPressed(){
    if(input.isEmpty) return;
    setState(() {
      final current = double.parse(input);
      storedValueNotifier.value += current;
      _currentSaleList.value = [
       ..._currentSaleList.value,
        SaleItem(productId: null, name: l10n.customAmount, price: double.parse(input), quantity: 1)
      ];
      input = "";
    });
  }

  void resetSale(){
    setState(() {
      storedValueNotifier.value = 0;
      input = "";
      partValues = "";
      _currentSaleList.value = [];
    });
  }

  void addDiscount(String discount){

    setState(() {
      switch (discount) {
        case "5%":
          final double fivePercent = -storedValueNotifier.value * 0.05;
          setState(() {
            storedValueNotifier.value *= 0.95;
            _currentSaleList.value = [
              ..._currentSaleList.value,
            SaleItem(productId: null, name: "5% ${l10n.discount}: ", price: fivePercent, quantity: 1)
            ];
          });
          break;
        case "10%":
          final double tenPercent = -storedValueNotifier.value * 0.1;
          setState(() {
            storedValueNotifier.value *= 0.90;
            _currentSaleList.value = [
              ..._currentSaleList.value,
              SaleItem(productId: null, name: "10% ${l10n.discount}: ", price: tenPercent, quantity: 1)
            ];
          });
          break;
        case "15%":
          final double fifteenPercent = -storedValueNotifier.value * 0.15;
          setState(() {
            storedValueNotifier.value *=0.85;
            _currentSaleList.value = [
              ..._currentSaleList.value,
              SaleItem(productId: null, name: "15% ${l10n.discount}: ", price: fifteenPercent, quantity: 1)
            ];
          });
          break;
        case "...":
          _showCustomDialog();
          break;
       }
      }
    );
  }

  void _onCalculatePressed(double amountReceived) async {

    Navigator.pop(context);

    await DatabaseService.instance.processSale(
        items: _currentSaleList.value,
        amountReceived: amountReceived);
    if(!mounted) return;

    showDialog(
      context: context,
      builder: (_) => Dialog.fullscreen(
        child: ReceiptWidget(
          amountToPay: storedValueNotifier.value,
          onNewSale: resetSale,
          amountReceived: amountReceived,
          soldProducts: _currentSaleList,
        ),
      ),
    );
  }

  void _showCustomDialog(){
    double customDiscount;
    setState(() {
      showDialog(context: context, builder: (BuildContext context) => Dialog(
        backgroundColor: Colors.white,
        child: SizedBox(width: 400, height: 200,
        child: Column(
          children: [
            SizedBox(height: 56,
                child: Stack( alignment: Alignment.center,
                  children: [
                    Align(alignment: Alignment.centerLeft,
                        child: CloseButton()
                    ),
                    Text(l10n.customDiscount, style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                  ],
                )
            ),
            SizedBox(height: 10),
            TextField(
              controller: controller,
            decoration: InputDecoration(
              constraints: BoxConstraints(maxWidth: 100),
              suffixIcon: Icon(Icons.percent),
              border: OutlineInputBorder(),
            )
            ),
            SizedBox(height: 10),
            ElevatedButton(style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              side: BorderSide(color: Colors.black, style: BorderStyle.solid)
            ),
                onPressed: () => {
              setState(() {
              customDiscount = -storedValueNotifier.value * (double.parse(controller.text) / 100);
                  _currentSaleList.value = [
                    ..._currentSaleList.value,
                    SaleItem(
                      productId: null,
                      name: "${controller.text}% ${l10n.discount}",
                      price: customDiscount,
                      quantity: 1)
                  ];

                  storedValueNotifier.value *= 1.0 - (double.parse(controller.text) / 100);
                  controller.text = "";
              }),
                Navigator.pop(context)},
                child: Text(l10n.addDiscount, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),))
          ],
        ))
      ));
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TabsWidget(tabs: [
              TabConfig(l10n.numpad),
              TabConfig(l10n.inventory),
              TabConfig(l10n.favorites)],
                currentIndex: _currentIndex,
                onSelectedTab: (index) {
              setState(() => _currentIndex = index);
                }),
            Expanded(child: tabs[_currentIndex]()),
            Align(alignment: Alignment.bottomCenter,
              child:
            CheckoutButtonWidget(label:
            getChargeButtonText(currentSaleList: _currentSaleList.value,
                input: input,
                review: l10n.review, items: l10n.items, charge: l10n.charge),
                onClicked: () {
              if(input.isNotEmpty){
                setState(() {
                  final customAmount = double.parse(input);
                  storedValueNotifier.value += customAmount;
                  _currentSaleList.value = [
                    ..._currentSaleList.value,
                    SaleItem(productId: null, name: l10n.customAmount, price: double.parse(input), quantity: 1)
                  ];
                  input = "";
                });
              }
              showModalBottomSheet(
                  context: context,
                  builder: (_) =>
                    CheckoutBottomSheet(
                      itemsCount: _currentSaleList.value.length,
                      currentSaleItems: _currentSaleList.value,
                      storedValueNotifier: storedValueNotifier,
                      saleItemNotifier: _currentSaleList,
                      onNewSale: resetSale,
                      addDiscount: addDiscount,
                      onCalculate: _onCalculatePressed,),
                  );
                  }
                )
            )
          ],
        ),
      ),
    );
  }
}

