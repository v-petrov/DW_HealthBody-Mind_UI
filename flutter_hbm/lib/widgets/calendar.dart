import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/provider/date_provider.dart';

class DateSelectionWidget extends StatelessWidget {
  final String page;

  const DateSelectionWidget({super.key, required this.page});

  void updateDate(BuildContext context, int days) {
    final dateProvider = Provider.of<DateProvider>(context, listen: false);
    dateProvider.updateDate(context, dateProvider.selectedDate.add(Duration(days: days)), page);
  }

  Future<void> selectDate(BuildContext context) async {
    final dateProvider = Provider.of<DateProvider>(context, listen: false);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: dateProvider.selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != dateProvider.selectedDate) {
      dateProvider.updateDate(context, picked, page);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateProvider = Provider.of<DateProvider>(context);
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 2),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: ()  => updateDate(context, -1),
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
                "${dateProvider.selectedDate.day}/${dateProvider.selectedDate.month}/${dateProvider.selectedDate.year}",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          InkWell(
            onTap: () => updateDate(context, 1),
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