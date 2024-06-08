class Users {
  bool? success;
  List<UserData>? data;
  String? message;

  Users({this.success, this.data, this.message});

  Users.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <UserData>[];
      json['data'].forEach((v) {
        data!.add(UserData.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    return data;
  }
}

class UserData {
  int? idUser;
  String? name;
  String? username;
  String? password;
  int? idTeamUser;
  String? role;

  UserData(
      {this.idUser,
      this.name,
      this.username,
      this.password,
      this.idTeamUser,
      this.role});

  //getters and setters
  int? getIdUser() {
    return idUser;
  }

  void setidUser(int? value) {
    idUser = value;
  }

  String? getName() {
    return name;
  }

  void setName(String? value) {
    name = value;
  }

  String? getUsername() {
    return username;
  }

  void setUsername(String? value) {
    username = value;
  }

  String? getPassword() {
    return password;
  }

  void setPassword(String? value) {
    password = value;
  }

  int? getidTeamUser() {
    return idTeamUser;
  }

  void setidTeamUser(int? value) {
    idTeamUser = value;
  }

  String? getRole() {
    return role;
  }

  void setRole(String? value) {
    role = value;
  }

  UserData.fromJson(Map<String, dynamic> json) {
    idUser = json['id_user'];
    name = json['Name'];
    username = json['username'];
    password = json['password'];
    idTeamUser = json['id_team_user'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id_user'] = idUser;
    data['Name'] = name;
    data['username'] = username;
    data['password'] = password;
    data['id_team_user'] = idTeamUser;
    data['role'] = role;
    return data;
  }
}
