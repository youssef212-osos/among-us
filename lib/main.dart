import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
        primaryColor: const Color(0xFF6366F1),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E293B),
          elevation: 0,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

// ==================== 1. الشاشة الرئيسية ====================
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('🤫', style: TextStyle(fontSize: 80)),
              const SizedBox(height: 10),
              const Text(
                'Imposter Alive',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.redAccent, letterSpacing: 1.5),
              ),
              const SizedBox(height: 5),
              const Text('مين الإمبوستر بينّا؟', style: TextStyle(color: Colors.white54, fontSize: 16)),
              const SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6366F1),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateRoomScreen()));
                },
                child: const Text('إنشاء روم جديدة 🎮', style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
              const SizedBox(height: 15),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  side: const BorderSide(color: Color(0xFF6366F1)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const JoinRoomScreen()));
                },
                child: const Text('الانضمام لروم 🔑', style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== 2. شاشة إنشاء روم ====================
class CreateRoomScreen extends StatefulWidget {
  const CreateRoomScreen({super.key});

  @override
  State<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  final TextEditingController _categoryController = TextEditingController(text: 'أفلام عربية');
  int _playerCount = 4;
  int _roomsCount = 3;
  bool _hasReception = true;

  @override
  Widget build(BuildContext context) {
    int minRooms = _hasReception ? 2 : 3;
    int maxRooms = 5;

    return Scaffold(
      appBar: AppBar(title: const Text('إعدادات الروم ⚙️')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('موضوع الكلمة (الفئة):', style: TextStyle(fontSize: 16, color: Colors.white70)),
              const SizedBox(height: 8),
              TextField(
                controller: _categoryController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFF1E293B),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 20),

              // تحديد عدد اللاعبين
              Text('كام واحد هيلعب؟ ($_playerCount لاعبين)', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.cyanAccent)),
              Slider(
                value: _playerCount.toDouble(),
                min: 3,
                max: 12,
                divisions: 9,
                activeColor: const Color(0xFF6366F1),
                label: '$_playerCount',
                onChanged: (val) {
                  setState(() => _playerCount = val.toInt());
                },
              ),
              const Divider(color: Colors.white24, height: 30),

              // إعدادات الخريطة والمكان
              const Text('🏢 إعدادات المكان:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.amber)),
              const SizedBox(height: 10),

              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SwitchListTile(
                  title: const Text('هل يوجد رسبشن؟ 🛋️', style: TextStyle(color: Colors.white)),
                  subtitle: Text(
                    _hasReception ? 'موجود (أقل عدد غرف 2)' : 'غير موجود (أقل عدد غرف 3)',
                    style: const TextStyle(color: Colors.white54, fontSize: 13),
                  ),
                  value: _hasReception,
                  activeColor: const Color(0xFF6366F1),
                  onChanged: (val) {
                    setState(() {
                      _hasReception = val;
                      if (!_hasReception && _roomsCount < 3) {
                        _roomsCount = 3;
                      }
                    });
                  },
                ),
              ),
              const SizedBox(height: 15),

              Text('عدد الغرف: $_roomsCount غرف', style: const TextStyle(fontSize: 16, color: Colors.white70)),
              Slider(
                value: _roomsCount.toDouble().clamp(minRooms.toDouble(), maxRooms.toDouble()),
                min: minRooms.toDouble(),
                max: maxRooms.toDouble(),
                divisions: maxRooms - minRooms,
                activeColor: const Color(0xFF22C55E),
                label: '$_roomsCount',
                onChanged: (val) {
                  setState(() => _roomsCount = val.toInt());
                },
              ),

              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF22C55E),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LobbyScreen(
                        roomCode: '7892',
                        category: _categoryController.text,
                        playerCount: _playerCount,
                        roomsCount: _roomsCount,
                        hasReception: _hasReception,
                      ),
                    ),
                  );
                },
                child: const Text('تأكيد وبدء الروم 🚀', style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== 3. شاشة الانضمام ====================
class JoinRoomScreen extends StatelessWidget {
  const JoinRoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController codeController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('انضمام لروم 🔑')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: codeController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, letterSpacing: 4),
              decoration: InputDecoration(
                hintText: 'أدخل كود الروم (مثلاً 7892)',
                filled: true,
                fillColor: const Color(0xFF1E293B),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6366F1),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                if (codeController.text.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LobbyScreen(
                        roomCode: codeController.text,
                        category: 'أفلام عربية',
                        playerCount: 4,
                        roomsCount: 3,
                        hasReception: true,
                      ),
                    ),
                  );
                }
              },
              child: const Text('دخول 🚪', style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== 4. غرف الانتظار (Lobby) ====================
class LobbyScreen extends StatelessWidget {
  final String roomCode;
  final String category;
  final int playerCount;
  final int roomsCount;
  final bool hasReception;

  const LobbyScreen({
    super.key,
    required this.roomCode,
    required this.category,
    required this.playerCount,
    required this.roomsCount,
    required this.hasReception,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> players = [
      {"name": "أحمد", "avatar": "🦊", "isImposter": "false"},
      {"name": "سارة", "avatar": "🐱", "isImposter": "false"},
      {"name": "يوسف", "avatar": "🦁", "isImposter": "true"},
      {"name": "عمر", "avatar": "🐼", "isImposter": "false"},
    ];

    return Scaffold(
      appBar: AppBar(title: Text('روم #$roomCode 📌'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('الفئة: $category', style: const TextStyle(fontSize: 15, color: Colors.amber)),
                      Text('الرمز: $roomCode', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const Divider(color: Colors.white24, height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('اللاعبين المطلوبين: $playerCount 👥', style: const TextStyle(color: Colors.cyanAccent)),
                      Text('الغرف: $roomsCount 🚪', style: const TextStyle(color: Colors.white70)),
                      Text('رسبشن: ${hasReception ? "نعم 🛋️" : "لا ❌"}', style: const TextStyle(color: Colors.white70)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerRight,
              child: Text('اللاعبون المتواجدون:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: players.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: const Color(0xFF1E293B),
                    child: ListTile(
                      leading: Text(players[index]["avatar"]!, style: const TextStyle(fontSize: 28)),
                      title: Text(players[index]["name"]!, style: const TextStyle(color: Colors.white)),
                      trailing: index == 0
                          ? const Chip(label: Text('الهوست 👑'), backgroundColor: Colors.amber)
                          : const Icon(Icons.check_circle, color: Colors.green),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEC4899),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RevealWordScreen(players: players),
                  ),
                );
              },
              child: const Text('كشف الكلمة والدور 🃏', style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== 5. شاشة كشف الكلمة ====================
class RevealWordScreen extends StatefulWidget {
  final List<Map<String, String>> players;
  const RevealWordScreen({super.key, required this.players});

  @override
  State<RevealWordScreen> createState() => _RevealWordScreenState();
}

class _RevealWordScreenState extends State<RevealWordScreen> {
  bool _isSecretRevealed = false;
  final bool _isCurrentUserImposter = true;
  final String _secretWord = "الناظر";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('بطاقتك السرية 🤫')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('اضغط لمعرفة دورك في هذه الجولة', style: TextStyle(fontSize: 18, color: Colors.white70)),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isSecretRevealed = !_isSecretRevealed;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: _isSecretRevealed
                        ? (_isCurrentUserImposter ? Colors.red.shade900 : Colors.indigo.shade900)
                        : const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white24, width: 2),
                  ),
                  child: Center(
                    child: _isSecretRevealed
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _isCurrentUserImposter ? '😈 أنت الإمبوستر!' : '🔑 الكلمة هي:',
                                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.amber),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                _isCurrentUserImposter ? 'حاول الخداع ولا تتكشف!' : _secretWord,
                                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ],
                          )
                        : const Text('اضغط للكشف 👆', style: TextStyle(fontSize: 22, color: Colors.white54)),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEF4444),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VotingScreen(players: widget.players),
                    ),
                  );
                },
                child: const Text('الانتقال للتصويت 🗳️', style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== 6. شاشة التصويت والنتيجة ====================
class VotingScreen extends StatefulWidget {
  final List<Map<String, String>> players;
  const VotingScreen({super.key, required this.players});

  @override
  State<VotingScreen> createState() => _VotingScreenState();
}

class _VotingScreenState extends State<VotingScreen> {
  void _submitVote(Map<String, String> player) {
    bool isImposter = player["isImposter"] == "true";

    HapticFeedback.vibrate();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.volume_up, color: Colors.amber),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                isImposter ? '📢 صوت مرتفع: "يا لوزر يا لوزر! 🤪🔥"' : '📢 صوت مرتفع: "يادي النيلة! طلع مظلوم! 😱"',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        ),
        backgroundColor: isImposter ? Colors.green.shade800 : Colors.red.shade900,
        duration: const Duration(seconds: 3),
      ),
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: Text(
          isImposter ? "🤪 يا لوزر يا لوزر! 🎉" : "😱 يادي النيلة! طلع مظلوم!",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: isImposter ? Colors.greenAccent : Colors.redAccent,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(player["avatar"]!, style: const TextStyle(fontSize: 60)),
            const SizedBox(height: 10),
            Text(
              isImposter
                  ? "عاش يا أبطال! اتكشف ومشينا بنقوله: (يا لوزر يا لوزر!) 🤪💥"
                  : "للأسف ${player["name"]} بريء والامبوستر ضحك عليكم وكسب الجولة! 😈",
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70, fontSize: 15),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text("العودة للروم 🔄", style: TextStyle(color: Colors.cyanAccent, fontSize: 16)),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تصويت الاجتماع الطارئ 🗳️'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text('من المشتبه به كـ Imposter؟', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 15),
            Expanded(
              child: ListView.builder(
                itemCount: widget.players.length,
                itemBuilder: (context, index) {
                  final player = widget.players[index];
                  return Card(
                    color: const Color(0xFF1E293B),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      leading: Text(player["avatar"]!, style: const TextStyle(fontSize: 26)),
                      title: Text(player["name"]!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      trailing: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFDC2626)),
                        onPressed: () => _submitVote(player),
                        child: const Text('تصويت 🗳️', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
