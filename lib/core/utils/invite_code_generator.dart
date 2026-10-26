import 'dart:math';

class InviteCodeGenerator {
  static const _chars =
      'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';

  static String generate({
    int length = 6,
  }) {
    final random = Random();

    return List.generate(
      length,
      (_) => _chars[random.nextInt(_chars.length)],
    ).join();
  }
}