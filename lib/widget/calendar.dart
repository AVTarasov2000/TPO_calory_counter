import 'package:calory_counter/calendarLib/table_calendar.dart';
import 'package:calory_counter/calendarLib/src/shared/utils.dart';
import 'package:calory_counter/internal/date_time_util.dart';
import 'package:calory_counter/widget/utils.dart';
import 'package:flutter/material.dart';


class TableBasicsExample extends StatefulWidget {
  @override
  _TableBasicsExampleState createState() => _TableBasicsExampleState();
}

class _TableBasicsExampleState extends State<TableBasicsExample> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TableCalendar - Basics'),
      ),
      body: TableCalendar(
        firstDay: kFirstDay,
        lastDay: kLastDay,
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        selectedDayPredicate: (day) {
          return _selectedDay == day;
        },
        onDaySelected: (selectedDay, focusedDay) {
          if (_selectedDay != selectedDay) {
            // Call `setState()` when updating the selected day
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
            print(selectedDay);
          }
        },
        onFormatChanged: (format) {
          if (_calendarFormat != format) {
            // Call `setState()` when updating calendar format
            setState(() {
              _calendarFormat = format;
            });
          }
        },
        onPageChanged: (focusedDay) {
          // No need to call `setState()` here
          _focusedDay = focusedDay;
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          setState(() {
            _selectedDay = DateTime.now();
            _focusedDay = DateTime.now();
          });
        },
        tooltip: 'Increment',
        child: Text(_focusedDay.day.toString())//const Icon(Icons.add),
      ),
    );
  }
}