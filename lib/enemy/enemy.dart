import 'dart:async' as asy;

import 'package:bonfire/bonfire.dart';

import 'package:teste_tec2/audio/bgm.dart';
import 'package:teste_tec2/player/soldier.dart';

import 'enemy_sprite_sheet.dart';

/// Inimigo que anda pelo mapa
class EnemySoldier extends SimpleEnemy
    with ObjectCollision, AutomaticRandomMovement {
  // Timer que representará o tempo até o inimigo reaparecer
  asy.Timer? timer;
  // Posição inicial do inimigo
  Vector2 initialPosition;
  Component? oldParent;

  EnemySoldier(Vector2 position)
      : initialPosition = position,
        super(
          position: position,
          size: Vector2(64, 64),
          animation: SimpleDirectionAnimation(
            idleRight: EnemySpriteSheet.idleRight,
            runRight: EnemySpriteSheet.runRight,
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

  @override
  void update(double dt) {
    seePlayer(
      observed: (observed) {
        // Vai ao jogador
        seeAndMoveToPlayer(
          closePlayer: (closePlayer) {},
          margin: 0,
          radiusVision: 32 * 8,
        );
      },
      notObserved: () {
        // Anda aleatóriamente
        runRandomMovement(
          dt,
          speed: speed,
          maxDistance: 32 * 8,
          minDistance: 32 * 3,
          timeKeepStopped: 1000,
        );
      },
      radiusVision: 32 * 8,
    );
    super.update(dt);
  }

  @override
  bool onCollision(GameComponent component, bool active) {
    if (component is Soldier) {
      // Desabilita colisão
      //enableCollision(false);
      component.die();
    }
    return super.onCollision(component, active);
  }

  void respawn() {
    addToParent(oldParent!);
    position = initialPosition;
    enableCollision(true);
  }

  @override
  void die() async {
    oldParent = parent;
    MasterAudio.playerDeath();
    enableCollision(false);
    removeFromParent();
    // Animação de morte do inimigo
    gameRef.add(AnimatedObjectOnce(
      position: position,
      size: size,
      animation: SpriteAnimation.load(
        "enemy/players red x2.png",
        SpriteAnimationData.sequenced(
          amount: 6,
          stepTime: 0.2,
          textureSize: Vector2(64, 64),
          texturePosition: Vector2(0, 64 * 5 + 1),
          loop: false,
        ),
      ),
    ));
    await Future.delayed(const Duration(milliseconds: 1600));
    // O inimigo é reinvocado depois de um certo tempo
    timer = asy.Timer(const Duration(seconds: 15), () => respawn());
  }
}
