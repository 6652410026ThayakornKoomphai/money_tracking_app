import 'package:flutter/material.dart';
import 'package:money_tracking_app/components/custom_button.dart';
import 'package:money_tracking_app/extensions/comma.dart';
import 'package:money_tracking_app/models/money.dart';
import 'package:money_tracking_app/models/user.dart';
import 'package:money_tracking_app/services/money_api.dart';

class SubHome01UI extends StatefulWidget {
  final int userID;
  const SubHome01UI({super.key, required this.userID});

  @override
  State<SubHome01UI> createState() => _SubHome01UIState();
}

class _SubHome01UIState extends State<SubHome01UI> {
  late Future<List<Money>> moneyAllData;
  Future<List<Money>> getMoneyByUserId() async {
    return await MoneyApi().getMoneyByUserID(widget.userID);
  }

  void refreshData() {
    setState(() {
      moneyAllData = getMoneyByUserId(); // Trigger a refresh of the data
    });
  }

  @override
  void initState() {
    refreshData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 20),
            Text(
              "เงินเข้า/เงินออก",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: FutureBuilder(
                future: moneyAllData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    ); // แสดง loading
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('เกิดข้อผิดพลาด: ${snapshot.error}'),
                    );
                  } else if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading:
                              snapshot.data![index].moneyType == 1
                                  ? Icon(
                                    Icons.arrow_circle_down_outlined,
                                    color: Colors.green,
                                    size: 36,
                                  )
                                  : Icon(
                                    Icons.arrow_circle_up_outlined,
                                    color: Colors.red,
                                    size: 36,
                                  ),
                          title: Text(
                            '${snapshot.data![index].moneyDetail}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            '${snapshot.data![index].moneyDate}',
                            style: TextStyle(fontSize: 12),
                          ),
                          trailing:
                              snapshot.data![index].moneyType == 1
                                  ? Text(
                                    " + ${snapshot.data![index].moneyInOut!.withComma} บาท",
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 18,
                                    ),
                                  )
                                  : Text(
                                    " - ${snapshot.data![index].moneyInOut!.withComma} บาท",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 18,
                                    ),
                                  ),
                        );
                      },
                    );
                  }
                  return Text('ไม่มีข้อมูล');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
