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
  final String? imageUrl;
  @HiveField(5)
  final String? className;
  @HiveField(6)
  final int? memberNumber;
  @HiveField(7)
  final AdminType adminType;
  @HiveField(8)
  final int? activeMemberNumber;

  const AdminUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.adminType,
    this.className,
    this.memberNumber,
    this.activeMemberNumber,
    this.imageUrl,
  });

  static AdminUser loading() => AdminUser(
        uid: 'uid',
        name: 'name',
        email: 'email',
        phone: 'phone',
        adminType: AdminType.tester,
      );

  AdminUser mornitorCopyWith({
    String? phone,
    int? activeMemberNumber,
  }) {
    if (adminType == AdminType.librarian) return this;
    return copyWith(activeMemberNumber: activeMemberNumber, phone: phone);
  }

  AdminUser copyWith({
    String? uid,
    String? name,
    String? email,
    String? phone,
    String? className,
    String? imageUrl,
    int? activeMemberNumber,
    int? memberNumber,
  }) =>
      AdminUser(
        uid: uid ?? this.uid,
        name: name ?? this.name,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        adminType: adminType,
        imageUrl: imageUrl ?? this.imageUrl,
        className: className ?? this.className,
        memberNumber: memberNumber ?? this.memberNumber,
        activeMemberNumber: activeMemberNumber ?? this.activeMemberNumber,
      );

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'name': name,
        'email': email,
        'phone': phone,
        'imageUrl': imageUrl,
        'adminType': adminType.toString(),
        'className': className,
        'memberNumber': memberNumber,
        'activeMemberNumber': activeMemberNumber,
      };

  factory AdminUser.fromJson(Map<String, dynamic> json) => AdminUser(
        uid: json['uid'],
        name: json['name'],
        email: json['email'],
        phone: json['phone'],
        imageUrl: json['imageUrl'],
        adminType: _typeMap[json['adminType']]!,
        className: json['className'],
        memberNumber: json['memberNumber'],
        activeMemberNumber: json['activeMemberNumber'],
      );
}

@HiveType(typeId: HiveId.adminType)
enum AdminType {
  @HiveField(0)
  librarian,
  @HiveField(1)
  mornitor,
  @HiveField(2)
  tester,
}

final Map<String, AdminType> _typeMap = {
  'AdminType.librarian': AdminType.librarian,
  'AdminType.mornitor': AdminType.mornitor,
  'AdminType.tester': AdminType.tester,
};
