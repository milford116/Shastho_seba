class Intermediary {
  final String id;
  final String name;
  final String mobileNo;
  final num age;
  final String sex;
  final String occupation_type;
  final String location;
  final String password;
  final String image;

  Intermediary(
      {this.id,
      this.name,
      this.mobileNo,
      this.age,
      this.sex,
      this.occupation_type,
      this.location,
      this.password,
      this.image});

  Intermediary.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        name = json['name'],
        mobileNo = json['mobile_no'],
        age=json['age'],
        image = json['image_link'].toString(),
        sex = json['sex'],
        occupation_type = json['occupation_type'],
        location= json['location'],
        password = json['password'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'mobile_no': mobileNo,
        'age': age,
        'sex': sex,
        'occupation_type': occupation_type,
        'location' : location,
        'image': image,
        'password': password
      };
}
