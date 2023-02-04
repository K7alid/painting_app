class CustomerModel {
  late String name;
  late String address;
  late String phone;
  late String uId;
  late String dateTime;

  CustomerModel({
    required this.name,
    required this.address,
    required this.phone,
    required this.uId,
    required this.dateTime,
  });

  CustomerModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    address = json['address'];
    phone = json['phone'];
    uId = json['uId'];
    dateTime = json['dateTime'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address,
      'phone': phone,
      'uId': uId,
      'dateTime': dateTime,
    };
  }
}
