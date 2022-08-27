import 'package:bonfire/bonfire.dart';

import 'package:teste_tec2/audio/bgm.dart';
import 'package:teste_tec2/game_stats_controller.dart';
import 'package:teste_tec2/shield.dart';
import 'player_sprite_sheet.dart';

/// Representa o jogador
class Soldier extends SimplePlayer with ObjectCollision {
  final gameStatsController = BonfireInjector().get<GameStatsController>();

  Soldier(Vector2 position)
      : super(
          position: position,
          speed: 170,
          size: Vector2(64, 64),
          animation: SimpleDirectionAnimation(
            idleRight: PlayerSpriteSheet.idleRight,
            runRight: PlayerSpriteSheet.runRight,
          ),
        ) {
    setupCollision(CollisionConfig(
      collisions: [
        CollisionArea.circle(
          radius: 12,
          align: Vector2(20, 36),
        ),
      ],
    ));
  }

  // Chama o controlador para aumentar o placar
  void updateScore(int points) {
    gameStatsController.incrementScore(points);
  }

  // Invoca um escudo
  void activatePower() {
    add(Shield(position));
  }

  @override
  void die() async {
    // Desabilita colisão
    enableCollision(false);
    MasterAudio.playerDeath();
    // Remove o jogador
    removeFromParent();
    // Adiciona animação de morte
    gameRef.add(AnimatedObjectOnce(
      position: position,
      size: size,
      animation: SpriteAnimation.load(
        "player/players_blue_x2.png",
        SpriteAnimationData.sequenced(
          amount: 6,
          stepTime: 0.2,
          textureSize: Vector2(64, 64),
          texturePosition: Vector2(0, 64 * 5 + 1),
          loop: false,
        ),
      ),
    ));
    // Diminui quantidade de vidas
    gameStatsController.decrementLives();

    // Delay para esperar a animação de morte acabar
    await Future.delayed(const Duration(milliseconds: 1600));
    super.die();
  }

  @override
  void update(double dt) {
    if (isDead) {
      return;
    }
    super.update(dt);
  }
}
