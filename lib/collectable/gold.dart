import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';

import 'package:teste_tec2/audio/bgm.dart';
import 'package:teste_tec2/player/soldier.dart';

/// Ouro que pode ser coletado para acumular pontos
class Gold extends GameDecoration with Sensor, Lighting {
  Gold(Vector2 position)
      : super.withAnimation(
          animation: SpriteAnimation.load(
            "gold.png",
            SpriteAnimationData.sequenced(
              amount: 2,
              stepTime: 0.5,
              textureSize: Vector2(16, 16),
            ),
          ),
          position: position,
          size: Vector2(16, 16),
        ) {
    setupSensorArea(
      areaSensor: [
        CollisionArea.rectangle(
          size: Vector2(16, 16),
        ),
      ],
    );
    setupLighting(
      LightingConfig(
        radius: 16 * 1.5,
        color: Colors.yellow.withOpacity(0.1),
      ),
    );
  }

  @override
  void onContact(GameComponent component) {
    if (component is Soldier) {
      MasterAudio.goldPickup();
      // Adiciona um ponto
      component.updateScore(1);
      // Remove o ouro
      removeFromParent();
    }
  }

  @override
  void onContactExit(GameComponent component) {}
}
