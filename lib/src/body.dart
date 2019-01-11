import 'dart:io';
import 'dart:convert';
import './header.dart';

/**
 * Body 类 根据 请求内容类型 返回不同的数据
 */
class Body {
  dynamic _body;
  ContentType contentType;
  Body(body, {Header headers}) {
    this._body = body;
    contentType = headers.contentType is String
        ? ContentType.parse(headers.contentType)
        : headers.contentType;
  }
  void forEach(Function fn) {
    this._body.forEach(fn);
  }

  void add(dynamic value, {String name = ''}) {
    if (_body is List) {
      _body.add(value);
    } else if (_body is Map) {
      addAll({name: value});
    }
  }

  void addAll(objects) {
    if (!(_body is List && objects is Iterable)) {
      return;
    } else if (!(_body is Map && objects is Map)) {
      return;
    }
    _body.addAll(objects);
  }

  dynamic get content {
    if (contentType == ContentType.json) {
      return json.encode(_body);
    } else if (contentType == ContentType.html ||
        contentType == ContentType.text) {
      return toString();
    } else if (contentType == ContentType.binary) {
      return toBinary();
    } else {
      return _body;
    }
  }

  int get length {
    return this._body.length;
  }

  void write(HttpClientRequest request) {}

  /// 首先 _body -> String toString -> List codeUnits -> List<String> List.Map -> toRadisString(radix: 2)
  /// radix 是基数
  /// 例子
  /// List<int> "l".codeUnits ->> 108
  /// [108].map((int item) => item.toRadisString(2))  ->> ["1101100"] 二进制结果 逢2进1
  /// [108].map((int item) => item.toRadisString(3))  ->> ["11000"] 三进制结果  逢3进1
  /// [108].map((int item) => item.toRadisString(16)) ->> ["6c"] 十六进制 逢16进1
  /// 以此类推
  Iterable<String> toBinary() {
    return _body.toString().codeUnits.map((int itme) => itme.toRadixString(2));
  }

  String toString() => _body.toString();
}
