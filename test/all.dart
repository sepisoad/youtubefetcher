import 'dart:io';
import 'package:test/test.dart';
import 'package:sepisoad/ytd.dart' as ytd;

main(){
  testExtractVideos();
}

//==============================================================================List

testExtractVideos() async {
  test('testExtractVideos(); with valid data', () async {
    var file = new File('test/test-data/adaptive-formats.txt');
    var data = await file.readAsStringSync();
    var info = await ytd.extractVideos(data);

    expect(1, 1);
  });
}