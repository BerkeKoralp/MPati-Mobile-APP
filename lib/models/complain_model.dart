class Complain {
  final String complain;
  final String name;

//<editor-fold desc="Data Methods">
  const Complain({
    required this.complain,
    required this.name,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Complain &&
          runtimeType == other.runtimeType &&
          complain == other.complain &&
          name == other.name);

  @override
  int get hashCode => complain.hashCode ^ name.hashCode;

  @override
  String toString() {
    return 'Complain{' + ' complain: $complain,' + ' name: $name,' + '}';
  }

  Complain copyWith({
    String? complain,
    String? name,
  }) {
    return Complain(
      complain: complain ?? this.complain,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'complain': this.complain,
      'name': this.name,
    };
  }

  factory Complain.fromMap(Map<String, dynamic> map) {
    return Complain(
      complain: map['complain'] as String,
      name: map['name'] as String,
    );
  }

//</editor-fold>
}