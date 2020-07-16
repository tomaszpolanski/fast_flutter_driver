/// Specifies in what resolution the application should be run.
class Resolution {
  const Resolution(this.width, this.height);

  /// Creates [Resolution] object from String in format <width>x<height>,
  /// eg. 1200x900.
  factory Resolution.fromSize(String screenResolution) {
    final dimensions = screenResolution.split('x');
    return Resolution(double.parse(dimensions[0]), double.parse(dimensions[1]));
  }

  /// Creates [Resolution] object from json
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
