import 'package:calory_counter/domain/model/dish.dart';
import 'package:calory_counter/presentation/home.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'calendar.dart';

class AddFoodWidget extends StatefulWidget {
  AddFoodWidget({Key? key}) : super(key: key);

  final TextEditingController _amountTextController = TextEditingController();
  @override
  _AddFoodWidget createState() => _AddFoodWidget();
}

class _AddFoodWidget extends State<AddFoodWidget> {
  var value = FoodService.foodList[0]["value"];
  var amount = 0;
  List<Dish> dishes = [];

  final formKey = GlobalKey<FormState>();
  FoodService statisticService = FoodService.getFoodService();

  @override
  void initState() {
  }

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
            value: this.value,
            onSaved: (value) {
              setState(() {
                this.value = value;
              });
            },
            onChanged: (value) {
              setState(() {
                this.value = value;
              });
            },
            dataSource: FoodService.foodList,
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
                          amount+=100;
                          widget._amountTextController.text = amount.toString();
                        });
                      },
                    )
                  ]),
                  Column(children: <Widget>[
                    RaisedButton(
                      child: Icon(Icons.remove),
                      onPressed: () {
                        setState(() {
                          if (amount-100 >= 0) {
                            amount -= 100;
                          }
                          widget._amountTextController.text = amount.toString();
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
                        statisticService.saveMeal(dishes);
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
                          if (dishes.map((e) => e.id).contains(value)){
                            dishes.firstWhere((element) => element.id == value).amount+=amount;
                          } else{
                            dishes.add(Dish(value, getName(value), amount));
                          }
                          setDefault();
                        });
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
                              dishes.remove(dishes.firstWhere((element) => element.id == item.id));
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

  getName(var id){
    return FoodService.foodList.firstWhere((item)=>(item["value"] == id))["display"];
  }

  setDefault(){
    amount = 0;
    widget._amountTextController.text = '0';
  }
}
