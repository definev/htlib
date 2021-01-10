abstract class AbstractService<T> {
  Future<void> write(String key, T value);
  T read(String key);
  Future<void> delete(String key);
}
