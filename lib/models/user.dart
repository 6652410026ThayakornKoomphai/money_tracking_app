class User {
  int? userID;
  String? userFullName;
  String? userBirthDate;
  String? userName;
  String? userPassword;
  String? userImage;

  User({
    this.userID,
    this.userFullName,
    this.userBirthDate,
    this.userName,
    this.userPassword,
    this.userImage,
  });

  User.fromJson(Map<String, dynamic> json) {
    userID = json['userID'];
    userFullName = json['userFullName'];
    userBirthDate = json['userBirthDate'];
    userName = json['userName'];
    userPassword = json['userPassword'];
    userImage = json['userImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userID'] = userID;
    data['userFullName'] = userFullName;
    data['userBirthDate'] = userBirthDate;
    data['userName'] = userName;
    data['userPassword'] = userPassword;
    data['userImage'] = userImage;
    return data;
  }
}
