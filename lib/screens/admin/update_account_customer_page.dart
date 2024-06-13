import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlandcoffeeapp/apis/api.dart';
import 'package:highlandcoffeeapp/models/model.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';
import 'package:highlandcoffeeapp/widgets/custom_alert_dialog.dart';
import 'package:highlandcoffeeapp/widgets/my_button.dart';

class UpdateAccountCustomerPage extends StatefulWidget {
  static const String routeName = '/update_account_customer_page';
  const UpdateAccountCustomerPage({super.key});

  @override
  State<UpdateAccountCustomerPage> createState() =>
      _UpdateAccountCustomerPageState();
}

class _UpdateAccountCustomerPageState extends State<UpdateAccountCustomerPage> {
  final AdminApi adminApi = AdminApi();
  List<Customer> customers = [];
  final _textSearchCustomerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchCustomers();
  }

  Future<void> _fetchCustomers() async {
    try {
      List<Customer> fetchedCustomers = await adminApi.getAllCustomers();
      setState(() {
        customers = fetchedCustomers;
      });
    } catch (e) {
      print('Error fetching customers: $e');
    }
  }

  // function active account
  Future<void> activeAccountCustomer(String customerid) async {
    try {
      await adminApi.activateAccountCustomer(customerid);
      showCustomAlertDialog(
          context, 'Thông báo', 'Kích hoạt tài khoản khách hàng thành công');
          _fetchCustomers();
    } catch (e) {
      showCustomAlertDialog(context, 'Lỗi',
          'Cập nhật tài khoản khách hàng thật bại. Vui lòng thử lại.');
    }
  }

  // function block account
  Future<void> blockAccountCustomer(String customerid) async {
    try {
      await adminApi.blockAccountCustomer(customerid);
      showCustomAlertDialog(
          context, 'Thông báo', 'Chặn tài khoản khách hàng thành công');
          _fetchCustomers();
    } catch (e) {
      showCustomAlertDialog(context, 'Lỗi',
          'Cập nhật tài khoản khách hàng thất bại. Vui lòng thử lại.');
    }
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
                    'Cập nhật tài khoản khách hàng',
                    style: GoogleFonts.arsenal(
                      fontSize: 30,
                      color: brown,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 15),
                TextField(
                  controller: _textSearchCustomerController,
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm khách hàng',
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
                              _textSearchCustomerController.clear();
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
                    'Danh sách tài khoản khách hàng',
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
              itemCount: customers.length,
              itemBuilder: (context, index) {
                final customer = customers[index];
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
                              customer.name,
                              style: GoogleFonts.arsenal(
                                fontSize: 18,
                                color: black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              customer.address,
                              style: GoogleFonts.arsenal(
                                fontSize: 16,
                                color: brown,
                              ),
                            ),
                            Text(
                              customer.status == 0
                                  ? 'Đang hoạt động'
                                  : 'Đã bị chặn',
                              style: GoogleFonts.roboto(
                                fontSize: 16,
                                color: customer.status == 0 ? green : red,
                              ),
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
                            blockAccountCustomer(
                                customer.customerid.toString());
                          },
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: IconButton(
                          icon: Icon(
                            Icons.task_alt,
                            color: green,
                          ),
                          onPressed: () {
                            activeAccountCustomer(
                                customer.customerid.toString());
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
