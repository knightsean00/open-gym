import 'dart:collection';

// main(List<String> arguments) {
//   Workout workoutA = Workout("Bench Press", [
//     WeightRep.fromLbs(135, 5),
//     WeightRep.fromLbs(135, 5),
//     WeightRep.fromLbs(135, 5),
//     WeightRep.fromLbs(135, 5)
//   ]);
//   Workout workoutB = Workout("Incline Press", [
//     WeightRep.fromLbs(65, 5),
//     WeightRep.fromLbs(65, 5),
//     WeightRep.fromLbs(65, 5)
//   ]);
//   Workout workoutC = Workout("Bench Press", [
//     WeightRep.fromLbs(125, 5),
//     WeightRep.fromLbs(135, 5),
//     WeightRep.fromLbs(135, 5),
//     WeightRep.fromLbs(135, 5)
//   ]);

//   print(!(workoutA == workoutB)); // A should not equal B
//   print(workoutA == workoutC); // A should equal C

//   Day dayA = Day([workoutA]);
//   Day dayB = Day([workoutB]);
//   Day dayC = Day([workoutA, workoutB]);
//   Day dayD = Day([
//     workoutC
//   ]); //Currently this is determined to be the same day as Day A, but future version should use the same mutable object to prevent wrties to distinct Workout objects

//   WorkoutPlan workoutPlan = WorkoutPlan("5x5", [dayA, dayB, dayC, dayD]);

//   for (Day day in workoutPlan.days) {
//     print(day);
//     print("\n");
//   }
//   print(workoutPlan.pattern());

//   (workoutA.sets[0] as WeightRep).setLbs(125);

//   for (Day day in workoutPlan.days) {
//     print(day);
//     print("\n");
//   }
// }

class WorkoutPlan {
  List<Day> days = [];
  String name = "";
  int currentDay = -1; // -1 means that the Workout has not started
  // should add current idx for the day that we're on

  WorkoutPlan(this.name, this.days, {this.currentDay = -1});

  // WorkoutPlan.fromMap(
  //     Map<String, dynamic> map, Map<String, Workout> idWorkoutMap) {
  //   name = map["name"];
  //   days = map["days"].map((day) => Day.fromMap(day, idWorkoutMap)).toList();
  // }

  WorkoutPlan.fromMap(Map<String, dynamic> map) {
    name = map["name"];
    days = map["days"].map((day) => Day.fromMap(day)).toList();
    currentDay = map["currentDay"];
  }

  List<int> pattern() {
    Map<Day, int> dayMap = {};

    int i = 1;
    List<int> output = [];
    for (Day day in days) {
      if (dayMap.containsKey(day)) {
        output.add(dayMap[day]!);
      } else {
        output.add(i);
        dayMap[day] = i++;
      }
    }
    return output;
  }

  bool operator ==(Object other) {
    return other is WorkoutPlan && other.name == name;
  }

  String get id {
    return name;
  }

  @override
  int get hashCode => id.hashCode;

  // Map<String, dynamic> getMap() {
  //   return {
  //     "type": "WorkoutPlan",
  //     "_id": id,
  //     "name": name,
  //     "days": days.map((e) => e.getMap()).toList()
  //   };
  // }

  Map<String, dynamic> getMap() {
    return {
      "type": "WorkoutPlan",
      "_id": id,
      "name": name,
      "days": days.map((e) => e.getMap()).toList(),
      "currentDay": currentDay
    };
  }
}

class Day {
  List<String> workoutIds = [];
  List<String> completedWorkoutIds = [];

  Day(this.workoutIds, {this.completedWorkoutIds = const []});

  Day.fromMap(Map<String, dynamic> map) {
    workoutIds = map["workoutIds"];
    completedWorkoutIds = map["completedWorkoutIds"];
  }

  bool operator ==(Object other) {
    if (other is Day && other.workoutIds.length == workoutIds.length) {
      for (int i = 0; i < workoutIds.length; i++) {
        if (workoutIds[i] != other.workoutIds[i]) {
          return false;
        }
      }
      return true;
    }
    return false;
  }

  String get id {
    return "${workoutIds.join('-')}";
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return id;
  }

  Map<String, dynamic> getMap() {
    return {
      "type": "Day",
      "_id": id,
      "workouts": workoutIds,
      "completedWorkoutIds": completedWorkoutIds,
    };
  }
}

// class Day {
//   List<Workout> workouts = [];

//   Day(this.workouts);

//   Day.fromMap(Map<String, dynamic> map, Map<String, Workout> idWorkoutMap) {
//     workouts = map["workouts"].map((e) => idWorkoutMap[e]).toList();
//   }

//   bool operator ==(Object other) {
//     if (other is Day && other.workouts.length == workouts.length) {
//       for (int i = 0; i < workouts.length; i++) {
//         if (workouts[i] != other.workouts[i]) {
//           return false;
//         }
//       }
//       return true;
//     }
//     return false;
//   }

//   String get id {
//     return "${workouts.map((e) => e.id).toList().join('-')}";
//   }

//   @override
//   int get hashCode => id.hashCode;

//   @override
//   String toString() {
//     return "${this.workouts.map((e) => e.toString()).toList().join('\n')}";
//   }

//   Map<String, dynamic> getMap() {
//     return {
//       "type": "Day",
//       "_id": id,
//       "workouts": workouts.map((e) => e.id).toList()
//     };
//   }
// }

