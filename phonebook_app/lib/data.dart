//Local Contact Data
class Data {
  final String first_name, last_name;
  final List<dynamic> phone_numbers;

  Data(this.last_name, this.first_name, this.phone_numbers);
  
  String get initials {
    return first_name[0].substring(0, 1) + last_name[1].substring(0, 1);
  }
  Map<String, dynamic> toJson() => {
    'last_name': last_name,
    'first_name': first_name,
    'phone_numbers': phone_numbers,
  };
}