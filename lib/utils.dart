import 'dart:math' as math;

import 'package:bonfire/bonfire.dart';

// Fornece uma posição aleatória num retângulo, com um pequeno deslocamento
Vector2 randomPositionFromRect(Vector2 rectPosition, Vector2 size) {
  double randomPositionX =
      math.Random().nextDouble() * size.x + rectPosition.x - 16;
  double randomPositionY =
      math.Random().nextDouble() * size.y + rectPosition.y - 16;
  return Vector2(randomPositionX, randomPositionY);
}
