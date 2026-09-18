import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const AmongUsPartyApp());
}

class AmongUsPartyApp extends StatelessWidget {
  const AmongUsPartyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Buzz Party - Among Us',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF2A085C), // ثيم بازت بارتي موف غامق
        cardColor: const Color(0xFF4C1D95),
        primaryColor: const Color(0xFF8B5CF6),
      ),
      home: const GameSetupScreen(),
    );
  }
}

class GameSetupScreen extends StatefulWidget {
  const GameSetupScreen({super.key});

  @override
  State<GameSetupScreen> createState() => _GameSetupScreenState();
}

class _GameSetupScreenState extends State<GameSetupScreen> {
  final List<TextEditingController> playerControllers = [
    TextEditingController(text: 'لاعب 1'),
    TextEditingController(text: 'لاعب 2'),
  ];
  final TextEditingController roomCountController = TextEditingController(text: '2'); // أصلها أوضتين وصالة أو 3
  int hostIndex = 0;

  void addPlayer() {
    if (playerControllers.length < 15) { // أقصى عدد 15
      setState(() {
        playerControllers.add(TextEditingController(text: 'لاعب ${playerControllers.length + 1}'));
      });
    }
  }

  void removePlayer(int index) {
    if (playerControllers.length > 2) {
      setState(() {
        playerControllers.removeAt(index);
        if (hostIndex >= playerControllers.length) hostIndex = 0;
      });
    }
  }

