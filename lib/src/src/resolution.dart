class Resolution {
  const Resolution(this.width, this.height);

  factory Resolution.fromSize(String screenResolution) {
    final dimensions = screenResolution.split('x');
    return Resolution(double.parse(dimensions[0]), double.parse(dimensions[1]));
  }

  factory Resolution.fromJson(Map<String, dynamic> json) {
    return Resolution(json['width'], json['height']);
  }

  final double width;
  final double height;

  Map<String, dynamic> toJson() => {
        'width': width,
        'height': height,
      };
}
