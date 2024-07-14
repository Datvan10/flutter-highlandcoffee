import 'dart:convert';
import 'dart:typed_data';

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
import 'package:highlandcoffeeapp/widgets/custom_alert_dialog.dart';
import 'package:highlandcoffeeapp/widgets/size_product.dart';

class ProductDetailPage extends StatefulWidget {
  final List<Map<String, dynamic>> productSizes;
  final Product product;
  const ProductDetailPage(
      {super.key, required this.product, required this.productSizes});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int quantityCount = 1;
  int totalPrice = 0;
  bool isFavorite = false;
  String selectedSize = '';
  Customer? loggedInUser = AuthManager().loggedInCustomer;
  final SystemApi systemApi = SystemApi();

  @override
  void initState() {
    super.initState();
    selectedSize = widget.product.size;
    updateTotalPrice();
  }

  void decrementQuantity() {
    setState(() {
      if (quantityCount > 1) {
        quantityCount--;
        updateTotalPrice();
      }
    });
  }

  void incrementQuantity() {
    setState(() {
      quantityCount++;
      updateTotalPrice();
    });
  }

  void updateTotalPrice() {
    setState(() {
      totalPrice = getPriceForSelectedSize() * quantityCount;
    });
  }

  int getPriceForSelectedSize() {
    for (var size in widget.productSizes) {
      if (size['size'] == selectedSize) {
        return size['price'];
      }
    }
    return 0;
  }

  void _showConfirmationDialog() {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(
            "Thông báo",
            style: GoogleFonts.roboto(
              color: primaryColors,
              fontWeight: FontWeight.bold,
              fontSize: 19,
            ),
          ),
          content: Text("Thêm sản phẩm này vào danh sách sản phẩm yêu thích?",
              style: GoogleFonts.roboto(
                color: black,
                fontSize: 16,
              )),
          actions: [
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: Text("OK",
                  style: GoogleFonts.roboto(
                      color: blue, fontSize: 17, fontWeight: FontWeight.bold)),
              onPressed: () async {
                addToFavorites();
                setState(() {
                  isFavorite = !isFavorite;
                });
                Navigator.pop(context);
              },
            ),
            CupertinoDialogAction(
              child: Text(
                "Hủy",
                style: GoogleFonts.roboto(color: blue, fontSize: 17),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void addToFavorites() async {
    try {
      Uint8List image = base64Decode(widget.product.image);
      Uint8List imageDetail = base64Decode(widget.product.imagedetail);

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

      await systemApi.addFavorite(favorite);
      showCustomAlertDialog(
          context, 'Thành công', 'Đã thêm sản phẩm vào danh sách yêu thích');
    } catch (e) {
      print(e);
      showCustomAlertDialog(
          context, 'Lỗi', 'Không thể thêm sản phẩm vào danh sách yêu thích');
    }
  }

  Future<void> addToCart() async {
    try {
      Uint8List image = base64Decode(widget.product.image);
      String base64Image = base64Encode(image);

      Cart newCart = Cart(
          cartdetailid: '',
          cartid: '',
          customerid: loggedInUser!.customerid!,
          productid: widget.product.productid,
          quantity: quantityCount,
          image: base64Image,
          productname: widget.product.productname,
          totalprice: totalPrice,
          size: selectedSize);

      await systemApi.addCart(newCart);
      showCustomAlertDialog(
          context, 'Thành công', 'Đã thêm sản phẩm vào giỏ hàng');
    } catch (e) {
      print(e);
      showCustomAlertDialog(
          context, 'Lỗi', 'Không thể thêm sản phẩm vào giỏ hàng');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Stack(
                children: [
                  Image.memory(
                    widget.product.imagedetail != null
                        ? base64Decode(widget.product.imagedetail)
                        : Uint8List(0),
                  ),
                  Positioned(
                    top: 54,
                    left: 8,
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: white,
                      ),
                      onPressed: () {
                        Get.back();
                      },
                    ),
                  ),
                  Positioned(
                    top: 54,
                    right: 8,
                    child: IconButton(
                      icon: Icon(
                        Icons.shopping_cart,
                        color: white,
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => CartPage(),
                        ));
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 150),
            ],
          ),
          Positioned(
            top:
                415,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                child: Column(
                  children: [
                    SizedBox(height: 15.0,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.product.productname.toUpperCase(),
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
                      ],
                    ),
                    SizedBox(height: 10.0,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.memory(
                          base64Decode(widget.product.image),
                          width: 85,
                          height: 85,
                          fit: BoxFit.cover,
                        ),
                        Expanded(
                          child: SizedBox(
                            height: 120,
                            child: Text(
                              widget.product.description,
                              style: GoogleFonts.roboto(
                                  fontSize: 17, color: black),
                              maxLines: 5,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    //product size
                    Row(
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
                    SizedBox(
                      height: 20,
                    ),
                    //product quantity
                    Row(
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
                                    color: primaryColors,
                                    shape: BoxShape.circle),
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
                    SizedBox(
                      height: 20,
                    ),
                    //product price
                    Row(
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
                    SizedBox(
                      height: 20,
                    ),
                    Row(
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
                    SizedBox(
                      height: 50,
                    ),
                    //button add to cart and buy now
                    IntrinsicHeight(
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
                            color: light_brown,
                            thickness: 1,
                          ),
                          ButtonBuyNow(
                              text: 'Mua ngay',
                              onTap: () {
                                addToCart();
                              }),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
