// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_import

import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:project/components/heat_map.dart';
import 'package:project/components/my_drawer.dart';
import 'package:project/components/my_habit_tile.dart';
import 'package:project/data/habit_database.dart';
import 'package:project/models/habit.dart';
import 'package:project/theme/theme_provider.dart';
import 'package:project/util/habit_util.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}




class _HomePageState extends State<HomePage> {
  

  final TextEditingController textController = TextEditingController();

  void createHabit(){
  showDialog(
    context: context, 
    builder: (context) => AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min, // To ensure the dialog adjusts size based on the content
        children: [
          TextField(
            controller: textController, 
            decoration: InputDecoration(hintText: "Enter Habit Name"),
          ),
        ],
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.elliptical(10, 10))),
      actions: [
        MaterialButton(
          onPressed: (){
            Navigator.pop(context);
            textController.clear();
          },
          child: Text("Cancel", style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),),
        ),

        MaterialButton(
          onPressed: () async {
            String name = textController.text;
            if (name.isEmpty) {
              Fluttertoast.showToast(
                msg: "Name cannot be empty",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Theme.of(context).colorScheme.primary,
                textColor: Theme.of(context).colorScheme.inversePrimary,
                fontSize: 16.0
              );
            } else {
              TimeOfDay? time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );

              // Create habit with or without time based on selection
              String habitDetails = name;
              if (time != null) {
                habitDetails += " at " + time.format(context);
              }

              // Add habit details to the database
              context.read<HabitDatabase>().addHabit(habitDetails,time);
              Navigator.pop(context);
              textController.clear();
            }
          },
          child: Text("Add Habit", style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),),
        ),
      ],
    ),
  );
}

  void checkHabitOnOff(bool? value, Habit habit){
    if(value!=null){
      context.read<HabitDatabase>().updateHabitCompletion(habit.id, value);
    }
  }

  void editHabitBox(Habit habit){
    textController.text = habit.name;

    showDialog(
      context: context, 
      builder: (context)=> AlertDialog(
        content: TextField(
          controller: textController,
        ),
        actions: [
           MaterialButton(
          onPressed: (){
            Navigator.pop(context);

            textController.clear();
          },
          child: Text("Cancel", style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),),
        ),

        MaterialButton(
          onPressed: (){
            String name = textController.text;

            context.read<HabitDatabase>().updateHabitName(habit.id, name);

            Navigator.pop(context);

            textController.clear();
          },
          child: Text("Update Habit", style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),),
        ),
        ],
      ));
  }

  void deleteHabitBox(Habit habit){
    showDialog(context: context,
      builder: (context) => AlertDialog(
        title: const  Text("Are you sure you want to delete?"),
        actions: [
          MaterialButton(
          onPressed: (){
            Navigator.pop(context);
          },
          child: Text("No", style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),),
        ),
        MaterialButton(
          onPressed: (){
            context.read<HabitDatabase>().deleteHabit(habit.id);

            Navigator.pop(context);

          },
          child: Text("Yes", style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),),
        ),
        ],
        ),
    );
  }


  Widget _buildHabitList(){
    final habitDatabase = context.watch<HabitDatabase>();

    List<Habit> currentHabit = habitDatabase.currentHabits;

    return ListView.builder(
      itemCount: currentHabit.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index){
        final habit = currentHabit[index];

        bool isCompletedToday = isHabitCompletedToday(habit.completedDays);
      
        return MyHabitTile(isCompleted: isCompletedToday,
          text: habit.name, 
          onChanged: (value)=> checkHabitOnOff(value,habit), 
          editHabit: (context)=> editHabitBox(habit),
          deleteHabit: (context) => deleteHabitBox(habit),
        );
      } 
    
    );
  }
  

  Widget _buildHeatMap(){
    final habitDatabase =context.watch<HabitDatabase>();

    List<Habit> currentHabit = habitDatabase.currentHabits;

    return FutureBuilder<DateTime?>(
      future: habitDatabase.getFirstLaunchDate(), 
      builder: (context, snapshot) {
        if(snapshot.hasData){
          return HeatMaps(
            startDate: snapshot.data!,
            dataset: preHeatMapDataset(currentHabit),
          );
        }
        else{
          return Container();
        }
      }
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(title: Text("H A B I T  T R A C K E R",style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary), ),backgroundColor: Colors.transparent,foregroundColor: Theme.of(context).colorScheme.inversePrimary,),
      drawer: const MyDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: createHabit,
        elevation: 4.0,
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.inversePrimary,
        )
      ),
      body:ListView(
        children: [
          _buildHeatMap(),
          _buildHabitList(),
        ]    
      ) 
    );
  }
}