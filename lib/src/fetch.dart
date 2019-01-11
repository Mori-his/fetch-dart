import './request.dart';

Future fetch(dynamic input, [String method = "GET", Function callback]) {
  Request request = new Request(input, method, callback);
  if ((input['method'] ?? method).toUpperCase() == "POST") {
    return request.post();
  }
  return request.get();
}
