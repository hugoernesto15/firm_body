class MuscleBrain {
  Map<String, List<String>> muscleGroup = {
    'Chest': ['Flat Bench Press', 'Inclined Bench Press', 'Flyers'],
    'Upper back': [
      'Lateral Pull Down',
      'Back Lateral Pull Down',
      'Supine Narrow Pull Down'
    ],
    'Lower Back': ['Dead Lift'],
    'Shoulder': ['Military Press', 'Back Military Press', 'Lateral Raises'],
    'Biceps': ['Concentration Curl', 'Bar Curl', 'Reverse Curl'],
    'Triceps': ['Scull Crusher', 'Dumbell Kickbcack'],
    'Forearm': ['Forearm exercise'],
    'Legs': ['Squad']
  };

  List<String> exerciseType = [
    'Olympic Bar + (each side)',
    'Regular Bar + (each side)',
    'Dumbbell',
    'Puller'
  ];

  List<String> unit = ['lb', 'Kg'];
}
