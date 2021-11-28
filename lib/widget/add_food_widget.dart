import 'package:calory_counter/domain/model/dish.dart';
import 'package:calory_counter/presentation/home.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'calendar.dart';

class AddFoodWidget extends StatefulWidget {

  final TextEditingController _amountTextController = new TextEditingController();
  @override
  _AddFoodWidget createState() => _AddFoodWidget();
}

class _AddFoodWidget extends State<AddFoodWidget> {
  Dish dish = Dish('', 0);
  List<Dish> dishes = [];

  final formKey = new GlobalKey<FormState>();
  FoodService statisticService = FoodService.getFoodService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add food'),
      ),
      body: Column(children: <Widget>[
        Container(
          padding: EdgeInsets.all(16),
          child: DropDownFormField(
            titleText: 'My workout',
            hintText: 'Please choose one',
            value: dish.name,
            onSaved: (value) {
              setState(() {
                dish.name = value;
              });
            },
            onChanged: (value) {
              setState(() {
                dish.name = value;
              });
            },
            dataSource: statisticService.getFood(),
            textField: 'display',
            valueField: 'value',
          ),
        ),
        Container(
            padding: EdgeInsets.all(16),
            child: TextField(
              controller: widget._amountTextController,
              readOnly: true,
              // onChanged: (text) => {dish.amount = num.tryParse(text)!},
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],

              decoration: const InputDecoration(
                labelText: 'Enter amount',
                hintText: 'Enter amount',
              ),
            )),
        Container(
            padding: EdgeInsets.all(8),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(children: <Widget>[
                    RaisedButton(
                      child: Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          dish.amount+=100;
                          widget._amountTextController.text = dish.amount.toString();
                        });
                      },
                    )
                  ]),
                  Column(children: <Widget>[
                    RaisedButton(
                      child: Icon(Icons.remove),
                      onPressed: () {
                        setState(() {
                          if (dish.amount-100 >= 0) {
                            dish.amount -= 100;
                          }
                          widget._amountTextController.text = dish.amount.toString();
                        });
                      },
                    )
                  ])
                ])),
        Container(
            padding: EdgeInsets.all(8),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(children: <Widget>[
                    RaisedButton(
                      child: Text('Save'),
                      onPressed: () {

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => TableBasicsExample()),
                        );
                      },
                    )
                  ]),
                  Column(children: <Widget>[
                    RaisedButton(
                      child: Text('add'),
                      onPressed: () {
                        setState(() {
                          if (dishes.map((e) => e.name).contains(dish.name)){
                            dishes.firstWhere((element) => element.name == dish.name).amount+=dish.amount;
                          } else{
                            dishes.add(Dish(dish.name, dish.amount));
                          }
                          setDefault();
                        });
                        print(dish.amount);
                        print(dish.name);
                      },
                    )
                  ])
                ])),
        SingleChildScrollView(
          padding: EdgeInsets.all(8),
            child: Column(
              children: dishes.map(
                (item) => Card(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(item.name + " = " + item.amount.toString()),
                        RaisedButton(
                          child: Text('remove'),
                          onPressed: () {
                            setState(() {
                              dishes.remove(dishes.firstWhere((element) => element.name == item.name));
                            });
                          },
                        )
                      ]
                    )
                )
              ).toList()
            )
          ),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => TableBasicsExample()),
        ),
        tooltip: 'Increment',
        child: const Icon(Icons.exit_to_app),
      ),
    );
  }

  setDefault(){
    dish.amount = 0;
    widget._amountTextController.text = '0';
  }
}
