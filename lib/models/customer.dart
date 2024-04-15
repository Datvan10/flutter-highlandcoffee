// import 'dart:typed_data';

// class Customer {
//   final int id;
//   final String name;
//   final String email;
//   final String password;
//   final String confirm_password;
//   final Uint8List  image;
//   final int phone_number;
//   final String address;

//   Customer({
//     required this.id,
//     required this.name,
//     required this.email,
//     required this.password,
//     required this.confirm_password,
//     required this.image,
//     required this.phone_number,
//     required this.address,
//   });

//   factory Customer.fromJson(Map<String, dynamic> json) => Customer(
//       id: json['id'],
//       name: json['name'],
//       email: json['email'],
//       password: json['password'],
//       confirm_password: json['confirm_password'],
//       image: json['image'],
//       phone_number: json['phone_number'],
//       address: json['address'],
//     );

//   Map<String, dynamic> toJson() => {
//     'id': id,
//     'name': name,
//     'email': email,
//     'password': password,
//     'confirm_password': confirm_password,
//     'image': image,
//     'phone_number': phone_number,
//     'address': address,
//   };
//   }