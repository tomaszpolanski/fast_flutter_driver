/// Converts an enum object to user readable string representation
String fromEnum(Object enumeration) {
  assert(enumeration != null, 'Enumeration object cannot be null');
  return enumeration.toString().split('.').last;
}
