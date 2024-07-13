import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlandcoffeeapp/apis/api.dart';
import 'package:highlandcoffeeapp/models/model.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';
import 'package:highlandcoffeeapp/widgets/custom_alert_dialog.dart';
import 'package:highlandcoffeeapp/widgets/labeled_text_field.dart';
import 'package:highlandcoffeeapp/widgets/my_button.dart';

class UpdateStaffAccountPage extends StatefulWidget {
  static const String routeName = '/update_staff_account_page';
  const UpdateStaffAccountPage({super.key});

  @override
  State<UpdateStaffAccountPage> createState() => _UpdateStaffAccountPageState();
}

class _UpdateStaffAccountPageState extends State<UpdateStaffAccountPage> {
  final SystemApi systemApi = SystemApi();
  List<Staff> staffs = [];
  List<Staff> filteredStaffs = [];
  final _textSearchStaffController = TextEditingController();
  TextEditingController _editNameController = TextEditingController();
  TextEditingController _editPhoneNumberController = TextEditingController();
  TextEditingController _editSlaryController = TextEditingController();
  TextEditingController _editPassWordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchStaffs();
  }

  Future<void> _fetchStaffs() async {
    try {
      List<Staff> fetchedStaffs = await systemApi.getAllStaffs();
      setState(() {
        staffs = fetchedStaffs;
        filteredStaffs = fetchedStaffs;
      });
    } catch (e) {
      print('Error fetching staffs: $e');
    }
  }

  // Tạo một hàm để cập nhật danh mục
  Future<void> updateStaff(Staff Staff) async {
    try {
      await systemApi.updateStaff(Staff);
      Navigator.pop(context);
      showCustomAlertDialog(context, 'Thông báo',
          'Cập nhật sản thông tin tài khoản nhân viên thành công');
      _fetchStaffs();
    } catch (e) {
      showCustomAlertDialog(context, 'Lỗi',
          'Thông tin tài khoản nhân viên đã tồn tại. Vui lòng thử lại.');
      print('Error updating Staff: $e');
    }
  }

  //update product
  void _showUpdateStaffForm(BuildContext context, Staff staff) {
    // Điền các giá trị hiện tại của  thông tin nhân viên vào các trường nhập liệu
    _editNameController.text = staff.name;
    _editPhoneNumberController.text = staff.phonenumber;
    _editSlaryController.text = staff.salary.toString();
    _editPassWordController.text = staff.password;
    showModalBottomSheet(
        context: context,
        isScrollControlled: true, // Chiều dài có thể được cuộn
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
        ),
        builder: (BuildContext context) {
          return Container(
            height: 500,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 18.0, top: 30.0, right: 18.0, bottom: 18.0),
              child: Column(
                children: [
                  Text(
                    'Cập nhật tài khoản nhân viên',
                    style: GoogleFonts.arsenal(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        color: primaryColors),
                  ),
                  SizedBox(height: 10),
                  LabeledTextField(
                      label: 'Tên nhân viên mới',
                      controller: _editNameController),
                  LabeledTextField(
                      label: 'Số điện thoại',
                      controller: _editPhoneNumberController),
                  LabeledTextField(
                      label: 'Lương cơ bản', controller: _editSlaryController),
                  LabeledTextField(
                      label: 'Mật khẩu mới',
                      controller: _editPassWordController),
                  SizedBox(height: 10),
                  SizedBox(
                    height: 15.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          int salary;
                          salary = int.parse(_editSlaryController.text);
                          Staff updateNewStaff = Staff(
                            staffid: staff.staffid,
                            name: _editNameController.text,
                            phonenumber: _editPhoneNumberController.text,
                            salary: salary,
                            startday: staff.startday,
                            password: _editPassWordController.text,
                          );
                          if (updateNewStaff.name.isEmpty ||
                              updateNewStaff.phonenumber.isEmpty ||
                              updateNewStaff.password.isEmpty) {
                            showCustomAlertDialog(context, 'Lỗi',
                                'Vui lòng nhập đầy đủ thông tin nhân viên');
                            return;
                          } else if (updateNewStaff.password.length < 6) {
                            showCustomAlertDialog(context, 'Thông báo',
                                'Mật khẩu không hợp lệ, phải có ít nhất 6 ký tự');
                            return;
                          } else if(updateNewStaff.phonenumber.length < 10 || updateNewStaff.phonenumber.length > 10) {
                            showCustomAlertDialog(context, 'Thông báo',
                                'Số điện thoại không hợp lệ, phải có 10 số.');
                            return;
                          }
                          else if (salary <= 0) {
                            showCustomAlertDialog(context, 'Thông báo',
                                'Lương không được là số âm hoặc bằng 0.');
                                return;
                          }
                          // Xử lý khi nhấn nút
                          await updateStaff(updateNewStaff);
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: green),
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Icon(
                            //   Icons.cloud,
                            //   color: white,
                            // ),
                            // SizedBox(
                            //   width: 10,
                            // ),
                            Text(
                              'Lưu',
                              style: TextStyle(color: white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  void performSearchStaff(String keyword) {
    setState(() {
      filteredStaffs = staffs
          .where((staff) => staff.name
              .toLowerCase()
              .contains(keyword.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.only(
                left: 18.0, top: 18.0, right: 18.0, bottom: 10),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Cập nhật thông tin tài khoản nhân viên',
                    style: GoogleFonts.arsenal(
                      fontSize: 30,
                      color: brown,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 15),
                TextField(
                  controller: _textSearchStaffController,
                  onChanged: (value) {
                    performSearchStaff(value);
                  },
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm nhân viên',
                    contentPadding: EdgeInsets.symmetric(),
                    alignLabelWithHint: true,
                    filled: true,
                    fillColor: white,
                    prefixIcon: const Icon(
                      Icons.search,
                      size: 20,
                    ),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                            color: background, shape: BoxShape.circle),
                        child: Center(
                          child: IconButton(
                            icon: const Icon(
                              Icons.clear,
                              size: 10,
                            ),
                            onPressed: () {
                              _textSearchStaffController.clear();
                              performSearchStaff('');
                            },
                          ),
                        ),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(28.0),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(28.0),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Danh sách tài khoản nhân viên',
                    style: GoogleFonts.arsenal(
                      fontSize: 20,
                      color: brown,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 15),
              ],
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding:
                const EdgeInsets.only(left: 18.0, right: 18.0, bottom: 25.0),
            child: ListView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: filteredStaffs.length,
              itemBuilder: (context, index) {
                final staff = filteredStaffs[index];
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          flex: 1,
                          child: Icon(
                            Icons.person,
                            color: grey,
                            size: 30,
                          )),
                      Expanded(
                        flex: 6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              staff.name,
                              style: GoogleFonts.arsenal(
                                fontSize: 18,
                                color: black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              staff.salary.toString() + ' VND',
                              style: GoogleFonts.roboto(
                                fontSize: 16,
                                color: brown,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: blue,
                          ),
                          onPressed: () {
                            _showUpdateStaffForm(context, staff);
                          },
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 18.0, right: 18.0, bottom: 25.0),
          child: MyButton(
            text: 'Hoàn thành',
            onTap: () {
              Navigator.pushNamed(context, '/admin_page');
            },
            buttonColor: primaryColors,
          ),
        ),
      ],
    );
  }
}
