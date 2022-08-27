import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// Controla alguns valores importes do jogo
class GameStatsController {
  // Pontuação
  ValueNotifier<int> score = ValueNotifier(0);
  // Vidas
  ValueNotifier<int> lives = ValueNotifier(3);
  // Pontuação máxima registrada na partida
  int maxScore = 0;

  // Incrementa o placar
  void incrementScore(int points) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      score.value += points;
    });
  }

  // Remove uma vida
  void decrementLives() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      lives.value -= 1;
      // Salva a maior pontuação até o momento
      maxScore = math.max(maxScore, score.value);
      // Reinicia o placar
      score.value = 0;
    });
  }

  // Reinicia os valores
  void resetStats() {
    lives.value = 3;
    score.value = 0;
    maxScore = 0;
  }
}
