import 'dart:typed_data';

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

class Customer {
  final String name;
  final String email;
  final String password;
  final String confirm_password;
  Uint8List? image;
  final int phone_number;
  final String address;

  Customer({
    required this.name,
    required this.email,
    required this.password,
    required this.confirm_password,
    this.image,
    required this.phone_number,
    required this.address,
  });

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
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

class Product {
  final int id;
  final String product_name;
  final String description;
  final double price;
  final String image;

  Product(
      {required this.id,
      required this.product_name,
      required this.description,
      required this.price,
      required this.image});

  factory Product.fromJson(Map<String, dynamic> json) => Product(
      id: json['id'],
      product_name: json['product_name'],
      description: json['description'],
      price: json['price'],
      image: json['image']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'product_name': product_name,
        'description': description,
        'price': price,
        'image': image
      };
}

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

class Coffee {
  final int id;
  final String name;
  final String image;
  final double price;

  Coffee(
      {required this.id,
      required this.name,
      required this.image,
      required this.price});

  factory Coffee.fromJson(Map<String, dynamic> json) => Coffee(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      price: json['price']);

  Map<String, dynamic> toJson() =>
      {'id': id, 'name': name, 'image': image, 'price': price};
}

class Tea {
  final int id;
  final String name;
  final String image;
  final double price;

  Tea(
      {required this.id,
      required this.name,
      required this.image,
      required this.price});

  factory Tea.fromJson(Map<String, dynamic> json) => Tea(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      price: json['price']);

  Map<String, dynamic> toJson() =>
      {'id': id, 'name': name, 'image': image, 'price': price};
}

class Cake {
  final int id;
  final String name;
  final String image;
  final double price;

  Cake(
      {required this.id,
      required this.name,
      required this.image,
      required this.price});

  factory Cake.fromJson(Map<String, dynamic> json) => Cake(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      price: json['price']);

  Map<String, dynamic> toJson() =>
      {'id': id, 'name': name, 'image': image, 'price': price};
}

class Bread {
  final int id;
  final String name;
  final String image;
  final double price;

  Bread(
      {required this.id,
      required this.name,
      required this.image,
      required this.price});

  factory Bread.fromJson(Map<String, dynamic> json) => Bread(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      price: json['price']);

  Map<String, dynamic> toJson() =>
      {'id': id, 'name': name, 'image': image, 'price': price};
}

class Freeze {
  final int id;
  final String name;
  final String image;
  final double price;

  Freeze(
      {required this.id,
      required this.name,
      required this.image,
      required this.price});

  factory Freeze.fromJson(Map<String, dynamic> json) => Freeze(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      price: json['price']);

  Map<String, dynamic> toJson() =>
      {'id': id, 'name': name, 'image': image, 'price': price};
}

class Other {
  final int id;
  final String name;
  final String image;
  final double price;

  Other(
      {required this.id,
      required this.name,
      required this.image,
      required this.price});

  factory Other.fromJson(Map<String, dynamic> json) => Other(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      price: json['price']);

  Map<String, dynamic> toJson() =>
      {'id': id, 'name': name, 'image': image, 'price': price};
}

class Popular {
  final int id;
  final String name;
  final String image;
  final double price;

  Popular(
      {required this.id,
      required this.name,
      required this.image,
      required this.price});

  factory Popular.fromJson(Map<String, dynamic> json) => Popular(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      price: json['price']);

  Map<String, dynamic> toJson() =>
      {'id': id, 'name': name, 'image': image, 'price': price};
}

class Favorite {
  final int id;
  final String name;
  final String image;
  final double price;

  Favorite(
      {required this.id,
      required this.name,
      required this.image,
      required this.price});

  factory Favorite.fromJson(Map<String, dynamic> json) => Favorite(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      price: json['price']);

  Map<String, dynamic> toJson() =>
      {'id': id, 'name': name, 'image': image, 'price': price};
}
