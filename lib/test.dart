RegExp match = RegExp(r"^[0-9]{10, 10}$");

void main() {
  RegExpMatch? m = match.firstMatch('0755555122');
  m.toString();
  print(m);
}
