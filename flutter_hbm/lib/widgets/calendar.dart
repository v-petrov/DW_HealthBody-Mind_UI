import 'package:flutter/material.dart';

class DateSelectionWidget extends StatefulWidget {
  const DateSelectionWidget({super.key});

  @override
  DateSelectionWidgetState createState() => DateSelectionWidgetState();
}

class DateSelectionWidgetState extends State<DateSelectionWidget> {
  DateTime selectedDate = DateTime.now();

  void updateDate(int days) {
    setState(() {
      selectedDate = selectedDate.add(Duration(days: days));
    });
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 2),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () => updateDate(-1),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                border: Border(right: BorderSide(color: Colors.black, width: 1)),
              ),
              child: Text("P", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              decoration: BoxDecoration(
                border: Border(right: BorderSide(color: Colors.black, width: 1)),
              ),
              child: Text(
                "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          InkWell(
            onTap: () => updateDate(1),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Text("N", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
          InkWell(
            onTap: () => selectDate(context),
            child: Padding(
              padding: EdgeInsets.only(left: 5),
              child: Icon(Icons.calendar_today, color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }
}