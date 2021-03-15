class RESTUtils {
  static String encodeParams(Map<String, String> params) {
    var s = "";
    params.forEach((key, value) {
      // ignore: unnecessary_null_comparison
      if (value != null && value != "null") {
        var urlEncode = Uri.encodeFull(value);
        s += "&$key=$urlEncode";
      }
    });
    return s;
  }
}
