enum UserRole { doctor, patient }

class AppUser {
  final String? id;
  final String email;
  final UserRole role;
  final List<DateTime>? timeSlots;

  AppUser({
    this.id,
    required this.email,
    required this.role,
    this.timeSlots,
  });

  // factory UserProfile.fromDocumentSnapshot(
  //         DocumentSnapshot<Map<String, dynamic>> doc) =>
  //     UserProfile(
  //       id: doc.id,
  //       email: doc.data()!['email'],
  //       role: doc.data()!['role'],
  //     );

  factory AppUser.fromMap(Map<dynamic, dynamic> map, String id) {
    return AppUser(
      id: id,
      email: map['email'],
      role: UserRole.values.byName(map['role']),
      timeSlots: map['timeSlots'] is Iterable
          ? map['timeSlots']
              .map((value) => DateTime.fromMillisecondsSinceEpoch(value as int))
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'role': role.name,
      if (timeSlots != null) 'timeSlots': timeSlots,
    };
  }

  static List<DateTime> getDefaultTimeSlots() => [
        DateTime(2023, 9, 1, 10),
        DateTime(2023, 9, 1, 12),
        DateTime(2023, 9, 1, 16),
        DateTime(2023, 9, 3, 11),
        DateTime(2023, 9, 3, 13),
        DateTime(2023, 9, 7, 10),
        DateTime(2023, 9, 7, 11),
        DateTime(2023, 9, 7, 15),
        DateTime(2023, 9, 9, 10),
        DateTime(2023, 9, 9, 16),
        DateTime(2023, 9, 11, 13),
        DateTime(2023, 9, 11, 14),
        DateTime(2023, 9, 11, 15),
        DateTime(2023, 9, 11, 16),
        DateTime(2023, 9, 11, 17),
      ];
}
