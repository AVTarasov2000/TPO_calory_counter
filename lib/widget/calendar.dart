import 'package:calory_counter/calendarLib/table_calendar.dart';
import 'package:calory_counter/calendarLib/src/shared/utils.dart';
import 'package:calory_counter/domain/model/circular_data_pfc.dart';
import 'package:calory_counter/presentation/home.dart';
import 'package:calory_counter/widget/pfc_vidget.dart';
import 'package:calory_counter/widget/utils.dart';
import 'package:flutter/material.dart';


class TableBasicsExample extends StatefulWidget {
  @override
  _TableBasicsExampleState createState() => _TableBasicsExampleState();
}

class _TableBasicsExampleState extends State<TableBasicsExample> {
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOn;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  StatisticService statisticService = StatisticService.getStatisticService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calories_counter'),
      ),
      body: Column(
        children: <Widget>[
          TableCalendar(

            firstDay: kFirstDay,
            lastDay: kLastDay,
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            rangeStartDay: _rangeStart,
            rangeEndDay: _rangeEnd,
            calendarFormat: _calendarFormat,
            rangeSelectionMode: _rangeSelectionMode,
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(_selectedDay, selectedDay)) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                  _rangeStart = null; // Important to clean those
                  _rangeEnd = null;
                  _rangeSelectionMode = RangeSelectionMode.toggledOff;
                });
              }
            },
            onRangeSelected: (start, end, focusedDay) {
              setState(() {
                _selectedDay = null;
                _focusedDay = focusedDay;
                _rangeStart = start;
                _rangeEnd = end;
                _rangeSelectionMode = RangeSelectionMode.toggledOn;
              });
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          PfcWidget(data: statisticService.getCalories(_focusedDay),),
          PfcWidget(data: statisticService.getFat(_focusedDay),),
          PfcWidget(data: statisticService.getCarbohydrates(_focusedDay),),
          PfcWidget(data: statisticService.getProteins(_focusedDay),),
          PfcWidget(data: statisticService.getWater(_focusedDay),),
        ]
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          setState(() {
            _selectedDay = DateTime.now();
            _focusedDay = DateTime.now();
          });
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}