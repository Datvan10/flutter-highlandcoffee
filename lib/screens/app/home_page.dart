import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlandcoffeeapp/apis/api.dart';
import 'package:highlandcoffeeapp/models/model.dart';
import 'package:highlandcoffeeapp/screens/app/result_search_product_product_with_keyword_page.dart';
import 'package:highlandcoffeeapp/widgets/best_sale_product_item.dart';
import 'package:highlandcoffeeapp/widgets/custom_bottom_navigation_bar.dart';
import 'package:highlandcoffeeapp/widgets/product_category.dart';
import 'package:highlandcoffeeapp/widgets/product_popular_item.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';
import 'package:highlandcoffeeapp/utils/mic/mic_form.dart';
import 'package:highlandcoffeeapp/widgets/slide_image.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndexBottomBar = 0;
  bool _isListening = false;
  bool _isMicFormVisible = false;
  final _textSearchController = TextEditingController();
  List<Product> searchResults = [];

  //
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  //SelectedBottomBar
  void _selectedBottomBar(int index) {
    if (index == 0) {
      // Check if the home icon is pressed
      _refreshData(); // Perform the refresh logic
    } else {
      setState(() {
        _selectedIndexBottomBar = index;
      });
    }
  }

  //
  Future<void> _refreshData() async {
    await Future.delayed(Duration(seconds: 5));

    setState(() {});
  }

  //
  Future<void> _requestMicrophonePermission() async {
    var status = await Permission.microphone.status;
    if (status.isDenied) {
      await Permission.microphone.request();
    }
  }

  void _startListening() async {
    await _requestMicrophonePermission();

    if (await Permission.microphone.isGranted) {
      Get.to(() => MicForm())?.then((value) {
        setState(() {
          _isMicFormVisible = false;
        });
      });
    } else {
      print("Người dùng từ chối cấp quyền truy cập vào microphone");
    }
  }

  void performSearch(String query) async {
    try {
      ProductApi productApi = ProductApi();
      List<Product> products = await productApi.getListProducts();

      List<Product> filteredProducts = products
          .where((product) =>
              product.productname.toLowerCase().contains(query.toLowerCase()))
          .toList();

      List<Product> convertedResults = filteredProducts.map((product) {
        return Product(
          productid: product.productid,
          productname: product.productname,
          size: product.size,
          price: product.price,
          unit: product.unit,
          image: product.image,
          imagedetail: product.imagedetail,
          description: product.description,
          categoryid: product.categoryid,
        );
      }).toList();

      print('Search results: $convertedResults');

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultSearchProductWithKeyword(
            searchResults: convertedResults,
            voiceQuery: query,
          ),
        ),
      );
    } catch (error) {
      print('Error searching products: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: primaryColors,
        title: Padding(
          padding: const EdgeInsets.only(bottom: 15.0),
          child: SearchBar(
            textSearchController: _textSearchController,
            performSearch: performSearch,
            startListening: _startListening,
          ),
        ),
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refreshData,
        child: Padding(
          padding: const EdgeInsets.only(left: 18.0, top: 18.0, right: 18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SlideImage(
                height: 180,
              ),
              SizedBox(height: 15),
              ProductCategory(),
              SizedBox(height: 15),
              ProductPopularItem(),
              SizedBox(
                height: 5.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.toNamed('/product_popular_page');
                    },
                    child: Text(
                      'Xem thêm >>',
                      style: GoogleFonts.arsenal(color: blue, fontSize: 17),
                    ),
                  ),
                ],
              ),
              Text('ĐỒ UỐNG HÓT',
                  style: GoogleFonts.arsenal(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: primaryColors)),
              SizedBox(
                height: 5.0,
              ),
              Expanded(
                child: BestSaleProductItem(),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndexBottomBar,
        onTap: _selectedBottomBar,
      ),
    );
  }
}

class SearchBar extends StatefulWidget {
  final TextEditingController textSearchController;
  final Function(String) performSearch;
  final VoidCallback startListening;

  const SearchBar({
    Key? key,
    required this.textSearchController,
    required this.performSearch,
    required this.startListening,
  }) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  void initState() {
    super.initState();
    widget.textSearchController.addListener(_updateSuffixIcon);
  }

  @override
  void dispose() {
    widget.textSearchController.removeListener(_updateSuffixIcon);
    super.dispose();
  }

  void _updateSuffixIcon() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: TextField(
        controller: widget.textSearchController,
        onSubmitted: (String query) {
          widget.performSearch(query);
        },
        decoration: InputDecoration(
          hintText: 'Tìm kiếm đồ uống của bạn...',
          hintStyle: GoogleFonts.arsenal(color: black, fontSize: 17),
          contentPadding: EdgeInsets.symmetric(),
          alignLabelWithHint: true,
          filled: true,
          fillColor: Colors.white,
          prefixIcon: const Icon(
            Icons.search,
            size: 20,
          ),
          suffixIcon: widget.textSearchController.text.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: white_grey,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                        child: GestureDetector(
                      onTap: () {
                        widget.textSearchController.clear();
                        setState(() {});
                      },
                      child: Icon(
                        Icons.close,
                        size: 10,
                      ),
                    )),
                  ),
                )
              : GestureDetector(
                  onTap: () {
                    widget.startListening();
                    setState(() {});
                  },
                  child: Icon(
                    Icons.mic,
                    size: 20,
                  ),
                ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: BorderSide(color: Colors.white),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
