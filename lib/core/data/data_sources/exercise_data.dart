class Exercise {
  final String id;
  final String name;
  final String target;
  final int baseReps;
  final String gifUrl;

  const Exercise({
    required this.id,
    required this.name,
    required this.target,
    required this.baseReps,
    required this.gifUrl,
  });
}

class ExerciseData {
  static const List<Exercise> armorDay = [
    Exercise(
      id: 'pushup_1',
      name: 'Diamond Pushups',
      target: 'Inner Chest/Tri',
      baseReps: 12,
      gifUrl: '',
    ),
    Exercise(
      id: 'pike_1',
      name: 'Pike Pushups',
      target: 'Shoulders',
      baseReps: 10,
      gifUrl: '',
    ),
  ];

  static const List<Exercise> foundationDay = [
    Exercise(
      id: 'squat_1',
      name: 'Prisoner Squats',
      target: 'Quads/Glutes',
      baseReps: 20,
      gifUrl: '',
    ),
    Exercise(
      id: 'lunge_1',
      name: 'Explosive Lunges',
      target: 'Leg Power',
      baseReps: 12,
      gifUrl: '',
    ),
  ];

  static const List<Exercise> shredDay = [
    Exercise(
      id: 'pullup_1',
      name: 'Pullups (or Australain)',
      target: 'Back',
      baseReps: 8,
      gifUrl: '',
    ),
    Exercise(
      id: 'legraise_1',
      name: 'Hanging Leg Raises',
      target: 'Core',
      baseReps: 15,
      gifUrl: '',
    ),
  ];
}
