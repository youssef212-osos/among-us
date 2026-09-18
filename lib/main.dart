import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const ImposterAliveApp());
}

class ImposterAliveApp extends StatelessWidget {
  const ImposterAliveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Imposter Alive',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F172A),
      ),
      home: const MainMenuScreen(),
    );
  }
}

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // عنوان اللعبة بتصميم مميز
              const Text(
                'IMPOSTER ALIVE',
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.black,
                  color: Colors.redAccent,
                  letterSpacing: 4,
                  shadows: [
                    Shadow(color: Colors.black, offset: Offset(2, 2), blurRadius: 4),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'البقاء على قيد الحياة وإتمام المهام!',
                style: TextStyle(fontSize: 16, color: Colors.blueGrey, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 60),
              // زر اللعب
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const GameScreen()),
                  );
                },
                child: const Text(
                  'ابدأ اللعب الآن',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  // موقع اللاعب (Crewmate)
  double playerX = 150;
  double playerY = 300;
  final double playerSize = 25;
  final double speed = 6;

  // قائمة الـ Imposters (الأعداء)
  List<Point<double>> imposters = [
    const Point(50.0, 50.0),
    const Point(500.0, 100.0),
    const Point(200.0, 600.0),
  ];
  final double imposterSpeed = 2.0;

  // قائمة المهام (Tasks)
  List<Point<double>> tasks = [
    const Point(100.0, 150.0),
    const Point(450.0, 200.0),
    const Point(300.0, 500.0),
  ];
  List<bool> completedTasks = [false, false, false];

  Timer? gameTimer;
  bool isGameOver = false;
  bool isVictory = false;

  // حدود الخريطة
  final double mapWidth = 600;
  final double mapHeight = 800;

  @override
  void initState() {
    super.initState();
    startGameLoop();
  }

  void startGameLoop() {
    gameTimer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      if (isGameOver || isVictory) return;

      setState(() {
        // 1. تحديث حركة الـ Imposters وملاحقتهم للاعب
        for (int i = 0; i < imposters.length; i++) {
          double dx = playerX - imposters[i].x;
          double dy = playerY - imposters[i].y;
          double distance = sqrt(dx * dx + dy * dy);

          if (distance > 0) {
            imposters[i] = Point(
              imposters[i].x + (dx / distance) * imposterSpeed,
              imposters[i].y + (dy / distance) * imposterSpeed,
            );
          }

          // التحقق من اصطدام الإمبوستر باللاعب (خسارة)
          if (distance < playerSize) {
            isGameOver = true;
          }
        }

        // 2. التحقق من الاقتراب من المهام لإكمالها تلقائياً
        for (int i = 0; i < tasks.length; i++) {
          if (!completedTasks[i]) {
            double tDx = playerX - tasks[i].x;
            double tDy = playerY - tasks[i].y;
            double tDistance = sqrt(tDx * tDx + tDy * tDy);

            if (tDistance < 30) {
              completedTasks[i] = true;
            }
          }
        }

        // 3. التحقق من الفوز (إتمام جميع المهام)
        if (completedTasks.every((task) => task == true)) {
          isVictory = true;
        }
      });
    });
  }

  @override
  void dispose() {
    gameTimer?.cancel();
    super.dispose();
  }

  void movePlayer(double dx, double dy) {
    if (isGameOver || isVictory) return;
    setState(() {
      playerX = (playerX + dx * speed).clamp(playerSize, mapWidth - playerSize);
      playerY = (playerY + dy * speed).clamp(playerSize, mapHeight - playerSize);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // خلفية ساحة اللعب
          Positioned.fill(
            child: GestureDetector(
              onPanUpdate: (details) {
                // التحكم باللمس على الشاشة للحركة السريعة
                movePlayer(details.delta.dx.sign, details.delta.dy.sign);
              },
              child: CustomPaint(
                painter: GamePainter(
                  playerX: playerX,
                  playerY: playerY,
                  playerSize: playerSize,
                  imposters: imposters,
                  tasks: tasks,
                  completedTasks: completedTasks,
                  mapWidth: mapWidth,
                  mapHeight: mapHeight,
                ),
              ),
            ),
          ),

          // واجهة المستخدم بالأعلى (المهام)
          Positioned(
            top: 40,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black85,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blueAccent),
                  ),
                  child: Text(
                    'المهام المنجزة: ${completedTasks.where((t) => t).length} / ${tasks.length}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 30),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            ),
          ),

          // أزرار التحكم الافتراضية (D-Pad) في الأسفل
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: Column(
                children: [
                  // الاتجاه للأعلى
                  IconButton(
                    onPressed: () => movePlayer(0, -1),
                    icon: const Icon(Icons.arrow_upward, size: 50, color: Colors.white70),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // الاتجاه لليسار
                      IconButton(
                        onPressed: () => movePlayer(-1, 0),
                        icon: const Icon(Icons.arrow_back, size: 50, color: Colors.white70),
                      ),
                      const SizedBox(width: 40),
                      // الاتجاه لليمين
                      IconButton(
                        onPressed: () => movePlayer(1, 0),
                        icon: const Icon(Icons.arrow_forward, size: 50, color: Colors.white70),
                      ),
                    ],
                  ),
                  // الاتجاه للأسفل
                  IconButton(
                    onPressed: () => movePlayer(0, 1),
                    icon: const Icon(Icons.arrow_downward, size: 50, color: Colors.white70),
                  ),
                ],
              ),
            ),
          ),

          // شاشة النهاية (خسارة / فوز)
          if (isGameOver || isVictory)
            Container(
              color: Colors.black90,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      isVictory ? 'لقد انتصرت! 🎉' : 'قتلك الخائن! 💀',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: isVictory ? Colors.greenAccent : Colors.redAccent,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      isVictory ? 'أكملت جميع المهام بنجاح وبقيت حياً!' : 'لقد قضى عليك الـ Imposter!',
                      style: const TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      ),
                      onPressed: () {
                        setState(() {
                          playerX = 150;
                          playerY = 300;
                          imposters = [
                            const Point(50.0, 50.0),
                            const Point(500.0, 100.0),
                            const Point(200.0, 600.0),
                          ];
                          completedTasks = [false, false, false];
                          isGameOver = false;
                          isVictory = false;
                        });
                      },
                      child: const Text('إعادة المحاولة', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// رسم اللعبة (شخصيات ومهام وخلفية) باستخدام CustomPainter لتوفير استهلاك البيانات والصور
class GamePainter extends CustomPainter {
  final double playerX;
  final double playerY;
  final double playerSize;
  final List<Point<double>> imposters;
  final List<Point<double>> tasks;
  final List<bool> completedTasks;
  final double mapWidth;
  final double mapHeight;

  GamePainter({
    required this.playerX,
    required this.playerY,
    required this.playerSize,
    required this.imposters,
    required this.tasks,
    required this.completedTasks,
    required this.mapWidth,
    required this.mapHeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 1. خلفية الخريطة
    final bgPaint = Paint()..color = const Color(0xFF0F1728);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // خطوط الشبكة في الخلفية
    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..style = PaintingStyle.stroke;
    for (double i = 0; i < size.width; i += 40) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), gridPaint);
    }
    for (double i = 0; i < size.height; i += 40) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), gridPaint);
    }

    // 2. رسم المهام (Tasks)
    for (int i = 0; i < tasks.length; i++) {
      final taskPaint = Paint()
        ..color = completedTasks[i] ? Colors.greenAccent : Colors.yellowAccent
        ..style = PaintingStyle.fill;
      
      // رسم شكل الترس/المهمة
      canvas.drawCircle(Offset(tasks[i].x, tasks[i].y), 15, taskPaint);
      
      // رسم رمز مميز داخل المهمة
      final iconPaint = Paint()..color = Colors.black..style = PaintingStyle.stroke..strokeWidth = 2;
      canvas.drawRect(Rect.fromCircle(center: Offset(tasks[i].x, tasks[i].y), radius: 6), iconPaint);
    }

    // 3. رسم اللاعب (Crewmate الأزرق)
    final playerPaint = Paint()..color = Colors.cyan;
    // رسم الجسم البيضاوي والشنطة
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(playerX, playerY), width: playerSize * 1.2, height: playerSize * 1.5), const Radius.circular(10)), playerPaint);
    // الشنطة الخلفية
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(playerX - playerSize * 0.8, playerY - playerSize * 0.5, playerSize * 0.3, playerSize * 1), const Radius.circular(4)), Paint()..color = Colors.cyan.shade700);
    // النظارة (Glass visor)
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(playerX - playerSize * 0.1, playerY - playerSize * 0.5, playerSize * 0.6, playerSize * 0.4), const Radius.circular(6)), Paint()..color = Colors.white70);

    // 4. رسم الـ Imposters (الأعداء الحمراء)
    for (var imposter in imposters) {
      final imposterPaint = Paint()..color = Colors.redAccent;
      canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(imposter.x, imposter.y), width: playerSize * 1.2, height: playerSize * 1.5), const Radius.circular(10)), imposterPaint);
      // الشنطة الخلفية
      canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(imposter.x - playerSize * 0.8, imposter.y - playerSize * 0.5, playerSize * 0.3, playerSize * 1), const Radius.circular(4)), Paint()..color = Colors.red.shade900);
      // النظارة (Glass visor)
      canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(imposter.x - playerSize * 0.1, imposter.y - playerSize * 0.5, playerSize * 0.6, playerSize * 0.4), const Radius.circular(6)), Paint()..color = Colors.lightBlueAccent);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
