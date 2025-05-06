import 'package:flutter/material.dart';
import 'package:money_tracking_app/components/custom_button.dart';
import 'package:money_tracking_app/models/money.dart';
import 'package:money_tracking_app/services/money_api.dart';

class SubHome02UI extends StatefulWidget {
  final int? userID;
  Function refreshData;
  SubHome02UI({super.key, required this.userID, required this.refreshData});

  @override
  State<SubHome02UI> createState() => _SubHome02UIState();
}

class _SubHome02UIState extends State<SubHome02UI> {
  TextEditingController birthdayController = TextEditingController();
  TextEditingController moneyDetailController = TextEditingController();
  TextEditingController moneyValueController = TextEditingController();

  DateTime? selectedDate;

  Future<void> selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        birthdayController.text =
            "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      });
    }
  }

  showwarningsnackbar(context, mes) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mes, textAlign: TextAlign.center),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red,
      ),
    );
  }

  showcompletesnackbar(context, mes) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mes, textAlign: TextAlign.center),
        duration: Duration(seconds: 2),
        backgroundColor: const Color.fromARGB(255, 6, 107, 9),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  'เงินเข้า',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: moneyDetailController,
                  decoration: InputDecoration(
                    labelText: 'รายการเงินเข้า',
                    border: OutlineInputBorder(),
                    hintText: 'DETAIL',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: moneyValueController,
                  decoration: InputDecoration(
                    labelText: 'จำนวนเงินเข้า',
                    border: OutlineInputBorder(),
                    hintText: '0.00',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  keyboardType: TextInputType.none,
                  controller: birthdayController,
                  readOnly: true,
                  onTap: () {
                    selectDate();
                  },
                  decoration: InputDecoration(
                    labelText: 'วันที่ เดือน ปีที่เงินเข้า',
                    border: OutlineInputBorder(),
                    hintText: 'DATE INCOME',
                    hintStyle: TextStyle(color: Colors.grey),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () {
                        selectDate();
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20),
                CustomButton(
                  text: 'บันทึกเงินเข้า',
                  onPressed: () async {
                    if (moneyDetailController.text.isEmpty) {
                      showwarningsnackbar(context, 'กรุณากรอกรายการเงินเข้า');
                    } else if (moneyValueController.text.isEmpty) {
                      showwarningsnackbar(context, 'กรุณากรอกจํานวนเงินเข้า');
                    } else if (birthdayController.text.isEmpty) {
                      showwarningsnackbar(
                        context,
                        'กรุณากรอกวัน/เดือน/ปี ที่เงินเข้า',
                      );
                    } else {
                      Money money = Money(
                        moneyDetail: moneyDetailController.text,
                        moneyInOut: double.parse(
                          moneyValueController.text.trim(),
                        ),
                        moneyDate: birthdayController.text,
                        moneyType: 1,
                        userID: widget.userID,
                      );
                      if (await MoneyApi().addMoney(money)) {
                        showcompletesnackbar(
                          context,
                          'บันทึกเงินเข้าเรียบร้อย',
                        );
                        moneyDetailController.clear();
                        moneyValueController.clear();
                        birthdayController.clear();
                        widget.refreshData();
                      } else {
                        showwarningsnackbar(
                          context,
                          'บันทึกเงินเข้าไม่สําเร็จ',
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
