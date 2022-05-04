import 'dart:convert';
import 'package:Mkoani/exceptions/network_exceptions.dart';
import 'package:Mkoani/models/models.dart';
import 'package:Mkoani/requests/requests.dart';
import 'package:http/http.dart';

Future<BusModel> getSeats(id) async {
  var response = await get(
    Uri.parse('${Requests.domain}book/$id'),
    // Uri.parse(
    // 'http://192.168.1.212:5555/api/v1/book/$id',
    // ),
    headers: {
      "mkoani": r"VQ2%T$,Bm*^!Xd!pRaqq]7dwR=8;L2Kpv/[D?Y%29zyf>*X,",
    },
  );
  print(response.body);
  /* check if response is valid and process accordingly*/
  if (response.statusCode == 200) {
    Map data = json.decode(response.body);
    data = data['message'];
    // return a mapping for seats, bus models
    print(data);
    Map busData = data['bus'];

    int seatPrice = data['route']['amount'];
    List<String>? seats = [];
    for (String i in data['cells_selected']) {
      seats.add(i);
    }

    BusModel bus = BusModel(
        id: busData['id'],
        name: busData['name'],
        grade: busData['grade'],
        plateno: busData['plate_no'],
        busfare: seatPrice,
        boardtime: data['departure_time'],
        droppoint: data['route']['drop_point'],
        boardpoint: data['route']['board_point'],
        arrivaltime: data['arrival_time'],
        layouts: busData['layout'],
        tin: data['tin'],
        address: data['address'],
        reportingtime: data['reporting_time'],
        selectedseats: seats,
        isMainRoute: data['is_main_route'].toString(),
        tripRouteId: data['trip_route_id'].toString(),
        tripId: data['trip_id'].toString());

    return bus;
  } else {
    throw const NetworkException('No Data');
  }
}

/*Requests requests = Requests();

Future<BusModel> getSeats(id) async {
  String url = 'book/$id';
  Map<String, dynamic> data = await requests.get(url);

  Map busData = data['bus'];

  int seatPrice = data['route']['amount'];
  List<String>? seats = [];
  for (String i in data['cells_selected']) {
    seats.add(i);
  }

  BusModel bus = BusModel(
      id: busData['id'],
      name: busData['name'],
      grade: busData['grade'],
      plateno: busData['plate_no'],
      busfare: seatPrice,
      boardtime: data['departure_time'],
      droppoint: data['route']['drop_point'],
      boardpoint: data['route']['board_point'],
      arrivaltime: data['arrival_time'],
      layouts: busData['layout'],
      tin: data['tin'],
      address: data['address'],
      reportingtime: data['reporting_time'],
      selectedseats: seats,
      tripid: data['trip_id'].toString());

  return bus;
}*/
