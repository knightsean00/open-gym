import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'utilities/workout_data_structs.dart';
import 'package:hive/hive.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox("workouts");
  await Hive.openBox("workout_plans");

  runApp(MainApp());
}

class MainApp extends StatefulWidget {
  MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  Box workoutsStorage = Hive.box("workouts");
  Box workoutPlansStorage = Hive.box("workout_plans");

  Map<String, Workout> _workouts = new Map<String, Workout>();
  Map<String, WorkoutPlan> _workoutPlans = new Map<String, WorkoutPlan>();

  @override
  void initState() {
    // Map<String, Workout> temp = new Map<String, Workout>();
    workoutsStorage
        .toMap()
        .forEach((k, v) => _workouts[k] = Workout.fromMap(v));

    workoutPlansStorage.toMap().forEach(
        (k, v) => _workoutPlans[k] = WorkoutPlan.fromMap(v, _workouts));

    setState(() {
      _workouts = _workouts;
      _workoutPlans = _workoutPlans;
    });
    super.initState();
  }

  void reloadState() {
    setState(() {
      _workouts = _workouts;
      _workoutPlans = _workoutPlans;
    });
  }

  void updateWorkoutsStorage(Workout workout, {bool reload = true}) {
    workoutsStorage.put(workout.id, workout.getMap());
    if (reload) {
      reloadState();
    }
  }

  void updateWorkoutPlansStorage(WorkoutPlan plan, {bool reload = true}) {
    workoutPlansStorage.put(plan.id, plan.getMap());
    if (reload) {
      reloadState();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(
          workouts: _workouts,
          workoutPlans: _workoutPlans,
          updateWorkoutsStorage: updateWorkoutsStorage,
          updateWorkoutPlansStorage: updateWorkoutPlansStorage),
    );
  }
}

class HomePage extends StatefulWidget {
  final Map<String, Workout> workouts;
  final Map<String, WorkoutPlan> workoutPlans;
  final Function updateWorkoutsStorage;
  final Function updateWorkoutPlansStorage;

  HomePage(
      {super.key,
      required Map<String, Workout> this.workouts,
      required Map<String, WorkoutPlan> this.workoutPlans,
      required Function this.updateWorkoutsStorage,
      required Function this.updateWorkoutPlansStorage});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final textController = TextEditingController();

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.workoutPlans.length == 0) {
      // Workout Creator Page
      return Scaffold(
        body: SafeArea(
            child: Center(
                child: Text("You have no workouts made yet, make one here"))),
      );
    }
    return Scaffold(
      body: SafeArea(
          child: Center(
              child: Text(
                  "You have ${widget.workoutPlans.length} workout plans made"))),
    );
  }
}
