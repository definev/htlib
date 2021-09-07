import 'package:dartz/dartz.dart';

const int _foundationYear = 1930;

class ClassUtils {
  static int firstYearOfBirth = 2003;
  static int maxClassNumber = 15;

  static String getClassNameFromYearOfBirth({
    required int yearOfBirth,
    required int classNumber,
  }) =>
      'A$classNumber-K${yearOfBirthToK(yearOfBirth)}';

  static int getYearOfBirthFromIndex(int index) => index + firstYearOfBirth;
  static int getIndexFromYearOfBirth(int yearOfBirth) => yearOfBirth - firstYearOfBirth;

  static int yearOfBirthToK(int yearOfBirth) => yearOfBirth - _foundationYear;
  static int kToYearOfBirth(int k) => k + _foundationYear;

  static Tuple2<int, int> parseClassNameToMatrix(String className) {
    try {
      List<String> data = className.split('-');
      int classNumber = int.parse(data[0].substring(1)) - 1;
      int k = int.parse(data[1].substring(1)) - 73;

      return Tuple2(k, classNumber);
    } catch (e) {
      return Tuple2(-1, -1);
    }
  }
}
