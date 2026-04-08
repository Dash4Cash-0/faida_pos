import 'package:faida_pos/controllers/checkout_controller.dart';
import 'package:faida_pos/controllers/product_controller.dart';
import 'package:faida_pos/l10n/app_localizations.dart';
import 'package:faida_pos/models/product.dart';
import 'package:faida_pos/models/sale_item.dart';
import 'package:faida_pos/services/database_service.dart';
import 'package:faida_pos/services/voice_recording_service.dart';
import 'package:faida_pos/services/wake_up_service.dart';
import 'package:faida_pos/widgets/checkout_widgets/checkout_bottom_sheet.dart';
import 'package:faida_pos/widgets/checkout_widgets/checkout_button_widget.dart';
import 'package:faida_pos/widgets/checkout_widgets/favorites_tab/favorites_widget.dart';
import 'package:faida_pos/widgets/checkout_widgets/inventory_tab/inventory_widget.dart';
import 'package:faida_pos/widgets/checkout_widgets/numpad_tab_widget.dart';
import 'package:faida_pos/widgets/shared/tab_config.dart';
import 'package:faida_pos/widgets/shared/tabs_widget.dart';
import 'package:flutter/material.dart';
import 'package:faida_pos/utils/checkout_utils/charge_button_text.dart';
import 'package:provider/provider.dart';
import '../widgets/checkout_widgets/receipt_widget.dart';


class Checkout extends StatefulWidget {

  final CheckoutController controller;
  final VoiceRecordingService recording;
  final WakeUpService wakeUp;

