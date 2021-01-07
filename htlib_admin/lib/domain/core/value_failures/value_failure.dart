abstract class ValueFailure<T> {
  final T value;

  ValueFailure(
    this.value,
  );

  @override
  String toString() => 'ValueFailure(value: $value)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is ValueFailure<T> && o.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}
