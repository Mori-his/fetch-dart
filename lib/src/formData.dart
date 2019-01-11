import 'dart:collection';

class FormData extends MapMixin {
  Map _map = new Map();
  FormData() {}
  @override
  operator [](Object key) {
    return _map[key];
  }

  @override
  void operator []=(name, value) {
    _map[name] = value;
  }

  @override
  void clear() {
    _map.clear();
  }

  @override
  Iterable<String> get keys => _map.keys;

  @override
  remove(Object key) {
    return _map.remove(key);
  }
}
