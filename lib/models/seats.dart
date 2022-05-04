class SeatModel {
  final int id;
  final String status;
  final String? position;
  bool selected;

  SeatModel(
      {required this.id,
      required this.status,
      this.position,
      this.selected = false});
}
