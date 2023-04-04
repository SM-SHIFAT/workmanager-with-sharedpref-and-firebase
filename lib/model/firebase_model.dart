class FirebaseModel {
  final int? data1;
  final bool? data2;
  final String? data3;
  final String? data4;

  FirebaseModel({
    required this.data1,
    required this.data2,
    required this.data3,
    required this.data4,
  });

  Map<String, dynamic> toJson() => {
        "data1": data1,
        "data2": data2,
        "data3": data3,
        "data4": data4,
      };
  static FirebaseModel fromJson(Map<String, dynamic> json) => FirebaseModel(
        data1: json["Data1"] as int?,
        data2: json["Data2"] as bool?,
        data3: json["Data3"] as String?,
        data4: json["Data4"] as String?,
      );
}
