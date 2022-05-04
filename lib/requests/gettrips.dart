import 'package:Mkoani/models/models.dart';
import 'package:Mkoani/requests/requests.dart';

Requests request = Requests<List<BusModel>>();
Future<List<BusModel>> getTrips(
    {required String from, required String to, required String date}) async {
  List<BusModel> buses = [];

  Map<String, dynamic> data = await request
      .post(url: 'routes', body: {"from": from, "to": to, "depart_date": date});

  // check if there are buses for that route
  if (!data['message'].isEmpty) {
    for (var i in data['message']) {
      buses.add(BusModel.fromjson(i));
    }
    return buses;
  } else {
    return [];
  }
}
