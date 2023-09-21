import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:open_gym/widgets/card.dart';
import 'utilities/workout_data_structs.dart';
import 'screens/DayScreen.dart';
import 'package:hive/hive.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox("workouts");

  // await Hive.openBox("workout_plans");
  // Hive.box("workout_plans").clear();
  await Hive.openBox("workout_plans");
  await Hive.openBox("workout_history");

  runApp(MainApp());
}

class MainApp extends StatefulWidget {
  MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  // // Box workoutsStorage = Hive.box("workouts");
  // Box workoutPlansStorage = Hive.box("workout_plans");

  // // Map<String, Workout> _workouts = new Map<String, Workout>();
  // Map<String, WorkoutPlan> _workoutPlans = new Map<String, WorkoutPlan>();

  // @override
  // void initState() {
  //   // Map<String, Workout> temp = new Map<String, Workout>();
  //   // workoutsStorage
  //   //     .toMap()
  //   //     .forEach((k, v) => _workouts[k] = Workout.fromMap(v));

  //   workoutPlansStorage
  //       .toMap()
  //       .forEach((k, v) => _workoutPlans[k] = WorkoutPlan.fromMap(v));

  //   setState(() {
  //     _workoutPlans = _workoutPlans;
  //   });
  //   super.initState();
  // }

  // void reloadState() {
  //   setState(() {
  //     _workoutPlans = _workoutPlans;
  //   });
  // }

  // void updateWorkoutsStorage(Workout workout, {bool reload = true}) {
  //   workoutsStorage.put(workout.id, workout.getMap());
  //   if (reload) {
  //     reloadState();
  //   }
  // }

  // void updateWorkoutPlansStorage(WorkoutPlan plan, {bool reload = true}) {
  //   workoutPlansStorage.put(plan.id, plan.getMap());
  //   if (reload) {
  //     reloadState();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color.fromARGB(255, 85, 64, 139),
      // systemNavigationBarColor: Colors.white,
      // systemNavigationBarIconBrightness: Brightness.dark,
      // statusBarIconBrightness: Brightness.light,
    ));
    return MaterialApp(
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Box workoutPlansStorage = Hive.box("workout_plans");
  Map<String, WorkoutPlan> _workoutPlans = Map<String, WorkoutPlan>();

  final textController = TextEditingController();

  @override
  void initState() {
    print(workoutPlansStorage.toMap());
    workoutPlansStorage.toMap().forEach((k, v) => _workoutPlans[k as String] =
        WorkoutPlan.fromMap(v.map((key, value) => MapEntry(key as String, value))));
    setState(() {
      _workoutPlans = _workoutPlans;
    });
    super.initState();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> sortedKeys = _workoutPlans.keys.toList();
    sortedKeys.sort();

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
                    child: const Text("Open Gym",
                        maxLines: 1,
                        style:
                            TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0, fontSize: 42)),
                  ),
                  if (_workoutPlans.isEmpty)
                    const Text("You have no work out plans, create one below!")
                  else
                    ...(sortedKeys.map((e) => GymCard(
                        title: _workoutPlans[e]!.name,
                        body: "${_workoutPlans[e]?.days.length} day program"))),
                  Center(
                      child: IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) {
                          String newName = "New Workout #${_workoutPlans.length + 1}";
                          WorkoutPlan newPlan = WorkoutPlan(newName, []);
                          return DayScreen(
                              workoutPlan: newPlan,
                              setWorkoutPlan: (WorkoutPlan workoutPlan) {
                                print(workoutPlan.getMap());
                                print(workoutPlan.id);
                                setState(() {
                                  _workoutPlans[workoutPlan.id] = workoutPlan;
                                  workoutPlansStorage.put(workoutPlan.id, workoutPlan.getMap());
                                });
                              });
                        }),
                      );
                    },
                    icon: const Icon(Icons.add_circle_outline_rounded),
                    tooltip: "Create New Workout Plan",
                  )),
                ],
              ))),
    );
  }
}
