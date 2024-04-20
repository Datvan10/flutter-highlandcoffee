import 'package:get/get_navigation/get_navigation.dart';
import 'package:highlandcoffeeapp/screens/customer/profile_customer_page.dart';
import 'package:highlandcoffeeapp/screens/app/bread_page.dart';
import 'package:highlandcoffeeapp/screens/app/choose_login_type_page%20.dart';
import 'package:highlandcoffeeapp/screens/app/coffee_page.dart';
import 'package:highlandcoffeeapp/screens/app/list_product_page.dart';
import 'package:highlandcoffeeapp/screens/admin/forgot_password_admin_page.dart';
import 'package:highlandcoffeeapp/screens/customer/forgot_password_customer_page.dart';
import 'package:highlandcoffeeapp/screens/app/freeze_page.dart';
import 'package:highlandcoffeeapp/screens/app/other_page.dart';
import 'package:highlandcoffeeapp/screens/app/payment_result_page.dart';
import 'package:highlandcoffeeapp/screens/app/tea_page.dart';
import 'package:highlandcoffeeapp/widgets/best_sale_product_item.dart';
import 'package:highlandcoffeeapp/screens/app/order_page.dart';
import 'package:highlandcoffeeapp/screens/app/favorite_product_page.dart';
import 'package:highlandcoffeeapp/screens/app/product_popular_page.dart';
import 'package:highlandcoffeeapp/screens/admin/admin_page.dart';
import 'package:highlandcoffeeapp/auth/auth_customer_page.dart';
import 'package:highlandcoffeeapp/screens/app/cart_page.dart';
import 'package:highlandcoffeeapp/screens/app/home_page.dart';
import 'package:highlandcoffeeapp/screens/app/introduce_page1.dart';
import 'package:highlandcoffeeapp/screens/app/introduce_page2.dart';
import 'package:highlandcoffeeapp/screens/customer/my_order_page.dart';
import 'package:highlandcoffeeapp/screens/customer/update_user_profille.dart';
import 'package:highlandcoffeeapp/screens/app/welcome_page.dart';

List<GetPage> getPages = [
  GetPage(name: '/welcome_page', page: () => const WelcomePage()),
  GetPage(name: '/introduce_page1', page: () => const IntroducePage1()),
  GetPage(name: '/introduce_page2', page: () => const IntroducePage2()),
  GetPage(name: '/choose_login_type_page', page: () => ChooseLoginTypePage()),
  GetPage(name: '/auth_customer_page', page: () => const AuthCustomerPage()),
  GetPage(name:  '/admin_page', page: () => const AdminPage()),
  GetPage(name: '/home_page', page: () => const HomePage()),
  GetPage(name: '/list_product_page', page:() => const ListProductPage()),
  GetPage(name: '/product_popular_page', page:() => const ProductPopularPage()),
  GetPage(name: '/favorite_product_page', page:() => const FavoriteProductPage()),
  GetPage(name: '/coffee_page', page:() => const CoffeePage(),),
  GetPage(name: '/freeze_page', page:() => const FreezePage()),
  GetPage(name: '/tea_page', page:() => const TeaPage()),
  GetPage(name: '/bread_page', page:() => const BreadPage()),
  GetPage(name : '/other_page', page:() => const OtherPage()),
  GetPage(name: '/product_popular_page', page:() => const ProductPopularPage()),
  GetPage(name: '/best_sale_product_item', page:() => const BestSaleProductItem()),
  GetPage(name: '/favorite_product_page', page: () => const FavoriteProductPage()),
  GetPage(name: '/cart_page', page:() => const CartPage()),
  GetPage(name: '/bill_page', page:() => const BillPage()),
  GetPage(name: '/admin_page', page:() => const AdminPage()),
  GetPage(name: '/forgot_password_admin_page', page:() => const ForgotPasswordAdminPage()),
  GetPage(name: '/forgot_password_customer_page', page:() => const ForgotPasswordCustomerPage()),
  GetPage(name: '/profile_user_page', page:() => ProfileCustomerPage()),
  GetPage(name: '/update_user_profile_page', page:() => const UpdateUserProfilePage()),
  GetPage(name: '/my_order_page', page:() => const MyOrderPage()),
  GetPage(name: '/payment_result_page', page:() => const PaymentResultPage()),
];
