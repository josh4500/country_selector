class States {
  final String name;
  final String code;
  final String? subdivision;

  static States get notSelected => States(name: '', code: '');

  States({
    required this.name,
    required this.code,
    this.subdivision,
  });
}
