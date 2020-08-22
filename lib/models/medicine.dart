class Medicine {
  final String name;
  final String dose;
  final String day;

  Medicine({this.name, this.day, this.dose});

  Medicine.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        dose = json['dose'],
        day = json['day'];
}
