class WorkoutEngine {
  static const int daysInCycle = 100;
  static const int daysPerRotation = 4;

  static WorkoutType getWorkoutType(int day) {
    final rotationIndex = (day - 1) % daysPerRotation;
    switch (rotationIndex) {
      case 0:
        return WorkoutType.armor;
      case 1:
        return WorkoutType.foundation;
      case 2:
        return WorkoutType.shred;
      case 3:
        return WorkoutType.recovery;
      default:
        return WorkoutType.recovery;
    }
  }

  // --- Phase Progression Logic ---

  static WorkoutPhase getPhase(int day) {
    if (day <= 25) return WorkoutPhase.volume;
    if (day <= 50) return WorkoutPhase.intensity;
    if (day <= 75) return WorkoutPhase.tempo;
    return WorkoutPhase.mastery;
  }

  // --- Exercise Data ---

  static List<Exercise> getExercisesForDay(
    int day,
    Map<String, int> userBaseline,
  ) {
    final type = getWorkoutType(day);
    final rotation = (day - 1) ~/ daysPerRotation;

    if (type == WorkoutType.recovery) return [];

    List<Exercise> baseExercises;

    switch (type) {
      case WorkoutType.armor:
        baseExercises = [
          Exercise(
            name: 'Pike Push-ups',
            sets: 3,
            baseReps: 10,
            description: 'Shoulder width',
            instructions:
                'Place hands shoulder-width apart, elevate hips into a V-shape. Lower your head towards the floor between your hands, then push back up. Focus on your shoulders.',
          ),
          Exercise(
            name: 'Standard Push-ups',
            sets: 3,
            baseReps: 15,
            instructions:
                'Keep your body in a straight line from head to heels. Lower chest to the floor and push back up explosively.',
          ),
          Exercise(
            name: 'Wide Push-ups',
            sets: 3,
            baseReps: 12,
            description: 'Targets outer chest',
            instructions:
                'Place hands wider than shoulder-width. This emphasizes the outer pectoral muscles and reduces triceps involvement.',
          ),
          Exercise(
            name: 'Diamond Push-ups',
            sets: 3,
            baseReps: 10,
            description: 'Inner chest/triceps',
            instructions:
                'Place hands together under your chest, forming a diamond shape with your index fingers and thumbs. Focus on squeezing your triceps.',
          ),
          Exercise(
            name: 'Decline Push-ups',
            sets: 3,
            baseReps: 12,
            description: 'Feet on bed/chair',
            instructions:
                'Elevate your feet on a stable surface. This shifts the weight to your upper chest and front delts.',
          ),
          Exercise(
            name: 'Plank-to-Pushups',
            sets: 3,
            baseReps: 10,
            description: 'Shoulder stability',
            instructions:
                'Start in a forearm plank. Push up one hand at a time into a high plank, then lower back down. Minimize hip swaying.',
          ),
          Exercise(
            name: 'Pseudo-Planche Hold',
            sets: 3,
            baseReps: 30,
            isHold: true,
            instructions:
                'In a high plank, lean your body forward so your shoulders are ahead of your wrists. Turn hands slightly outward. Hold for time.',
          ),
        ];
        break;
      case WorkoutType.foundation:
        baseExercises = [
          Exercise(
            name: 'Air Squats',
            sets: 3,
            baseReps: 25,
            instructions:
                'Feet shoulder-width apart. Sit back and down as if into a chair. Keep your chest up and heels on the ground.',
          ),
          Exercise(
            name: 'Forward Lunges',
            sets: 3,
            baseReps: 15,
            description: 'Per leg',
            instructions:
                'Step forward and lower your back knee towards the ground. Both knees should form 90-degree angles. Push back to start.',
          ),
          Exercise(
            name: 'Bulgarian Split Squats',
            sets: 3,
            baseReps: 12,
            description: 'Per leg',
            instructions:
                'Place one foot behind you on an elevated surface. Squat down with the front leg. Maintain a vertical shin.',
          ),
          Exercise(
            name: 'Glute Bridges',
            sets: 3,
            baseReps: 20,
            description: 'Squeeze at the top',
            instructions:
                'Lie on your back with knees bent and feet flat. Lift your hips toward the ceiling, squeezing your glutes hard at the top.',
          ),
          Exercise(
            name: 'Single-Leg Calf Raises',
            sets: 3,
            baseReps: 20,
            description: 'Per leg',
            instructions:
                'Stand on one leg (hold something for balance). Rise up onto your toes, pause, and lower slowly.',
          ),
          Exercise(
            name: 'Sumo Squats',
            sets: 3,
            baseReps: 20,
            description: 'Wide stance',
            instructions:
                'Take a very wide stance with toes pointed outwards. Squat down, focusing on the inner thighs and glutes.',
          ),
          Exercise(
            name: 'Wall Sit',
            sets: 3,
            baseReps: 45,
            isHold: true,
            instructions:
                'Lean against a wall with thighs parallel to the ground. Hold this position, focusing on quadriceps endurance.',
          ),
        ];
        break;
      case WorkoutType.shred:
        baseExercises = [
          Exercise(
            name: 'Supermans',
            sets: 3,
            baseReps: 15,
            description: 'Lower back/Shoulder blades',
            instructions:
                'Lie face down. Simultaneously lift your arms, chest, and legs off the floor. Pause at the top and lower with control.',
          ),
          Exercise(
            name: 'Floor Pulls',
            sets: 3,
            baseReps: 12,
            description: 'Pull body forward using lats',
            instructions:
                'Lie face down on a smooth floor. Reach forward, dig your palms/forearms into the floor, and pull your torso forward using your lats.',
          ),
          Exercise(
            name: 'Leg Raises',
            sets: 3,
            baseReps: 15,
            description: 'Lower abs',
            instructions:
                'Lie on your back. Keep legs straight and lift them until they are vertical. Lower them slowly without touching the floor.',
          ),
          Exercise(
            name: 'Hollow Body Hold',
            sets: 3,
            baseReps: 45,
            isHold: true,
            instructions:
                'Lie on your back. Lift shoulders and legs slightly off the floor. Press your lower back firmly into the ground. Hold.',
          ),
          Exercise(
            name: 'Bicycle Crunches',
            sets: 3,
            baseReps: 20,
            description: 'Per side',
            instructions:
                'Bring your opposite elbow to opposite knee while cycling your legs. Focus on rotation and oblique engagement.',
          ),
          Exercise(
            name: 'Russian Twists',
            sets: 3,
            baseReps: 30,
            description: 'Obliques',
            instructions:
                'Sit with knees bent and feet slightly off the floor. Rotate your torso from side to side, touching the floor with your hands.',
          ),
          Exercise(
            name: 'Mountain Climbers',
            sets: 3,
            baseReps: 60,
            isHold: true,
            description: 'Cardio burn',
            instructions:
                'In a high plank, explosively bring knees toward your chest. Keep your core tight and maintain a rapid pace.',
          ),
        ];
        break;
      default:
        baseExercises = [];
    }

    return baseExercises.map((e) {
      int sets = e.sets;
      int reps = e.baseReps;
      String name = e.name;

      if (day <= 25) {
        if (!e.isHold) {
          reps += (rotation * 2);
        } else {
          reps += (rotation * 5);
        }
      } else if (day <= 50) {
        sets += 1;
        reps += (6 * 2);
      } else if (day <= 75) {
        sets += 1;
        reps += (6 * 2);
      } else if (day <= 100) {
        sets += 1;
        reps += (6 * 2);
        name = _getExplosiveVariation(name);
      }

      return e.copyWith(sets: sets, baseReps: reps, name: name);
    }).toList();
  }

