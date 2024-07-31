import 'dart:convert';

import 'package:highlandcoffeeapp/auth/auth_manage.dart';
import 'package:highlandcoffeeapp/models/model.dart';
import 'package:http/http.dart' as http;

// System API
class SystemApi {
  final String personUrl = "http://localhost:5194/api/persons";
  final String accountUrl = "http://localhost:5194/api/accounts";
  final String adminUrl = "http://localhost:5194/api/admins";
  final String staffUrl = "http://localhost:5194/api/staffs";
  final String customerUrl = "http://localhost:5194/api/customers";
  final String carouselUrl = "http://localhost:5194/api/carousels";
  final String productUrl = "http://localhost:5194/api/products";
  final String categoryUrl = "http://localhost:5194/api/categories";
  final String orderUrl = "http://localhost:5194/api/orders";
  final String getProductUrl = 'http://localhost:5194/api/products/category';
  final String billUrl = 'http://localhost:5194/api/bills';
  final String commentUrl = 'http://localhost:5194/api/comments';
  final String popularUrl = "http://localhost:5194/api/products/category/dm030";
  final String favoriteUrl = "http://localhost:5194/api/favorites";
  final String bestSaleUrl =
      "http://localhost:5194/api/products/category/dm029";
  final String cartUrl = "http://localhost:5194/api/carts";
  final String cartDetailUrl = "http://localhost:5194/api/cartdetails";
  final String orderDetailUrl = "http://localhost:5194/api/orderdetails";

  /// Method for actor Admin

  // Read data from API
  Future<List<Admin>> getAdmins() async {
    try {
      final response = await http.get(Uri.parse(adminUrl));
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map((data) => new Admin.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load admins');
      }
    } catch (e) {
      throw Exception('Failed to load admins');
    }
  }

  // Add data to API
  Future<void> addAdmin(Admin admin) async {
    final uri = Uri.parse(adminUrl);

    try {
      final response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(admin.toJson()),
      );
      if (response.statusCode == 200) {
        print('Admin added successfully');
      } else {
        throw Exception('Failed to add admin: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to add admin: $e');
    }
  }

