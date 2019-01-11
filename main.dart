// import 'dart:async';
import 'dart:io';
// import 'dart:convert';
import './lib/fetch.dart';

void main() async {
  File file = new File("./test.html");
  // print(file.readAsStringSync());
  var response = await fetch({
    "uri": "http://127.0.0.1:3880",
    "body": file.readAsStringSync(),
    "headers": {"contentType": ContentType.html},
    "method": "POST"
  });
  await file.writeAsString("");
  response.listen((data) {
    file.writeAsBytesSync(data, mode: FileMode.append);
  });
}
