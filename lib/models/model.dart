class Customer {
  final int id;
  final String customer_name;
  final String password;
  final String confirm_password;
  final String email;
  final String address;
  final int phone;

  Customer(
      {required this.id,
      required this.customer_name,
      required this.password,
      required this.confirm_password,
      required this.email,
      required this.address,
      required this.phone});

      factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        id: json['id'],
        customer_name: json['customer_name'],
        password: json['password'],
        confirm_password: json['confirm_password'],
        email: json['email'],
        address: json['address'],
        phone: json['phone']
      );

      Map<String, dynamic> toJson() => {
        'id': id,
        'customer_name': customer_name,
        'password': password,
        'confirm_password': confirm_password,
        'email': email,
        'address': address,
        'phone': phone
      };
}
