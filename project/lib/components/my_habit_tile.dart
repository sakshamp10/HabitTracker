import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class MyHabitTile extends StatelessWidget {
  final String text;
  final bool isCompleted;
  final void Function(bool?)? onChanged;
  final void Function(BuildContext)? editHabit;
  final void Function(BuildContext)? deleteHabit;


  const MyHabitTile({
    super.key, 
    required this.isCompleted, 
    required this.text, 
    required this.onChanged, 
    required this.editHabit,
    required this.deleteHabit,
    });


  

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const DrawerMotion(), 
          children: [
            SlidableAction(
              onPressed: editHabit,
              backgroundColor: Colors.grey.shade600,
              icon: Icons.settings,
              borderRadius: BorderRadius.circular(10),
              spacing: 5
            ),
            // Container(),
            SlidableAction(
              onPressed: deleteHabit,
              backgroundColor: const Color.fromARGB(255, 241, 70, 67),
              icon: Icons.delete,
              borderRadius: BorderRadius.circular(10),
              spacing: 5
            )
          ],
        ),
        child: GestureDetector(
          onTap:(){ 
            if(onChanged!=null){
              onChanged!(!isCompleted);
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: isCompleted?const Color.fromARGB(255, 119, 238, 123): Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(10)
            ),
            margin: const EdgeInsets.symmetric(vertical: 0.5, horizontal: 15),
            child: ListTile(
              title: Text(text),
              leading: Checkbox(
                activeColor:const Color.fromARGB(255, 157, 243, 160) ,
                value: isCompleted,
                onChanged: onChanged,
              )
            ),
          ),
        ),
      ),
    );
  }
}