class BusModel {
  final int id;
  final String name;
  final String grade;
  final String plateno;
  var busfare;
  final String boardtime;
  final String droppoint;
  final String boardpoint;
  final String arrivaltime;
  final List? layouts;
  final String? tin;
  final String? address;
  final String? reportingtime;
  List<String> selectedseats;
  final String? tripId;
  final String? tripRouteId;
  final String? isMainRoute;
  int? totalSeats;

  BusModel(
      {required this.id,
      required this.name,
      required this.grade,
      required this.plateno,
      required this.busfare,
      required this.boardtime,
      required this.droppoint,
      required this.boardpoint,
      required this.arrivaltime,
      this.totalSeats,
      this.layouts,
      this.address,
      this.reportingtime,
      this.tin,
      this.selectedseats = const [],
      this.tripId,
      this.isMainRoute,
      this.tripRouteId});

  factory BusModel.fromjson(Map<String, dynamic> json) {
    return BusModel(
        id: json['id'],
        name: json['name'],
        grade: json['grade'],
        plateno: json['plateno'],
        busfare: json['busfare'],
        boardtime: json['departure_time'],
        droppoint: json['droppoint'],
        boardpoint: json['boardpoint'],
        arrivaltime: json['arrival_time']);
  }

  @override
  String toString() {
    return name;
  }
}
