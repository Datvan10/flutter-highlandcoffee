import 'package:highlandcoffeeapp/models/model.dart';

class AuthManager {
  static final AuthManager _instance = AuthManager._internal();

  factory AuthManager() {
    return _instance;
  }

  AuthManager._internal();

  Customer? loggedInCustomer;
  Admin? loggedInAdmin;

  // Get the logged in customer
  void setLoggedInCustomer(Customer customer) {
    loggedInCustomer = customer;
  }

  // Get the logged in admin
  void setLoggedInAdmin(Admin admin) {
    loggedInAdmin = admin;
  }

  // Delete the logged in customer
  void logoutCustomer() {
    loggedInCustomer = null;
  }

  // Delete the logged in admin
  void logoutAdmin() {
    loggedInAdmin = null;
  }
}
