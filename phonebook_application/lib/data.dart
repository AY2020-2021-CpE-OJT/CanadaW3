//Local Contact Data
class Data {
  final String? first_name, last_name;
  final int? v;
  final List<dynamic>? phone_numbers;
  final String? id;

  Data(this.last_name, this.first_name, this.phone_numbers, this.id, this.v,);

  Map<String, dynamic> toJson() => {
    "phone_numbers": List<dynamic>.from(phone_numbers!.map((x) => x)),
    "_id": id,
    "last_name": last_name,
    "first_name": first_name,
    "__v": v,
  };
}