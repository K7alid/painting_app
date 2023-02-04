class DayModel {
  late String dateTime;
  late String uId;

  DayModel({
    required this.dateTime,
    required this.uId,
  });

  DayModel.fromJson(Map<String, dynamic> json) {
    dateTime = json['dateTime'];
    uId = json['uId'];
  }

  Map<String, dynamic> toMap() {
    return {
      'dateTime': dateTime,
      'uId': uId,
    };
  }
}
