abstract class DbModel<T> {
  final T id;
  DbModel({required this.id});

  static fromMap(Map<String, dynamic> map) {}
  Map<String, dynamic> toMap() {
    return Map.fromIterable([]);
  }
}