class Workout {
  String name = "";
  List<Rep> sets = [];
  // type of progression;

  Workout(String name, List<Rep> sets) {
    this.name = name;
    this.sets = sets;
  }

  Workout.fromMap(Map<String, dynamic> map) {
    Rep repFromMap(Map<String, dynamic> map) {
      if (map["type"] == "DurationRep") {
        return DurationRep.fromMap(map);
      } else {
        return WeightRep.fromMap(map);
      }
    }

    name = map["name"];
    sets = map["sets"].map((repMap) => repFromMap(repMap)).toList();

    history = [];
    for (var r = 0; r < map["repHistory"].length; r++) {
      if (r >= history.length) {
        history.add([]);
      }
      for (var c = 0; c < map["repHistory"][r].length; c++) {
        history[r].add((map["repHistory"]));
      }
    }
    history = map["history"]
        .map((e) => e.map((repMap) => (repFromMap(repMap),)).toList())
        .toList();
  }

  @override
  bool operator ==(Object other) {
    if (other is Workout) {
      if (other.name == name && other.sets.length == sets.length) {
        for (int i = 0; i < sets.length; i++) {
          if (other.sets[i].reps != sets[i].reps) {
            return false;
          }
        }
        return true;
      }
    }
    return false;
  }

  @override
  String toString() {
    return "${name}: ${sets.length} sets of ${sets.map((e) => e.toString()).toList().join(', ')}";
  }

  String get id {
    return "${name}-${sets.map((e) => e.reps).toList().join('-')}"; // notice we leave out weight/seconds because what makes an exercise distinct is the type of lift and number of reps bench 5x5 is the same regardless of weight done
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> getMap() {
    return {
      "type": "Workout",
      "_id": id,
      "name": name,
      "sets": sets.map((e) => e.getMap()).toList(),
      "repHistory": history
          .map((e) => e.map((repTime) => repTime.$1.getMap()).toList())
          .toList(),
      "timeHistory": history
          .map((e) =>
              e.map((repTime) => repTime.$2.millisecondsSinceEpoch).toList())
          .toList()
    };
  }
}

interface class Rep {
  int _reps = 0;

  @override
  bool operator ==(Object other);

  String get id {
    return "${_reps}";
  }

  @override
  int get hashCode => id.hashCode;

  int get reps {
    return _reps;
  }

  Map<String, dynamic> getMap() {
    return Map<String, dynamic>();
  }
}

class WeightRep implements Rep {
  @override
  int _reps = 0;
  double _lbs = 0;
  final double lbsRounding = 2.5;

  final double kgRounding = 1;

  WeightRep.fromLbs(double lbs, int reps) {
    _lbs = lbs;
    _reps = reps;
  }

  WeightRep.fromKg(double kg, int reps) {
    _lbs = toLbs(kg);
    _reps = reps;
  }

  WeightRep.fromMap(Map<String, dynamic> map) {
    _reps = map["reps"];
    _lbs = map["lbs"];
  }

  @override
  bool operator ==(Object other) {
    if (other is WeightRep) {
      if (_lbs == other._lbs && (_reps == other._reps)) {
        return true;
      }
    }
    return false;
  }

  @override
  String get id {
    return "${_lbs}-${_reps}";
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return "${roundToNearest(_lbs, lbsRounding)}lbs/${roundToNearest(toKg(_lbs), kgRounding)}kg for ${_reps} reps";
  }

  double get lbs {
    return roundToNearest(_lbs, lbsRounding);
  }

  double get kg {
    return roundToNearest(toKg(_lbs), kgRounding);
  }

  @override
  int get reps {
    return _reps;
  }

  void setLbs(double lbs) {
    _lbs = lbs;
  }

  void setKg(double kg) {
    _lbs = toLbs(kg);
  }

  void setReps(int reps) {
    _reps = reps;
  }

  static double toKg(double lbs) {
    return lbs * 0.45359237;
  }

  static double toLbs(double kg) {
    return kg * 2.20462;
  }

  @override
  Map<String, dynamic> getMap() {
    return {"type": "WeightRep", "_id": id, "reps": _reps, "lbs": _lbs};
  }
}

class DurationRep implements Rep {
  @override
  int _reps = 0;
  int _seconds = 0;

  DurationRep(this._seconds, this._reps);

  DurationRep.fromMap(Map<String, dynamic> map) {
    _seconds = map["seconds"];
    _reps = map["reps"];
  }

  @override
  bool operator ==(Object other) {
    if (other is DurationRep &&
        other._seconds == _seconds &&
        other._reps == _reps) {
      return true;
    }
    return false;
  }

  @override
  String get id {
    return "${_seconds}-${_reps}";
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return "${_seconds}s for ${_reps} reps";
  }

  int get duration {
    return _seconds;
  }

  @override
  int get reps {
    return _reps;
  }

  void setReps(int reps) {
    _reps = reps;
  }

  void setDuration(int seconds) {
    _seconds = seconds;
  }

  @override
  Map<String, dynamic> getMap() {
    return {
      "type": "DurationRep",
      "_id": id,
      "reps": _reps,
      "seconds": _seconds
    };
  }
}

double roundToNearest(double number, double rounding) {
  return (number ~/ rounding) * rounding;
}
