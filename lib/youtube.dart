import 'dart:async';
import 'package:http/http.dart' as http;
import './defs.dart';

const _version = '0.1';

//==============================================================================

version() {
  return _version;
}

//==============================================================================

Future<Info> getVideoInfo(String url) async {
  var id = getVideoId(url);
  if (id == null) throw new Exception('the url is invalid');

  try {
    var info = await fetchVideoInfo(id);
    if (info == null) throw new Exception('failed to get video info');
    return info;
  } catch (e) {
    throw e;
  }
}

//==============================================================================

String getVideoId(String url) {
  var re = new RegExp(r'(https:\/\/www\.youtube\.com\/watch\?)(.*)');
  var match = re.firstMatch(url);

  if (match == null) return null;
  var rawQuery = match.group(2);
  var queries = rawQuery.split('&');

  var id = (() {
    for (var query in queries) {
      var kv = query.split('=');
      if (kv[0] == 'v') {
        return kv[1];
      }
    }
    return null;
  })();

  return id;
}

//==============================================================================

Future<Info> fetchVideoInfo(String id) async {
  const baseInfoUrl = 'http://youtube.com/get_video_info?video_id=';
  var infoUrl = baseInfoUrl + id;

  var response = await http.get(infoUrl);
  if (response.statusCode != 200) {
    return null;
  }
  if (response.contentLength <= 0) {
    return null;
  }

  try {
    return parseVideoInfo(response.body);
  } catch (e) {
    throw e;
  }
}

//==============================================================================

Future<Info> parseVideoInfo(String body) async {
  var map = new Map();
  var dataList = body.split('&');

  if (dataList.length <= 1) {
    return null;
  }

  for (var data in dataList) {
    var kv = data.split('=');
    map[kv[0]] = kv[1];
  }

  if (map.length <= 0) {
    return null;
  }

  try {
    var info = new Info();

    info.timestamp = num.tryParse(map['timestamp']);
    info.title = Uri.decodeQueryComponent(map['title']);
    info.author = Uri.decodeQueryComponent(map['author']);
    info.id = map['video_id'];
    info.thumbnail = Uri.decodeComponent(map['thumbnail_url']);
    info.length = map['length_seconds'];

    info.formats = extractFormats(map['url_encoded_fmt_stream_map']);
    info.adaptiveFormats = extractAdaptiveFormats(map['adaptive_fmts']);

    return info;
  } catch (e) {
    throw e;
  }
}

//==============================================================================

List<Format> extractFormats(String input) {
  if (input == null || input == '') {
    return null;
  }

  var decodedInput = Uri.decodeComponent(input);
  var rgx = new RegExp('([^,?\&]+)');
  var matches = rgx.allMatches(decodedInput);

  var format = new Format();
  var formats = new List<Format>();
  var queryKeys = new Map();

  matches.forEach((match) {
    var val = match.group(1);
    var kv = val.split('=');

    if (queryKeys.containsKey(kv[0])) {
      formats.add(format);
      format = new Format();
      queryKeys.clear();
    } else {
      queryKeys[kv[0]] = true;
    }

    switch (kv[0]) {
      case 'quality':
        format.quality = kv[1];
        break;
      case 'itag':
        format.itag = kv[1];
        break;
      case 'type':
        format.type = Uri.decodeComponent(kv[1]);
        break;
      case 'url':
        format.url = Uri.decodeComponent(kv[1]);
        break;
      default:
        break;
    }
  });

  return formats;
}

//==============================================================================

List<AdaptiveFormat> extractAdaptiveFormats(String input) {
  if (input == null || input == '') {
    return null;
  }

  var decodedInput = Uri.decodeComponent(input);
  var rgx = new RegExp('([^,?\&]+)');
  var matches = rgx.allMatches(decodedInput);

  var format = new AdaptiveFormat();
  var formats = new List<AdaptiveFormat>();
  var queryKeys = new Map();

  matches.forEach((match) {
    var val = match.group(1);
    var kv = val.split('=');

    if (queryKeys.containsKey(kv[0])) {
      formats.add(format);
      format = new AdaptiveFormat();
      queryKeys.clear();
    } else {
      queryKeys[kv[0]] = true;
    }

    switch (kv[0]) {
      case 'init':
        format.init = kv[1];
        break;
      case 'clen':
        format.clen = kv[1];
        break;
      case 'type':
        format.type = Uri.decodeComponent(kv[1]);
        break;
      case 'projection_type':
        format.projectionType = kv[1];
        break;
      case 'url':
        format.url = Uri.decodeComponent(kv[1]);
        break;
      case 'itag':
        format.itag = kv[1];
        break;
      case 'index':
        format.index = kv[1];
        break;
      case 'fps':
        format.fps = kv[1];
        break;
      case 'lmt':
        format.lmt = kv[1];
        break;
      case 'size':
        format.size = kv[1];
        break;
      case 'bitrate':
        format.bitrate = kv[1];
        break;
      case 'quality_label':
        format.qualityLabel = kv[1];
        break;
      case 'xtags':
        format.xtags = kv[1];
        break;
      default:
        break;
    }
  });

  return formats;
}
