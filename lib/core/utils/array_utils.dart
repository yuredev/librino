import 'dart:math';

abstract class ArrayUtils {
  static List<T> shuffle<T>(List<T> array) {
    final random = Random();
    for (var i = array.length - 1; i > 0; i--) {
      final n = random.nextInt(i + 1);
      final temp = array[i];
      array[i] = array[n];
      array[n] = temp;
    }
    return array;
  }
}
