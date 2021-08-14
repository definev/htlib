import 'package:hive/hive.dart';
import 'package:htlib/src/model/hive_id.dart';

part 'admin_user.g.dart';

@HiveType(typeId: HiveId.librarianUser)
class AdminUser {
  @HiveField(0)
  final String uid;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String email;
  @HiveField(3)
  final String phone;
  @HiveField(4)
  final String? imageUrl;
  @HiveField(5)
  final String? className;
  @HiveField(6)
  final int? memberNumber;
  @HiveField(7)
  final AdminType adminType;

  AdminUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.adminType,
    this.className,
    this.memberNumber,
    this.imageUrl,
  });

  AdminUser copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? className,
    String? imageUrl,
    int? memberNumber,
  }) =>
      AdminUser(
        uid: id ?? this.uid,
        name: name ?? this.name,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        adminType: adminType,
        imageUrl: imageUrl ?? this.imageUrl,
        className: className ?? this.className,
        memberNumber: memberNumber ?? this.memberNumber,
      );

  Map<String, dynamic> toJson() => {
        'id': uid,
        'name': name,
        'email': email,
        'phone': phone,
        'imageUrl': imageUrl,
        'adminType': adminType.toString(),
        'className': className,
        'memberNumber': memberNumber,
      };

  factory AdminUser.fromJson(Map<String, dynamic> json) {
    return AdminUser(
      uid: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      imageUrl: json['imageUrl'],
      adminType: _typeMap[json['adminType']]!,
      className: json['className'],
      memberNumber: json['memberNumber'],
    );
  }
}

@HiveType(typeId: HiveId.adminType)
enum AdminType {
  @HiveField(0)
  librarian,
  @HiveField(1)
  mornitor,
}

final Map<String, AdminType> _typeMap = {
  'AdminType.librarian': AdminType.librarian,
  'AdminType.mornitor': AdminType.mornitor,
};