  // Update data to API
  Future<Admin> updateAdmin(Admin admin) async {
    try {
      final response = await http.put(Uri.parse('$adminUrl/${admin}'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(admin.toJson()));
      if (response.statusCode == 200) {
        return Admin.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to update admin');
      }
    } catch (e) {
      throw Exception('Failed to update admin');
    }
  }

  // Delete data from API
  Future<void> deleteAdmin(int id) async {
    try {
      final response = await http.delete(Uri.parse('$adminUrl/$id'));
      if (response.statusCode != 204) {
        throw Exception('Failed to delete admin');
      }
    } catch (e) {
      throw Exception('Failed to delete admin');
    }
  }

  ///////////////// Chua xu ly phan nay
  // Update admin password
  Future<bool> updateAdminPassword(String email, String newPassword) async {
    try {
      final response = await http.get(Uri.parse(adminUrl));
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);

        for (var adminData in jsonResponse) {
          Admin admin = Admin.fromJson(adminData);
          if (admin.name == email) {
            try {
              final updateResponse = await http.put(
                Uri.parse('$adminUrl'),
                headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                },
                body: jsonEncode({'password': newPassword}),
              );
              if (updateResponse.statusCode == 200) {
                return true;
              } else {
                return false;
              }
            } catch (e) {
              return false;
            }
          }
        }
        return false;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  // Authenticate admin
  Future<bool> authenticateAccountAdmin(
      String identifier, String password) async {
    final uri = Uri.parse(adminUrl);
    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);

        for (var adminData in jsonResponse) {
          Admin admin = Admin.fromJson(adminData);
          if ((admin.name == identifier || admin.phonenumber == identifier) &&
              admin.password == password) {
            return true;
          }
        }
        return false;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  // Add product for admin
  Future<void> addProduct(Product product) async {
    try {
      final response = await http.post(
        Uri.parse(productUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(product.toJson()),
      );
      // print(response.statusCode);
      if (response.statusCode == 200) {
        print('Product added successfully');
      } else {
        throw Exception('Failed to add product: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to add product: $e');
    }
  }

  // Get product for admin
  Future<List<Product>> getProducts(String categoryid) async {
    try {
      final response = await http.get(Uri.parse('$getProductUrl/$categoryid'));
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        List<Product> products = [];
        for (var item in jsonData) {
          Product product = Product.fromJson(item);

          products.add(product);
        }
        return products;
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }

  // Delete product for admin
  Future<void> deleteProduct(String productid) async {
    try {
      final response = await http.delete(Uri.parse('$productUrl/$productid'));
      print(response.statusCode);
      if (response.statusCode == 200 || response.statusCode == 204) {
        print('Product deleted successfully');
      } else {
        throw Exception('Failed to delete product');
      }
    } catch (e) {
      throw Exception('Failed to delete product');
    }
  }

  // Update product for admin
  Future<void> updateProduct(Product product) async {
    try {
      final response = await http.put(
        Uri.parse('$productUrl/${product.productid}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(product.toJson()),
      );
      if (response.statusCode == 200) {
        print('Product updated successfully');
      } else {
        throw Exception('Failed to update product: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to update product: $e');
    }
  }

  // Add category for admin
  Future<void> addCategory(Category category) async {
    try {
      final response = await http.post(
        Uri.parse(categoryUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(category.toJson()),
      );
      if (response.statusCode == 200) {
        print('Category added successfully');
      } else {
        throw Exception('Failed to add category: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to add category: $e');
    }
  }

  // Delete category for admin
  Future<void> deleteCategory(String categoryid) async {
    try {
      final response = await http.delete(Uri.parse('$categoryUrl/$categoryid'));
      if (response.statusCode == 200 || response.statusCode == 204) {
        print('Category deleted successfully');
      } else {
        throw Exception('Failed to delete category');
      }
    } catch (e) {
      throw Exception('Failed to delete category');
    }
  }

  // Update category for admin
  Future<void> updateCategory(Category category) async {
    try {
      final response = await http.put(
        Uri.parse('$categoryUrl/${category.categoryid}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(category.toJson()),
      );
      if (response.statusCode == 200) {
        print('Category updated successfully');
      } else {
        throw Exception('Failed to update category: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to update category: $e');
    }
  }

  // Get Carousel
  Future<List<Carousel>> getCarousels() async {
    try {
      final response = await http.get(Uri.parse(carouselUrl));
      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        List<Carousel> carousels =
            body.map((dynamic item) => Carousel.fromJson(item)).toList();
        return carousels;
      } else {
        throw Exception('Failed to load Carousels');
      }
    } catch (e) {
      throw Exception('Failed to load Carousels');
    }
  }

  Future<void> addCarousel(Carousel carousel) async {
    try {
      final response = await http.post(
        Uri.parse(carouselUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(carousel.toJson()),
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('Carousel added successfully');
      } else {
        throw Exception('Failed to add carousel: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to add carousel: $e');
    }
  }

  Future<void> cancelCarousel(String carouselid) async {
    try {
      final response = await http.put(
        Uri.parse(
            '$carouselUrl/$carouselid/cancel'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      // print(response.statusCode);

      if (response.statusCode == 200) {
        // print('Carousel cancelled successfully');
      } else {
        throw Exception('Failed to cancel carousel: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to cancel carousel: $e');
    }
  }

  Future<void> activateCarousel(String carouselid) async {
    try {
      final response = await http.put(
        Uri.parse('$carouselUrl/$carouselid/activate'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      // print(response.statusCode);

      if (response.statusCode == 200) {
        // print('Carousel activated successfully');
      } else {
        throw Exception('Failed to activate carousel: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to activate carousel: $e');
    }
  }

  // Add staff for admin
  Future<void> addStaff(Staff staff) async {
    final uri = Uri.parse(staffUrl);

    try {
      final response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(staff.toJson()),
      );
      // print(response.statusCode);
      if (response.statusCode == 200) {
        print('Staff added successfully');
      } else {
        throw Exception('Failed to add staff: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to add staff: $e');
    }
  }

  // Get staff for admin
  Future<List<Staff>> getAllStaffs() async {
    try {
      final response = await http.get(Uri.parse(staffUrl));
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map((data) => new Staff.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load staffs');
      }
    } catch (e) {
      throw Exception('Failed to load staffs');
    }
  }

  // Delete staff for admin
  Future<void> deleteStaff(String staffid) async {
    try {
      final response = await http.delete(Uri.parse('$staffUrl/$staffid'));
      // print(response.statusCode);
      if (response.statusCode == 200 || response.statusCode == 204) {
        print('Staff deleted successfully');
      } else {
        throw Exception('Failed to delete Staff');
      }
    } catch (e) {
      throw Exception('Failed to delete Staff');
    }
  }

  // Update staff for admin
  Future<void> updateStaff(Staff staff) async {
    try {
      final response = await http.put(
        Uri.parse('$staffUrl/${staff.staffid}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(staff.toJson()),
      );
      // print(response.statusCode);
      if (response.statusCode == 200) {
        print('Staff updated successfully');
      } else {
        throw Exception('Failed to update Staff: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to update Staff: $e');
    }
  }

  // Get all customer
  Future<List<Customer>> getAllCustomers() async {
    try {
      final response = await http.get(Uri.parse(customerUrl));
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map((data) => new Customer.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load customers');
      }
    } catch (e) {
      throw Exception('Failed to load customers');
    }
  }

  // function active account customer
  Future<void> activateAccountCustomer(String customerid) async {
    try {
      final response = await http.post(
        Uri.parse('$customerUrl/activate/$customerid'),
      );

      if (response.statusCode == 200) {
        print('Account activated successfully');
      } else {
        print('Failed to activate account: ${response.statusCode}');
      }
    } catch (e) {
      print('Error activating account: $e');
      // Xử lý lỗi nếu cần thiết
    }
  }

  // function block account customer
  Future<void> blockAccountCustomer(String customerid) async {
    try {
      final response = await http.post(
        Uri.parse('$customerUrl/block/$customerid'),
      );

      if (response.statusCode == 200) {
        print('Account blocked successfully');
      } else {
        print('Failed to block account: ${response.statusCode}');
      }
    } catch (e) {
      print('Error blocking account: $e');
      // Xử lý lỗi nếu cần thiết
    }
  }

  // function access role staff
  Future<void> accessRoleStaff(String staffid) async {
    try {
      final response = await http.post(
        Uri.parse('$personUrl/access-role/$staffid'),
      );

      if (response.statusCode == 200) {
        print('Account access successfully');
      } else {
        print('Failed to access account: ${response.statusCode}');
      }
    } catch (e) {
      print('Error access account: $e');
    }
  }

  // function cancel role staff
  Future<void> cancelRoleStaff(String staffid) async {
    try {
      final response = await http.post(
        Uri.parse('$personUrl/cancel-role/$staffid'),
      );

      if (response.statusCode == 200) {
        print('Account canceled successfully');
      } else {
        print('Failed to cancel account: ${response.statusCode}');
      }
    } catch (e) {
      print('Error cancel account: $e');
    }
  }

  // Get product for admin
  Future<List<Product>> getListProducts() async {
    try {
      final response = await http.get(Uri.parse(productUrl));
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        List<Product> products = [];
        for (var item in jsonData) {
          Product product = Product.fromJson(item);
          // Decode image and image detail
          base64Decode(product.image);
          base64Decode(product.imagedetail);

          products.add(product);
        }
        return products;
      } else {
        throw Exception('Failed to load product products');
      }
    } catch (e) {
      throw Exception('Failed to load product products');
    }
  }

  // Get category for admin
  Future<List<Category>> getListCategories() async {
    try {
      final response = await http.get(Uri.parse(categoryUrl));
      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        List<Category> categories =
            body.map((dynamic item) => Category.fromJson(item)).toList();
        return categories;
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      throw Exception('Failed to load categories');
    }
  }

  // fetch daily revenue
  Future<int> fetchDailyRevenue(DateTime date) async {
    try {
      final response = await http.get(Uri.parse(
          '$billUrl/daily-revenue?date=${date.toString().substring(0, 10)}'));
      if (response.statusCode == 200) {
        return int.parse(response.body);
      } else {
        throw Exception('Failed to load daily revenue');
      }
    } catch (e) {
      throw Exception('Failed to load daily revenue');
    }
  }

  // fetch top products
  Future<List<Map<String, dynamic>>> fetchTopProducts(DateTime date) async {
    try {
      final response = await http.get(Uri.parse(
          '$billUrl/top-products?date=${date.toString().substring(0, 10)}'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body).cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to load top products');
      }
    } catch (e) {
      throw Exception('Failed to load top products');
    }
  }

  // Delete order
  Future<void> deleteOrder(String orderid) async {
    try {
      final response = await http.delete(Uri.parse('$orderUrl/$orderid'));
      if (response.statusCode == 200 || response.statusCode == 204) {
        print('Order deleted successfully');
      } else {
        throw Exception('Failed to delete Order');
      }
    } catch (e) {
      throw Exception('Failed to delete Order');
    }
  }

  // fetch all comment
  Future<List<Comment>> fetchAllComment() async {
    try {
      final response = await http.get(Uri.parse(commentUrl));
      // print('Response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        // print('Response body: $jsonData');
        List<Comment> comments =
            jsonData.map((data) => Comment.fromJson(data)).toList();
        // print('Parsed comments: $comments');
        return comments;
      } else {
        throw Exception('Failed to load comments');
      }
    } catch (e) {
      throw Exception('Failed to load comments');
    }
  }

  // function publish comment
  Future<void> publishComment(String commentid) async {
    try {
      final response = await http.post(
        Uri.parse('$commentUrl/publish-comment/$commentid'),
      );

      if (response.statusCode == 200) {
        print('Comment published successfully');
      } else {
        print('Failed to publish comment: ${response.statusCode}');
      }
    } catch (e) {
      print('Error publish comment: $e');
      // Xử lý lỗi nếu cần thiết
    }
  }

  //
  Future<void> cancelComment(String commentid) async {}

  //
  Future<List<Comment>> fetchPublishedComments() async {
    try {
      final response = await http.get(Uri.parse(commentUrl));
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        List<Comment> comments = jsonData
            .where((comment) => comment['status'] == 1)
            .map((data) => Comment.fromJson(data))
            .toList();
        return comments;
      } else {
        throw Exception('Failed to load published comments');
      }
    } catch (e) {
      throw Exception('Failed to load published comments: $e');
    }
  }

  // Authenticate account
  Future<bool> authenticateAccountStaffs(
      String identifier, String password) async {
    final uri = Uri.parse(accountUrl);

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);

        for (var accountData in jsonResponse) {
          Account account = Account.fromJson(accountData);
          if ((account.username == identifier) &&
              account.password == password) {
            return true;
          }
        }
        return false;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<Staff> getStaffByIdentifier(String identifier) async {
    final uri = Uri.parse(staffUrl);

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        List<dynamic> responseData = json.decode(response.body);

        for (var staffData in responseData) {
          Staff staff = Staff.fromJson(staffData);

          if (staff.phonenumber == identifier) {
            return staff;
          }
        }

        throw Exception('Staff data not found for identifier: $identifier');
      } else {
        throw Exception('Failed to load staff data');
      }
    } catch (e) {
      throw Exception('Error fetching staff data: $e');
    }
  }

  // Confirm order
  Future<void> confirmOrder(String orderid, String staffid) async {
    final uri = Uri.parse('$orderUrl/confirm');

    try {
      final response = await http.put(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'orderid': orderid,
          'staffid': staffid,
        }),
      );
      // print(response.statusCode);
      if (response.statusCode == 200) {
        print('Order confirmed successfully');
      } else {
        throw Exception('Failed to confirm order: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to confirm order: $e');
    }
  }

  // Add bill
  Future<void> addBill(Bill bill) async {
    final uri = Uri.parse(billUrl);

    try {
      final response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(bill.toJson()),
      );
      // print(response.statusCode);
      if (response.statusCode == 200) {
        print('Bill added successfully');
      } else {
        throw Exception('Failed to add bill: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to add bill: $e');
    }
  }

  // Get bill by orderid for Staff
  Future<List<Bill>> getBillByOrderId(String orderid) async {
    try {
      final response = await http.get(Uri.parse('$billUrl/bill/$orderid'));
      // print(response.statusCode);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);

        // Kiểm tra xem có dữ liệu được trả về không
        if (jsonData.isNotEmpty) {
          List<Bill> billDetails =
              jsonData.map((item) => Bill.fromJson(item)).toList();
          return billDetails;
        } else {
          // Nếu không có dữ liệu, trả về một danh sách trống
          return [];
        }
      } else if (response.statusCode == 404) {
        throw Exception('Bill detail not found');
      } else {
        throw Exception(
            'Failed to load Bill detail with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load order detail');
    }
  }

  // Print bill for Staff
  Future<void> printBill(String orderid, String staffid) async {
    final uri = Uri.parse('$billUrl/print');

    try {
      final response = await http.put(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'orderid': orderid,
          'staffid': staffid,
        }),
      );
      // print(response.statusCode);
      if (response.statusCode == 200) {
        print('Bill printed successfully');
      } else {
        throw Exception('Failed to print bill: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to print bill: $e');
    }
  }

  // function getRoleByPersonId
  Future<String?> getRoleByPersonId(String personid) async {
    try {
      final response = await http.get(Uri.parse('$personUrl/$personid'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data != null && data is Map<String, dynamic>) {
          return data['role'] as String?;
        }
      } else {
        print('Failed to load role. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching role: $e');
    }

    return null;
  }

  /// Method for actor Customer

  // Read data from API
  Future<List<Customer>> getCustomers() async {
    try {
      final response = await http.get(Uri.parse(customerUrl));
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map((data) => new Customer.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load customers');
      }
    } catch (e) {
      throw Exception('Failed to load customers');
    }
  }

  // Add data to API
  Future<void> addCustomer(Customer customer) async {
    final uri = Uri.parse(customerUrl);

    try {
      final response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(customer.toJson()),
      );
      // print(response.statusCode);
      if (response.statusCode == 200) {
        print('Customer added successfully');
      } else {
        throw Exception('Failed to add customer: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to add customer: $e');
    }
  }

  // Update data to API
  Future<Customer> updateCustomer(Customer customer) async {
    try {
      final response =
          await http.put(Uri.parse('$customerUrl/${customer.customerid}'),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode(customer.toJson()));
      print(response.statusCode);
      // print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        print('Customer updated successfully');
        if (response.body.isNotEmpty) {
          return Customer.fromJson(json.decode(response.body));
        } else {
          return customer;
        }
      } else {
        throw Exception('Failed to update customer: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to update customer : $e');
    }
  }

  // Delete data from API
  Future<void> deleteCustomer(int customerid) async {
    try {
      final response = await http.delete(Uri.parse('$customerUrl/$customerid'));
      if (response.statusCode != 204) {
        throw Exception('Failed to delete customer');
      }
    } catch (e) {
      throw Exception('Failed to delete customer');
    }
  }

  // Remove leading zeros from input
  String removeLeadingZeros(String input) {
    if (input.startsWith('0')) {
      return input.replaceFirst(RegExp('^0+'), '');
    }
    return input;
  }

  Future<bool> updateCustomerPassword(
      String identifier, String newPassword) async {
    identifier = removeLeadingZeros(identifier);

    try {
      final response = await http.get(Uri.parse(customerUrl));

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);

        for (var customerData in jsonResponse) {
          Customer customer = Customer.fromJson(customerData);
          if (customer.phonenumber.toString() == identifier) {
            try {
              final updateResponse = await http.put(
                Uri.parse('$customerUrl/${customer.customerid}'),
                headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                },
                body: jsonEncode({'password': newPassword}),
              );
              print(updateResponse.statusCode);
              print(customer.customerid);

              if (updateResponse.statusCode == 200) {
                return true;
              } else {
                return false;
              }
            } catch (e) {
              print("Error updating password: $e");
              return false;
            }
          }
        }
        return false;
      } else {
        return false;
      }
    } catch (e) {
      print("Error fetching customer data: $e");
      return false;
    }
  }

  // Authenticate account
  Future<String> authenticateAccountCustomer(
      String identifier, String password) async {
    final uri = Uri.parse(accountUrl);

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);

        for (var accountData in jsonResponse) {
          Account account = Account.fromJson(accountData);
          if (account.username == identifier) {
            if (account.status == 1) {
              return 'locked';
            } else if (account.status == 0 && account.password == password) {
              return 'authenticated';
            }
          }
        }
        return 'not_authenticated';
      } else {
        return 'not_authenticated';
      }
    } catch (e) {
      return 'not_authenticated';
    }
  }

  // Hàm lấy thông tin khách hàng dựa vào identifier
  Future<Customer> getCustomerByIdentifier(String identifier) async {
    final uri = Uri.parse(customerUrl);

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        List<dynamic> responseData = json.decode(response.body);

        for (var userData in responseData) {
          Customer customer = Customer.fromJson(userData);

          if (customer.phonenumber == identifier) {
            return customer;
          }
        }

        throw Exception('Customer data not found for identifier: $identifier');
      } else {
        throw Exception('Failed to load customer data');
      }
    } catch (e) {
      throw Exception('Error fetching customer data: $e');
    }
  }

  // Add comment for customer
  Future<void> addComment(Comment comment) async {
    final uri = Uri.parse(commentUrl);

    try {
      final response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(comment.toJson()),
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('Comment added successfully');
      } else {
        throw Exception('Failed to add comment: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to add comment: $e');
    }
  }

  // function cancel order
  Future<void> cancelOrder(String orderId) async {
    final uri = Uri.parse('$orderUrl/cancel/$orderId');

    try {
      final response = await http.put(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      // print(response.statusCode);
      if (response.statusCode == 200) {
        print('Order cancelled successfully');
      } else {
        throw Exception('Failed to cancel order: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to cancel order: $e');
    }
  }

  //
  Future<Category> getCategoryById(String categoryid) async {
    // Giả sử bạn có một API endpoint để lấy danh mục theo ID
    final response = await http.get(Uri.parse('$categoryUrl/$categoryid'));
    if (response.statusCode == 200) {
      return Category.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load category');
    }
  }

  //
  Future<List<Category>> getCategories() async {
    try {
      final response = await http.get(Uri.parse(categoryUrl));
      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        List<Category> categories =
            body.map((dynamic item) => Category.fromJson(item)).toList();
        return categories;
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      throw Exception('Failed to load categories');
    }
  }

  //
  Future<List<Product>> getProductsByCategory(String categoryid) async {
    final String productUrl =
        "http://localhost:5194/api/products/category/$categoryid";
    try {
      final response = await http.get(Uri.parse(productUrl));
      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        List<Product> products =
            jsonData.map((item) => Product.fromJson(item)).toList();
        return products;
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Failed to load products');
    }
  }

  // Fetch product sizes and prices by product ID
  Future<List<Map<String, dynamic>>> getProductSizes(String productname) async {
    final String productSizesUrl =
        "http://localhost:5194/api/products/sizes/$productname";

    try {
      final response = await http.get(Uri.parse(productSizesUrl));
      // print(response.statusCode);
      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        List<Map<String, dynamic>> sizes = [];
        for (var item in jsonData) {
          sizes.add({
            "size": item["size"],
            "price": item["price"],
          });
        }
        return sizes;
      } else {
        throw Exception('Failed to load product sizes');
      }
    } catch (e) {
      throw Exception('Failed to load product sizes');
    }
  }

  // Read data from API
  Future<List<Product>> getPopulars() async {
    try {
      final response = await http.get(Uri.parse(popularUrl));
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        List<Product> populars = [];
        for (var item in jsonData) {
          Product popular = Product.fromJson(item);
          // Decode image and image detail
          base64Decode(popular.image);
          base64Decode(popular.imagedetail);

          populars.add(popular);
        }
        return populars;
      } else {
        throw Exception('Failed to load popular products');
      }
    } catch (e) {
      throw Exception('Failed to load popular products');
    }
  }

  // Add data to API
  Future<void> addPopular(Product popular) async {
    final uri = Uri.parse(popularUrl);

    try {
      final response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(popular.toJson()),
      );
      if (response.statusCode == 200) {
        print('Popular product added successfully');
      } else {
        throw Exception('Failed to add popular product: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to add popular product: $e');
    }
  }

  // Update data to API
  Future<Product> updatePopular(Product popular) async {
    try {
      final response = await http.put(Uri.parse('$popularUrl/${popular}'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(popular.toJson()));
      if (response.statusCode == 200) {
        return Product.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to update popular product');
      }
    } catch (e) {
      throw Exception('Failed to update popular product');
    }
  }

  // Delete data from API
  Future<void> deletePopular(int id) async {
    try {
      final response = await http.delete(Uri.parse('$popularUrl/$id'));
      if (response.statusCode != 204) {
        throw Exception('Failed to delete popular product');
      }
    } catch (e) {
      throw Exception('Failed to delete popular product');
    }
  }

  Customer? loggedInUser = AuthManager().loggedInCustomer;
  // Read data from API
  Future<List<Favorite>> getFavoritesByCustomerId() async {
    // print(loggedInUser?.customerid);
    try {
      final response = await http.get(Uri.parse('$favoriteUrl'));
      print(response.statusCode);
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        List<Favorite> favorites = [];

        for (var item in jsonResponse) {
          if (item['customerid'] == loggedInUser?.customerid) {
            Favorite favorite = Favorite.fromJson(item);
            // Decode image and image detail
            base64Decode(favorite.image);
            base64Decode(favorite.imagedetail);

            favorites.add(favorite);
          } else {
            item = [];
          }
        }

        return favorites;
      } else {
        print('Failed to load favorite products');
        throw Exception('Failed to load favorite products');
      }
    } catch (e) {
      print('Failed to load favorite products');
      throw Exception('Failed to load favorite products');
    }
  }

  // Add data to API
  Future<void> addFavorite(Favorite favorite) async {
    final uri = Uri.parse(favoriteUrl);

    try {
      final response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(favorite.toJson()),
      );
      if (response.statusCode == 200) {
        print('Favorite product added successfully');
      } else {
        throw Exception('Failed to add favorite product: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to add favorite product: $e');
    }
  }

  // Delete data from API
  Future<void> deleteFavorite(String favoriteid) async {
    try {
      final response = await http.delete(Uri.parse('$favoriteUrl/$favoriteid'));
      if (response.statusCode == 200 || response.statusCode == 204) {
        print('Favorite product deleted successfully');
      } else {
        throw Exception('Failed to delete favorite product');
      }
    } catch (e) {
      throw Exception('Failed to delete favorite product');
    }
  }

  // Read data from API
  Future<List<Product>> getBestSales() async {
    try {
      final response = await http.get(Uri.parse(bestSaleUrl));
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        List<Product> bestsales = [];
        for (var item in jsonData) {
          Product bestsale = Product.fromJson(item);
          // Decode image and image detail
          base64Decode(bestsale.image);
          base64Decode(bestsale.imagedetail);

          bestsales.add(bestsale);
        }
        return bestsales;
      } else {
        throw Exception('Failed to load bestsale products');
      }
    } catch (e) {
      throw Exception('Failed to load bestsale products');
    }
  }

  // Read data from API
  Future<List<Cart>> getCarts() async {
    try {
      final response = await http.get(Uri.parse(cartUrl));
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        List<Cart> carts = [];
        for (var item in jsonData) {
          Cart cart = Cart.fromJson(item);
          // Decode product_image
          base64Decode(cart.image);

          carts.add(cart);
        }
        return carts;
      } else {
        throw Exception('Failed to load carts');
      }
    } catch (e) {
      throw Exception('Failed to load carts');
    }
  }

  // Add data to API
  Future<void> addCart(Cart cart) async {
    final uri = Uri.parse(cartUrl);

    try {
      final response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(cart.toJson()),
      );
      if (response.statusCode == 200) {
        // print('Cart added successfully');
      } else {
        throw Exception('Failed to add cart: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to add cart: $e');
    }
  }

  // Update data to API
  Future<Cart> updateCart(Cart cart) async {
    try {
      final response = await http.put(Uri.parse('$cartUrl/${cart}'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(cart.toJson()));
      if (response.statusCode == 200) {
        return Cart.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to update cart');
      }
    } catch (e) {
      throw Exception('Failed to update cart');
    }
  }

  // Delete data from API
  Future<void> deleteCart(String cartdetailid) async {
    try {
      // print(cartdetailId);
      final response = await http.delete(
        Uri.parse('$cartDetailUrl/$cartdetailid'),
      );
      // print(response.statusCode);
      if (response.statusCode == 200) {
        print('Product removed successfully!');
      } else {
        throw Exception('Product removal failed!');
      }
    } catch (e) {
      print('Product removal failed: $e');
    }
  }

  Future<List<dynamic>> fetchCartDetails() async {
    try {
      final response = await http.get(Uri.parse(cartDetailUrl));
      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse;
      } else {
        throw Exception('Failed to load cart details');
      }
    } catch (e) {
      throw Exception('Error fetching cart details: $e');
    }
  }

  // fetch order by customer
  Future<List<Order>> fetchCustomerOrder(String customerid) async {
    try {
      final response =
          await http.get(Uri.parse('$orderUrl/customer/$customerid'));
      print(response.body);
      // print(response.statusCode);
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        List<Order> orders =
            jsonData.map((data) => Order.fromJson(data)).toList();
        return orders;
      } else {
        throw Exception('Failed to load orders');
      }
    } catch (e) {
      throw Exception('Failed to load orders');
    }
  }

  // Add order
  Future<void> addOrder(OrderDetail orderdetail) async {
    final uri = Uri.parse(orderUrl);

    try {
      final response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(orderdetail.toJson()),
      );
      // print(response.statusCode);
      print(orderdetail.productid);
      if (response.statusCode == 200) {
        print('Order added successfully');
      } else {
        throw Exception('Failed to add order: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to add order: $e');
    }
  }

  // fetch all order from customer
  Future<List<Order>> fetchAllOrder() async {
    try {
      final response = await http.get(Uri.parse(orderUrl));
      // print(response.statusCode);
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        List<Order> orders =
            jsonData.map((data) => Order.fromJson(data)).toList();
        return orders;
      } else {
        throw Exception('Failed to load orders');
      }
    } catch (e) {
      throw Exception('Failed to load orders');
    }
  }

  // fetch order by customer
  Future<List<OrderDetail>> fetchOrderDetail(String orderid) async {
    try {
      final response =
          await http.get(Uri.parse('$orderDetailUrl/order/$orderid'));
      // print(response.statusCode);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);

        // Kiểm tra xem có dữ liệu được trả về không
        if (jsonData.isNotEmpty) {
          List<OrderDetail> orderDetails =
              jsonData.map((item) => OrderDetail.fromJson(item)).toList();
          return orderDetails;
        } else {
          // Nếu không có dữ liệu, trả về một danh sách trống
          return [];
        }
      } else if (response.statusCode == 404) {
        throw Exception('Order detail not found');
      } else {
        throw Exception(
            'Failed to load order detail with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load order detail');
    }
  }
}
