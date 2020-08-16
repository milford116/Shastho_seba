class Doctor {
  final String name;
  final String email;
  final String mobileNo;
  final String institution;
  final List<String> specialization;
  final String designation;
  final String registrationNo;
  final String referrer;
  final String about_me;

  Doctor({
    this.name,
    this.email,
    this.mobileNo,
    this.institution,
    this.specialization,
    this.designation,
    this.registrationNo,
    this.referrer,
    this.about_me,
  });

  Doctor.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        mobileNo = json['mobile_no'],
        email = json['email'],
        designation = json['designation'],
        institution = json['institution'],
        specialization = json['specialization'].cast<String>(),
        referrer = json['referrer'],
        registrationNo = json['reg_number'],
        about_me = json['about_me'];
}
