import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlandcoffeeapp/auth/auth_manage.dart';
import 'package:highlandcoffeeapp/screens/admin/access_and_cancel_role_staff_page.dart';
import 'package:highlandcoffeeapp/screens/admin/add_carousel_page.dart';
import 'package:highlandcoffeeapp/screens/admin/add_category_page.dart';
import 'package:highlandcoffeeapp/screens/admin/add_product_page.dart';
import 'package:highlandcoffeeapp/screens/admin/add_staff_account_page.dart';
import 'package:highlandcoffeeapp/screens/admin/dashboard_page.dart';
import 'package:highlandcoffeeapp/screens/admin/delete_category_page.dart';
import 'package:highlandcoffeeapp/screens/admin/delete_product_page.dart';
import 'package:highlandcoffeeapp/screens/admin/delete_staff_account_page.dart';
import 'package:highlandcoffeeapp/screens/admin/list_bill_page.dart';
import 'package:highlandcoffeeapp/screens/admin/publish_and_cancel_comment_page.dart';
import 'package:highlandcoffeeapp/screens/admin/list_order_page.dart';
import 'package:highlandcoffeeapp/screens/admin/top_product_page.dart';
import 'package:highlandcoffeeapp/screens/admin/active_and_block_account_customer_page.dart';
import 'package:highlandcoffeeapp/screens/admin/active_and_cancel_carousel_page.dart';
import 'package:highlandcoffeeapp/screens/admin/update_carousel_page.dart';
import 'package:highlandcoffeeapp/screens/admin/update_category_page.dart';
import 'package:highlandcoffeeapp/screens/admin/update_product_page.dart';
import 'package:highlandcoffeeapp/screens/admin/update_staff_account_page.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {

  Widget _selectedItem = const DashboardPage();

  void screenSlector(item) {
    switch (item.route) {
      case DashboardPage.routeName:
        setState(() {
          _selectedItem = const DashboardPage();
        });

        break;

      case TopProductPage.routeName:
        setState(() {
          _selectedItem = const TopProductPage();
        });

        break;

      case AddStaffAccountPage.routeName:
        setState(() {
          _selectedItem = const AddStaffAccountPage();
        });

        break;

      case DeleteStaffAccountPage.routeName:
        setState(() {
          _selectedItem = const DeleteStaffAccountPage();
        });

        break;

      case UpdateStaffAccountPage.routeName:
        setState(() {
          _selectedItem = const UpdateStaffAccountPage();
        });

        break;

      case ActiveAndBlockAccountCustomerPage.routeName:
        setState(() {
          _selectedItem = const ActiveAndBlockAccountCustomerPage();
        });

        break;

      case AddCarouselPage.routeName:
        setState(() {
          _selectedItem = const AddCarouselPage();
        });

        break;

      case ActiveAndCancelCarouselPage.routeName:
        setState(() {
          _selectedItem = const ActiveAndCancelCarouselPage();
        });

        break;

      case UpdateCarouselPage.routeName:
        setState(() {
          _selectedItem = const UpdateCarouselPage();
        });

        break;

      case AddCategoryPage.routeName:
        setState(() {
          _selectedItem = const AddCategoryPage();
        });

        break;

      case DeleteCategoryPage.routeName:
        setState(() {
          _selectedItem = const DeleteCategoryPage();
        });

        break;

      case UpdateCategoryPage.routeName:
        setState(() {
          _selectedItem = const UpdateCategoryPage();
        });

        break;

      case AddProductPage.routeName:
        setState(() {
          _selectedItem = const AddProductPage();
        });

        break;

      case DeleteProductPage.routeName:
        setState(() {
          _selectedItem = const DeleteProductPage();
        });

        break;

      case UpdateProductPage.routeName:
        setState(() {
          _selectedItem = const UpdateProductPage();
        });

      case ListOrderPage.routeName:
        setState(() {
          _selectedItem = const ListOrderPage();
        });

        break;

      case ListBillPage.routeName:
        setState(() {
          _selectedItem = const ListBillPage();
        });

        break;

      case AccessAndCancelRoleStaffPage.routeName:
        setState(() {
          _selectedItem = const AccessAndCancelRoleStaffPage();
        });

        break;

      case PublishAndCancelCommentPage.routeName:
        setState(() {
          _selectedItem = const PublishAndCancelCommentPage();
        });

        break;
    }
  }

  //
  void showConfirmExit(BuildContext context) {
    // print('show confirm exit');
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(
            "Thông báo",
            style: GoogleFonts.roboto(
              color: primaryColors,
              fontWeight: FontWeight.bold,
              fontSize: 19,
            ),
          ),
          content: Text("Đăng xuất khỏi tài khoản Admin?",
              style: GoogleFonts.roboto(
                color: black,
                fontSize: 16,
              )),
          actions: [
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: Text("OK",
                  style: GoogleFonts.roboto(
                      color: blue, fontSize: 17, fontWeight: FontWeight.bold)),
              onPressed: () async {
                AuthManager().logoutAdmin();
                Navigator.pushReplacementNamed(
                    context, '/choose_login_type_page');
              },
            ),
            CupertinoDialogAction(
              child: Text(
                "Hủy",
                style: GoogleFonts.roboto(color: blue, fontSize: 17),
              ),
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
    return AdminScaffold(
        backgroundColor: background,
        appBar: AppBar(
          elevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton(
                  onPressed: () {
                    showConfirmExit(context);
                  },
                  icon: Icon(Icons.login_outlined)),
              // icon: Icon(Icons.account_circle)),
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
          items: const [
            AdminMenuItem(
                title: 'Tổng quan',
                icon: Icons.dashboard,
                route: DashboardPage.routeName,
                children: [
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
                    route: ActiveAndBlockAccountCustomerPage.routeName,
                    icon: Icons.person_add_disabled),
              ],
            ),
            // manager carousel
            AdminMenuItem(
              title: 'Quản lý băng chuyền',
              icon: Icons.widgets,
              children: [
                AdminMenuItem(
                    title: 'Thêm băng chuyển',
                    route: AddCarouselPage.routeName,
                    icon: Icons.topic),
                // AdminMenuItem(
                //     title: 'Xóa băng chuyển',
                //     route: DeleteCategoryPage.routeName,
                //     icon: Icons.remove),
                AdminMenuItem(
                    title: 'Thiết lập băng chuyền',
                    route: ActiveAndCancelCarouselPage.routeName,
                    icon: Icons.view_carousel),
                AdminMenuItem(
                    title: 'Sửa băng chuyền',
                    route: UpdateCarouselPage.routeName,
                    icon: Icons.sort_outlined),
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
              icon: Icons.fastfood,
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
                title: 'Quản lý hóa đơn',
                icon: Icons.receipt,
                children: [
                  AdminMenuItem(
                      title: 'Danh sách hóa đơn',
                      route: ListBillPage.routeName,
                      icon: Icons.receipt_long)
                ]),
            //
            AdminMenuItem(
                title: 'Quản lý đánh giá, bình luận',
                icon: Icons.notifications_active_outlined,
                children: [
                  AdminMenuItem(
                      title: 'Đánh giá, bình luận',
                      icon: Icons.poll,
                      route: PublishAndCancelCommentPage.routeName)
                ]),
            AdminMenuItem(
                title: 'Phân quyền nhân viên',
                icon: Icons.supervisor_account,
                children: [
                  AdminMenuItem(
                    title: 'Thêm danh mục, sản phẩm',
                    route: AccessAndCancelRoleStaffPage.routeName,
                    icon: Icons.person_add,
                  ),
                ]),
            //
            // AdminMenuItem(title: 'Đăng xuất', icon: Icons.logout, children: [
            //   AdminMenuItem(
            //     title: 'Đăng xuất',
            //     route: LogoutPage.routeName,
            //     icon: Icons.logout,
            //     onPressed: () => handleLogout,
            //   ),
            // ]),
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
        ),
        body: _selectedItem);
  }
}
