// Model account
class Account{
  String username;
  String password;
  String personid;
  int status;

  Account({required this.username, required this.password, required this.personid, required this.status});

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      username: json['username'],
      password: json['password'],
      personid: json['personid'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'personid': personid,
      'status': status,
    };
  }
}
// Model admin
class Admin {
  String? adminid;
  final String name;
  final String phonenumber;
  int? shift;
  final String password;

  Admin({
    this.adminid,
    required this.name,
    required this.phonenumber,
    required this.shift,
    required this.password,
  });

  factory Admin.fromJson(Map<String, dynamic> json) => Admin(
        adminid: json['adminid'],
        name: json['name'],
        phonenumber: json['phonenumber'],
        shift: json['shift'],
        password: json['password'],
      );

  Map<String, dynamic> toJson() => {
        'adminid': adminid,
        'name': name,
        'phonenumber': phonenumber,
        'shift': shift,
        'password': password,
      };
}

// Model staff
class Staff {
  final String staffid;
  final String name;
  final String phonenumber;
  final DateTime startday;
  int? salary;
  final String password;

  Staff({
    required this.staffid,
    required this.name,
    required this.phonenumber,
    required this.startday,
    required this.salary,
    required this.password,
  });

  factory Staff.fromJson(Map<String, dynamic> json) => Staff(
        staffid: json['staffid'],
        name: json['name'],
        phonenumber: json['phonenumber'],
        startday: DateTime.parse(json['startday']),
        salary: json['salary'],
        password: json['password'],
      );

  Map<String, dynamic> toJson() => {
        'staffid': staffid,
        'name': name,
        'phonenumber': phonenumber,
        'startday': startday.toIso8601String(),
        'salary': salary,
        'password': password,
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
  int? status;

  Customer({
    this.customerid,
    required this.name,
    required this.phonenumber,
    required this.address,
    required this.point,
    required this.password,
    required this.status,
  });

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        customerid: json['customerid'],
        name: json['name'],
        phonenumber: json['phonenumber'],
        address: json['address'],
        point: json['point'],
        password: json['password'],
        status: json['status'],
      );

  Map<String, dynamic> toJson() => {
        'customerid': customerid,
        'name': name,
        'phonenumber': phonenumber,
        'address': address,
        'point': point,
        'password': password,
        'status': status,
      };
}

// Model order
class Order {
  final String orderid;
  final String customerid;
  final String? staffid;
  final DateTime date;
  final String paymentmethod;
  final int status;
  final int totalprice;

  Order({
    required this.orderid,
    required this.customerid,
    this.staffid,
    required this.date,
    required this.paymentmethod,
    required this.status,
    required this.totalprice,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderid: json['orderid'],
      customerid: json['customerid'],
      staffid: json['staffid'],
      date: DateTime.parse(json['date']),
      paymentmethod: json['paymentmethod'],
      status: json['status'],
      totalprice: json['totalprice'],
    );
  }

  Map<String, dynamic> toJson() => {
        'orderid': orderid,
        'customerid': customerid,
        'staffid': staffid,
        'date': date.toIso8601String(),
        'paymentmethod': paymentmethod,
        'status': status,
        'totalprice': totalprice,
      };
}

// Model orderdetail
class OrderDetail {
  final String orderdetailid;
  final String orderid;
  final String? cartid; // Allowing null values
  final String staffid;
  final String customerid;
  final String productid;
  final String productname;
  final int quantity;
  final String size;
  final String image; // Assuming image is a base64 encoded string
  final int intomoney;
  final int totalprice;
  final DateTime date;
  final String paymentmethod;
  final int status;
  final String customername;
  final String address;
  final String phonenumber;

