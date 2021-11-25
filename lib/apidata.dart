class clients {
  final String? name;
  final int? id;
  final String? company;
  final int? orderId;
  final int? invoicepaid;
  final int? invoicePending;

  clients(
      {this.name,
      this.id,
      this.company,
      this.orderId,
      this.invoicepaid,
      this.invoicePending});

  factory clients.fromJson(Map<String, dynamic> json) {
    return clients(
        name: json["name"],
        id: json["id"],
        company: json["company"],
        orderId: json["orderId"],
        invoicepaid: json["invoicepaid"],
        invoicePending: json["invoicePending"]);
  }
}
