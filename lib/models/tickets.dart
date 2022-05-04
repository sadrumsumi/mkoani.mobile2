import 'package:Mkoani/models/models.dart';

class Ticket {
  int? id;
  String? to;
  String? tin;
  String? from;
  String? phone;
  String? brand;
  String? status;
  String? address;
  String? seatNo;
  String? fullname;
  int? busfare;
  String? plateNo;
  String? dateIssued;
  String? departureDate;
  String? reportingTime;
  String? departureTime;
  String? reference;
  bool empty;

  Ticket(
      {this.id,
      this.address,
      this.brand,
      this.busfare,
      this.dateIssued,
      this.departureDate,
      this.departureTime,
      this.from,
      this.fullname,
      this.phone,
      this.plateNo,
      this.reportingTime,
      this.seatNo,
      this.status,
      this.tin,
      this.to,
      this.reference,
      this.empty = false});

  Ticket.fromJson(Map json, String? reference)
      : id = json['id'],
        address = json['address'],
        brand = json['brand'],
        busfare = json['bus_fare'],
        dateIssued = json['date_issued'],
        departureDate = json['departure_date'],
        departureTime = json['departure_time'],
        from = json['from'],
        fullname = json['fullname'],
        phone = json['phone'],
        plateNo = json['plate_no'],
        reportingTime = json['reporting_time'],
        seatNo = json['seat_no'],
        status = json['status'],
        tin = json['tin'],
        to = json['to'],
        reference = reference,
        empty = false;

  factory Ticket.empty() {
    Ticket ticket = Ticket();
    ticket.empty = true;
    return ticket;
  }

  bool isEmpty() {
    return empty;
  }
}

class Payment {
  String? id;
  int? amount;
  String? createdAt;
  String? paymentStatus;
  List<PaymentOption>? options;
  List<Ticket>? tickets;
  String? reference;

  Payment(
      {this.options,
      this.amount,
      this.createdAt,
      this.id,
      this.paymentStatus,
      this.tickets,
      this.reference});

  Payment.fromJson(Map json)
      : id = json['id'].toString(),
        amount = json['amount'],
        createdAt = json['created_at'],
        paymentStatus = json['payment_status'];
}
