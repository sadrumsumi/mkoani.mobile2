abstract class LoadingState {
  const LoadingState();
}

class Load extends LoadingState {
  final String? effects;
  const Load({this.effects = 'dialog'});
}

class Complete extends LoadingState {
  const Complete();
}

class NotLoading extends LoadingState {
  const NotLoading();
}
