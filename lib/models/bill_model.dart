class Bill {
  final DateTime? date;
  final double? amount;
  final String sourceOfBill;

//<editor-fold desc="Data Methods">
  const Bill({
    this.date,
    this.amount,
    required this.sourceOfBill,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Bill &&
          runtimeType == other.runtimeType &&
          date == other.date &&
          amount == other.amount &&
          sourceOfBill == other.sourceOfBill);

  @override
  int get hashCode => date.hashCode ^ amount.hashCode ^ sourceOfBill.hashCode;

  @override
  String toString() {
    return 'Bill{' +
        ' date: $date,' +
        ' amount: $amount,' +
        ' sourceOfBill: $sourceOfBill,' +
        '}';
  }

  Bill copyWith({
    DateTime? date,
    double? amount,
    String? sourceOfBill,
  }) {
    return Bill(
      date: date ?? this.date,
      amount: amount ?? this.amount,
      sourceOfBill: sourceOfBill ?? this.sourceOfBill,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': this.date,
      'amount': this.amount,
      'sourceOfBill': this.sourceOfBill,
    };
  }

  factory Bill.fromMap(Map<String, dynamic> map) {
    return Bill(
      date: map['date'] as DateTime,
      amount: map['amount'] as double,
      sourceOfBill: map['sourceOfBill'] as String,
    );
  }

//</editor-fold>
}