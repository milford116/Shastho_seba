class Patient {
  final String id;
  final String name;
  final String mobileNo;
  final DateTime dob;
  final String sex;
  // final String password;
  final String image;
  final String patient_token;

  Patient(
      {this.id,
      this.name,
      this.mobileNo,
      this.dob,
      this.sex,
      // this.password,
      this.image,
      this.patient_token
      });

  Patient.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        name = json['name'],
        mobileNo = json['mobile_no'],
        dob = DateTime.parse(json['date_of_birth']),
        image = json['image_link'].toString(),
        sex = json['sex'],
        patient_token = json['patient_token'];
        // password = json['password'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'mobile_no': mobileNo,
        'date_of_birth': dob.toString(),
        'sex': sex,
        'image': image,
         'patient_token':patient_token,
        // 'password': password
      };
}
