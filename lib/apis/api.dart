import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:highlandcoffeeapp/models/model.dart';
import 'package:http/http.dart' as http;

// Admin API
class AdminApi {
  final String adminUrl = "http://localhost:5194/api/admins";
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
          if (admin.email == email) {
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
  Future<bool> authenticateAdmin(String email, String password) async {
    try {
      final response = await http.get(
        Uri.parse('$adminUrl?email=$email&password=$password'),
      );
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);

        for (var adminData in jsonResponse) {
          Admin admin = Admin.fromJson(adminData);
          if (admin.email == email) {
            if (admin.password == password) {
              return true;
            } else {
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
}

// Customer API
class CustomerApi {
  final String customerUrl = "http://localhost:5194/api/customers";
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
      final response = await http.put(Uri.parse('$customerUrl/${customer}'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(customer.toJson()));
      if (response.statusCode == 200) {
        return Customer.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to update customer');
      }
    } catch (e) {
      throw Exception('Failed to update customer');
    }
  }

  // Delete data from API
  Future<void> deleteCustomer(int id) async {
    try {
      final response = await http.delete(Uri.parse('$customerUrl/$id'));
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

  ///////////////// Chua xu ly phan nay
  // Update customer password
  Future<bool> updateCustomerPassword(String identifier, String newPassword) async {
  // Loại bỏ các ký tự không cần thiết trong số điện thoại
  identifier = removeLeadingZeros(identifier);

  try {
    // Gửi yêu cầu API để lấy danh sách khách hàng
    final response = await http.get(Uri.parse(customerUrl));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);

      for (var customerData in jsonResponse) {
        Customer customer = Customer.fromJson(customerData);
        // Kiểm tra nếu email hoặc số điện thoại trùng khớp
        if (customer.email == identifier || customer.phone_number.toString() == identifier) {
          try {
            // Gửi yêu cầu API để cập nhật mật khẩu với id của khách hàng tương ứng
            final updateResponse = await http.put(
              Uri.parse('$customerUrl/${customer.id}'),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode({'password': newPassword}),
            );
            print(updateResponse.statusCode);
            print(customer.id);

            if (updateResponse.statusCode == 200) {
              return true; // Trả về true nếu cập nhật thành công
            } else {
              return false; // Trả về false nếu cập nhật không thành công
            }
          } catch (e) {
            print("Error updating password: $e"); // In ra lỗi nếu có lỗi xảy ra
            return false; // Trả về false nếu có lỗi xảy ra
          }
        }
      }
      // Trả về false nếu không tìm thấy khách hàng với email hoặc số điện thoại tương ứng
      return false;
    } else {
      // Trả về false nếu không thể lấy được danh sách khách hàng từ API
      return false;
    }
  } catch (e) {
    print("Error fetching customer data: $e"); // In ra lỗi nếu có lỗi xảy ra khi gửi yêu cầu API
    return false; // Trả về false nếu có lỗi xảy ra khi gửi yêu cầu API
  }
}


  // Authenticate customer
  Future<bool> authenticateCustomer(String identifier, String password) async {
     String url;

    identifier = removeLeadingZeros(identifier);

    if (RegExp(r'^[0-9]+$').hasMatch(identifier)) {
        url = '$customerUrl?phone_number=$identifier&password=$password';
    } else {
        url = '$customerUrl?email=$identifier&password=$password';
    }
    try {
      final response = await http.get(
        Uri.parse('$customerUrl?identifier=$identifier&password=$password'),
      );
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);

        for (var adminData in jsonResponse) {
          Customer customer = Customer.fromJson(adminData);
          if (customer.email == identifier ||
              customer.phone_number.toString() == identifier) {
            if (customer.password == password) {
              return true;
            } else {
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
}

// Product API
class ProductApi {
  final String productUrl = "http://localhost:5194/api/products";
  // Read data from API
  Future<List<Product>> getProducts() async {
    try {
      final response = await http.get(Uri.parse(productUrl));
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map((data) => new Product.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Failed to load products');
    }
  }

  // Add data to API
  Future<void> addProduct(Product product) async {
    final uri = Uri.parse(productUrl);

    try {
      final response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(product.toJson()),
      );
      if (response.statusCode == 200) {
        print('Product added successfully');
      } else {
        throw Exception('Failed to add product: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to add product: $e');
    }
  }

  // Update data to API
  Future<Product> updateProduct(Product product) async {
    try {
      final response = await http.put(Uri.parse('$productUrl/${product}'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(product.toJson()));
      if (response.statusCode == 200) {
        return Product.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to update product');
      }
    } catch (e) {
      throw Exception('Failed to update product');
    }
  }

  // Delete data from API
  Future<void> deleteProduct(int id) async {
    try {
      final response = await http.delete(Uri.parse('$productUrl/$id'));
      if (response.statusCode != 204) {
        throw Exception('Failed to delete product');
      }
    } catch (e) {
      throw Exception('Failed to delete product');
    }
  }
}

// API for popular products
class PopularApi {
  final String popularUrl = "http://localhost:5194/api/populars";
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
          Uint8List decodedImage = base64Decode(popular.image);
          Uint8List decodedImageDetail = base64Decode(popular.image_detail);
          final image = MemoryImage(decodedImage);
          final image_detail = MemoryImage(decodedImageDetail);

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
}
// API for favorite products
class FavoriteApi {
  final String favoriteUrl = "http://localhost:5194/api/favorites";
  // Read data from API
  Future<List<Product>> getFavorites() async {
    try {
      final response = await http.get(Uri.parse(favoriteUrl));
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        List<Product> favorites = [];
        for (var item in jsonData) {
          Product favorite = Product.fromJson(item);
          // Decode image and image detail
          Uint8List decodedImage = base64Decode(favorite.image);
          Uint8List decodedImageDetail = base64Decode(favorite.image_detail);
          final image = MemoryImage(decodedImage);
          final image_detail = MemoryImage(decodedImageDetail);

          favorites.add(favorite);
        }
        return favorites;
      } else {
        throw Exception('Failed to load popular products');
      }
    } catch (e) {
      throw Exception('Failed to load popular products');
    }
  }


  // Add data to API
  Future<void> addFavorite(Product popular) async {
    final uri = Uri.parse(favoriteUrl);

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
  Future<Product> updateFavorite(Product popular) async {
    try {
      final response = await http.put(Uri.parse('$favoriteUrl/${popular}'),
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
  Future<void> deleteFavorite(int id) async {
    try {
      final response = await http.delete(Uri.parse('$favoriteUrl/$id'));
      if (response.statusCode != 204) {
        throw Exception('Failed to delete popular product');
      }
    } catch (e) {
      throw Exception('Failed to delete popular product');
    }
  }
}