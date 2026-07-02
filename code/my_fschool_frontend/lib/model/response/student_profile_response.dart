import 'package:dart_mappable/dart_mappable.dart';

import 'attendance_response.dart';
import 'class_response.dart';
import 'club_response.dart';

part 'student_profile_response.mapper.dart';

@MappableClass(generateMethods: GenerateMethods.decode)
class StudentProfileResponse with StudentProfileResponseMappable {
  String id;
  String studentCode;
  String fullName;
  DateTime dateOfBirth;
  String gender;
  String? avatarUrl;
  ClassResponse? currentClass;
  AttendanceResponse? todayAttendance;
  ClubResponse? joinedClub;

  StudentProfileResponse({
    required this.id,
    required this.studentCode,
    required this.fullName,
    required this.dateOfBirth,
    required this.gender,
    this.avatarUrl,
    this.currentClass,
    this.todayAttendance,
    this.joinedClub,
  });

  factory StudentProfileResponse.fromJson(String json) =>
      StudentProfileResponseMapper.fromJson(json);

  factory StudentProfileResponse.fromMap(Map<String, dynamic> map) =>
      StudentProfileResponseMapper.fromMap(map);
}
