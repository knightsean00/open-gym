import 'package:flutter/material.dart';
import 'package:open_gym/utilities/workout_data_structs.dart';
import 'package:open_gym/widgets/card.dart';

class DayScreen extends StatefulWidget {
  final WorkoutPlan workoutPlan;
  final Function(WorkoutPlan) setWorkoutPlan;

  const DayScreen({super.key, required this.workoutPlan, required this.setWorkoutPlan});

  @override
  State<DayScreen> createState() => _DayScreenState();
}

class _DayScreenState extends State<DayScreen> {
  final textController = TextEditingController();

  @override
  void initState() {
    textController.text = widget.workoutPlan.name;
    // workoutPlansStorage.toMap().forEach((k, v) => _workoutPlans[k] = WorkoutPlan.fromMap(v));
    // setState(() {
    //   _workoutPlans = _workoutPlans;
    // });
    super.initState();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
                padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 24),
                      padding: const EdgeInsets.only(right: 75),
                      child: TextField(
                          maxLines: 1,
                          controller: textController,
                          onTapOutside: (event) {
                            widget.workoutPlan.name = textController.text;
                            widget.setWorkoutPlan(widget.workoutPlan);
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600)),
                    ),
                    if (widget.workoutPlan.days.isEmpty)
                      const Text("You have no days of your workout plans, create one below!")
                    else
                      ...(widget.workoutPlan.days
                          .map((day) => GymCard(title: "place holder", body: "place holder"))),
                    // Center(
                    //     child: IconButton(
                    //   onPressed: () {
                    //     Navigator.of(context).push(
                    //       MaterialPageRoute(builder: (context) {
                    //         String newName = "New Workout #${_workoutPlans.length + 1}";
                    //         WorkoutPlan newPlan = WorkoutPlan(newName, []);
                    //         return DayScreen(
                    //             workoutPlan: newPlan,
                    //             setWorkoutPlan: (WorkoutPlan workoutPlan) {
                    //               setState(() {
                    //                 _workoutPlans[workoutPlan.id] = workoutPlan;
                    //                 workoutPlansStorage.put(workoutPlan.id, workoutPlan.getMap());
                    //               });
                    //             });
                    //       }),
                    //     );
                    //   },
                    //   icon: const Icon(Icons.add_circle_outline_rounded),
                    //   tooltip: "Create New Workout Plan",
                    // )),
                  ],
                ))));
  }
}
