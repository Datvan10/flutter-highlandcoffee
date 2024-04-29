import 'dart:typed_data';

// Model admin
class Admin {
  final String email;
  final String password;

  Admin({
    required this.password,
    required this.email,
  });

  factory Admin.fromJson(Map<String, dynamic> json) => Admin(
        password: json['password'],
        email: json['email'],
      );

  Map<String, dynamic> toJson() => {
        'password': password,
        'email': email,
      };
}

// Model staff
class Staff {
  final int id;
  final String staff_name;
  final String password;
  final String confirm_password;
  final String email;
  final String address;
  final int phone;

  Staff(
      {required this.id,
      required this.staff_name,
      required this.password,
      required this.confirm_password,
      required this.email,
      required this.address,
      required this.phone});

  factory Staff.fromJson(Map<String, dynamic> json) => Staff(
      id: json['id'],
      staff_name: json['staff_name'],
      password: json['password'],
      confirm_password: json['confirm_password'],
      email: json['email'],
      address: json['address'],
      phone: json['phone']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'staff_name': staff_name,
        'password': password,
        'confirm_password': confirm_password,
        'email': email,
        'address': address,
        'phone': phone
      };
}

// Model customer
class Customer {
  int? id;
  final String name;
  final String email;
  String password;
  final String confirm_password;
  Uint8List? image;
  final int phone_number;
  final String address;

  Customer({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.confirm_password,
    this.image,
    required this.phone_number,
    required this.address,
  });

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        password: json['password'],
        confirm_password: json['confirm_password'],
        image: json['image'],
        phone_number: json['phone_number'],
        address: json['address'],
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'password': password,
        'confirm_password': confirm_password,
        'image': image,
        'phone_number': phone_number,
        'address': address,
      };
}

// Model order
class Order {
  final int id;
  final int customer_id;
  final String product_name;
  final int quantity;
  final double total_price;
  final String status;

  Order(
      {required this.id,
      required this.customer_id,
      required this.product_name,
      required this.quantity,
      required this.total_price,
      required this.status});

  factory Order.fromJson(Map<String, dynamic> json) => Order(
      id: json['id'],
      customer_id: json['customer_id'],
      product_name: json['product_name'],
      quantity: json['quantity'],
      total_price: json['total_price'],
      status: json['status']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'customer_id': customer_id,
        'product_name': product_name,
        'quantity': quantity,
        'total_price': total_price,
        'status': status
      };
}

// Model cart
class Cart {
  int customer_id;
  String category_name;
  int product_id;
  int quantity;
  String product_image;
  String product_name;
  int selected_price;
  String selected_size;

  Cart(
      {required this.customer_id,
      required this.category_name,
      required this.product_id,
      required this.quantity,
      required this.product_image,
      required this.product_name,
      required this.selected_price,
      required this.selected_size});

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
      customer_id: json['customer_id'],
      category_name: json['category_name'],
      product_id: json['product_id'],
      quantity: json['quantity'],
      product_image: json['product_image'],
      product_name: json['product_name'],
      selected_price: json['selected_price'],
      selected_size: json['selected_size']);

  Map<String, dynamic> toJson() => {
        'customer_id': customer_id,
        'category_name': category_name,
        'product_id': product_id,
        'quantity': quantity,
        'product_image': product_image,
        'product_name': product_name,
        'selected_price': selected_price,
        'selected_size': selected_size
      };
}

// Model favorite
class Favorite {
  int customer_id;
  String category_name;
  int product_id;
  String product_name;
  String description;
  int size_s_price;
  int size_m_price;
  int size_l_price;
  String unit;
  String image;
  String image_detail;

  Favorite(
      {required this.customer_id,
      required this.category_name,
      required this.product_id,
      required this.product_name,
      required this.description,
      required this.size_s_price,
      required this.size_m_price,
      required this.size_l_price,
      required this.unit,
      required this.image,
      required this.image_detail,
      });

  factory Favorite.fromJson(Map<String, dynamic> json) => Favorite(
      customer_id: json['customer_id'],
      category_name: json['category_name'],
      product_id: json['product_id'],
      product_name: json['product_name'],
      description: json['description'],
      size_s_price: json['size_s_price'],
      size_m_price: json['size_m_price'],
      size_l_price: json['size_l_price'],
      unit: json['unit'],
      image: json['image'],
      image_detail: json['image_detail']
      );

  Map<String, dynamic> toJson() => {
        'customer_id': customer_id,
        'category_name': category_name,
        'product_id': product_id,
        'product_name': product_name,
        'description': description,
        'size_s_price': size_s_price,
        'size_m_price': size_m_price,
        'size_l_price': size_l_price,
        'unit': unit,
        'image': image,
        'image_detail': image_detail
      };
}

// Model product
class Product {
  final int id;
  final String category_name;
  final String product_name;
  final String description;
  final int size_s_price;
  final int size_m_price;
  final int size_l_price;
  final String unit;
  String image;
  String image_detail;

  Product({
    required this.id,
    required this.category_name,
    required this.product_name,
    required this.description,
    required this.size_s_price,
    required this.size_m_price,
    required this.size_l_price,
    required this.unit,
    required this.image,
    required this.image_detail,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      category_name: json['category_name'],
      product_name: json['product_name'],
      description: json['description'],
      size_s_price: json['size_s_price'],
      size_m_price: json['size_m_price'],
      size_l_price: json['size_l_price'],
      unit: json['unit'],
      image: json['image'],
      image_detail: json['image_detail'],
    );
  }

  Map<String, dynamic> toJson() => {
        'category_name': category_name,
        'product_name': product_name,
        'description': description,
        'size_s_price': size_s_price,
        'size_m_price': size_m_price,
        'size_l_price': size_l_price,
        'unit': unit,
        'image': image,
        'image_detail': image_detail,
      };
}
