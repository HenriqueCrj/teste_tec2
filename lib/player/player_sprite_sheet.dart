import 'package:bonfire/bonfire.dart';

class PlayerSpriteSheet {
  static get idleRight => SpriteAnimation.load(
        "player/players_blue_x2.png",
        SpriteAnimationData.sequenced(
          amount: 1,
          stepTime: 1,
          textureSize: Vector2(64, 64),
          texturePosition: Vector2(0, 0),
          loop: false,
        ),
      );

  static get runRight => SpriteAnimation.load(
        "player/players_blue_x2.png",
        SpriteAnimationData.sequenced(
          amount: 4,
          stepTime: 0.2,
          textureSize: Vector2(64, 64),
          texturePosition: Vector2(0, 64 * 3 + 1),
        ),
      );
}
