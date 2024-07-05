import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

class HeatMaps extends StatelessWidget {
  final DateTime startDate;
  final Map<DateTime,int> dataset;
  const HeatMaps({super.key, required this.startDate,required this.dataset});

  void func(){

  }


  @override
  Widget build(BuildContext context) {
    return HeatMap(
      startDate: startDate,
      endDate: DateTime.now(),
      datasets: dataset,
      colorMode: ColorMode.color,
      defaultColor: Theme.of(context).colorScheme.secondary,
      textColor: Theme.of(context).colorScheme.primary,
      showColorTip: false,
      showText: true,
      scrollable: true,
      size: 30,
      colorsets:{
        1: Colors.green.shade200,
        2: Colors.green.shade300,
        3: Colors.green.shade400,
        4: Colors.green.shade500,
        5: Colors.green.shade600,

      }
    );
  }
}