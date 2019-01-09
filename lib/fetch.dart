library Fetch;

import 'dart:io';
import 'dart:convert';

class Request {
  Uri url;
  Header header;
  Body body;
  Request(this.url, this.header, this.body);
  get() {}
  post() {}
}

class Header {
  Map<String, dynamic> _headers = {};
  Header(Map<String, dynamic> headers) {
    if (!(headers["uri"] is Uri)) {
      throw new TypeError();
    }
    this._headers = headers;
  }
  /**
   * 添加指定key
   */
  add(String key, dynamic value) {
    this._headers[key] = value;
    return this;
  }

  /**
   * 删除指定key
   */
  remove(String key) {
    this._headers.remove(key);
    return this;
  }
}

/**
 * 
 */
class Body {}

/// 处理代理
void handleProxy(HttpClient client, String proxy) {
  client.findProxy = (url) {
    if (url.scheme == "https") {
      return HttpClient.findProxyFromEnvironment(url,
          environment: {"https_proxy": proxy});
    }
    return HttpClient.findProxyFromEnvironment(url,
        environment: {"http_proxy": proxy});
  };
}

class Fetch {
  dynamic input;
  Function calback = () {};
  Fetch(dynamic input,
      [String uri, String url, String method = "GET", Function callback]) {
    if (input is Map) {
      final Header headers = new Header(input);
      return;
    } else if (input is String) {
      Map<String, dynamic> _headers = {"uri": Uri.parse(input)};
      Header headers = new Header(_headers);
    }
  }
}
