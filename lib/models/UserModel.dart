class UserData {
  String? id;
  String? username;
  String? email;
  String? mainFuel;

  UserData({
    this.id,
    this.username,
    this.email,
    this.mainFuel,
  });

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    mainFuel = json['mainFuel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['email'] = email;
    data['mainFuel'] = mainFuel;
    return data;
  }
}
