import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlandcoffeeapp/apis/api.dart';
import 'package:highlandcoffeeapp/screens/app/cart_page.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';
import 'package:highlandcoffeeapp/widgets/custom_alert_dialog.dart';

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
  SystemApi systemApi = SystemApi();
  // Hàm show notification xóa sản phẩm từ giỏ hàng
  void deleteProductFromCart(String cartdetailid) async {
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
          content:
              Text("Bạn có chắc muốn xóa sản phẩm này khỏi giỏ hàng không?",
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
                await systemApi.deleteCart(cartdetailid);
                Navigator.pop(context);
                showCustomAlertDialog(context, 'Thông báo',
                    'Xóa sản phẩm khỏi giỏ hàng thành công.');
                widget.onDelete();
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
              return Slidable(
                startActionPane: ActionPane(motion: StretchMotion(), children: [
                  SlidableAction(
                    onPressed: ((context) {
                      Get.toNamed('/list_product_page');
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
                      deleteProductFromCart(item.cartdetailid);
                    }),
                    borderRadius: BorderRadius.circular(18.0),
                    backgroundColor: Colors.transparent,
                    foregroundColor: red,
                    label: 'Xóa',
                    icon: Icons.remove_shopping_cart,
                  ),
                ]),
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Image.memory(
                            base64Decode(item.image),
                            width: 80,
                            height: 80,
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.productname,
                                style: GoogleFonts.arsenal(
                                    fontSize: 16,
                                    color: black,
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
                                        },
                                        child: Icon(
                                          Icons.remove,
                                          size: 15,
                                          color: white,
                                        ),
                                      )),
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
                        ),
                        Expanded(
                          flex: 2,
                          child: Column(
                            children: [
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
                          ),
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
