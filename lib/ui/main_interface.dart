import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';

import 'package:teste_tec2/game_stats_controller.dart';

/// Interface que mostra pontuação e número de vidas
class MainInterface extends StatelessWidget {
  final soldierController = BonfireInjector().get<GameStatsController>();

  MainInterface({Key? key}) : super(key: key);

  @override
  Widget build(context) {
    return ValueListenableBuilder<int>(
      valueListenable: soldierController.score,
      builder: (context, value, child) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Material(
            color: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Pontuação atual
                ValueListenableBuilder<int>(
                  valueListenable: soldierController.score,
                  builder: (context, value, child) {
                    return Text(
                      "Pontos: $value",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.red,
                      ),
                    );
                  },
                ),
                // Quantidade de vidas
                ValueListenableBuilder<int>(
                  valueListenable: soldierController.lives,
                  builder: (context, value, child) {
                    return Text(
                      "Vidas: $value",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.red,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
