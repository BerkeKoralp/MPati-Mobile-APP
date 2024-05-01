class BaseModel{
  final String? mail;
  final String? password;
  final String? type;
  final String? uid;

//<editor-fold desc="Data Methods">
  const BaseModel({
    this.mail,
    this.password,
    this.type,
    this.uid,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BaseModel &&
          runtimeType == other.runtimeType &&
          mail == other.mail &&
          password == other.password &&
          type == other.type &&
          uid == other.uid);

  @override
  int get hashCode =>
      mail.hashCode ^ password.hashCode ^ type.hashCode ^ uid.hashCode;

  @override
  String toString() {
    return 'BaseModel{' +
        ' mail: $mail,' +
        ' password: $password,' +
        ' type: $type,' +
        ' uid: $uid,' +
        '}';
  }

  Map<String, dynamic> toMap() {
    return {
      'mail': this.mail,
      'password': this.password,
      'type': this.type,
      'uid': this.uid,
    };
  }

  factory BaseModel.fromMap(Map<String, dynamic> map) {
    return BaseModel(
      mail: map['mail'] as String,
      password: map['password'] as String,
      type: map['type'] as String,
      uid: map['uid'] as String,
    );
  }
//</editor-fold>
}