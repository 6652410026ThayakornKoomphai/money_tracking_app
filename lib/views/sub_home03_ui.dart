import 'package:flutter/material.dart';
import 'package:money_tracking_app/components/custom_button.dart';
import 'package:money_tracking_app/models/money.dart';
import 'package:money_tracking_app/services/money_api.dart';

class SubHome03UI extends StatefulWidget {
  final int? userID;
  Function refreshData;
  SubHome03UI({super.key, required this.userID, required this.refreshData});

  @override
  State<SubHome03UI> createState() => _SubHome03UIState();
}

class _SubHome03UIState extends State<SubHome03UI> {
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
                  'เงินออก',
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
                    labelText: 'รายการเงินออก',
                    border: OutlineInputBorder(),
                    hintText: 'DETAIL',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: moneyValueController,
                  decoration: InputDecoration(
                    labelText: 'จำนวนเงินออก',
                    border: OutlineInputBorder(),
                    hintText: '0.00',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  keyboardType: TextInputType.none,
                  controller: birthdayController,
                  decoration: InputDecoration(
                    labelText: 'วันที่ เดือน ปีที่เงินออก',
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
                  text: 'บันทึกเงินออก',
                  onPressed: () async {
                    if (moneyDetailController.text.isEmpty) {
                      showwarningsnackbar(context, 'กรุณากรอกรายการเงินออก');
                    } else if (moneyValueController.text.isEmpty) {
                      showwarningsnackbar(context, 'กรุณากรอกจํานวนเงินออก');
                    } else if (birthdayController.text.isEmpty) {
                      showwarningsnackbar(
                        context,
                        'กรุณากรอกวัน/เดือน/ปี ที่เงินออก',
                      );
                    } else {
                      Money money = Money(
                        moneyDetail: moneyDetailController.text,
                        moneyInOut: double.parse(
                          moneyValueController.text.trim(),
                        ),
                        moneyDate: birthdayController.text,
                        moneyType: 2,
                        userID: widget.userID,
                      );
                      if (await MoneyApi().addMoney(money)) {
                        showcompletesnackbar(context, 'บันทึกเงินออกเรียบร้อย');
                        moneyDetailController.clear();
                        moneyValueController.clear();
                        birthdayController.clear();
                        widget.refreshData();
                      } else {
                        showwarningsnackbar(context, 'บันทึกเงินออกไม่สําเร็จ');
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