  // حساب عدد الإمبوسترز تلقائياً بناءً على عدد اللاعبين
  int calculateImpostersCount(int totalPlayers) {
    if (totalPlayers >= 10 && totalPlayers <= 15) {
      return 3;
    } else if (totalPlayers >= 5) {
      return 2;
    } else {
      return 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    int totalPlayers = playerControllers.length;
    int imposterCount = calculateImpostersCount(totalPlayers);

    return Scaffold(
      appBar: AppBar(
        title: const Text('💜 Buzz Party - إعدادات الجيم'),
        backgroundColor: const Color(0xFF3B0764),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '🏠 عدد الغرف في الشقة (أقل حد 2):',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFDDD6FE)),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: roomCountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'مثلاً: 2 (أوضتين وصالة) أو 3',
                filled: true,
                fillColor: Color(0xFF3B0764),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '👥 اللاعبين ($totalPlayers/15):',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFDDD6FE)),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle, color: Color(0xFFA7F3D0), size: 32),
                  onPressed: addPlayer,
                )
              ],
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: playerControllers.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: playerControllers[index],
                          decoration: InputDecoration(
                            labelText: 'اسم اللاعب ${index + 1}',
                            border: const OutlineInputBorder(),
                            filled: true,
                            fillColor: const Color(0xFF3B0764),
                          ),
                        ),
                      ),
                      if (playerControllers.length > 2)
                        IconButton(
                          icon: const Icon(Icons.remove_circle, color: Colors.redAccent),
                          onPressed: () => removePlayer(index),
                        )
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF581C87),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '🎮 عدد الإمبوستر التلقائي: $imposterCount (يتم تحديدهم عشوائياً)',
                style: const TextStyle(color: Colors.amberAccent, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                const Text('👑 مين الـ Host (صاحب الهوتسبوت)؟ ', style: TextStyle(fontSize: 15)),
                DropdownButton<int>(
                  value: hostIndex,
                  dropdownColor: const Color(0xFF3B0764),
                  items: List.generate(
                    playerControllers.length,
                    (i) => DropdownMenuItem(value: i, child: Text(playerControllers[i].text.isEmpty ? 'لاعب ${i + 1}' : playerControllers[i].text)),
                  ),
                  onChanged: (val) => setState(() => hostIndex = val!),
                ),
              ],
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B5CF6),
                minimumSize: const Size.fromHeight(55),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              onPressed: () {
                int rooms = int.tryParse(roomCountController.text) ?? 2;
                if (rooms < 2) rooms = 2;

                List<String> names = playerControllers.map((e) => e.text).toList();
                
                // اختيار الإمبوسترز عشوائياً بالكامل
                List<int> imposterIndices = [];
                final random = Random();
                while (imposterIndices.length < imposterCount) {
                  int randIndex = random.nextInt(names.length);
                  if (!imposterIndices.contains(randIndex)) {
                    imposterIndices.add(randIndex);
                  }
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LocalLobbyWaitingScreen(
                      playerNames: names,
                      roomCount: rooms,
                      hostIndex: hostIndex,
                      imposterIndices: imposterIndices,
                    ),
                  ),
                );
              },
              child: const Text('دخول اللوبي أوفلاين (Hotspot) 📡', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

class LocalLobbyWaitingScreen extends StatefulWidget {
  final List<String> playerNames;
  final int roomCount;
  final int hostIndex;
  final List<int> imposterIndices;

  const LocalLobbyWaitingScreen({
    super.key,
    required this.playerNames,
    required this.roomCount,
    required this.hostIndex,
    required this.imposterIndices,
  });

  @override
  State<LocalLobbyWaitingScreen> createState() => _LocalLobbyWaitingScreenState();
}

class _LocalLobbyWaitingScreenState extends State<LocalLobbyWaitingScreen> {
  int countdown = 3;
  Timer? lobbyTimer;

  @override
  void initState() {
    super.initState();
    lobbyTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown > 1) {
        setState(() => countdown--);
      } else {
        timer.cancel();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainGameRoomScreen(
              playerNames: widget.playerNames,
              roomCount: widget.roomCount,
              hostIndex: widget.hostIndex,
              imposterIndices: widget.imposterIndices,
            ),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    lobbyTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: Color(0xFFA7F3D0)),
            const SizedBox(height: 25),
            const Text(
              'جاري الاتصال باللاعبين عبر الهوتسبوت (Hotspot)...',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'الداخلون: ${widget.playerNames.join(', ')}',
              style: const TextStyle(color: Color(0xFFDDD6FE)),
            ),
            const SizedBox(height: 20),
            Text(
              'بدء اللعبة خلال $countdown ثواني...',
              style: const TextStyle(fontSize: 22, color: Colors.amberAccent, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class MainGameRoomScreen extends StatefulWidget {
  final List<String> playerNames;
  final int roomCount;
  final int hostIndex;
  final List<int> imposterIndices;

  const MainGameRoomScreen({
    super.key,
    required this.playerNames,
    required this.roomCount,
    required this.hostIndex,
    required this.imposterIndices,
  });

  @override
  State<MainGameRoomScreen> createState() => _MainGameRoomScreenState();
}

class _MainGameRoomScreenState extends State<MainGameRoomScreen> {
  int currentPlayerIndex = 0;
  List<String> assignedTasks = [];
  String currentInstruction = 'جاري توجيهك...';
  Timer? promptTimer;
  
  // نظام السابوتاج
  bool isSabotageActive = false;
  String sabotageRoom = '';
  int sabotageTimerSeconds = 10; // المهلة الكلية 10 ثواني للتصليح وإلا الخسارة
  Timer? sabotageTimer;

  @override
  void initState() {
    super.initState();
    generateFiveTasks();
    start3SecPromptLoop();
    playVoice('أنا جيت!');
  }

  void generateFiveTasks() {
    final random = Random();
    List<String> taskTypes = ['صلح السلك', 'امسح البصمات', 'نزل الملفات', 'شغل المولد'];
    assignedTasks.clear();

    for (int i = 0; i < 5; i++) {
      int roomNum = random.nextInt(widget.roomCount) + 1;
      String roomName = roomNum == 1 ? 'المطبخ' : (roomNum == 2 ? 'الريسبشن' : 'الأوضة رقم $roomNum');
      String task = taskTypes[random.nextInt(taskTypes.length)];
      assignedTasks.add('روح $roomName واعمل: $task');
    }
  }

  void start3SecPromptLoop() {
    final random = Random();
    promptTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (assignedTasks.isNotEmpty && !isSabotageActive) {
        setState(() {
          int randomIndex = random.nextInt(assignedTasks.length);
          currentInstruction = '📢 توجيه جديد: ${assignedTasks[randomIndex]} (المدة أقصاها 10 ثواني)';
        });
      }
    });
  }

  void startSabotage(String selectedRoom) {
    setState(() {
      isSabotageActive = true;
      sabotageRoom = selectedRoom;
      sabotageTimerSeconds = 10;
    });

    playVoice('عملت سابوتاج في $selectedRoom! قدامكم 10 ثواني تصليح!');

    sabotageTimer?.cancel();
    sabotageTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (sabotageTimerSeconds > 1) {
        setState(() => sabotageTimerSeconds--);
      } else {
        timer.cancel();
        setState(() => isSabotageActive = false);
        playVoice('يا لوزر يا لوزر! محدش صلح السابوتاج وكسب الإمبوستر!');
      }
    });
  }

  void fixSabotage() {
    sabotageTimer?.cancel();
    setState(() {
      isSabotageActive = false;
    });
    playVoice('تم إبطال السابوتاج بنجاح!');
  }

  void playVoice(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🔊 $text', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF8B5CF6),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void triggerEmergencyMeeting() {
    playVoice('يا دي النيلة! إيه اللي حصل؟');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF3B0764),
        title: const Text('🚨 اجتماااع طارئ! 🚨'),
        content: const Text('في حد داس على الميتينج أو لقى جثة! اتجمعوا واتناقشوا.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              playVoice('يا دي النيلة... طلع بريء!');
            },
            child: const Text('طردنا واحد بريء', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (widget.imposterIndices.contains(currentPlayerIndex)) {
                playVoice('يا لوزر يا لوزر!');
              } else {
                playVoice('وكسبناااا وكسبناااا!');
              }
            },
            child: const Text('كشفنا الإمبوستر!', style: TextStyle(color: Colors.amber)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    promptTimer?.cancel();
    sabotageTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isHost = currentPlayerIndex == widget.hostIndex;
    bool isImposter = widget.imposterIndices.contains(currentPlayerIndex);
    String playerName = widget.playerNames[currentPlayerIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('$playerName (${isImposter ? 'Imposter 😈' : 'Crewmate 👨‍🚀'})'),
        backgroundColor: isImposter ? Colors.red.shade900 : const Color(0xFF3B0764),
        actions: [
          DropdownButton<int>(
            value: currentPlayerIndex,
            dropdownColor: const Color(0xFF3B0764),
            items: List.generate(
              widget.playerNames.length,
              (i) => DropdownMenuItem(value: i, child: Text('تبديل لـ: ${widget.playerNames[i]}')),
            ),
            onChanged: (val) {
              setState(() {
                currentPlayerIndex = val!;
                generateFiveTasks();
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (isHost) ...[
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, minimumSize: const Size.fromHeight(48)),
                icon: const Icon(Icons.warning, color: Colors.white),
                label: const Text('EMERGENCY MEETING (الهوست بس)', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
                onPressed: triggerEmergencyMeeting,
              ),
              const SizedBox(height: 10),
            ],

            if (isSabotageActive) ...[
              Container(
                padding: const EdgeInsets.all(12),
                color: Colors.red.shade900,
                child: Column(
                  children: [
                    Text('🚨 سابوتاج شغال في $sabotageRoom!', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Text('باقي: $sabotageTimerSeconds ثواني!', style: const TextStyle(fontSize: 20, color: Colors.yellowAccent, fontWeight: FontWeight.bold)),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      onPressed: fixSabotage,
                      child: const Text('أنا في الأوضة ودست إبطال السابوتاج!'),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],

            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF4C1D95),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                currentInstruction,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFFA7F3D0)),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 10),

            if (!isImposter) ...[
              const Text('📋 5 مهام مخصصة لك:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Expanded(
                child: ListView.builder(
                  itemCount: assignedTasks.length,
                  itemBuilder: (context, idx) {
                    return Card(
                      color: const Color(0xFF3B0764),
                      child: ListTile(
                        title: Text(assignedTasks[idx]),
                        trailing: IconButton(
                          icon: const Icon(Icons.check_circle, color: Colors.greenAccent),
                          onPressed: () => setState(() => assignedTasks.removeAt(idx)),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],

            if (isImposter) ...[
              Expanded(
                child: Card(
                  color: const Color(0xFF31103F),
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Column(
                      children: [
                        const Text('😈 لوحة الإمبوستر', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.redAccent)),
                        const SizedBox(height: 10),
                        const Text('اختر غرق السابوتاج (مدة التنفيذ أقصاها 5 ثواني):'),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: List.generate(widget.roomCount, (index) {
                            String rName = (index + 1) == 1 ? 'المطبخ' : ((index + 1) == 2 ? 'الريسبشن' : 'الأوضة ${index + 1}');
                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF581C87)),
                              onPressed: () => startSabotage(rName),
                              child: Text('سابوتاج $rName'),
                            );
                          }),
                        ),
                        const SizedBox(height: 15),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8B0000), minimumSize: const Size.fromHeight(45)),
                          icon: const Icon(Icons.person_remove, color: Colors.white),
                          label: const Text('قتل لاعب (عند اللمس)', style: TextStyle(color: Colors.white)),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                TextEditingController victimController = TextEditingController();
                                return AlertDialog(
                                  backgroundColor: const Color(0xFF3B0764),
                                  title: const Text('قتل شخص حقيقي'),
                                  content: TextField(
                                    controller: victimController,
                                    decoration: const InputDecoration(hintText: 'اكتب اسم الشخص'),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        playVoice('قتلت ${victimController.text}! ينزل على الأرض فوراً!');
                                      },
                                      child: const Text('تأكيد 💀', style: TextStyle(color: Colors.redAccent)),
                                    )
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],

            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, minimumSize: const Size.fromHeight(48)),
              icon: const Icon(Icons.campaign),
              label: const Text('لقيت جثة! (Report)', style: TextStyle(fontSize: 16)),
              onPressed: triggerEmergencyMeeting,
            ),
          ],
        ),
      ),
    );
  }
}
