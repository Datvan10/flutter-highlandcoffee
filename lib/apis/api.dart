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

  // Kiểm tra nếu identifier có định dạng email
  if (RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(identifier)) {
    url = '$customerUrl?email=$identifier&password=$password';
  } else {
    // Kiểm tra nếu identifier có định dạng số điện thoại
    if (RegExp(r'^[0-9]+$').hasMatch(identifier)) {
      url = '$customerUrl?phone_number=$identifier&password=$password';
    } else {
      // Nếu không phải email hoặc số điện thoại, coi identifier là email
      url = '$customerUrl?email=$identifier&password=$password';
    }
  }

  try {
    final response = await http.get(
      Uri.parse(url),
    );
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);

      for (var adminData in jsonResponse) {
        Customer customer = Customer.fromJson(adminData);
        // Kiểm tra cả email và số điện thoại
        if (customer.email == identifier || customer.phone_number.toString() == identifier) {
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


  //
   Future<Customer> getCustomerByIdentifier(String identifier) async {
    String url;
    identifier = removeLeadingZeros(identifier);
  try {

    // Kiểm tra nếu identifier có định dạng email
    if (RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(identifier)) {
      url = '$customerUrl?email=$identifier';
    } else {
      // Kiểm tra nếu identifier có định dạng số điện thoại
      if (RegExp(r'^[0-9]+$').hasMatch(identifier)) {
        url = '$customerUrl?phone_number=$identifier';
      } else {
        // Nếu không phải email hoặc số điện thoại, không thực hiện truy vấn và ném ra ngoại lệ
        throw Exception('Invalid identifier format');
      }
    }

    final response = await http.get(
      Uri.parse(url),
    );

    if (response.statusCode == 200) {
      List<dynamic> responseData = json.decode(response.body);

      for (var userData in responseData) {
        Customer customer = Customer.fromJson(userData);
        // Kiểm tra cả email và số điện thoại
        if (customer.email == identifier || customer.phone_number.toString() == identifier) {
          return customer;
        }
      }

      // Nếu không tìm thấy người dùng có thông tin email hoặc số điện thoại trùng khớp, ném ra một ngoại lệ
      throw Exception('Customer data not found for identifier: $identifier');
    } else {
      // Nếu không thành công, ném ra một ngoại lệ
      throw Exception('Failed to load customer data');
    }
  } catch (e) {
    // Nếu có lỗi xảy ra trong quá trình xử lý, ném ra một ngoại lệ
    throw Exception('Error fetching customer data: $e');
  }
}


}

// Product API
class ProductApi {
  final String productUrl = "http://localhost:5194/api/products";
  // Read data from API
  Future<List<Product>> getProducts() async {
  try {
    final List<String> apiUrlList = [
      'http://localhost:5194/api/coffees',
      'http://localhost:5194/api/teas',
      'http://localhost:5194/api/freezes',
      'http://localhost:5194/api/breads',
      'http://localhost:5194/api/others',
    ];

    final List<http.Response> responses = await Future.wait(apiUrlList.map((String apiUrl) {
      return http.get(Uri.parse(apiUrl));
    }));

    List<Product> products = [];

    for (final response in responses) {
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        for (var item in jsonData) {
          Product product = Product.fromJson(item);
          // Decode image and image detail
          Uint8List decodedImage = base64Decode(product.image);
          Uint8List decodedImageDetail = base64Decode(product.image_detail);
          final image = MemoryImage(decodedImage);
          final image_detail = MemoryImage(decodedImageDetail);

          products.add(product);
        }
      } else {
        throw Exception('Failed to load products');
      }
    }

    return products;
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
        throw Exception('Failed to load favorite products');
      }
    } catch (e) {
      throw Exception('Failed to load favorite products');
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

// API for Coffee
class CoffeeApi {
  final String coffeeUrl = "http://localhost:5194/api/coffees";
  // Read data from API
  Future<List<Product>> getCoffees() async {
    try {
      final response = await http.get(Uri.parse(coffeeUrl));
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        List<Product> coffees = [];
        for (var item in jsonData) {
          Product coffee = Product.fromJson(item);
          // Decode image and image detail
          Uint8List decodedImage = base64Decode(coffee.image);
          Uint8List decodedImageDetail = base64Decode(coffee.image_detail);
          final image = MemoryImage(decodedImage);
          final image_detail = MemoryImage(decodedImageDetail);

          coffees.add(coffee);
        }
        return coffees;
      } else {
        throw Exception('Failed to load coffee products');
      }
    } catch (e) {
      throw Exception('Failed to load coffee products');
    }
  }

  // Add data to API
  Future<void> addCoffee(Product coffee) async {
    final uri = Uri.parse(coffeeUrl);

    try {
      final response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(coffee.toJson()),
      );
      if (response.statusCode == 200) {
        print('Coffee added successfully');
      } else {
        throw Exception('Failed to add coffee: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to add coffee: $e');
    }
  }

  // Update data to API
  Future<Product> updateCoffee(Product coffee) async {
    try {
      final response = await http.put(Uri.parse('$coffeeUrl/${coffee}'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(coffee.toJson()));
      if (response.statusCode == 200) {
        return Product.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to update coffee');
      }
    } catch (e) {
      throw Exception('Failed to update coffee');
    }
  }

  // Delete data from API
  Future<void> deleteCoffee(int id) async {
    try {
      final response = await http.delete(Uri.parse('$coffeeUrl/$id'));
      if (response.statusCode != 204) {
        throw Exception('Failed to delete coffee');
      }
    } catch (e) {
      throw Exception('Failed to delete coffee');
    }
  }
}

// API for Freeze
class FreezeApi{
  final String freezeUrl = "http://localhost:5194/api/freezes";
  // Read data from API
  Future<List<Product>> getFreezes() async {
    try {
      final response = await http.get(Uri.parse(freezeUrl));
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        List<Product> freezes = [];
        for (var item in jsonData) {
          Product freeze = Product.fromJson(item);
          // Decode image and image detail
          Uint8List decodedImage = base64Decode(freeze.image);
          Uint8List decodedImageDetail = base64Decode(freeze.image_detail);
          final image = MemoryImage(decodedImage);
          final image_detail = MemoryImage(decodedImageDetail);

          freezes.add(freeze);
        }
        return freezes;
      } else {
        throw Exception('Failed to load freeze products');
      }
    } catch (e) {
      throw Exception('Failed to load freeze products');
    }
  }

  // Add data to API
  Future<void> addFreeze(Product freeze) async {
    final uri = Uri.parse(freezeUrl);

    try {
      final response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(freeze.toJson()),
      );
      if (response.statusCode == 200) {
        print('Freeze added successfully');
      } else {
        throw Exception('Failed to add freeze: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to add freeze: $e');
    }
  }

  // Update data to API
  Future<Product> updateFreeze(Product freeze) async {
    try {
      final response = await http.put(Uri.parse('$freezeUrl/${freeze}'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(freeze.toJson()));
      if (response.statusCode == 200) {
        return Product.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to update freeze');
      }
    } catch (e) {
      throw Exception('Failed to update freeze');
    }
  }

  // Delete data from API
  Future<void> deleteFreeze(int id) async {
    try {
      final response = await http.delete(Uri.parse('$freezeUrl/$id'));
      if (response.statusCode != 204) {
        throw Exception('Failed to delete freeze');
      }
    } catch (e) {
      throw Exception('Failed to delete freeze');
    }
  }
}

// API for Tea
class TeaApi{
  final String teaUrl = "http://localhost:5194/api/teas";
  // Read data from API
  Future<List<Product>> getTeas() async {
    try {
      final response = await http.get(Uri.parse(teaUrl));
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        List<Product> teas = [];
        for (var item in jsonData) {
          Product tea = Product.fromJson(item);
          // Decode image and image detail
          Uint8List decodedImage = base64Decode(tea.image);
          Uint8List decodedImageDetail = base64Decode(tea.image_detail);
          final image = MemoryImage(decodedImage);
          final image_detail = MemoryImage(decodedImageDetail);

          teas.add(tea);
        }
        return teas;
      } else {
        throw Exception('Failed to load tea products');
      }
    } catch (e) {
      throw Exception('Failed to load tea products');
    }
  }

  // Add data to API
  Future<void> addTea(Product tea) async {
    final uri = Uri.parse(teaUrl);

    try {
      final response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(tea.toJson()),
      );
      if (response.statusCode == 200) {
        print('Tea added successfully');
      } else {
        throw Exception('Failed to add tea: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to add tea: $e');
    }
  }

  // Update data to API
  Future<Product> updateTea(Product tea) async {
    try {
      final response = await http.put(Uri.parse('$teaUrl/${tea}'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(tea.toJson()));
      if (response.statusCode == 200) {
        return Product.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to update tea');
      }
    } catch (e) {
      throw Exception('Failed to update tea');
    }
  }

  // Delete data from API
  Future<void> deleteTea(int id) async {
    try {
      final response = await http.delete(Uri.parse('$teaUrl/$id'));
      if (response.statusCode != 204) {
        throw Exception('Failed to delete tea');
      }
    } catch (e) {
      throw Exception('Failed to delete tea');
    }
  }
}

// API for bread
class BreadApi{
  final String breadUrl = "http://localhost:5194/api/breads";
  // Read data from API
  Future<List<Product>> getBreads() async {
    try {
      final response = await http.get(Uri.parse(breadUrl));
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        List<Product> breads = [];
        for (var item in jsonData) {
          Product bread = Product.fromJson(item);
          // Decode image and image detail
          Uint8List decodedImage = base64Decode(bread.image);
          Uint8List decodedImageDetail = base64Decode(bread.image_detail);
          final image = MemoryImage(decodedImage);
          final image_detail = MemoryImage(decodedImageDetail);

          breads.add(bread);
        }
        return breads;
      } else {
        throw Exception('Failed to load bread products');
      }
    } catch (e) {
      throw Exception('Failed to load bread products');
    }
  }

  // Add data to API
  Future<void> addBread(Product bread) async {
    final uri = Uri.parse(breadUrl);

    try {
      final response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(bread.toJson()),
      );
      if (response.statusCode == 200) {
        print('Bread added successfully');
      } else {
        throw Exception('Failed to add bread: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to add bread: $e');
    }
  }

  // Update data to API
  Future<Product> updateBread(Product bread) async {
    try {
      final response = await http.put(Uri.parse('$breadUrl/${bread}'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(bread.toJson()));
      if (response.statusCode == 200) {
        return Product.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to update bread');
      }
    } catch (e) {
      throw Exception('Failed to update bread');
    }
  }

  // Delete data from API
  Future<void> deleteBread(int id) async {
    try {
      final response = await http.delete(Uri.parse('$breadUrl/$id'));
      if (response.statusCode != 204) {
        throw Exception('Failed to delete bread');
      }
    } catch (e) {
      throw Exception('Failed to delete bread');
    }
  }
}

// API for Other
class OtherApi{
  final String otherUrl = "http://localhost:5194/api/others";
  // Read data from API
  Future<List<Product>> getOthers() async {
    try {
      final response = await http.get(Uri.parse(otherUrl));
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        List<Product> others = [];
        for (var item in jsonData) {
          Product other = Product.fromJson(item);
          // Decode image and image detail
          Uint8List decodedImage = base64Decode(other.image);
          Uint8List decodedImageDetail = base64Decode(other.image_detail);
          final image = MemoryImage(decodedImage);
          final image_detail = MemoryImage(decodedImageDetail);

          others.add(other);
        }
        return others;
      } else {
        throw Exception('Failed to load other products');
      }
    } catch (e) {
      throw Exception('Failed to load other products');
    }
  }

  // Add data to API
  Future<void> addOther(Product other) async {
    final uri = Uri.parse(otherUrl);

    try {
      final response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(other.toJson()),
      );
      if (response.statusCode == 200) {
        print('Other added successfully');
      } else {
        throw Exception('Failed to add other: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to add other: $e');
    }
  }

  // Update data to API
  Future<Product> updateOther(Product other) async {
    try {
      final response = await http.put(Uri.parse('$otherUrl/${other}'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(other.toJson()));
      if (response.statusCode == 200) {
        return Product.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to update other');
      }
    } catch (e) {
      throw Exception('Failed to update other');
    }
  }

  // Delete data from API
  Future<void> deleteOther(int id) async {
    try {
      final response = await http.delete(Uri.parse('$otherUrl/$id'));
      if (response.statusCode !=
          204) {
        throw Exception('Failed to delete other');
      }
    } catch (e) {
      throw Exception('Failed to delete other');
    }
  }
}