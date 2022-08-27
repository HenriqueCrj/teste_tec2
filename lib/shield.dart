import 'dart:async' as asy;

import 'package:bonfire/bonfire.dart';
import 'package:teste_tec2/audio/bgm.dart';

import 'enemy/enemy.dart';
import 'game_stats_controller.dart';

/// Escudo que elimina inimigos
class Shield extends GameDecoration with Follower, ObjectCollision {
  final gameStatsController = BonfireInjector().get<GameStatsController>();
  // Timer que representará o tempo do escudo
  asy.Timer? timer;

  Shield(Vector2 position)
      : super.withAnimation(
          animation: SpriteAnimation.load(
            "shield.png",
            SpriteAnimationData.sequenced(
              amount: 4,
              stepTime: 0.25,
              textureSize: Vector2(128, 128),
            ),
          ),
          position: position - Vector2(32, 32),
          size: Vector2(128, 128),
        ) {
    setupCollision(CollisionConfig(
      collisions: [
        CollisionArea.circle(
          radius: 64,
          align: Vector2(0, 0),
        ),
      ],
    ));
    // Ativa o escudo por 10 segundos e depois remove ele
    MasterAudio.shieldActivated();
    timer = asy.Timer(const Duration(seconds: 12), () => removeFromParent());
  }

  @override
  asy.Future<void> onLoad() {
    // O escudo segue o jogador
    setupFollower(target: gameRef.player, offset: -Vector2(32, 32));
    return super.onLoad();
  }

  @override
  bool onCollision(GameComponent component, bool active) {
    if (component is EnemySoldier) {
      // Um inimigo eliminado fornece 5 pontos
      gameStatsController.score.value += 5;
      // Elimina um inimigo
      component.die();
    }
    return false;
    //return super.onCollision(component, active);
  }
}
