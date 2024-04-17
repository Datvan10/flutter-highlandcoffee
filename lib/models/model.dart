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

// Model product
class Product {
  final String category_name;
  final String product_name;
  final String description;
  final int size_s_price;
  final int size_m_price;
  final int size_l_price;
  final int unit;
  Uint8List image;
  Uint8List image_detail;
  final int quantity;

  Product(
      {required this.category_name,
      required this.product_name,
      required this.description,
      required this.size_s_price,
      required this.size_m_price,
      required this.size_l_price,
      required this.unit,
      required this.image,
      required this.image_detail,
      required this.quantity});

  factory Product.fromJson(Map<String, dynamic> json) => Product(
      category_name: json['category_name'],
      product_name: json['product_name'],
      description: json['description'],
      size_s_price: json['size_s_price'],
      size_m_price: json['size_m_price'],
      size_l_price: json['size_l_price'],
      unit: json['unit'],
      image: json['image'],
      image_detail: json['image_detail'],
      quantity: json['quantity']);

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
        'quantity': quantity
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
  final int id;
  final int customer_id;
  final String product_name;
  final int quantity;
  final double total_price;

  Cart(
      {required this.id,
      required this.customer_id,
      required this.product_name,
      required this.quantity,
      required this.total_price});

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
      id: json['id'],
      customer_id: json['customer_id'],
      product_name: json['product_name'],
      quantity: json['quantity'],
      total_price: json['total_price']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'customer_id': customer_id,
        'product_name': product_name,
        'quantity': quantity,
        'total_price': total_price
      };
}

// Model coffee
class Coffee {
  final String category_name;
  final String product_name;
  final String description;
  final int size_s_price;
  final int size_m_price;
  final int size_l_price;
  final int unit;
  Uint8List image;
  Uint8List image_detail;
  final int quantity;

  Coffee(
      {required this.category_name,
      required this.product_name,
      required this.description,
      required this.size_s_price,
      required this.size_m_price,
      required this.size_l_price,
      required this.unit,
      required this.image,
      required this.image_detail,
      required this.quantity});

  factory Coffee.fromJson(Map<String, dynamic> json) => Coffee(
      category_name: json['category_name'],
      product_name: json['product_name'],
      description: json['description'],
      size_s_price: json['size_s_price'],
      size_m_price: json['size_m_price'],
      size_l_price: json['size_l_price'],
      unit: json['unit'],
      image: json['image'],
      image_detail: json['image_detail'],
      quantity: json['quantity']);

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
        'quantity': quantity
      };
}

// Model tea
class Tea {
  final String category_name;
  final String product_name;
  final String description;
  final int size_s_price;
  final int size_m_price;
  final int size_l_price;
  final int unit;
  Uint8List image;
  Uint8List image_detail;
  final int quantity;

  Tea(
      {required this.category_name,
      required this.product_name,
      required this.description,
      required this.size_s_price,
      required this.size_m_price,
      required this.size_l_price,
      required this.unit,
      required this.image,
      required this.image_detail,
      required this.quantity});

  factory Tea.fromJson(Map<String, dynamic> json) => Tea(
      category_name: json['category_name'],
      product_name: json['product_name'],
      description: json['description'],
      size_s_price: json['size_s_price'],
      size_m_price: json['size_m_price'],
      size_l_price: json['size_l_price'],
      unit: json['unit'],
      image: json['image'],
      image_detail: json['image_detail'],
      quantity: json['quantity']);

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
        'quantity': quantity
      };
}

class Cake {
  final String category_name;
  final String product_name;
  final String description;
  final int size_s_price;
  final int size_m_price;
  final int size_l_price;
  final int unit;
  Uint8List image;
  Uint8List image_detail;
  final int quantity;

  Cake(
      {required this.category_name,
      required this.product_name,
      required this.description,
      required this.size_s_price,
      required this.size_m_price,
      required this.size_l_price,
      required this.unit,
      required this.image,
      required this.image_detail,
      required this.quantity});

  factory Cake.fromJson(Map<String, dynamic> json) => Cake(
      category_name: json['category_name'],
      product_name: json['product_name'],
      description: json['description'],
      size_s_price: json['size_s_price'],
      size_m_price: json['size_m_price'],
      size_l_price: json['size_l_price'],
      unit: json['unit'],
      image: json['image'],
      image_detail: json['image_detail'],
      quantity: json['quantity']);

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
        'quantity': quantity
      };
}

class Bread {
  final String category_name;
  final String product_name;
  final String description;
  final int size_s_price;
  final int size_m_price;
  final int size_l_price;
  final int unit;
  Uint8List image;
  Uint8List image_detail;
  final int quantity;

