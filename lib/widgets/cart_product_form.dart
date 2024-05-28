import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlandcoffeeapp/apis/api.dart';
import 'package:highlandcoffeeapp/screens/app/cart_page.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';

class CartProductForm extends StatefulWidget {
  final List<CartItem> cartItems;
  final VoidCallback onDelete;
  const CartProductForm(
      {Key? key, required this.cartItems, required this.onDelete})
      : super(key: key);

  @override
  State<CartProductForm> createState() => _CartProductFormState();
}

class _CartProductFormState extends State<CartProductForm> {
  CartApi cartApi = CartApi();
  // Hàm show notification xóa sản phẩm từ giỏ hàng
  void deleteProductFromCart(String cartid) async {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(
            "Thông báo",
            style: GoogleFonts.arsenal(
              color: primaryColors,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          content:
              Text("Bạn có chắc muốn xóa sản phẩm này khỏi giỏ hàng không?"),
          actions: [
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: Text("Xóa"),
              onPressed: () async {
                await cartApi.deleteCart(cartid);
                Navigator.pop(context);
                _showAlert(
                    'Thông báo', 'Xóa sản phẩm khỏi giỏ hàng thành công.');
                widget.onDelete();
              },
            ),
            CupertinoDialogAction(
              child: Text(
                "Hủy",
                style: TextStyle(color: blue),
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

  // Future<void> removeCart(int cartId) async {
  //   try {
  //     print(cartId);
  //     // Thực hiện xóa sản phẩm từ cơ sở dữ liệu thông qua API
  //     final response = await http.delete(
  //       Uri.parse('http://localhost:5194/api/carts/$cartId'),
  //     );
  //     print(response.statusCode);
  //     if (response.statusCode == 200) {
  //       print('Product removed successfully!');
  //     } else {
  //       throw Exception('Product removal failed!');
  //     }
  //   } catch (e) {
  //     print('Product removal failed: $e');
  //   }
  // }

  // Future<int> getCartId(CartItem item) async {
  //   return item.id;
  // }

//
  void _showAlert(String title, String content) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(
            title,
            style: GoogleFonts.arsenal(color: primaryColors),
          ),
          content: Text(content),
          actions: <Widget>[
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'OK',
                style: TextStyle(color: blue),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 650,
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: widget.cartItems.length,
            itemBuilder: (context, index) {
              var item = widget.cartItems[index];
              // Uint8List _imageBytesDecoded = base64.decode(item.product_image);
              return Slidable(
                startActionPane: ActionPane(motion: StretchMotion(), children: [
                  SlidableAction(
                    onPressed: ((context) {
                      Get.toNamed('/home_page');
                    }),
                    borderRadius: BorderRadius.circular(18.0),
                    backgroundColor: Colors.transparent,
                    foregroundColor: blue,
                    label: 'Thêm',
                    icon: Icons.add_shopping_cart,
                  )
                ]),
                endActionPane: ActionPane(motion: StretchMotion(), children: [
                  SlidableAction(
                    onPressed: ((context) {
                      //comand delete
                      deleteProductFromCart(item.cartid);
                    }),
                    borderRadius: BorderRadius.circular(18.0),
                    backgroundColor: Colors.transparent,
                    foregroundColor: red,
                    label: 'Xóa',
                    icon: Icons.remove_shopping_cart,
                  ),
                ]),
                child: Container(
                  margin: EdgeInsets.symmetric(
                      vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // if(isValidBase64(item.product_image))
                        ///////////////////////////////////////////////////////////// Chưa fix lỗi hình ảnh chỗ này
                        Image.memory(
                          base64Decode(item.image),
                          width: 85,
                          height: 85,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.productname,
                              style: GoogleFonts.arsenal(
                                  fontSize: 18,
                                  color: primaryColors,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              item.totalprice.toStringAsFixed(3) + 'đ',
                              style: GoogleFonts.roboto(
                                color: primaryColors,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            // Text('Quantity: ${item.quantity}'),
                            Row(
                              children: [
                                Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                        color: primaryColors,
                                        shape: BoxShape.circle),
                                    child: GestureDetector(
                                      onTap: () {
                                        // Xử lý khi nhấn nút giảm
                                      },
                                      child: Icon(
                                        Icons.remove,
                                        size: 15,
                                        color: white,
                                      ),
                                    )),
                                //quantity + count
                                SizedBox(
                                  width: 35,
                                  child: Center(
                                    child: Text(
                                      item.quantity.toString(),
                                      style: GoogleFonts.roboto(
                                          fontSize: 15, color: black),
                                    ),
                                  ),
                                ),
                                Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                        color: primaryColors,
                                        shape: BoxShape.circle),
                                    child: GestureDetector(
                                      onTap: () {
                                        // Xử lý khi nhấn nút thêm
                                      },
                                      child: Icon(
                                        Icons.add,
                                        size: 15,
                                        color: white,
                                      ),
                                    ))
                              ],
                            )
                          ],
                        ),
                        Column(
                          children: [
                            // Text('Size: ${item.selectedSize}'),
                            Container(
                              height: 25,
                              width: 50,
                              decoration: BoxDecoration(
                                color: white,
                                borderRadius: BorderRadius.circular(18.0),
                                border: Border.all(
                                  color: primaryColors,
                                  width: 1,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  item.size,
                                  style: GoogleFonts.arsenal(
                                      color: primaryColors,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
