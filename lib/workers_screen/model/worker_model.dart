class WorkerModel {
  late String name;
  late String uId;

  WorkerModel({
    required this.name,
    required this.uId,
  });

  WorkerModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    uId = json['uId'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'uId': uId,
    };
  }
}