  Bread(
      {required this.category_name,
      required this.product_name,
      required this.description,
      required this.size_s_price,
      required this.size_m_price,
      required this.size_l_price,
      required this.unit,
      required this.image,
      required this.image_detail,
      required this.quantity});

  factory Bread.fromJson(Map<String, dynamic> json) => Bread(
      category_name: json['category_name'],
      product_name: json['product_name'],
      description: json['description'],
      size_s_price: json['size_s_price'],
      size_m_price: json['size_m_price'],
      size_l_price: json['size_l_price'],
      unit: json['unit'],
      image: json['image'],
      image_detail: json['image_detail'],
      quantity: json['quantity']);

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
        'quantity': quantity
      };
}

class Freeze {
  final String category_name;
  final String product_name;
  final String description;
  final int size_s_price;
  final int size_m_price;
  final int size_l_price;
  final int unit;
  Uint8List image;
  Uint8List image_detail;
  final int quantity;

  Freeze(
      {required this.category_name,
      required this.product_name,
      required this.description,
      required this.size_s_price,
      required this.size_m_price,
      required this.size_l_price,
      required this.unit,
      required this.image,
      required this.image_detail,
      required this.quantity});

  factory Freeze.fromJson(Map<String, dynamic> json) => Freeze(
      category_name: json['category_name'],
      product_name: json['product_name'],
      description: json['description'],
      size_s_price: json['size_s_price'],
      size_m_price: json['size_m_price'],
      size_l_price: json['size_l_price'],
      unit: json['unit'],
      image: json['image'],
      image_detail: json['image_detail'],
      quantity: json['quantity']);

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
        'quantity': quantity
      };
}

class Other {
  final String category_name;
  final String product_name;
  final String description;
  final int size_s_price;
  final int size_m_price;
  final int size_l_price;
  final int unit;
  Uint8List image;
  Uint8List image_detail;
  final int quantity;

  Other(
      {required this.category_name,
      required this.product_name,
      required this.description,
      required this.size_s_price,
      required this.size_m_price,
      required this.size_l_price,
      required this.unit,
      required this.image,
      required this.image_detail,
      required this.quantity});

  factory Other.fromJson(Map<String, dynamic> json) => Other(
      category_name: json['category_name'],
      product_name: json['product_name'],
      description: json['description'],
      size_s_price: json['size_s_price'],
      size_m_price: json['size_m_price'],
      size_l_price: json['size_l_price'],
      unit: json['unit'],
      image: json['image'],
      image_detail: json['image_detail'],
      quantity: json['quantity']);

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
        'quantity': quantity
      };
}

class Popular {
  final String category_name;
  final String product_name;
  final String description;
  final int size_s_price;
  final int size_m_price;
  final int size_l_price;
  final int unit;
  Uint8List image;
  Uint8List image_detail;
  final int quantity;

  Popular(
      {required this.category_name,
      required this.product_name,
      required this.description,
      required this.size_s_price,
      required this.size_m_price,
      required this.size_l_price,
      required this.unit,
      required this.image,
      required this.image_detail,
      required this.quantity});

  factory Popular.fromJson(Map<String, dynamic> json) => Popular(
      category_name: json['category_name'],
      product_name: json['product_name'],
      description: json['description'],
      size_s_price: json['size_s_price'],
      size_m_price: json['size_m_price'],
      size_l_price: json['size_l_price'],
      unit: json['unit'],
      image: json['image'],
      image_detail: json['image_detail'],
      quantity: json['quantity']);

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
        'quantity': quantity
      };
}

class Favorite {
  final String category_name;
  final String product_name;
  final String description;
  final int size_s_price;
  final int size_m_price;
  final int size_l_price;
  final int unit;
  Uint8List image;
  Uint8List image_detail;
  final int quantity;

  Favorite(
      {required this.category_name,
      required this.product_name,
      required this.description,
      required this.size_s_price,
      required this.size_m_price,
      required this.size_l_price,
      required this.unit,
      required this.image,
      required this.image_detail,
      required this.quantity});

  factory Favorite.fromJson(Map<String, dynamic> json) => Favorite(
      category_name: json['category_name'],
      product_name: json['product_name'],
      description: json['description'],
      size_s_price: json['size_s_price'],
      size_m_price: json['size_m_price'],
      size_l_price: json['size_l_price'],
      unit: json['unit'],
      image: json['image'],
      image_detail: json['image_detail'],
      quantity: json['quantity']);

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
        'quantity': quantity
      };
}
