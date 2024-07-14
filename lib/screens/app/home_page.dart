// home_page.dart
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
import 'package:highlandcoffeeapp/widgets/custom_search_bar.dart';

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
  SystemApi systemApi = SystemApi();

  //
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  void _selectedBottomBar(int index) {
    if (index == 0) {
      _refreshData();
    } else {
      setState(() {
        _selectedIndexBottomBar = index;
      });
    }
  }

  Future<void> _refreshData() async {
    await Future.delayed(Duration(seconds: 5));

    setState(() {});
  }

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
      List<Product> products = await systemApi.getListProducts();

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
          child: CustomSearchBar(
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
