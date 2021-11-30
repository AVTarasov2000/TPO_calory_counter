import 'package:calory_counter/domain/model/user.dart';
import 'package:calory_counter/presentation/home.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'calendar.dart';

class UserWidget extends StatefulWidget {
  UserWidget({Key? key}) : super(key: key);

  final TextEditingController _heightTextController = new TextEditingController();
  final TextEditingController _weightTextController = new TextEditingController();
  final TextEditingController _ageTextController = new TextEditingController();
  final TextEditingController _modeTextController = new TextEditingController();

  @override
  _UserWidget createState() => _UserWidget();
}

class _UserWidget extends State<UserWidget> {
  UserService userService = UserService.getUserService();
  late User user = User(0,0,0,0,1);

  @override
  void initState() {
    userService.getUser().then(
      (value){
        user = value;
        widget._heightTextController.text = user.height.toString();
        widget._weightTextController.text = user.weight.toString();
        widget._ageTextController.text = user.age.toString();
        widget._modeTextController.text = user.mode.toString();
      }
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User'),
      ),
      body: Column(children: <Widget>[
        Container(
            padding: EdgeInsets.all(16),
            child: TextField(
              controller: widget._ageTextController,
              onChanged: (text) => {user.age = num.tryParse(text)!.toInt()},
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: const InputDecoration(
                labelText: 'Enter age',
                hintText: 'Enter age',
              ),
            )),
        Container(
            padding: EdgeInsets.all(16),
            child: TextField(
              controller: widget._heightTextController,
              onChanged: (text) => {user.height = num.tryParse(text)!.toInt()},
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: const InputDecoration(
                labelText: 'Enter height',
                hintText: 'Enter height',
              ),
            )),
        Container(
            padding: EdgeInsets.all(16),
            child: TextField(
              controller: widget._weightTextController,
              onChanged: (text) => {user.weight = num.tryParse(text)!.toInt()},
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: const InputDecoration(
                labelText: 'Enter weight',
                hintText: 'Enter weight',
              ),
            )),
        Container(
          padding: EdgeInsets.all(16),
          child: DropDownFormField(
            titleText: 'My workout',
            hintText: 'Please choose one',
            value: user.mode,
            onSaved: (value) {
              setState(() {
                user.mode = value;
              });
            },
            onChanged: (value) {
              setState(() {
                user.mode = value;
              });
            },
            dataSource: const [
              {
                "display": "похудение",
                "value": 1,
              },
              {
                "display": "поддержание веса",
                "value": 2,
              },
              {
                "display": "Набор веса",
                "value": 3,
              },
            ],
            textField: 'display',
            valueField: 'value',
          ),
        ),
        Container(
            padding: EdgeInsets.all(8),
            child: RaisedButton(
                child: Text('Save'),
                onPressed: () {
                  userService.save(user);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => TableBasicsExample()),
                  );
                })),
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
}
