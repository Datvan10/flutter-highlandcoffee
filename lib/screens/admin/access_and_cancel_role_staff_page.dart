import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlandcoffeeapp/apis/api.dart';
import 'package:highlandcoffeeapp/auth/auth_manage.dart';
import 'package:highlandcoffeeapp/models/model.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';
import 'package:highlandcoffeeapp/widgets/custom_alert_dialog.dart';
import 'package:highlandcoffeeapp/widgets/my_button.dart';

class AccessAndCancelRoleStaffPage extends StatefulWidget {
  static const String routeName = '/access_and_cancel_role_staff_page';
  const AccessAndCancelRoleStaffPage({super.key});

  @override
  State<AccessAndCancelRoleStaffPage> createState() =>
      _AccessAndCancelRoleStaffPageState();
}

class _AccessAndCancelRoleStaffPageState
    extends State<AccessAndCancelRoleStaffPage> {
  final AdminApi adminApi = AdminApi();
  final staffApi = StaffApi();
  List<Staff> staffs = [];
  final _textSearchStaffController = TextEditingController();
  String? role;

  @override
  void initState() {
    super.initState();
    fetchStaffs();
  }

  //
  Future<void> fetchStaffs() async {
    try {
      List<Staff> fetchedStaffs = await adminApi.getAllStaffs();
      for (var staff in fetchedStaffs) {
        role = await staffApi.getRoleByPersonId(staff.staffid);
      }
      setState(() {
        staffs = fetchedStaffs;
      });
    } catch (e) {
      print('Error fetching staffs: $e');
    }
  }

  // function active account
  Future<void> accessRoleStaff(String staffid) async {
    try {
      await adminApi.accessRoleStaff(staffid);
      showCustomAlertDialog(
          context, 'Thông báo', 'Cấp quyền cho tài khoản nhân viên thành công');
      fetchStaffs();
    } catch (e) {
      showCustomAlertDialog(context, 'Thông báo',
          'Cấp quyền cho tài khoản nhân viên thất bại. Vui lòng thử lại.');
    }
  }

  // function block account
  Future<void> cancelRoleStaff(String staffid) async {
    showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(
              'Thông báo',
              style: GoogleFonts.roboto(
                color: primaryColors,
                fontSize: 19,
              ),
            ),
            content: Text(
                'Bạn có chắc muốn hủy quyền của tài khoản nhân viên này không?',
                style: GoogleFonts.roboto(
                  color: black,
                  fontSize: 16,
                )),
            actions: [
              CupertinoDialogAction(
                isDestructiveAction: true,
                child: Text('OK',
                    style: GoogleFonts.roboto(
                        color: blue,
                        fontSize: 17,
                        fontWeight: FontWeight.bold)),
                onPressed: () async {
                  try {
                    await adminApi.cancelRoleStaff(staffid);
                    Navigator.pop(context);
                    showCustomAlertDialog(context, 'Thông báo',
                        'Hủy quyền tài khoản nhân viên thành công');
                    fetchStaffs();
                  } catch (e) {
                    showCustomAlertDialog(context, 'Thông báo',
                        'Cập nhật tài khoản khách hàng thất bại. Vui lòng thử lại.');
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
                    'Cấp quyền thêm danh mục và sản phẩm cho nhân viên',
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
                            Icons.manage_accounts,
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
                            Row(
                              children: [
                                Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: role == '0' ? green : red,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  role == '0'
                                      ? 'Đang cấp quyền'
                                      : 'Chưa cấp quyền',
                                  style: GoogleFonts.roboto(
                                    fontSize: 16,
                                    color: role == '0' ? green : red,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: IconButton(
                          icon: Icon(
                            Icons.block,
                            color: red,
                          ),
                          onPressed: () {
                            cancelRoleStaff(staff.staffid);
                          },
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: IconButton(
                          icon: Icon(
                            Icons.how_to_reg,
                            color: green,
                          ),
                          onPressed: () {
                            accessRoleStaff(staff.staffid);
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
