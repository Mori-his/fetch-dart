import 'dart:io';
import 'dart:convert';

import './header.dart';
import './body.dart';

/**
 *  Tip: bufferOutput - 是否开去缓冲 默认：true   不建议关闭缓冲输出  会严重影响性能  不会公开此设置
 * TODO:
 *  参数设置
 *  1、ContentLength - 设置请求内容长度 如果不知道长度为-1  默认： -1
 * 
 * 
 * 
 */
class Request {
  Uri url;
  String method;
  Header headers;
  Body body;
  String proxy;
  dynamic encoding;
  var streamTransformer;
  Request(dynamic input, [String method = "GET", Function callback]) {
    _init(input, method, callback);
  }
  Future get() {
    return _grab();
  }

  Future post() {
    return _grab();
  }

  Future _grab() {
    HttpClient client = new HttpClient();
    if (_isTypeProxy()) {
      // 开启代理
      handleProxy(client, this.proxy);
    }
    var _request = (method == "POST" ? client.postUrl : client.getUrl);
    return _request(url).then((HttpClientRequest request) {
      if (this.headers != null) {
        request.contentLength = -1;
        headers.write(request);
      }
      if (body.length > 0) {
        request.write(json.encode(body.content));
      }
      // request.cookies
      return request.close();
    }).then((HttpClientResponse response) {
      if (encoding == null) {
        return response;
      }
      return response.transform(this.streamTransformer);
    }).catchError((e) => throw e);
  }

  bool _isTypeProxy() {
    RegExp re = new RegExp(r"^http");
    if (proxy != null && re.hasMatch(proxy.toString())) {
      return true;
    } else if (proxy != null && !re.hasMatch(proxy.toString())) {
      print("\"$proxy\" type is not http or https.");
      throw new TypeError();
    }
    return false;
  }

  void _init(dynamic input, [String method = "GET", dynamic encoding = null]) {
    if (input is String) {
      input = {"uri": input, "method": method};
    }
    if (input["headers"] != null) {
      headers = new Header(input["headers"]);
    }
    if (input["body"] != null) {
      body = new Body(input["body"], headers: headers);
    }
    if (input["proxy"] != null) {
      proxy = input["proxy"];
    }
    this.encoding = input["encoding"] ?? encoding;
    this.method = input["method"] ?? method;
    url = Uri.parse(input["uri"] ?? input["url"]);

    if (encoding == "utf8") {
      streamTransformer = utf8.decoder;
    } else if (encoding == "json") {
      streamTransformer = json.decoder;
    } else if (encoding == "latin1") {
      streamTransformer = latin1.decoder;
    } else if (encoding == "base64") {
      streamTransformer = base64.decoder;
    } else if (encoding == "base64Url") {
      streamTransformer = base64Url.decoder;
    }
  }
}

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
