import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlandcoffeeapp/apis/api.dart';
import 'package:highlandcoffeeapp/models/model.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';
import 'package:highlandcoffeeapp/widgets/custom_alert_dialog.dart';
import 'package:highlandcoffeeapp/widgets/labeled_number_field.dart';
import 'package:highlandcoffeeapp/widgets/labeled_text_field.dart';
import 'package:highlandcoffeeapp/widgets/my_button.dart';

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

  SystemApi systemApi = SystemApi();

  //
  Future<void> addStaff() async {
    try {
      int salary;
      try {
        salary = int.parse(_salaryController.text);

        if (salary <= 0) {
          showCustomAlertDialog(
              context, 'Thông báo', 'Lương không được là số âm hoặc bằng 0.');
          return;
        }
      } catch (e) {
        showCustomAlertDialog(
            context, 'Thông báo', 'Lương phải là một số hợp lệ.');
        return;
      }

      Staff newStaff = Staff(
        staffid: '',
        phonenumber: _phoneNumberController.text,
        name: _nameController.text,
        password: _passwordController.text,
        startday: DateTime.now(),
        salary: salary,
      );

      if (newStaff.name.isEmpty ||
          newStaff.phonenumber.isEmpty ||
          newStaff.password.isEmpty) {
        showCustomAlertDialog(
            context, 'Thông báo', 'Vui lòng nhập đầy đủ thông tin.');
        return;
      }

      if (_phoneNumberController.text.length < 10 ||
          _phoneNumberController.text.length > 10) {
        showCustomAlertDialog(
            context, 'Thông báo', 'Số điện thoại không hợp lệ, phải có 10 số.');
        return;
      }

      if (newStaff.password.length < 6) {
        showCustomAlertDialog(context, 'Thông báo',
            'Mật khẩu không hợp lệ, phải có ít nhất 6 ký tự.');
        return;
      }

      await systemApi.addStaff(newStaff);

      showCustomAlertDialog(
          context, 'Thông báo', 'Thêm tài khoản nhân viên thành công.');

      _phoneNumberController.clear();
      _nameController.clear();
      _passwordController.clear();
      _salaryController.clear();
    } catch (e) {
      showCustomAlertDialog(
          context, 'Lỗi', 'Nhân viên đã tồn tại vui lòng thử lại.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 18.0, top: 18.0, right: 18.0, bottom: 25),
      child: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Thêm thông tin nhân viên',
                    style: GoogleFonts.arsenal(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: brown),
                  ),
                ),
                SizedBox(height: 30),
                LabeledTextField(
                    label: 'Tên nhân viên', controller: _nameController),
                LabeledNumberField(
                  label: 'Số điện thoại',
                  controller: _phoneNumberController,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                ),
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
                      style: ElevatedButton.styleFrom(backgroundColor: whiteGreen),
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
          MyButton(
            text: 'Hoàn thành',
            onTap: () {
              Navigator.pushNamed(context, '/admin_page');
            },
            buttonColor: primaryColors,
          ),
        ],
      ),
    );
  }
}
