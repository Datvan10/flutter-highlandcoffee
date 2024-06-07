import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:highlandcoffeeapp/auth/auth_manage.dart';
import 'package:highlandcoffeeapp/models/model.dart';
import 'package:http/http.dart' as http;

// Admin API
class AdminApi {
  final String adminUrl = "http://localhost:5194/api/admins";
  final String productUrl = "http://localhost:5194/api/products";
  final String categoryUrl = "http://localhost:5194/api/categories";

  // List of API URLs for each category
  static const String baseUrl = 'http://localhost:5194/api/products/category';
  String getCategoryApiUrl(String selectedCategory) {
    switch (selectedCategory) {
      case 'Coffee':
        return '$baseUrl/dm001';
      case 'Freeze':
        return '$baseUrl/dm002';
      case 'Trà':
        return '$baseUrl/dm003';
      case 'Đồ ăn':
        return '$baseUrl/dm004';
      case 'Danh sách sản phẩm':
        return '$baseUrl/products';
      case 'Sản phẩm phổ biến':
        return '$baseUrl/dm005';
      case 'Sản phẩm bán chạy nhất':
        return '$baseUrl/dm006';
      case 'Danh sách sản phẩm phổ biến':
        return '$baseUrl/populars';
      case 'Khác':
        return '$baseUrl/others';
      default:
        throw Exception('Invalid category');
    }
  }

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
          // Kiểm tra `name` hoặc `phonenumber` và `password`
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
      print(response.statusCode);
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
  Future<List<Product>> getProducts(String selectedCategory) async {
    final apiUrl = getCategoryApiUrl(selectedCategory);

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        List<Product> products = [];
        for (var item in jsonData) {
          Product product = Product.fromJson(item);
          // Decode image and image detail
          Uint8List decodedImage = base64Decode(product.image);
          Uint8List decodedImageDetail = base64Decode(product.imagedetail);
          final image = MemoryImage(decodedImage);
          final image_detail = MemoryImage(decodedImageDetail);

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
      // print(response.statusCode);
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
      print(response.statusCode);
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

  // Get category for admin
  Future<List<Category>> getCategories() async {
    try {
      final response = await http.get(Uri.parse(categoryUrl));
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map((data) => new Category.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      throw Exception('Failed to load categories');
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
}

// Customer API
class CustomerApi {
  final String customerUrl = "http://localhost:5194/api/customers";
  final String commentUrl = "http://localhost:5194/api/comments";
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
      // final customerJson = jsonEncode(customer.toJson());
      // print('Customer JSON: $customerJson'); // In ra dữ liệu để kiểm tra
      final response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(customer.toJson()),
      );
      print(response.statusCode);
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
      print('Response body: ${response.body}');

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
  Future<bool> updateCustomerPassword(
      String identifier, String newPassword) async {
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
          if (customer.phonenumber.toString() == identifier) {
            try {
              // Gửi yêu cầu API để cập nhật mật khẩu với id của khách hàng tương ứng
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
                return true; // Trả về true nếu cập nhật thành công
              } else {
                return false; // Trả về false nếu cập nhật không thành công
              }
            } catch (e) {
              print(
                  "Error updating password: $e"); // In ra lỗi nếu có lỗi xảy ra
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
      print(
          "Error fetching customer data: $e"); // In ra lỗi nếu có lỗi xảy ra khi gửi yêu cầu API
      return false; // Trả về false nếu có lỗi xảy ra khi gửi yêu cầu API
    }
  }

  // Authenticate account
  Future<bool> authenticateAccountCustomer(
      String identifier, String password) async {
    final uri = Uri.parse(customerUrl);

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);

        for (var customerData in jsonResponse) {
          Customer customer = Customer.fromJson(customerData);
          // Kiểm tra `name` hoặc `phonenumber` và `password`
          if ((customer.name == identifier ||
                  customer.phonenumber == identifier) &&
              customer.password == password) {
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

  // Hàm lấy thông tin khách hàng dựa vào identifier
  Future<Customer> getCustomerByIdentifier(String identifier) async {
    final uri = Uri.parse(customerUrl);

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        List<dynamic> responseData = json.decode(response.body);

        for (var userData in responseData) {
          Customer customer = Customer.fromJson(userData);
          // Kiểm tra `name` hoặc `phonenumber`
          if (customer.name == identifier ||
              customer.phonenumber == identifier) {
            return customer;
          }
        }

        // Nếu không tìm thấy người dùng có thông tin trùng khớp, ném ra một ngoại lệ
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
}

// Category API
class CategoryApi {
  final String categoryUrl = "http://localhost:5194/api/categories";
  // Read data from API
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
}

// Product API
class ProductApi {
  final String productUrl = "http://localhost:5194/api/products";
  // Read data from API
  Future<List<Product>> getListProducts() async {
    try {
      final response = await http.get(Uri.parse(productUrl));
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        List<Product> products = [];
        for (var item in jsonData) {
          Product product = Product.fromJson(item);
          // Decode image and image detail
          Uint8List decodedImage = base64Decode(product.image);
          Uint8List decodedImageDetail = base64Decode(product.imagedetail);
          final image = MemoryImage(decodedImage);
          final imagedetail = MemoryImage(decodedImageDetail);

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
  final String popularUrl = "http://localhost:5194/api/products/category/dm005";
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
          Uint8List decodedImageDetail = base64Decode(popular.imagedetail);
          final image = MemoryImage(decodedImage);
          final imagedetail = MemoryImage(decodedImageDetail);

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
  Customer? loggedInUser = AuthManager().loggedInCustomer;
  // Read data from API
  Future<List<Favorite>> getFavoritesByCustomerId() async {
    // print(loggedInUser?.customerid);
    try {
      final response = await http.get(Uri.parse('$favoriteUrl'));
      // print(response.statusCode);
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        List<Favorite> favorites = [];

        for (var item in jsonResponse) {
          if (item['customerid'] == loggedInUser?.customerid) {
            Favorite favorite = Favorite.fromJson(item);
            // Decode image and image detail
            Uint8List decodedImage = base64Decode(favorite.image);
            Uint8List decodedImageDetail = base64Decode(favorite.imagedetail);
            final image = MemoryImage(decodedImage);
            final imagedetail = MemoryImage(decodedImageDetail);

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
}

// API fo best sale
class BestSaleApi {
  final String bestSaleUrl =
      "http://localhost:5194/api/products/category/dm006";
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
          Uint8List decodedImage = base64Decode(bestsale.image);
          Uint8List decodedImageDetail = base64Decode(bestsale.imagedetail);
          final image = MemoryImage(decodedImage);
          final imagedetail = MemoryImage(decodedImageDetail);

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
}

// API for Coffee
class CoffeeApi {
  final String coffeeUrl = "http://localhost:5194/api/products/category/dm001";
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
          Uint8List decodedImageDetail = base64Decode(coffee.imagedetail);
          final image = MemoryImage(decodedImage);
          final imagedetail = MemoryImage(decodedImageDetail);

          coffees.add(coffee);
        }
        return coffees;
      } else {
        throw Exception('Failed to load bestsale products');
      }
    } catch (e) {
      throw Exception('Failed to load bestsale products');
    }
  }
}

// API for Freeze
class FreezeApi {
  final String freezeUrl = "http://localhost:5194/api/products/category/dm002";
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
          Uint8List decodedImageDetail = base64Decode(freeze.imagedetail);
          final image = MemoryImage(decodedImage);
          final imagedetail = MemoryImage(decodedImageDetail);

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
}

// API for Tea
class TeaApi {
  final String teaUrl = "http://localhost:5194/api/products/category/dm003";
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
          Uint8List decodedImageDetail = base64Decode(tea.imagedetail);
          final image = MemoryImage(decodedImage);
          final imagedetail = MemoryImage(decodedImageDetail);

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
}

// API for bread
class BreadApi {
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
          Uint8List decodedImageDetail = base64Decode(bread.imagedetail);
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

// API for food
class FoodApi {
  final String foodUrl = "http://localhost:5194/api/products/category/dm004";
  // Read data from API
  Future<List<Product>> getFoods() async {
    try {
      final response = await http.get(Uri.parse(foodUrl));
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        List<Product> foods = [];
        for (var item in jsonData) {
          Product food = Product.fromJson(item);
          // Decode image and image detail
          Uint8List decodedImage = base64Decode(food.image);
          Uint8List decodedImageDetail = base64Decode(food.imagedetail);
          final image = MemoryImage(decodedImage);
          final imagedetail = MemoryImage(decodedImageDetail);

          foods.add(food);
        }
        return foods;
      } else {
        throw Exception('Failed to load food products');
      }
    } catch (e) {
      throw Exception('Failed to load food products');
    }
  }
}

// API for Other
class OtherApi {
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
          Uint8List decodedImageDetail = base64Decode(other.imagedetail);
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
}

// API for Cart
class CartApi {
  final String cartUrl = "http://localhost:5194/api/carts";
  final String cartDetailUrl = "http://localhost:5194/api/cartdetails";
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
          Uint8List decodedImage = base64Decode(cart.image);
          final product_image = MemoryImage(decodedImage);

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
      print(response.statusCode);
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
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('Product removed successfully!');
      } else {
        throw Exception('Product removal failed!');
      }
    } catch (e) {
      print('Product removal failed: $e');
    }
  }
}

// API for CartDetail
class CartDetailApi {
  final String cartDetailUrl = "http://localhost:5194/api/cartdetails";

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
}

/// API for Order
class OrderApi {
  final String orderUrl = "http://localhost:5194/api/orders";

  // fetch order by customer
  Future<List<Order>> fetchOrder(String customerid) async {
    try {
      final response =
          await http.get(Uri.parse('$orderUrl/customer/$customerid'));
      print(response.body);
      print(response.statusCode);
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
      print(response.statusCode);
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
}

//
class OrderDetailApi {
  final String orderDetailUrl = "http://localhost:5194/api/orderdetails";

  // fetch order by customer
  Future<List<OrderDetail>> fetchOrderDetail(String orderid) async {
    try {
      final response =
          await http.get(Uri.parse('$orderDetailUrl/order/$orderid'));
      print(response.statusCode);

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
