import 'dart:io';

/**
 * Header类处理一些headers之类的操作
 */
class Header {
  Map<String, dynamic> _headers = {"contentType": ContentType.json};
  Header(Map<String, dynamic> headers) {
    if (headers.containsKey("contentType") &&
        headers["contentType"] is String) {
      String contentType = headers["contentType"];
      if (contentType.indexOf("charset") == -1) {
        contentType = contentType.replaceAll(
            new RegExp("$contentType"), "$contentType; charset=utf-8");
      }
      headers["contentType"] = contentType;
    }
    this._headers = headers;
  }
  Map getAll() {
    return this._headers;
  }

  int length() {
    return this._headers.length;
  }

  write(HttpClientRequest request) {
    _headers.forEach((key, value) {
      request.headers.add(key, value);
    });
  }

  get contentType {
    return this._headers["contentType"];
  }

  get charset {
    return this._headers["charset"] ?? "utf8";
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
