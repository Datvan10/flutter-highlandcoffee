import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlandcoffeeapp/apis/api.dart';
import 'package:highlandcoffeeapp/models/model.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';
import 'package:highlandcoffeeapp/widgets/custom_alert_dialog.dart';
import 'package:highlandcoffeeapp/widgets/my_button.dart';

class ActiveAndBlockAccountCustomerPage extends StatefulWidget {
  static const String routeName = '/update_account_customer_page';
  const ActiveAndBlockAccountCustomerPage({super.key});

  @override
  State<ActiveAndBlockAccountCustomerPage> createState() =>
      _ActiveAndBlockAccountCustomerPageState();
}

class _ActiveAndBlockAccountCustomerPageState
    extends State<ActiveAndBlockAccountCustomerPage> {
  final SystemApi systemApi = SystemApi();
  List<Customer> customers = [];
  List<Customer> filteredCustomers = [];
  final _textSearchAccountCustomerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchAccountCustomers();
  }

  Future<void> fetchAccountCustomers() async {
    try {
      List<Customer> fetchedCustomers = await systemApi.getAllCustomers();
      setState(() {
        customers = fetchedCustomers;
        filteredCustomers = fetchedCustomers;
      });
    } catch (e) {
      print('Error fetching customers: $e');
    }
  }

  Future<void> activeAccountCustomer(String customerid) async {
    try {
      await systemApi.activateAccountCustomer(customerid);
      showCustomAlertDialog(
          context, 'Thông báo', 'Kích hoạt tài khoản khách hàng thành công');
      fetchAccountCustomers();
    } catch (e) {
      showCustomAlertDialog(context, 'Thông báo',
          'Cập nhật tài khoản khách hàng thất bại. Vui lòng thử lại.');
    }
  }

  Future<void> blockAccountCustomer(String customerid) async {
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
            content:
                Text('Bạn có chắc muốn chặn tài khoản của khác hàng này không?',
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
                    await systemApi.blockAccountCustomer(customerid);
                    Navigator.pop(context);
                    showCustomAlertDialog(context, 'Thông báo',
                        'Chặn tài khoản khách hàng thành công');
                    fetchAccountCustomers();
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

  void performSearchAccountCustomer(String keyword) {
    setState(() {
      filteredCustomers = customers
          .where((customer) =>
              customer.name.toLowerCase().contains(keyword.toLowerCase()))
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
                  controller: _textSearchAccountCustomerController,
                  onChanged: (value) {
                    performSearchAccountCustomer(value);
                  },
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm tài khoản khách hàng',
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
                              _textSearchAccountCustomerController.clear();
                              performSearchAccountCustomer('');
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
              itemCount: filteredCustomers.length,
              itemBuilder: (context, index) {
                final customer = filteredCustomers[index];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: white,
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
                              style: GoogleFonts.roboto(
                                fontSize: 16,
                                color: brown,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  customer.point.toString(),
                                  style: GoogleFonts.roboto(
                                    fontSize: 16,
                                    color: red,
                                  ),
                                ),
                                SizedBox(width: 5.0,),
                                Text('điểm thưởng', style: GoogleFonts.roboto(
                                    fontSize: 16,
                                    color: black,
                                  ),)
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: customer.status == 0 ? green : red,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: 8),
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
                            Icons.how_to_reg,
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
