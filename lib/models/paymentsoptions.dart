class PaymentOption {
  String name;
  List steps;
  PaymentOption({required this.name, required this.steps});

  factory PaymentOption.fromjson(Map json) {
    return PaymentOption(name: json['type'], steps: json['procedure']);
  }
}
