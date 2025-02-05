import 'package:flutter/material.dart';

Widget buildGoalRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 16)),
        Align(
          alignment: Alignment.centerRight,
          child: Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
      ],
    ),
  );
}

Widget buildTextFieldWithLabel(String label, String suffix) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10.0),
    child: Row(
      children: [
        Expanded(
          child: Text(label, style: TextStyle(fontSize: 14)),
        ),
        SizedBox(
          width: 276,
          child: TextField(
            readOnly: true,
            enabled: false,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Enter value",
              suffixText: suffix,
            ),
            keyboardType: TextInputType.number,
          ),
        ),
      ],
    ),
  );
}

Widget buildDropdownWithLabel(String label, List<String> options, String selectedValue, Function(String?) onChanged) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 2,
          child: Text(label, style: TextStyle(fontSize: 14)),
        ),
        SizedBox(width: 10),
        Expanded(
          flex: 3,
          child: DropdownButtonFormField<String>(
            value: selectedValue,
            isExpanded: true,
            onChanged: null,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              border: OutlineInputBorder(),
            ),
            items: options.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                enabled: false,
                child: Tooltip(
                  message: value,
                  child: Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    ),
  );
}

Widget buildProfileField(String label, String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: Row(
      children: [
        SizedBox(
          width: 90,
          child: Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(width: 5),
        Flexible(
          child: Container(
            width: 200,
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 1),
            ),
            child: Text(value),
          ),
        ),
      ],
    ),
  );
}