  OrderDetail({
    required this.orderdetailid,
    required this.orderid,
    this.cartid,
    required this.staffid,
    required this.customerid,
    required this.productid,
    required this.productname,
    required this.quantity,
    required this.size,
    required this.image,
    required this.intomoney,
    required this.totalprice,
    required this.date,
    required this.paymentmethod,
    required this.status,
    required this.customername,
    required this.address,
    required this.phonenumber,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    return OrderDetail(
      orderdetailid: json['orderdetailid'] ?? '',
      orderid: json['orderid'] ?? '',
      cartid: json['cartid'],
      staffid: json['staffid'] ?? '',
      customerid: json['customerid'] ?? '',
      productid: json['productid'] ?? '',
      productname: json['productname'] ?? '',
      quantity: json['quantity'] ?? 0,
      size: json['size'] ?? '',
      image: json['image'] ?? '',
      intomoney: json['intomoney'] ?? 0,
      totalprice: json['totalprice'] ?? 0,
      date: DateTime.parse(json['date'] ?? DateTime.now().toString()),
      paymentmethod: json['paymentmethod'] ?? '',
      status: json['status'] ?? 0,
      customername: json['customername'] ?? '',
      address: json['address'] ?? '',
      phonenumber: json['phonenumber'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'orderdetailid': orderdetailid,
        'orderid': orderid,
        'cartid': cartid,
        'staffid': staffid,
        'customerid': customerid,
        'productid': productid,
        'productname': productname,
        'quantity': quantity,
        'size': size,
        'image': image,
        'intomoney': intomoney,
        'totalprice': totalprice,
        'date': date.toIso8601String(),
        'paymentmethod': paymentmethod,
        'status': status,
        'customername': customername,
        'address': address,
        'phonenumber': phonenumber,
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

// Model comment
class Comment {
  final String commentid;
  final String customerid;
  final String customername;
  final String titlecomment;
  final String contentcomment;
  final DateTime date;
  String image;
  int status;

  Comment({
    required this.commentid,
    required this.customerid,
    required this.customername,
    required this.titlecomment,
    required this.contentcomment,
    required this.date,
    required this.image,
    required this.status,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      commentid: json['commentid'],
      customerid: json['customerid'],
      customername: json['customername'],
      titlecomment: json['titlecomment'],
      contentcomment: json['contentcomment'],
      date: json['date'],
      image: json['image'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() => {
        'commentid': commentid,
        'customerid': customerid,
        'customername': customername,
        'titlecomment': titlecomment,
        'contentcomment': contentcomment,
        'date': date.toIso8601String(),
        'image': image,
        'status': status,
      };
}

// Model category
class Category {
  final String categoryid;
  final String categoryname;
  final String description;

  Category({
    required this.categoryid,
    required this.categoryname,
    required this.description,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      categoryid: json['categoryid'],
      categoryname: json['categoryname'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() => {
        'categoryid': categoryid,
        'categoryname': categoryname,
        'description': description,
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

// Modle Bill
class Bill {
  String billid;
  String orderid;
  String staffid;
  String staffname;
  String customerid;
  String customername;
  DateTime date;
  String paymentmethod;
  int totalprice;
  int status;
  String address;
  int discountcode;
  String phonenumber;
  

  Bill({
    required this.billid,
    required this.orderid,
    required this.staffid,
    required this.customerid,
    required this.date,
    required this.paymentmethod,
    required this.totalprice,
    required this.status,
    required this.address,
    required this.discountcode,
    required this.staffname,
    required this.phonenumber,
    required this.customername,
  });

  factory Bill.fromJson(Map<String, dynamic> json) {
    return Bill(
      billid: json['billid'],
      orderid: json['orderid'],
      staffid: json['staffid'],
      customerid: json['customerid'],
      date: DateTime.parse(json['date']),
      paymentmethod: json['paymentmethod'],
      totalprice: json['totalprice'],
      status: json['status'],
      address: json['address'],
      discountcode: json['discountcode'],
      staffname: json['staffname'],
      phonenumber: json['phonenumber'],
      customername: json['customername'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'billid': billid,
      'orderid': orderid,
      'staffid': staffid,
      'customerid': customerid,
      'date': date.toIso8601String(),
      'paymentmethod': paymentmethod,
      'totalprice': totalprice,
      'status': status,
      'address': address,
      'staffname': staffname,
      'phonenumber': phonenumber,
      'customername': customername,
    };
  }
}

class DailyRevenue {
  final String date;
  final int revenue;

  DailyRevenue({required this.date, required this.revenue});
}
