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
  Map<String, dynamic> _headers = new Map();
  Header(Map<String, dynamic> headers) {
    if (headers.length > 0) {
      if (headers["uri"]) {
        // new Error
      }
    }
  }
  /**
   * 添加指定key
   */
  add(String key, dynamic value) {
    this._headers[key] = value;
  }

  /**
   * 删除指定key
   */
  remove(String key) {
    this._headers.remove(key);
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
      Header headers = new Header(new Map());
      headers.add("uri", Uri.parse(input));
    }
  }
}
