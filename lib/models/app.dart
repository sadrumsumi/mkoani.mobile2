import 'package:Mkoani/models/models.dart';

class App {
  ChosenRoute route;
  String? currentPage;
  bool onBoardingComplete = false;
  Payment? currentPayment;
  Map<String, String> payees = {};
  bool initialised = false;
  bool isNetworkAvailable = false;
  List<RouteModel>? cities;
  User? user;
  App(
      {this.cities,
      this.user,
      required this.route,
      this.currentPayment,
      this.currentPage});

  void addPayee(Map<String, String> payee) {
    payees.addAll(payee);
  }

  void addPayment(Map<String, dynamic> value) {
    currentPayment =
        Payment(options: value['paymentOptions'], id: value['reference']);
  }

  void addpayment(Payment payment) {
    currentPayment = payment;
  }

  void logout() {
    currentPayment = null;
    user = null;
  }
}

class ChosenRoute {
  String? from;
  String? to;
  String? date;
  List<BusModel> buses = [];

  ChosenRoute({this.from, this.to, this.date});

  void addFrom(String name) {
    from = name;
  }

  void addTo(String name) {
    to = name;
  }

  void addDate(String name) {
    date = name;
  }

  void addBuses(List<BusModel> buses) {
    this.buses = buses;
  }
}
