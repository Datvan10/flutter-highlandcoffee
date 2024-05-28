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
  String? customerid;
  final String name;
  final String phonenumber;
  final String address;
  int? point;
  final String password;

  Customer({
    this.customerid,
    required this.name,
    required this.phonenumber,
    required this.address,
    required this.point,
    required this.password,
  });

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        customerid: json['customerid'],
        name: json['name'],
        phonenumber: json['phonenumber'],
        address: json['address'],
        point: json['point'],
        password: json['password'],
      );

  Map<String, dynamic> toJson() => {
        'customerid': customerid,
        'name': name,
        'phonenumber': phonenumber,
        'address': address,
        'point': point,
        'password': password,
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
  String cartdetailid;
  String cartid;
  String customerid;
  String productid;
  int quantity;
  int totalprice;
  String productname;
  String size;
  String image;

  Cart(
      {required this.cartdetailid,
      required this.cartid,
      required this.customerid,
      required this.productid,
      required this.quantity,
      required this.totalprice,
      required this.productname,
      required this.size,
      required this.image});

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
      cartdetailid: json['cartdetailid'],
      cartid: json['cartid'],
      customerid: json['customerid'],
      productid: json['productid'],
      quantity: json['quantity'],
      totalprice: json['totalprice'],
      productname: json['productname'],
      size: json['size'],
      image: json['image']);

  Map<String, dynamic> toJson() => {
        'cartdetailid': cartdetailid,
        'cartid': cartid,
        'customerid': customerid,
        'productid': productid,
        'quantity': quantity,
        'totalprice': totalprice,
        'productname': productname,
        'size': size,
        'image': image
      };
}

// Model favorite
class Favorite {
  String? favoriteid;
  String customerid;
  String productid;
  String productname;
  String description;
  String size;
  int price;
  String unit;
  String image;
  String imagedetail;

  Favorite(
      {this.favoriteid,
      required this.customerid,
      required this.productid,
      required this.productname,
      required this.description,
      required this.size,
      required this.price,
      required this.unit,
      required this.image,
      required this.imagedetail});

  factory Favorite.fromJson(Map<String, dynamic> json) => Favorite(
      favoriteid: json['favoriteid'],
      customerid: json['customerid'],
      productid: json['productid'],
      productname: json['productname'],
      description: json['description'],
      size: json['size'],
      price: json['price'],
      unit: json['unit'],
      image: json['image'],
      imagedetail: json['imagedetail']);

  Map<String, dynamic> toJson() => {
        'favoriteid': favoriteid,
        'customerid': customerid,
        'productid': productid,
        'productname': productname,
        'description': description,
        'size': size,
        'price': price,
        'unit': unit,
        'image': image,
        'imagedetail': imagedetail
      };
}

// Model product

class Product {
  final String productid;
  final String categoryid;
  final String productname;
  final String description;
  final String size;
  final int price;
  final String unit;
  String image;
  String imagedetail;

  Product({
    required this.productid,
    required this.categoryid,
    required this.productname,
    required this.description,
    required this.size,
    required this.price,
    required this.unit,
    required this.image,
    required this.imagedetail,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productid: json['productid'],
      categoryid: json['categoryid'],
      productname: json['productname'],
      description: json['description'],
      size: json['size'],
      price: json['price'],
      unit: json['unit'],
      image: json['image'],
      imagedetail: json['imagedetail'],
    );
  }

  Map<String, dynamic> toJson() => {
        'productid': productid,
        'categoryid': categoryid,
        'productname': productname,
        'description': description,
        'size': size,
        'price': price,
        'unit': unit,
        'image': image,
        'imagedetail': imagedetail,
      };
}
