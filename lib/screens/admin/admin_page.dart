import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlandcoffeeapp/auth/auth_manage.dart';
import 'package:highlandcoffeeapp/screens/admin/add_category_page.dart';
import 'package:highlandcoffeeapp/screens/admin/add_product_page.dart';
import 'package:highlandcoffeeapp/screens/admin/add_staff_account_page.dart';
import 'package:highlandcoffeeapp/screens/admin/dashboard_page.dart';
import 'package:highlandcoffeeapp/screens/admin/delete_category_page.dart';
import 'package:highlandcoffeeapp/screens/admin/delete_product_page.dart';
import 'package:highlandcoffeeapp/screens/admin/delete_staff_account_page.dart';
import 'package:highlandcoffeeapp/screens/admin/feddback_page.dart';
import 'package:highlandcoffeeapp/screens/admin/list_order_page.dart';
import 'package:highlandcoffeeapp/screens/admin/top_product_page.dart';
import 'package:highlandcoffeeapp/screens/admin/update_account_customer_page.dart';
import 'package:highlandcoffeeapp/screens/admin/update_category_page.dart';
import 'package:highlandcoffeeapp/screens/admin/update_product_page.dart';
import 'package:highlandcoffeeapp/screens/admin/update_staff_account_page.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';
import 'package:highlandcoffeeapp/widgets/notification.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  //
  Widget _selectedItem = DashboardPage();

  screenSlector(item) {
    switch (item.route) {
      case DashboardPage.routeName:
        setState(() {
          _selectedItem = DashboardPage();
        });

        break;

      // case RevenuePage.routeName:
      //   setState(() {
      //     _selectedItem = RevenuePage();
      //   });

      //   break;

      case TopProductPage.routeName:
        setState(() {
          _selectedItem = TopProductPage();
        });

        break;

      case AddStaffAccountPage.routeName:
        setState(() {
          _selectedItem = AddStaffAccountPage();
        });

        break;

      case DeleteStaffAccountPage.routeName:
        setState(() {
          _selectedItem = DeleteStaffAccountPage();
        });

        break;

      case UpdateStaffAccountPage.routeName:
        setState(() {
          _selectedItem = UpdateStaffAccountPage();
        });

        break;

      case UpdateAccountCustomerPage.routeName:
        setState(() {
          _selectedItem = UpdateAccountCustomerPage();
        });

        break;
      case AddCategoryPage.routeName:
        setState(() {
          _selectedItem = AddCategoryPage();
        });

        break;

      case DeleteCategoryPage.routeName:
        setState(() {
          _selectedItem = DeleteCategoryPage();
        });

        break;

      case UpdateCategoryPage.routeName:
        setState(() {
          _selectedItem = UpdateCategoryPage();
        });

        break;

      case AddProductPage.routeName:
        setState(() {
          _selectedItem = AddProductPage();
        });

        break;

      case DeleteProductPage.routeName:
        setState(() {
          _selectedItem = DeleteProductPage();
        });

        break;

      case UpdateProductPage.routeName:
        setState(() {
          _selectedItem = UpdateProductPage();
        });

      case ListOrderPage.routeName:
        setState(() {
          _selectedItem = ListOrderPage();
        });

        break;

      case FeddBackPage.routeName:
        setState(() {
          _selectedItem = FeddBackPage();
        });

        break;
    }
  }

  //
  void _showConfirmExit(BuildContext context) {
    print('show confirm exit');
    notificationDialog(
      context: context,
      title: "Đăng xuất khỏi tài khoản của bạn?",
      onConfirm: () {},
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Hủy", style: TextStyle(color: Colors.red)),
        ),
        TextButton(
          onPressed: () {
            AuthManager().logoutAdmin();
            Navigator.pushReplacementNamed(context, '/choose_login_type_page');
          },
          child: Text("Đồng ý", style: TextStyle(color: Colors.blue)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
        backgroundColor: background,
        appBar: AppBar(
          elevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton(
                  onPressed: () {}, icon: Icon(Icons.account_circle)),
            )
          ],
          backgroundColor: Colors.transparent,
          title: Text(
            'TRANG QUẢN TRỊ',
            style: GoogleFonts.arsenal(
                color: primaryColors,
                fontWeight: FontWeight.bold,
                fontSize: 20),
          ),
        ),
        sideBar: SideBar(
          iconColor: primaryColors,
          activeIconColor: blue,
          // activeTextStyle: TextStyle(color: primaryColors),
          items: [
            AdminMenuItem(
                title: 'Tổng quan',
                icon: Icons.dashboard,
                route: DashboardPage.routeName,
                children: [
                  // AdminMenuItem(
                  //     title: 'Doanh số bán hàng',
                  //     route: RevenuePage.routeName,
                  //     icon: Icons.monetization_on_outlined),
                  AdminMenuItem(
                      title: 'Thống kê sản phẩm',
                      icon: Icons.trending_up,
                      route: TopProductPage.routeName)
                ]),
            // manage account
            AdminMenuItem(
              title: 'Quản lý nhân sự',
              icon: Icons.manage_accounts,
              children: [
                AdminMenuItem(
                    title: 'Thêm tài khoản nhân viên',
                    route: AddStaffAccountPage.routeName,
                    icon: Icons.person_add),
                AdminMenuItem(
                    title: 'Xóa tài khoản nhân viên',
                    route: DeleteStaffAccountPage.routeName,
                    icon: Icons.person_remove),
                AdminMenuItem(
                    title: 'Sửa tài khoản nhân viên',
                    route: UpdateStaffAccountPage.routeName,
                    icon: Icons.person_search),
              ],
            ),
            // mânge account customer
            AdminMenuItem(
              title: 'Quản lý tài khoản khách hàng',
              icon: Icons.supervisor_account,
              children: [
                AdminMenuItem(
                    title: 'Cập nhật  khoản khách hàng',
                    route: UpdateAccountCustomerPage.routeName,
                    icon: Icons.person_add_disabled),
                // AdminMenuItem(
                //     title: 'Xóa tài khoản khách hàng',
                //     route: DeleteStaffAccountPage.routeName,
                //     icon: Icons.person_remove),
                // AdminMenuItem(
                //     title: 'Sửa tài khoản khách hàng',
                //     route: UpdateStaffAccountPage.routeName,
                //     icon: Icons.person_search),
              ],
            ),
            // manage category
            AdminMenuItem(
              title: 'Quản lý danh mục',
              icon: Icons.category_outlined,
              children: [
                AdminMenuItem(
                    title: 'Thêm danh mục',
                    route: AddCategoryPage.routeName,
                    icon: Icons.add),
                AdminMenuItem(
                    title: 'Xóa danh mục',
                    route: DeleteCategoryPage.routeName,
                    icon: Icons.remove),
                AdminMenuItem(
                    title: 'Sửa danh mục',
                    route: UpdateCategoryPage.routeName,
                    icon: Icons.edit),
              ],
            ),
            //manager product
            AdminMenuItem(
              title: 'Quản lý sản phẩm',
              icon: Icons.restaurant_menu_outlined,
              children: [
                AdminMenuItem(
                    title: 'Thêm sản phẩm',
                    route: AddProductPage.routeName,
                    icon: Icons.add),
                AdminMenuItem(
                    title: 'Xóa sản phẩm',
                    route: DeleteProductPage.routeName,
                    icon: Icons.remove),
                AdminMenuItem(
                    title: 'Sửa sản phẩm',
                    route: UpdateProductPage.routeName,
                    icon: Icons.edit),
              ],
            ),
            //
            AdminMenuItem(
                title: 'Quản lý đơn hàng',
                icon: CupertinoIcons.cart_fill,
                children: [
                  AdminMenuItem(
                      title: 'Danh sách đơn hàng',
                      route: ListOrderPage.routeName,
                      icon: Icons.format_list_bulleted_outlined)
                ]),
            //
            AdminMenuItem(
                title: 'Quản lý đánh giá, bình luận',
                icon: Icons.notifications_active_outlined,
                children: [
                  AdminMenuItem(
                      title: 'Đánh giá, bình luận',
                      icon: Icons.poll,
                      route: FeddBackPage.routeName)
                ]),
            // //
            // AdminMenuItem(
            //   title: 'Dữ liệu',
            //   route: '/',
            //   icon: Icons.storage,
            // ),
            //
            AdminMenuItem(
                title: 'Cài đặt',
                icon: Icons.miscellaneous_services,
                children: [
                  AdminMenuItem(
                      title: 'Chỉnh sửa trang các nhân',
                      icon: Icons.manage_accounts)
                ]),
            //
            AdminMenuItem(
              title: 'Đăng xuất',
              icon: Icons.logout,
            ),
          ],
          selectedRoute: '',
          onSelected: (item) {
            screenSlector(item);
          },
          header: Container(
            height: 50,
            width: double.infinity,
            color: brown,
            child: const Center(
              child: Text(
                'Highlands Coffee Admin',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          // footer: Container(
          //   height: 50,
          //   width: double.infinity,
          //   color: const Color(0xff444444),
          //   child: const Center(
          //     child: Text(
          //       'footer',
          //       style: TextStyle(
          //         color: Colors.white,
          //       ),
          //     ),
          //   ),
          // ),
        ),
        body: _selectedItem);
  }
}
