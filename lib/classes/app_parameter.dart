class AppParameter {
  String key;
  String? value;

  AppParameter({
    required this.key,
    this.value,
  });

  factory AppParameter.fromMap(Map<String, dynamic> map) {
    return AppParameter(
      key: map['key'] as String,
      value: map['value'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'key': key,
      'value': value,
    };
  }

  AppParameter copyWith({
    String? key,
    String? value,
  }) {
    return AppParameter(
      key: key ?? this.key,
      value: value ?? this.value,
    );
  }

  @override
  String toString() {
    return 'AppParameter{key: $key, value: $value}';
  }
}
