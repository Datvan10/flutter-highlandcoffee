import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlandcoffeeapp/apis/api.dart';
import 'package:highlandcoffeeapp/models/model.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';
import 'package:highlandcoffeeapp/widgets/custom_alert_dialog.dart';
import 'package:highlandcoffeeapp/widgets/image_picker_widget.dart';
import 'package:highlandcoffeeapp/widgets/labeled_text_field.dart';
import 'package:image_picker/image_picker.dart';

class StoreInformationPage extends StatefulWidget {
  static const String routeName = '/store_information_page';
  const StoreInformationPage({Key? key}) : super(key: key);

  @override
  State<StoreInformationPage> createState() => _StoreInformationPageState();
}

class _StoreInformationPageState extends State<StoreInformationPage> {
  late final Store store;
  final SystemApi systemApi = SystemApi();

  TextEditingController storeNameController = TextEditingController();
  TextEditingController storeAddressController = TextEditingController();
  TextEditingController storePhoneNumberController = TextEditingController();

  File? logoController;

  @override
  void initState() {
    super.initState();
  }


  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        logoController = File(pickedFile.path);
      });
    }
  }

  Future<void> addStoreInformation() async {
    try {
      if (storeNameController.text.isEmpty ||
          storeAddressController.text.isEmpty ||
          storePhoneNumberController.text.isEmpty ||
          logoController == null) {
        showCustomAlertDialog(
            context, 'Thông báo', 'Vui lòng điền đầy đủ thông tin thương hiệu cửa hàng.');
        return;
      }



      final bytesImage = logoController!.readAsBytesSync();
      final String base64Image = base64Encode(bytesImage);

      Store newStoreInformation = Store(
        storeid: '',
        storelogo: base64Image,
        storename: storeNameController.text,
        storeaddress: storeAddressController.text,
        storephonenumber: storePhoneNumberController.text,
        status: 1
      );

      if (storePhoneNumberController.text.length < 10 || storePhoneNumberController.text.length > 10){
        showCustomAlertDialog(context, 'Thông báo', 'Số điện thoại không hợp lệ, phải có 10 chữ số.');
        return;
      }

      await systemApi.addStoreInformation(newStoreInformation);

      showCustomAlertDialog(
          context, 'Thông báo', 'Thêm thương hiệu cửa hàng vào cơ sở dữ liệu thành công.');

      storeNameController.clear();
      storeAddressController.clear();
      storePhoneNumberController.clear();
      setState(() {
        logoController = null;
      });
    } catch (e) {
      print('Error adding store information to Database: $e');
      showCustomAlertDialog(
          context, 'Thông báo', 'Thương hiệu cửa hàng đã tồn tại, vui lòng thử lại.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            Container(
              alignment: Alignment.topLeft,
              child: Text(
                'Thêm thông tin cửa hàng trên hóa đơn',
                style: GoogleFonts.arsenal(
                    fontSize: 30, fontWeight: FontWeight.bold, color: brown),
              ),
            ),
            const SizedBox(height: 10),
            ImagePickerWidget(
              imagePath: logoController,
              onPressed: pickImage,
              label: 'Logo cửa hàng',
            ),
            LabeledTextField(
                label: 'Tên thương hiệu', controller: storeNameController),
            LabeledTextField(
                label: 'Số điện thoại', controller: storePhoneNumberController),
            LabeledTextField(
                label: 'Địa chỉ', controller: storeAddressController),
            const SizedBox(height: 10),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/admin_page');
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: red),
                  child: Text(
                    'Hủy',
                    style: GoogleFonts.roboto(fontSize: 18, color: white),
                  ),
                ),
                const SizedBox(width: 15),
                ElevatedButton(
                  onPressed: () {
                    addStoreInformation();
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: whiteGreen),
                  child: Text(
                    'Thêm',
                    style: GoogleFonts.roboto(fontSize: 18, color: white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
