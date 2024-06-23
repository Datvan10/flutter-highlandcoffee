import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlandcoffeeapp/apis/api.dart';
import 'package:highlandcoffeeapp/models/model.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';
import 'package:highlandcoffeeapp/widgets/custom_alert_dialog.dart';
import 'package:highlandcoffeeapp/widgets/my_button.dart';

class DeleteStaffAccountPage extends StatefulWidget {
  static const String routeName = '/delete_staff_account_page';
  const DeleteStaffAccountPage({super.key});

  @override
  State<DeleteStaffAccountPage> createState() => _DeleteStaffAccountPageState();
}

class _DeleteStaffAccountPageState extends State<DeleteStaffAccountPage> {
  final AdminApi adminApi = AdminApi();
  List<Staff> staffs = [];
  final _textSearchStaffController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchStaffs();
  }

  Future<void> _fetchStaffs() async {
    try {
      List<Staff> fetchedStaffs = await adminApi.getAllStaffs();
      setState(() {
        staffs = fetchedStaffs;
      });
    } catch (e) {
      print('Error fetching staffs: $e');
    }
  }

  Future<void> deleteStaff(String categoryId) async {
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(
            "Thông báo",
            style: GoogleFonts.roboto(
              color: primaryColors,
              fontSize: 19,
            ),
          ),
          content: Text("Bạn có chắc muốn xóa nhân viên này không?",
              style: GoogleFonts.roboto(
                color: black,
                fontSize: 16,
              )),
          actions: [
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: Text('OK',
                  style: GoogleFonts.roboto(
                      color: blue, fontSize: 17, fontWeight: FontWeight.bold)),
              onPressed: () async {
                try {
                  await adminApi.deleteStaff(categoryId);
                  Navigator.pop(context);
                  showCustomAlertDialog(
                      context, 'Thông báo', 'Xóa thông tin tài khoản nhân viên thành công');
                  _fetchStaffs();
                } catch (e) {
                  print('Error deleting staff: $e');
                  Navigator.pop(context);
                  showCustomAlertDialog(
                      context, 'Lỗi', 'Nhân viên không thể bị xóa do liên quan đến dữ liệu khác trong hệ thống.');
                }
              },
            ),
            CupertinoDialogAction(
              child: Text('Hủy',
                  style: GoogleFonts.roboto(color: blue, fontSize: 17)),
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
                    'Xóa thông tin tài khoản nhân viên',
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
              itemCount: staffs.length,
              itemBuilder: (context, index) {
                final staff = staffs[index];
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
                              style: GoogleFonts.arsenal(
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
                            Icons.delete,
                            color: red,
                          ),
                          onPressed: () {
                            deleteStaff(staff.staffid);
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
