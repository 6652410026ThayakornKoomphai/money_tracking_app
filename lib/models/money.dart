class Money {
  int? moneyID;
  String? moneyDetail;
  String? moneyDate;
  double? moneyInOut;
  int? moneyType;
  int? userID;

  Money({
    this.moneyID,
    this.moneyDetail,
    this.moneyDate,
    this.moneyInOut,
    this.moneyType,
    this.userID,
  });

  Money.fromJson(Map<String, dynamic> json) {
    moneyID = json['moneyID'];
    moneyDetail = json['moneyDetail'];
    moneyDate = json['moneyDate'];
    moneyInOut = json['moneyInOut'];
    moneyType = json['moneyType'];
    userID = json['userID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['moneyID'] = moneyID;
    data['moneyDetail'] = moneyDetail;
    data['moneyDate'] = moneyDate;
    data['moneyInOut'] = moneyInOut;
    data['moneyType'] = moneyType;
    data['userID'] = userID;
    return data;
  }
}
