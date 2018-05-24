class Format {
  String url;
  String quality;
  String type;
  String itag;
}

//==============================================================================

class AdaptiveFormat {
  String init;
  String clen;
  String type;
  String projectionType;
  String url;
  String itag;
  String index;
  String fps;
  String lmt;
  String size;
  String bitrate;
  String qualityLabel;
  String xtags;
}

//==============================================================================
/// Info type
class Info {
  num timestamp;
  String title;
  String author;
  String id;
  String thumbnail;
  String length;
  List<Format> formats;
  List<AdaptiveFormat> adaptiveFormats;
}
