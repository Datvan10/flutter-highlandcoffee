import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlandcoffeeapp/apis/api.dart';
import 'package:highlandcoffeeapp/auth/auth_manage.dart';
import 'package:highlandcoffeeapp/models/model.dart';
import 'package:highlandcoffeeapp/widgets/button_add_to_cart.dart';
import 'package:highlandcoffeeapp/widgets/button_buy_now.dart';
import 'package:highlandcoffeeapp/screens/app/cart_page.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';
import 'package:highlandcoffeeapp/widgets/notification_dialog.dart';
import 'package:highlandcoffeeapp/widgets/size_product.dart';
import 'package:highlandcoffeeapp/widgets/notification.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;
  const ProductDetailPage({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class CartPageArguments {}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int quantityCount = 1; //quantity
  int totalPrice = 0; // total price
  bool isFavorite = false;
  String selectedSize = 'S';
  Customer? loggedInUser = AuthManager().loggedInCustomer;
  final CartApi cartApi = CartApi();
  final FavoriteApi favoriteApi = FavoriteApi();

  @override
  void initState() {
    super.initState();
    updateTotalPrice();
  }

  //
  void decrementQuantity() {
    setState(() {
      if (quantityCount > 1) {
        quantityCount--;
        updateTotalPrice();
      }
    });
  }

  //
  void incrementQuantity() {
    setState(() {
      quantityCount++;
      updateTotalPrice();
    });
  }

  // // initialization variable total price
  // double totalPrice = 0.0;

  // void updateTotalPrice() {
  //   setState(() {
  //     int productPrice = widget.product.price;
  //     totalPrice = productPrice * quantityCount;
  //   });
  // }

  void updateTotalPrice() {
    setState(() {
      int productPrice;
      switch (selectedSize) {
        case 'S':
          productPrice = widget.product.price;
          break;
        case 'M':
          productPrice = widget.product.price;
          break;
        case 'L':
          productPrice = widget.product.price;
          break;
        default:
          productPrice = 0;
      }
      totalPrice = productPrice * quantityCount;
    });
  }

  //
  int getPriceForSelectedSize() {
    // Dựa vào kích thước đã chọn, trả về giá tương ứng
    switch (selectedSize) {
      case 'S':
        return widget.product.price;
      case 'M':
        return widget.product.price;
      case 'L':
        return widget.product.price;
      default:
        return 0;
    }
  }

  //
  // void _showConfirmationDialog() {
  //   showCupertinoDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return CupertinoAlertDialog(
  //         title: Text("Thêm vào danh sách sản phẩm yêu thích?"),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.pop(context);
  //             },
  //             child: Text("Hủy", style: TextStyle(color: red),),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               _addToFavorites();
  //               setState(() {
  //                 isFavorite = !isFavorite;
  //               });
  //               Navigator.pop(context);
  //             },
  //             child: Text("Đồng ý", style: TextStyle(color: blue),),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
  void _showConfirmationDialog() {
    notificationDialog(
      context: context,
      title: "Thêm vào danh sách sản phẩm yêu thích?",
      onConfirm: () {
        _addToFavorites();
        setState(() {
          isFavorite = !isFavorite;
        });
      },
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Hủy", style: TextStyle(color: Colors.red)),
        ),
        TextButton(
          onPressed: () {
            _addToFavorites();
            setState(() {
              isFavorite = !isFavorite;
            });
            Navigator.pop(context);
          },
          child: Text("Đồng ý", style: TextStyle(color: Colors.blue)),
        ),
      ],
    );
  }

  //
  void _addToFavorites() async {
    try {
      // Chuyển đổi chuỗi base64 thành dữ liệu nhị phân (Uint8List)
      Uint8List image = base64Decode(widget.product.image);
      Uint8List imageDetail = base64Decode(widget.product.imagedetail);

      // Mã hóa dữ liệu nhị phân thành chuỗi base64
      String base64Image = base64Encode(image);
      String base64ImageDetail = base64Encode(imageDetail);

      Favorite favorite = Favorite(
        favoriteid: '',
        customerid: loggedInUser!.customerid!,
        productid: widget.product.productid,
        productname: widget.product.productname,
        description: widget.product.description,
        size: selectedSize,
        price: widget.product.price,
        unit: widget.product.unit,
        image: base64Image,
        imagedetail: base64ImageDetail,
      );

      await favoriteApi.addFavorite(favorite);
      showNotification(
          'Thành công', 'Đã thêm sản phẩm vào danh sách yêu thích');
    } catch (e) {
      print(e);
      showNotification(
          'Lỗi', 'Không thể thêm sản phẩm vào danh sách yêu thích');
    }
  }

  // Function to add item to the cart collection
  Future<void> addToCart() async {
    try {
      // Chuyển đổi chuỗi base64 thành dữ liệu nhị phân (Uint8List)
      Uint8List image = base64Decode(widget.product.image);
      // Mã hóa dữ liệu nhị phân thành chuỗi base64
      String base64Image = base64Encode(image);
      Cart cart = Cart(
          cartdetailid: '',
          cartid: '',
          customerid: loggedInUser!.customerid!,
          productid: widget.product.productid,
          quantity: quantityCount,
          image: base64Image,
          productname: widget.product.productname,
          totalprice: totalPrice,
          size: selectedSize);
      // print(cart.toJson());

      await cartApi.addCart(cart);
      showNotification('Thành công', 'Đã thêm sản phẩm vào giỏ hàng');
    } catch (e) {
      print(e);
      showNotification('Lỗi', 'Không thể thêm sản phẩm vào giỏ hàng');
    }
  }

  //
  void showNotification(String title, String content) {
  showCupertinoDialog(
    context: context,
    builder: (BuildContext context) {
      return NotificationDialog(title: title, content: content);
    },
  );
}

  //

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              Image.memory(
                widget.product.imagedetail != null
                    ? base64Decode(widget.product.imagedetail)
                    : Uint8List(0),
              ),

              //
              Positioned(
                top: 54,
                left: 8,
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: white,
                  ),
                  onPressed: () {
                    // Xử lý khi nhấn nút quay lại
                    Get.back();
                  },
                ),
              ),
              //
              Positioned(
                top: 54,
                right: 8,
                child: IconButton(
                  icon: Icon(
                    Icons.shopping_cart,
                    color: white,
                  ),
                  onPressed: () {
                    // Xử lý khi nhấn nút giỏ hàng
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CartPage(),
                    ));
                  },
                ),
              ),
            ],
          ),
          Expanded(
              child: Container(
            padding: const EdgeInsets.only(top: 10.0),
            decoration: BoxDecoration(color: white),
            child: Column(
              children: [
                //product name and icon favorite
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                    widget.product.productname,
                    style: GoogleFonts.arsenal(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: primaryColors),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  IconButton(
                      onPressed: () {
                        _showConfirmationDialog();
                      },
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: primaryColors,
                        size: 30,
                      ))
                ]),
                //product image and description
                Padding(
                  padding: const EdgeInsets.only(right: 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.memory(
                        base64Decode(widget.product.image),
                        width: 85,
                        height: 85,
                        fit: BoxFit.cover,
                      ),
                      Expanded(
                        child: Text(
                          widget.product.description,
                          style: GoogleFonts.roboto(fontSize: 17, color: black),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                //product size
                Padding(
                  padding: const EdgeInsets.only(left: 18, right: 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Chọn Size',
                        style: GoogleFonts.arsenal(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: black),
                      ),
                      SizeProducts(
                        titleSize: 'S',
                        isSelected: selectedSize == 'S',
                        onSizeSelected: (size) {
                          setState(() {
                            selectedSize = size;
                            updateTotalPrice();
                          });
                        },
                      ),
                      SizeProducts(
                        titleSize: 'M',
                        isSelected: selectedSize == 'M',
                        onSizeSelected: (size) {
                          setState(() {
                            selectedSize = size;
                            updateTotalPrice();
                          });
                        },
                      ),
                      SizeProducts(
                        titleSize: 'L',
                        isSelected: selectedSize == 'L',
                        onSizeSelected: (size) {
                          setState(() {
                            selectedSize = size;
                            updateTotalPrice();
                          });
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                //product quantity
                Padding(
                  padding: const EdgeInsets.only(left: 18, right: 18),
                  child: Row(
                    children: [
                      Text(
                        'Số lượng ',
                        style: GoogleFonts.arsenal(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: black),
                      ),
                      SizedBox(width: 50),
                      Row(
                        children: [
                          Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                  color: light_grey, shape: BoxShape.circle),
                              child: GestureDetector(
                                onTap: decrementQuantity,
                                child: Icon(
                                  Icons.remove,
                                  size: 19,
                                  color: white,
                                ),
                              )),
                          //quantity + count
                          SizedBox(
                            width: 35,
                            child: Center(
                              child: Text(
                                quantityCount.toString(),
                                style: GoogleFonts.roboto(
                                    fontSize: 17, color: black),
                              ),
                            ),
                          ),
                          Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                  color: primaryColors, shape: BoxShape.circle),
                              child: GestureDetector(
                                onTap: incrementQuantity,
                                child: Icon(
                                  Icons.add,
                                  size: 19,
                                  color: white,
                                ),
                              ))
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                //product price
                Padding(
                  padding: const EdgeInsets.only(left: 18, right: 18),
                  child: Row(
                    children: [
                      Text(
                        'Tổng tiền',
                        style: GoogleFonts.arsenal(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: black),
                      ),
                      SizedBox(
                        width: 50,
                      ),
                      Text(
                        totalPrice.toStringAsFixed(3) + 'đ',
                        style: GoogleFonts.roboto(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: primaryColors),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 18, right: 18),
                  child: Row(
                    children: [
                      Text(
                        'Đơn vị tính ',
                        style: GoogleFonts.arsenal(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: black),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Text(
                        '${widget.product.unit}',
                        style: GoogleFonts.roboto(fontSize: 19, color: black),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 60,
                ),
                //button add to cart and buy now
                Padding(
                  padding: const EdgeInsets.only(left: 18, right: 18),
                  child: IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ButtonAddToCart(
                          text: 'Thêm vào giỏ',
                          onTap: () {
                            addToCart();
                          },
                        ),
                        VerticalDivider(
                          color: light_grey,
                          thickness: 1,
                        ),
                        ButtonBuyNow(text: 'Mua ngay', onTap: () {}),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )),
        ],
      ),
    );
  }
}
