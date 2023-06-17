abstract class StringUtils {
  static String toTitle(String string) {
    return '${string.substring(0, 1).toUpperCase()}${string.substring(1).toLowerCase()}';
  }
}