  const Checkout({super.key,
    required this.controller,
    required this.recording,
    required this.wakeUp});

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> with TickerProviderStateMixin {
  late final List<AnimationController> _barControllers;
  late final List<Animation<double>> _barAnimations;
  late final l10n = AppLocalizations.of(context)!;
  late final productController = Provider.of<ProductController>(context, listen: false);
  final _formKey = GlobalKey<FormState>();
  bool _isRecording = false;


  @override
  void initState(){
    super.initState();
    _barControllers = List.generate(8, (i) =>AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 250 + (i * 60) + (i % 3 * 40)),
    ));
    _barAnimations = _barControllers.map((c) =>
    Tween<double>(begin: 4, end: 45).animate(
      CurvedAnimation(parent: c, curve: Curves.easeInOut)
    )).toList();
    _loadFavoriteProducts();
    widget.recording.onAddProduct = onAddProductByVoice;
    widget.recording.onVoiceResult = (result) {
      if (result.toString().contains("unknown")) {
        onUnknownVoiceCommand();
      } else if (result.toString().contains("help")) {
        onHelpVoiceCommand();
      } else if (result.toString().contains("add")) {
        widget.recording.addProductsByVoice(result);
      } else {
        widget.recording.triggerQuickSale(result);
      }
    };
    widget.wakeUp.onRecordingStateChanged = (isRecording) {
      setState(() => _isRecording = isRecording);
      if (isRecording) {
        _startWave();
      } else {
        _stopWave();
      }
    };
  }

  @override
  void dispose(){
    for(final c in _barControllers){
      c.dispose();
    }
    super.dispose();
  }

  void _startWave(){
    for (final c in _barControllers){
      c.repeat(reverse: true);
    }
  }

  void _stopWave(){
    for(final c in _barControllers){
      c.stop();
      c.reset();
    }
  }

  Future<void> _loadFavoriteProducts() async {
    final products = await DatabaseService.instance.getFavoriteProducts();
    setState(() {
      widget.controller.favoriteProducts = products;
      widget.controller.isLoadingProducts = false;
    });
  }

  void _showOutOfStockDialog(Product p) {
    showDialog(context:
    context, builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.red,
        title: Text(l10n.outOfStock),
        content: Text("${p.name} ${l10n.isOutOfStock}",
            style: TextStyle(fontSize: 16)),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
                side: BorderSide(
                    color: Colors.black,
                    width: 1, style:
                BorderStyle.solid)
            ),
            child: Text(l10n.ok),)
        ],
      );
    });
  }

  Future<void> _onProductTapped(Product product) async {
    TextEditingController quantity = TextEditingController();
    if(product.inStock == 0){
      _showOutOfStockDialog(product);
    }else {
      await showDialog(context: context, builder: (_) =>
          Dialog(
            backgroundColor: Colors.white,
            child: SizedBox(width: 200, height: 200,
              child: Form(key: _formKey,
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: quantity,
                    keyboardType: TextInputType.numberWithOptions(
                        decimal: true),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(border: OutlineInputBorder(),
                        labelText: l10n.enterQuantity),
                    validator: (value) {
                      if(value == null || value.isEmpty || double.parse(value) <= 0){
                        return l10n.enterQuantity;
                      }
                      if(double.parse(value) > product.inStock){
                        return "${l10n.lowStock}\n"
                            "${l10n.inStock}:${product.inStock.round()}";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: BorderSide(color: Colors.black,
                              width: 1,
                              style: BorderStyle.solid)),
                      onPressed: () {
                        if(_formKey.currentState?.validate() == true) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("${product.name} ${l10n.added}"),
                              duration: Duration(seconds: 2),
                            ),
                          );
                          setState(() {
                            widget.controller.currentSaleList.value = [
                              ...widget.controller.currentSaleList.value,
                              SaleItem(productId: product.id,
                                  name: product.name,
                                  price: product.price,
                                  quantity: double.parse(quantity.text))
                            ];
                            widget.controller.storedValueNotifier.value +=
                                product.price * double.parse(quantity.text);
                          });
                        }
                          Navigator.pop(context);
                      }, child: Text(l10n.add))
                ],
              ),
            ),
            )
          )
          );
    }
  }

  void _onAddProductComplete() {
    _loadFavoriteProducts();
  }

  void onNumPressed(String digit){
    setState (() {
      widget.controller.input += digit;
    });
  }

  void onClear() {
    setState(() {
      widget.controller.input = "";
      widget.controller.storedValueNotifier.value = 0;
      widget.controller.partValues = "";
      widget.controller.currentSaleList.value = [];
    });
  }

  void onPlusPressed(){
    if(widget.controller.input.isEmpty) return;
    setState(() {
      final current = double.parse(widget.controller.input);
      widget.controller.storedValueNotifier.value += current;
      widget.controller.currentSaleList.value = [
       ...widget.controller.currentSaleList.value,
        SaleItem(productId: null, name: l10n.customAmount, price: double.parse(widget.controller.input), quantity: 1)
      ];
      widget.controller.input = "";
    });
  }

  void resetSale(){
    setState(() {
      widget.controller.storedValueNotifier.value = 0;
      widget.controller.input = "";
      widget.controller.partValues = "";
      widget.controller.currentSaleList.value = [];
    });
  }

  void addDiscount(String discount){

    setState(() {
      switch (discount) {
        case "5%":
          final double fivePercent = -widget.controller.storedValueNotifier.value * 0.05;
          setState(() {
            widget.controller.storedValueNotifier.value *= 0.95;
            widget.controller.currentSaleList.value = [
              ...widget.controller.currentSaleList.value,
            SaleItem(productId: null, name: "5% ${l10n.discount}: ", price: fivePercent, quantity: 1)
            ];
          });
          break;
        case "10%":
          final double tenPercent = -widget.controller.storedValueNotifier.value * 0.1;
          setState(() {
            widget.controller.storedValueNotifier.value *= 0.90;
            widget.controller.currentSaleList.value = [
              ...widget.controller.currentSaleList.value,
              SaleItem(productId: null, name: "10% ${l10n.discount}: ", price: tenPercent, quantity: 1)
            ];
          });
          break;
        case "15%":
          final double fifteenPercent = -widget.controller.storedValueNotifier.value * 0.15;
          setState(() {
            widget.controller.storedValueNotifier.value *=0.85;
            widget.controller.currentSaleList.value = [
              ...widget.controller.currentSaleList.value,
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
  try{
    await DatabaseService.instance.processSale(
        items: widget.controller.currentSaleList.value,
        amountReceived: amountReceived);
    await productController
        .commitSale(widget.controller.currentSaleList.value);

  } catch(e){
    if(!mounted) return;
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: Colors.red,
          title: Text(l10n.error),
          content: Text(l10n.wentWrong,
          style: TextStyle(fontSize: 16)),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.white,
                  side: BorderSide(
                      color: Colors.black,
                      width: 1, style:
                  BorderStyle.solid)
              ),
              child: Text(l10n.ok),)
          ],
        ));
    return;
  }
    if(!mounted) return;

    showDialog(
      context: context,
      builder: (_) => Dialog.fullscreen(
        child: ReceiptWidget(
          amountToPay: widget.controller.storedValueNotifier.value,
          onNewSale: resetSale,
          amountReceived: amountReceived,
          soldProducts: widget.controller.currentSaleList,
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
              controller: widget.controller.controller,
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
              customDiscount = -widget.controller.storedValueNotifier.value * (double.parse(widget.controller.controller.text) / 100);
              widget.controller.currentSaleList.value = [
                    ...widget.controller.currentSaleList.value,
                    SaleItem(
                      productId: null,
                      name: "${widget.controller.controller.text}% ${l10n.discount}",
                      price: customDiscount,
                      quantity: 1)
                  ];

              widget.controller.storedValueNotifier.value *= 1.0 - (double.parse(widget.controller.controller.text) / 100);
              widget.controller.controller.text = "";
              }),
                Navigator.pop(context)},
                child: Text(l10n.addDiscount, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),))
          ],
        ))
      ));
    });
  }

  void onQuickSale(){
    if(widget.controller.input.isNotEmpty) {
      setState(() {
        final current = double.parse(widget.controller.input);
        widget.controller.storedValueNotifier.value += current;
      });
    }
    showDialog(
        context: context,
        builder: (_) => Dialog(
          backgroundColor: Colors.white,
          constraints: BoxConstraints(maxHeight: 200, minWidth: 250),
          child:Padding(padding: EdgeInsets.all(10),
            child: Column( mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.compQuick,style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
              Spacer(),
              Text("TZS ${widget.controller.storedValueNotifier.value}",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20)),
                  Spacer(),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: ElevatedButton(onPressed: () async {
                              try{
                                await DatabaseService.instance.processQuickSale(
                                    amountReceived:
                                    widget.controller.storedValueNotifier.value);
                              }catch(e){
                                if(!mounted) return;
                                showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      backgroundColor: Colors.red,
                                      title: Text(l10n.error),
                                      content: Text(l10n.wentWrong,
                                          style: TextStyle(fontSize: 16)),
                                      actions: [
                                        ElevatedButton(
                                          onPressed: () => Navigator.pop(context),
                                          style: ElevatedButton.styleFrom(
                                              foregroundColor: Colors.black,
                                              backgroundColor: Colors.white,
                                              side: BorderSide(
                                                  color: Colors.black,
                                                  width: 1, style:
                                              BorderStyle.solid)
                                          ),
                                          child: Text(l10n.ok),)
                                      ],
                                    ));
                                return;
                              }
                              if(!mounted)return;
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.black,
                                backgroundColor: Colors.white,
                                side: BorderSide(
                                  color: Colors.black,width: 1,
                                  style: BorderStyle.solid,)), child: Text(l10n.yes)),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(onPressed: () =>
                                Navigator.pop(context),style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.black,
                                    backgroundColor: Colors.white,
                                    side: BorderSide(
                                      color: Colors.black,width: 1,
                                      style: BorderStyle.solid,)),
                                child: Text(l10n.no)),
                          ),
                        ],
                      ),
            ],
          )
            ,)
          ),
        );
  }

  void onUnknownVoiceCommand(){
    showDialog(context: context,
        builder: (context){
      Future.delayed(Duration(milliseconds: 1500), () {
        if(!context.mounted) return;
        Navigator.pop(context);
          });
      return AlertDialog(
        backgroundColor: Colors.deepOrange,
        content: Text("I didn't understand, please try again",
            style: TextStyle(fontWeight: FontWeight.bold,
                fontSize: 24)),
      );
        });
  }

  void onHelpVoiceCommand(){
    showDialog(context: context,
        builder: (context){
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text("Voice command examples",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            shape: Border.all(color: Colors.black,
                width: 1,
                style: BorderStyle.solid),
            content: Text("Try say: 'sell for [amount]' "
                "or 'make a sale for [amount] to make a quick sale",
                style: TextStyle(fontSize: 18)),
            actions: [
              ElevatedButton(onPressed: () => Navigator.pop(context),
                  child: Text("Close"))
            ],
          );
        });
  }

  void onAddProductByVoice(Product product, double quantity){
    if(product.inStock == 0){
      _showOutOfStockDialog(product);
    }else{
      setState(() {
        widget.controller.currentSaleList.value = [
          ...widget.controller.currentSaleList.value,
          SaleItem(productId: product.id,
              name: product.name,
              price: product.price,
              quantity: quantity)
        ];
        widget.controller.storedValueNotifier.value +=
            product.price * quantity;
      });
    }

  }
  @override
  Widget build(BuildContext context) {

    late final tabs = [
          () => NumpadTabWidget(
          onNumPressed: onNumPressed,
          onClear: onClear,
          onPlusPressed: onPlusPressed,
          value: widget.controller.input,
          partValues: widget.controller.partValues,
          storedValue: widget.controller.storedValueNotifier.value),
          () => InventoryWidget(
        productController: productController,
        onProductTap: _onProductTapped,
        refreshOnAddedFavorite: _onAddProductComplete,),
          () => FavoritesWidget(
        products: widget.controller.favoriteProducts,
        isLoading: widget.controller.isLoadingProducts,
        onProductTap: _onProductTapped,
        onProductAdded: _onAddProductComplete,
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child:Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TabsWidget(tabs: [
                  TabConfig(l10n.numpad),
                  TabConfig(l10n.inventory),
                  TabConfig(l10n.favorites)],
                    currentIndex: widget.controller.currentIndex,
                    onSelectedTab: (index) {
                  setState(() => widget.controller.currentIndex = index);
                    }),
                Expanded(child: tabs[widget.controller.currentIndex]()),
                CheckoutButtonWidget(label: l10n.quickSale,
                    onClicked: () => onQuickSale()),
                Align(alignment: Alignment.bottomCenter,
                  child:
                CheckoutButtonWidget(label:
                getChargeButtonText(currentSaleList: widget.controller.currentSaleList.value,
                    input: widget.controller.input,
                    review: l10n.review, items: l10n.items, charge: l10n.charge),
                    onClicked: () {
                  if(widget.controller.input.isNotEmpty){
                    setState(() {
                      final customAmount = double.parse(widget.controller.input);
                      widget.controller.storedValueNotifier.value += customAmount;
                      widget.controller.currentSaleList.value = [
                        ...widget.controller.currentSaleList.value,
                        SaleItem(productId: null, name: l10n.customAmount, price: double.parse(widget.controller.input), quantity: 1)
                      ];
                      widget.controller.input = "";
                    });
                  }
                  showModalBottomSheet(
                      context: context,
                      builder: (_) =>
                        CheckoutBottomSheet(
                          itemsCount: widget.controller.currentSaleList.value.length,
                          currentSaleItems: widget.controller.currentSaleList.value,
                          storedValueNotifier: widget.controller.storedValueNotifier,
                          saleItemNotifier: widget.controller.currentSaleList,
                          onNewSale: resetSale,
                          addDiscount: addDiscount,
                          onCalculate: _onCalculatePressed,),
                      );
                      }
                    )
                )
              ],
            ),
            if(_isRecording)
              Positioned(
                bottom: 250,
                left: 0,
                right: 0,
                child: IgnorePointer(
                  child: Column(
                    children: [
                      Text(
                        "Listening....",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 12),
                      SizedBox(
                        height: 60,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: List.generate(20, (i) =>
                              AnimatedBuilder(
                                animation: _barAnimations[i % _barAnimations.length],
                                builder: (context, _) {
                                  final distanceFromCenter = (i - 9.5).abs();
                                  final heightMultiplier = 1.0 - (distanceFromCenter / 12);
                                  return Container(
                                    margin: EdgeInsets.symmetric(horizontal: 2.5),
                                    width: 4,
                                    height: (_barAnimations[i % _barAnimations.length].value * heightMultiplier).clamp(4, 60),
                                    decoration: BoxDecoration(
                                      color: Colors.red.withValues(alpha: 0.6 + (heightMultiplier * 0.4)),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  );
                                },
                              ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            Positioned(
              bottom: 155,
              child: Listener(
                onPointerDown: (_) {
                  setState(() => _isRecording = true);
                  widget.wakeUp.stopListening();
                  _startWave();
                  widget.recording.startRecording();
                },
                onPointerUp: (_) async {
                  setState(() => _isRecording = false);
                  _stopWave();
                  final result = await widget.recording.stopRecording();
                  await Future.delayed(const Duration(milliseconds: 300));

                  widget.wakeUp.startListening();
                  if(result.toString().contains("unknown")){
                    onUnknownVoiceCommand();
                  }
                  else if(result.toString().contains("help")){
                      onHelpVoiceCommand();
                  }
                  else if(result.toString().contains("add")){
                    widget.recording.addProductsByVoice(result);
                  }else{
                    widget.recording.triggerQuickSale(result);
                  }
                },
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: _isRecording ? Colors.red : Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.mic, color: Colors.white),
                ),
              ),
            ),
          ],
        )
      ),
    );
  }
}

