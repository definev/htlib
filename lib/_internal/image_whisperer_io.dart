import "package:universal_html/html.dart";

abstract class BaseImage {
  BaseImage([this.name]);

  String? name;
}

class BlobImage extends BaseImage {
  BlobImage(this.blob, {String? name}) : super(name) {
    if (blob is File && name == null) name = (blob as File).name;
  }

  /// Returns a blob URL, so the image can be displayed in an `<img>` tag.
  ///
  /// The blob URL is accessible until release or until the document is
  /// destroyed (that is close or reload).
  String? get url {
    if (_url == null) _url = Url.createObjectUrlFromBlob(blob!);
    return _url;
  }

  /// Releases the allocated blob URLs.
  ///
  /// Does nothing if there was no URL allocated for this `BlobImage`.
  void releaseUrl() {
    if (_url != null) {
      Url.revokeObjectUrl(_url!);
      _url = null;
    }
  }

  final Blob? blob;
  String? _url;
}
