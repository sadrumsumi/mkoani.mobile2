abstract class LoadingEvents {
  const LoadingEvents();
}

class OnLoad extends LoadingEvents {
  final String? effects;
  const OnLoad({this.effects});
}

class OnLoadComplete extends LoadingEvents {}
