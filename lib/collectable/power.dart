import 'package:bonfire/bonfire.dart';
import 'package:teste_tec2/audio/bgm.dart';
import 'package:teste_tec2/player/soldier.dart';

/// Coletável que fornece o poder ao jogador
class Power extends GameDecoration with Sensor {
  Power(Vector2 position)
      : super.withAnimation(
          animation: SpriteAnimation.load(
            "power.png",
            SpriteAnimationData.sequenced(
              amount: 3,
              stepTime: 0.33,
              textureSize: Vector2(32, 32),
            ),
          ),
          position: position,
          size: Vector2(32, 32),
        ) {
    setupSensorArea(
      areaSensor: [
        CollisionArea.rectangle(
          size: Vector2(32, 32),
        ),
      ],
    );
  }

  @override
  void onContact(GameComponent component) {
    if (component is Soldier) {
      // Ativa o poder
      component.activatePower();
      MasterAudio.powerPickup();
      // Remove o item
      removeFromParent();
    }
  }

  @override
  void onContactExit(GameComponent component) {}
}
