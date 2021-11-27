import 'package:calory_counter/domain/model/circular_data_pfc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';


class PfcWidget extends StatefulWidget {
  PfcWidget({Key? key, required this.data}) : super(key: key);

  CircularDataPFC data;

  @override
  _PfcWidget createState() => _PfcWidget();
}

class _PfcWidget extends State<PfcWidget> {


  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircularPercentIndicator(
          radius: 60.0,
          lineWidth: 5.0,
          percent: 0.8,
          center: new Text(widget.data.value.toString()+"%"),
          progressColor: widget.data.color,
        ),
        Text(widget.data.title)
      ],
    );
  }
}