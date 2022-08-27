import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';

import 'audio/bgm.dart';
import 'collectable/gold.dart';
import 'collectable/power.dart';
import 'enemy/enemy.dart';
import 'game_stats_controller.dart';
import 'player/soldier.dart';
import 'ui/main_interface.dart';
import 'utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MasterAudio.initialize();
  BonfireInjector().put((i) => GameStatsController());
  //MasterAudio.stopBackgroundSound();
  //MasterAudio.playBackgroundSound();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Game(),
    );
  }
}

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> implements GameListener {
  late GameController _gameController;
  bool isDeathAnimationRunning = false;
  final gameStatsController = BonfireInjector().get<GameStatsController>();

  @override
  void initState() {
    super.initState();
    // if (!MasterAudio.isBgmPlaying()) {
    //   MasterAudio.playBackgroundSound(volume: 0.1);
    // }
    _gameController = GameController()..addListener(this);
  }

  // Função que é chamada quando a partida termina
  void endgameDialog(String text) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Material(
          color: Colors.transparent,
          child: Center(
            child: SizedBox(
              width: 200,
              height: 200,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      text,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Maior pontuação: ${gameStatsController.maxScore}",
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Reinicia pontos e vidas
                      gameStatsController.resetStats();
                      // Recria o mapa
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const Game()));
                    },
                    child: const Text("Reiniciar"),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void changeCountLiveEnemies(int count) {}

  @override
  void updateGame() {
    // Se não houver ouro no mapa
    if (!(_gameController.allDecorations?.any((element) => element is Gold) ??
        false)) {
      // Recria o mapa
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const Game()));
    }
    if (_gameController.player?.isDead ?? false) {
      if (!isDeathAnimationRunning) {
        if (gameStatsController.lives.value <= 0) {
          // Tela de derrota
          endgameDialog("Fim de jogo");
        } else {
          // Recria o mapa
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const Game()));
        }
        isDeathAnimationRunning = true;
      }
    }
  }

  @override
  Widget build(context) {
    return SafeArea(
      child: BonfireWidget(
        gameController: _gameController,
        joystick: Joystick(
          directional: JoystickDirectional(),
          keyboardConfig: KeyboardConfig(
            keyboardDirectionalType: KeyboardDirectionalType.wasd,
          ),
        ),
        lightingColorGame: Colors.black.withOpacity(0.1),
        map: WorldMapByTiled(
          "map.json",
          forceTileSize: Vector2(32, 32),
          // Invoca certos elementos no jogo nas regiões que foram marcadas no tiled
          objectsBuilder: {
            "food": (properties) => Gold(
                randomPositionFromRect(properties.position, properties.size)),
            "enemy": (properties) => EnemySoldier(
                randomPositionFromRect(properties.position, properties.size)),
            "power": (properties) => Power(
                randomPositionFromRect(properties.position, properties.size)),
          },
        ),
        player: Soldier(Vector2(28 * 32, 16 * 32)),
        overlayBuilderMap: {
          "score": (context, game) => MainInterface(),
          "miniMap": (context, game) => MiniMap(
                game: game,
                margin: const EdgeInsets.fromLTRB(8, 32, 8, 8),
                size: Vector2.all(MediaQuery.of(context).size.height / 4),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                ),
              ),
        },
        initialActiveOverlays: const [
          "score",
          "miniMap",
        ],
      ),
    );
  }
}
