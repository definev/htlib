/// Use this ext for entities
extension EntitiesExt on dynamic {
  Map<String, dynamic> haveNullValue() {
    var map = this.toJson();
    for (int i = 0; i < map.values.length; i++) {
      if (map.values.elementAt(i) == null)
        return {
          "isNull": true,
          "nullField": map.key.elementAt(i),
        };
    }
    return {
      "isNull": false,
      "nullField": "no field null",
    };
  }
}
