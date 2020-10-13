class StudentIds{
  dynamic Ids;

  StudentIds(this.Ids);

  factory StudentIds.fromJson(dynamic json){
    return StudentIds(
      json['Student Ids']
    );
  }
}


class Degree{
  final dynamic Id;
  final dynamic Name;

  Degree(this.Id,this.Name);

  factory Degree.fromJson(Map<String,dynamic> json){
    return Degree(
        json['Id'],
        json['Name'],
    );
  }

  Map<String,dynamic> toMap(){
    return<String,dynamic>{
      'Id' : Id,
      'Name' : Name
    };
  }

  String getName(){
    return Name.toString();
  }
}

class Course{
  final dynamic Id;
  final dynamic Name;
  final dynamic Faculty_Id;
  final dynamic Credits;
  final dynamic Seats;

  Course(this.Id,this.Name,this.Faculty_Id,this.Credits,this.Seats);

  factory Course.fromJson(Map<String,dynamic> json){
    return Course(
        json['Id'],
        json['Name'],
        json['Faculty Id'],
        json['Credits'],
        json['Seats']
    );
  }

  Map<String,dynamic> toMap(){
    return<String,dynamic>{
      'Id' : Id,
      'Name' : Name,
      'Faculty Id' : Faculty_Id,
      'Credits' : Credits,
      'Seats' : Seats
    };
  }

  String getName(){
    return Name.toString();
  }
}

