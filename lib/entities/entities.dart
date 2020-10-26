class Registered {
  final int Id;
  final String Password;

  Registered(this.Id, this.Password);

  factory Registered.fromJson(Map<String, dynamic> json) {
    return Registered(json['Id'], json['Password']);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'Id': Id, 'Password': Password};
  }
}

class Admin {
  String Email;
  String Name;
  String Phone;

  Admin(this.Email, this.Name, this.Phone);

  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(json['Email'], json['Name'], json['Phone']);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'Email': Email, 'Name': Name, 'Phone': Phone};
  }
}

class Degree {
  final int Id;
  final String Name;
  final List<int> Student_Ids;

  Degree(this.Id, this.Name, this.Student_Ids);

  factory Degree.fromJson(Map<String, dynamic> json) {
    return Degree(json['Id'], json['Name'], json['Student Ids'].cast<int>());
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'Id': Id, 'Name': Name, 'Student Ids': Student_Ids};
  }
}

class Course {
  final int Id;
  final String Name;
  final int Faculty_Id;
  final int Credits;
  final int Seats;
  final List<int> Student_Ids;

  Course(this.Id, this.Name, this.Faculty_Id, this.Credits, this.Seats, this.Student_Ids);

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(json['Id'], json['Name'], json['Faculty Id'], json['Credits'], json['Seats'], json['Student Ids'].cast<int>());
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'Id': Id, 'Name': Name, 'Faculty Id': Faculty_Id, 'Credits': Credits, 'Seats': Seats, 'Student Ids': Student_Ids};
  }
}

class Student {
  int Id;
  String Name;
  String Email;
  String Phone;

  Student(this.Id, this.Name, this.Email, this.Phone);

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(json['Id'], json['Name'], json['Email'], json['Phone']);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'Id': Id, 'Name': Name, 'Email': Email, 'Phone': Phone};
  }
}

class Faculty {
  int Id;
  String Name;
  String Email;
  String Phone;

  Faculty(this.Id, this.Name, this.Email, this.Phone);

  factory Faculty.fromJson(Map<String, dynamic> json) {
    return Faculty(json['Id'], json['Name'], json['Email'], json['Phone']);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'Id': Id, 'Name': Name, 'Email': Email, 'Phone': Phone};
  }
}
