import 'package:Mkoani/models/models.dart';
import 'package:Mkoani/requests/requests.dart';

Requests requests = Requests();
Future<List<RouteModel>> getRoutes({url = 'city'}) async {
  Map<String, dynamic> data = await requests.get(url);
  List<RouteModel> routes = [];

  for (var name in data['message']) {
    routes.add(RouteModel(name: name));
  }
  return routes;
}
