import 'package:hive/hive.dart';
import 'package:htlib/src/model/hive_id.dart';

part 'admin_user.g.dart';

@HiveType(typeId: HiveId.adminUser)
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
  final AdminType type;

  AdminUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.type,
  });

  AdminUser copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    AdminType? type,
  }) =>
      AdminUser(
        uid: id ?? this.uid,
        name: name ?? this.name,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        type: type ?? this.type,
      );

  Map<String, dynamic> toJson() => {
        'id': uid,
        'name': name,
        'email': email,
        'phone': phone,
        'type': type.toString(),
      };

  factory AdminUser.fromJson(Map<String, dynamic> json) {
    return AdminUser(
      uid: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      type: _AdminTypeMap[json['type']] ?? AdminType.mornitor,
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

Map<String, AdminType> _AdminTypeMap = {
  'AdminType.librarian': AdminType.librarian,
  'AdminType.mornitor': AdminType.mornitor,
};