  static String _getExplosiveVariation(String originalName) {
    if (originalName.contains('Push-ups')) return 'Clapping $originalName';
    if (originalName.contains('Squats')) return 'Jump $originalName';
    if (originalName.contains('Lunges')) return 'Switch $originalName';
    return 'Explosive $originalName';
  }

  static Duration getRestDuration(int day) {
    final phase = getPhase(day);
    if (phase == WorkoutPhase.volume) return const Duration(seconds: 60);
    return const Duration(seconds: 30);
  }

  static String? getTempo(int day) {
    final phase = getPhase(day);
    if (phase == WorkoutPhase.tempo) {
      return "4 : 1 : 1 (Descent : Pause : Explode)";
    }
    return null;
  }
}

class Exercise {
  final String name;
  final int sets;
  final int baseReps;
  final String? description;
  final String instructions;
  final bool isHold;

  Exercise({
    required this.name,
    required this.sets,
    required this.baseReps,
    this.description,
    this.instructions = 'Follow the visual guide and maintain proper form.',
    this.isHold = false,
  });

  Exercise copyWith({
    String? name,
    int? sets,
    int? baseReps,
    String? description,
    String? instructions,
    bool? isHold,
  }) {
    return Exercise(
      name: name ?? this.name,
      sets: sets ?? this.sets,
      baseReps: baseReps ?? this.baseReps,
      description: description ?? this.description,
      instructions: instructions ?? this.instructions,
      isHold: isHold ?? this.isHold,
    );
  }
}

enum WorkoutType { armor, foundation, shred, recovery }

enum WorkoutPhase { volume, intensity, tempo, mastery }

extension WorkoutTypeExt on WorkoutType {
  String get label {
    switch (this) {
      case WorkoutType.armor:
        return "CHEST & SHOULDERS";
      case WorkoutType.foundation:
        return "LEGS & GLUTES";
      case WorkoutType.shred:
        return "BACK & CORE";
      case WorkoutType.recovery:
        return "RECOVERY";
    }
  }
}
