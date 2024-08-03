
class Expense {
  final int? id;
  final String category;
  final String? description;
  final int amount;
  final String date;

  Expense({
    this.id,
    required this.category,
    this.description,
    required this.amount,
    required this.date
  });


  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'description': description,
      'amount': amount,
      'date': date
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id']?.toInt() ?? 0,
      category: map['category'] ?? '',
      description: map['description'],
      amount: map['amount'] ?? 0,
      date: map['date'] ?? '',
    );
  }


  @override
  String toString() => 'Expense(id: $id, category: $category, description: $description,'
      'amount: $amount,date: $date)';
}
