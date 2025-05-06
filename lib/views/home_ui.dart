import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:money_tracking_app/components/custom_button.dart';
import 'package:money_tracking_app/constants/baseurl.dart';
import 'package:money_tracking_app/constants/color_constants.dart';
import 'package:money_tracking_app/models/money.dart';
import 'package:money_tracking_app/models/user.dart';
import 'package:money_tracking_app/services/money_api.dart';
import 'package:money_tracking_app/views/sub_home01_ui.dart';
import 'package:money_tracking_app/views/sub_home02_ui.dart';
import 'package:money_tracking_app/views/sub_home03_ui.dart';

class HomeUI extends StatefulWidget {
  final String? userName;
  final String? userImage;
  final int? userID;
  const HomeUI({super.key, this.userName, this.userImage, this.userID});

  @override
  State<HomeUI> createState() => _HomeUIState();
}

class _HomeUIState extends State<HomeUI> {
  TextEditingController bottomBarController = TextEditingController();

  int selectedIndex = 1;

  late Future<List<Money>> moneyAllData;

  List showUI = [];
  Future<List<Money>> getMoneyByUserId() async {
    return await MoneyApi().getMoneyByUserID(widget.userID!);
  }

  void refreshData() {
    setState(() {
      moneyAllData = getMoneyByUserId(); // Trigger a refresh of the data
    });
  }

  @override
  void initState() {
    refreshData();
    showUI = [
      SubHome02UI(userID: widget.userID!, refreshData: refreshData),
      SubHome01UI(userID: widget.userID!),
      SubHome03UI(userID: widget.userID!, refreshData: refreshData),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double totalBalance = 0.0;
    double totalIncome = 0.0;
    double totalExpanse = 0.0;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Text(
              widget.userName.toString(),
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ],
        ),
        actions: [
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child:
                widget.userImage!.isEmpty == true
                    ? Image.asset(
                      'assets/images/vegito.jpg',
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    )
                    : Image.network(
                      '$baseUrl/images/users/${widget.userImage}',
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    ),
          ),
          SizedBox(width: 25),
        ],
        backgroundColor: Color(mainColor),
      ),
      backgroundColor: Colors.white,
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(canvasColor: Color(mainColor)),
        child: BottomNavigationBar(
          onTap: (value) {
            setState(() {
              selectedIndex = value;
            });
          },
          currentIndex: selectedIndex,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          showSelectedLabels: true,
          showUnselectedLabels: false,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.arrow_circle_down_outlined, size: 45),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined, size: 45),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.arrow_circle_up_outlined, size: 45),
              label: '',
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          FutureBuilder(
            future: moneyAllData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                ); // แสดง loading
              } else if (snapshot.hasError) {
                return Center(child: Text('เกิดข้อผิดพลาด: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                // ตัวแปรนี้จะทำการคำนวณยอดเงินคงเหลือ
                snapshot.data!.forEach((x) {
                  if (x.moneyType == 1) {
                    totalBalance += x.moneyInOut!;
                    totalIncome += x.moneyInOut!;
                  } else {
                    totalExpanse += x.moneyInOut!;
                    totalBalance -= x.moneyInOut!;
                  }
                });
                return Stack(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Color(subColor),
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(24),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Align(
                        alignment: Alignment.center,
                        child: Material(
                          elevation: 8,
                          color: Color(mainColor),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.93,
                            height: 200,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 25,
                              vertical: 25,
                            ),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 254, 68, 130),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  "ยอดเงินคงเหลือ",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  totalBalance.toStringAsFixed(2),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.arrow_circle_down_outlined,
                                              color: const Color.fromARGB(
                                                255,
                                                81,
                                                254,
                                                0,
                                              ),
                                            ),
                                            SizedBox(width: 5),
                                            Text(
                                              "ยอดเงินเข้าร่วม",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          totalIncome.toStringAsFixed(2),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "ยอดเงินออกร่วม",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                              ),
                                            ),
                                            SizedBox(width: 5),
                                            Icon(
                                              Icons.arrow_circle_up_outlined,
                                              color: const Color.fromARGB(
                                                255,
                                                255,
                                                0,
                                                0,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          totalExpanse.toStringAsFixed(2),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
              return Center(child: Text('ไม่มีข้อมูล'));
            },
          ),
          Expanded(child: showUI[selectedIndex]),
        ],
      ),
    );
  }
}
