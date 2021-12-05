import 'package:calory_counter/calendarLib/table_calendar.dart';
import 'package:calory_counter/calendarLib/src/shared/utils.dart';
import 'package:calory_counter/domain/model/circular_data_pfc.dart';
import 'package:calory_counter/presentation/home.dart';
import 'package:calory_counter/widget/pfc_vidget.dart';
import 'package:calory_counter/widget/user_widget.dart';
import 'package:calory_counter/widget/utils.dart';
import 'package:flutter/material.dart';

import 'add_food_widget.dart';


class TableBasicsExample extends StatefulWidget {
  @override
  _TableBasicsExampleState createState() => _TableBasicsExampleState();
}

class _TableBasicsExampleState extends State<TableBasicsExample> {
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOn;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart = DateTime.now();
  DateTime? _rangeEnd = DateTime.now();

  PfcWidget calories      = PfcWidget(data: CircularDataPFC("calories", 0, Colors.amberAccent));
  PfcWidget fat           = PfcWidget(data: CircularDataPFC("fat", 0, Colors.greenAccent));
  PfcWidget carbohydrates = PfcWidget(data: CircularDataPFC("carbohydrates", 0, Colors.blueGrey));
  PfcWidget watter        = PfcWidget(data: CircularDataPFC("watter", 0, Colors.deepPurple));
  PfcWidget proteins      = PfcWidget(data: CircularDataPFC("proteins", 0, Colors.blue));

  StatisticService statisticService = StatisticService.getStatisticService();
  RecommendationService recommendationService = RecommendationService.service;

  @override
  void initState() {
    setState(() {
      setSpines();
    });
    super.initState();
  }

  setSpines(){
    statisticService.getCalories(_rangeStart, _rangeEnd).then((val){calories = PfcWidget(data: val);});
    statisticService.getFat(_rangeStart, _rangeEnd).then((val){fat = PfcWidget(data: val);});
    statisticService.getCarbohydrates(_rangeStart, _rangeEnd).then((val){carbohydrates = PfcWidget(data: val);});
    statisticService.getProteins(_rangeStart, _rangeEnd).then((val){proteins = PfcWidget(data: val);});
    statisticService.getWatter(_rangeStart, _rangeEnd).then((val){watter = PfcWidget(data: val);});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calories_counter'),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle_outlined),
            onPressed: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => UserWidget()),
              )
            },
          ),
        ],
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
                  // calories = PfcWidget(data: statisticService.getCalories(_rangeStart, _rangeEnd),);
                });
                statisticService.getCalories(_rangeStart, _rangeEnd).then((val){ setState(() {calories = PfcWidget(data: val);});});
                statisticService.getFat(_rangeStart, _rangeEnd).then((val){setState(() {fat = PfcWidget(data: val);});});
                statisticService.getCarbohydrates(_rangeStart, _rangeEnd).then((val){setState(() {carbohydrates = PfcWidget(data: val);});});
                statisticService.getProteins(_rangeStart, _rangeEnd).then((val){setState(() {proteins = PfcWidget(data: val);});});
                statisticService.getWatter(_rangeStart, _rangeEnd).then((val){setState(() {watter = PfcWidget(data: val);});});
              }
            },
            onRangeSelected: (start, end, focusedDay) {
              setState(() {
                _selectedDay = null;
                _focusedDay = focusedDay;
                _rangeStart = start;
                _rangeEnd = end;
                _rangeSelectionMode = RangeSelectionMode.toggledOn;
                // calories = PfcWidget(data: statisticService.getCalories(_rangeStart, _rangeEnd),);
              });
              statisticService.getCalories(_rangeStart, _rangeEnd).then((val){ setState(() {calories = PfcWidget(data: val);});});
              statisticService.getFat(_rangeStart, _rangeEnd).then((val){setState(() {fat = PfcWidget(data: val);});});
              statisticService.getCarbohydrates(_rangeStart, _rangeEnd).then((val){setState(() {carbohydrates = PfcWidget(data: val);});});
              statisticService.getProteins(_rangeStart, _rangeEnd).then((val){setState(() {proteins = PfcWidget(data: val);});});
              statisticService.getWatter(_rangeStart, _rangeEnd).then((val){setState(() {watter = PfcWidget(data: val);});});
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
          calories,
          fat,
          carbohydrates,
          proteins,
          watter,
          RaisedButton(
            child: Text('get recommendation'),
            onPressed: () {
              showAlertDialog(context);
            },
          )
        ]
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AddFoodWidget()),
        ),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    recommendationService.getRecommendation(DateTime.now()).then((rec) {
      Widget okButton = TextButton(
        child: Text("OK"),
        onPressed: () {
          Navigator.of(context).pop();
        },
      );

      AlertDialog alert = AlertDialog(
        title: Text("Рекомендация"),
        content: Text(rec),
        actions: [
          okButton,
        ],
      );

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    });
  }
}