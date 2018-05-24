import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';
import 'package:sepisoad/ytd.dart';

//==============================================================================

void argHelp(bool val) {
  if (val) {
    print('this is a simple help');
    exit(0);
  }
}

//==============================================================================

void argVersion(bool val) {
  if (val) {
    print('version: ${version()}');
    exit(0);
  }
}

//==============================================================================

Future main(List<String> args) async {
  var argParser = new ArgParser();

  argParser.addFlag('help',
      abbr: 'h', help: 'print this help', callback: argHelp);
  argParser.addFlag('version',
      abbr: 'v', help: 'print version', callback: argVersion);
  argParser.addOption('address',
      abbr: 'a', help: 'this switch defines the address of remote file');

  var opt = argParser.parse(args);
  if (opt['address'] == null) {
    print('please set the address of the media');
    exit(0);
  }

  Info info;
  try {
    info = await getVideoInfo(opt['address']);
  } catch (e) {
    print(e);
    exit(1);
  }

  print('Video Title:\n  ' + info.title);
  print('Video Author:\n  ' + info.author);
  print('Video ID:\n  ' + info.id);
  print('Video Thumbnail:\n  ' + info.thumbnail);
  print('Available Formats:');
  info.adaptiveFormats.forEach((format) {
    print(' type: ${format.type ?? ''}');
    print(' size: ${format.size ?? ''}');
    print(' quality: ${format.qualityLabel ?? ''}');
    print(' url: ${format.url ?? ''}');
  });
}
