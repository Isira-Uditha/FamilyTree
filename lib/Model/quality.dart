//Following classes in this files including the items of multiselect widgets in add generation form and types of generations.

class Strength {
  final String id;
  final String name;

  Strength({
    required this.id,
    required this.name,
  });

  static List<Strength> strengths = [
    Strength(id: '1', name: "Responsible Roles"),
    Strength(id: '2', name: "Good Team Players"),
    Strength(id: '3', name: "Excellent Mentors"),
    Strength(id: '4', name: "Good Work-Family Balancers"),
    Strength(id: '5', name: "Best Overall Workers"),
    Strength(id: '6', name: "Quick Learners"),
    Strength(id: '7', name: "Independent Workers"),
  ];
}

class Weaknesses {
  final String id;
  final String name;

  Weaknesses({
    required this.id,
    required this.name,
  });

  static final List<Weaknesses> weaknesses = [
    Weaknesses(id: '1', name: "Non Flexible"),
    Weaknesses(id: '2', name: "Competitive"),
    Weaknesses(id: '3', name: "Least Tech Savvy"),
    Weaknesses(id: '4', name: "Not satisfied with seniors"),
    Weaknesses(id: '5', name: "Weak Overall Workers"),
    Weaknesses(id: '6', name: "Impatient"),
    Weaknesses(id: '7', name: "Weak Work Ethic"),
  ];
}

class GenerationType {
  final String name;
  int count;
  final String gifUrl;

  GenerationType(
      {required this.name, required this.count, required this.gifUrl});

  static List<GenerationType> generationTypes = [
    GenerationType(
        name: 'Baby Boomers', count: 0, gifUrl: 'assets/generation/boomer.gif'),
    GenerationType(
        name: 'Gen X', count: 0, gifUrl: 'assets/generation/genX.gif'),
    GenerationType(
        name: 'Millennial/Gen Y',
        count: 0,
        gifUrl: 'assets/generation/genY.gif'),
    GenerationType(
        name: 'Gen Z', count: 0, gifUrl: 'assets/generation/genZ.gif'),
  ];
}
