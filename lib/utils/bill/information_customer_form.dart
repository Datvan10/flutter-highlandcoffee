import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlandcoffeeapp/models/model.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';

class InformationCustomerForm extends StatelessWidget {
  final Customer? loggedInUser; // Thêm thuộc tính loggedInUser
  const InformationCustomerForm({Key? key, required this.loggedInUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Kiểm tra nếu người dùng đã đăng nhập
    if (loggedInUser != null) {
      // Trích xuất thông tin từ loggedInUser
      String userName = loggedInUser!.name;
      String address = loggedInUser!.address;
      String phoneNumber = loggedInUser!.phonenumber.toString();

      return Container(
        height: 150,
        decoration: BoxDecoration(
            color: white, borderRadius: BorderRadius.circular(15.0)),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.person, color: primaryColors),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    userName,
                    style: GoogleFonts.roboto(
                      fontSize: 17,
                      color: black,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.location_on, color: primaryColors),
                  SizedBox(
                    width: 10,
                  ),
                  Text(address,
                      style: GoogleFonts.roboto(
                        fontSize: 17,
                        color: black,
                      )),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.phone, color: primaryColors),
                  SizedBox(
                    width: 10,
                  ),
                  Text(phoneNumber,
                      style: GoogleFonts.roboto(
                        fontSize: 17,
                        color: black,
                      )),
                ],
              )
            ],
          ),
        ),
      );
    } else {
      return Text('Người dùng chưa đăng nhập');
    }
  }
}
