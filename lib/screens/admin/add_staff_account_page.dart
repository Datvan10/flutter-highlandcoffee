import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlandcoffeeapp/apis/api.dart';
import 'package:highlandcoffeeapp/models/model.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';
import 'package:highlandcoffeeapp/widgets/custom_alert_dialog.dart';
import 'package:highlandcoffeeapp/widgets/labeled_text_field.dart';

class AddStaffAccountPage extends StatefulWidget {
  static const String routeName = '/add_staff_account_page';
  const AddStaffAccountPage({super.key});

  @override
  State<AddStaffAccountPage> createState() => _AddStaffAccountPageState();
}

class _AddStaffAccountPageState extends State<AddStaffAccountPage> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();

  AdminApi adminApi = AdminApi();

  //
  Future<void> addStaff() async {
    try {
      Staff newStaff = Staff(
        staffid: '',
        phonenumber: _phoneNumberController.text,
        name: _nameController.text,
        password: _passwordController.text,
        startday: DateTime.now(),
        salary: int.parse(_salaryController.text),
      );
      if (newStaff.name == '' ||
          newStaff.phonenumber == '' ||
          newStaff.password == '') {
        // Show error message
        showCustomAlertDialog(
            context, 'Thông báo', 'Vui lòng nhập đầy đủ thông tin.');
        return;
      }else if(newStaff.password.length < 6){
        showCustomAlertDialog(
            context, 'Thông báo', 'Mật khẩu không hợp lệ, phải có ít nhất 6 ký tự');
        return;
      }
      // Add category
      await adminApi.addStaff(newStaff);
      // Show success message
      showCustomAlertDialog(context, 'Thông báo', 'Thêm nhân viên thành công.');
      // Clear text field
      _phoneNumberController.clear();
      _nameController.clear();
      _passwordController.clear();
      _salaryController.clear();
    } catch (e) {
      // Show error message
      showCustomAlertDialog(
          context, 'Lỗi', 'Nhân viên đã tồn tại vui lòng thử lại.');
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
                'Thêm thông tin nhân viên',
                style: GoogleFonts.arsenal(
                    fontSize: 30, fontWeight: FontWeight.bold, color: brown),
              ),
            ),
            SizedBox(height: 30),
            LabeledTextField(
                label: 'Tên nhân viên', controller: _nameController),
            LabeledTextField(
                label: 'Số điện thoại', controller: _phoneNumberController),
                LabeledTextField(
                label: 'Mật khẩu', controller: _passwordController),
                LabeledTextField(
                label: 'Lương cơ bản', controller: _salaryController),
            SizedBox(height: 15),
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
                    style: TextStyle(color: white),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                ElevatedButton(
                  onPressed: () {
                    addStaff();
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: green),
                  child: Text(
                    'Thêm',
                    style: TextStyle(color: white),
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