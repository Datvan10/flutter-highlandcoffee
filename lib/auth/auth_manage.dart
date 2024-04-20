import 'package:highlandcoffeeapp/models/customer.dart';
import 'package:highlandcoffeeapp/models/model.dart';

class AuthManager {
  static final AuthManager _instance = AuthManager._internal();

  factory AuthManager() {
    return _instance;
  }

  AuthManager._internal();

  Customer? loggedInCustomer;

  void setLoggedInCustomer(Customer user) {
    loggedInCustomer = user;
  }
}
