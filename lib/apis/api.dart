import 'dart:convert';

import 'package:highlandcoffeeapp/models/model.dart';
import 'package:http/http.dart' as http;

// Admin API
class AdminApi{
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

}

// Customer API
class CustomerApi{
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
}

// Product API
class ProductApi{
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