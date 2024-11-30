class UserData {
  int? idUser;
  String? name;
  String? username;
  String? password;
  String? email;
  String? role;
  String? token;

  UserData({
    this.idUser,
    this.name,
    this.username,
    this.password,
    this.email,
    this.role,
    this.token,
  });

  UserData.fromJson(Map<String, dynamic> json) {
    idUser = json['iduser'];
    name = json['name'];
    username = json['username'];
    password = json['password'];
    email = json['email'];
    role = json['role'];
    token = json['token']; 
  }

  Map<String, dynamic> toJson() {
    return {
      'iduser': idUser,
      'name': name,
      'username': username,
      'password': password,
      'email': email,
      'role': role,
      'token': token, 
    };
  }
}
