import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlandcoffeeapp/apis/api.dart';
import 'package:highlandcoffeeapp/models/model.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';
import 'package:highlandcoffeeapp/widgets/custom_alert_dialog.dart';
import 'package:highlandcoffeeapp/widgets/image_picker_widget.dart';
import 'package:highlandcoffeeapp/widgets/labeled_text_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class UpdateStoreInformationPage extends StatefulWidget {
  static const String routeName = '/update_store_information_page';
  const UpdateStoreInformationPage({Key? key}) : super(key: key);

  @override
  State<UpdateStoreInformationPage> createState() =>
      _UpdateStoreInformationPageState();
}

class _UpdateStoreInformationPageState
    extends State<UpdateStoreInformationPage> {
  late final Store store;
  final SystemApi systemApi = SystemApi();
  List<Store> stores = [];
  List<bool> selectedStoreInformation = [];

  TextEditingController editStoreNameController = TextEditingController();
  TextEditingController editStoreAddressController = TextEditingController();
  TextEditingController editStorePhoneNumberController =
      TextEditingController();

  File? logoController;

  @override
  void initState() {
    super.initState();
    fetchStoreInformation();
  }

  Future<File> writeBase64ToFile(String base64Str) async {
    final decodedBytes = base64Decode(base64Str);
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/temp_image.png');
    return file.writeAsBytes(decodedBytes);
  }

  Future<void> fetchStoreInformation() async {
    try {
      List<Store> fetchedStoreInformation = await systemApi.getStores();
      setState(() {
        stores = fetchedStoreInformation;
        Store selectedStore = stores.first;

        editStoreNameController.text = selectedStore.storename;
        editStoreAddressController.text = selectedStore.storeaddress;
        editStorePhoneNumberController.text = selectedStore.storephonenumber;

        if (selectedStore.storelogo.isNotEmpty) {
          writeBase64ToFile(selectedStore.storelogo).then((file) {
            setState(() {
              logoController = file;
            });
          });
        }
      });
    } catch (e) {
      print('Failed to load store information: $e');
    }
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

  Future<void> updateStoreInformation() async {
    try {
      if (editStoreNameController.text.isEmpty ||
          editStoreAddressController.text.isEmpty ||
          editStorePhoneNumberController.text.isEmpty ||
          logoController == null) {
        showCustomAlertDialog(context, 'Thông báo',
            'Vui lòng điền đầy đủ thông tin thương hiệu cửa hàng.');
        return;
      }

      final bytesImage = logoController!.readAsBytesSync();
      final String base64Image = base64Encode(bytesImage);

      Store newStoreInformation = Store(
          storeid: stores.first.storeid,
          storelogo: base64Image,
          storename: editStoreNameController.text,
          storeaddress: editStoreAddressController.text,
          storephonenumber: editStorePhoneNumberController.text,
          status: stores.first.status);

      if (editStorePhoneNumberController.text.length < 10 || editStorePhoneNumberController.text.length > 10){
        showCustomAlertDialog(context, 'Thông báo', 'Số điện thoại không hợp lệ, phải có 10 chữ số.');
        return;
      }

      await systemApi.updateStoreInformation(newStoreInformation);

      showCustomAlertDialog(context, 'Thông báo',
          'Cập nhật thương hiệu cửa hàng vào cơ sở dữ liệu thành công.');
      setState(() {
        fetchStoreInformation();
      });
    } catch (e) {
      print('Error updating store information to Database: $e');
      showCustomAlertDialog(context, 'Thông báo',
          'Thương hiệu cửa hàng đã tồn tại, vui lòng thử lại.');
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
                'Cập nhật thông tin cửa hàng trên hóa đơn',
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
                label: 'Tên thương hiệu', controller: editStoreNameController),
            LabeledTextField(
                label: 'Số điện thoại',
                controller: editStorePhoneNumberController),
            LabeledTextField(
                label: 'Địa chỉ', controller: editStoreAddressController),
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
                    updateStoreInformation();
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: whiteGreen),
                  child: Text(
                    'Cập nhật',
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
