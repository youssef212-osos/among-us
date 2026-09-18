import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const BuzzyStyleImposterApp());
}

class BuzzyStyleImposterApp extends StatelessWidget {
  const BuzzyStyleImposterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Real Imposter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF130A2A),
        cardColor: const Color(0xFF221545),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF8B5CF6),
          brightness: Brightness.dark,
        ),
      ),
      home: const BuzzyHomeScreen(),
    );
  }
}

class BuzzyHomeScreen extends StatefulWidget {
  const BuzzyHomeScreen({super.key});

  @override
  State<BuzzyHomeScreen> createState() => _BuzzyHomeScreenState();
}

class _BuzzyHomeScreenState extends State<BuzzyHomeScreen> {
  String userName = "Youssef Aly";
  String profilePicLetter = "Y";
  final TextEditingController _codeJoinController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
          child: Column(
            children: [
              // الهيدر العلوي (الأكونت والنقاط)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.green,
                        child: Text(
                          profilePicLetter,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAlignment.start,
                        children: [
                          Text(
                            userName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Row(
                            children: [
                              Icon(Icons.monetization_on, color: Colors.amber, size: 16),
                              SizedBox(width: 4),
                              Text("425", style: TextStyle(color: Colors.amber, fontSize: 13)),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      _topIconButton(Icons.storefront, "المتجر"),
                      const SizedBox(width: 8),
                      _topIconButton(Icons.assignment, "المهام"),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 35),

              // اللوجو الرئيسي اللطيف
              const Text(
                "REAL\nIMPOSTER",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.black,
                  color: Color(0xFFFFB703),
                  shadows: [
                    Shadow(offset: Offset(0, 4), color: Colors.black80, blurRadius: 8),
                  ],
                ),
              ),

              const Spacer(),

              // أزرار القائمة الرئيسية على طريقة باظي بارتي
              _menuButton(
                title: "إنشاء لعبة",
                color: const Color(0xFF8B5CF6),
                icon: Icons.gavel,
                onTap: () {
                  String newRoomCode = (Random().nextInt(899999) + 100000).toString();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RoomLobbyScreen(
                        playerName: userName,
                        roomCode: newRoomCode,
                        isHost: true,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 14),

              _menuButton(
                title: "ادخل لعبة (الكود)",
                color: const Color(0xFFFB8500),
                icon: Icons.touch_app,
                onTap: () => _showJoinCodeDialog(),
              ),
              const SizedBox(height: 14),

              _menuButton(
                title: "بحث محلي (Local)",
                color: const Color(0xFF2A9D8F),
                icon: Icons.wifi_find,
                onTap: () {
                  // دخول تلقائي للهوست القريب
                },
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _topIconButton(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF221545),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.white70),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(fontSize: 11)),
        ],
      ),
    );
  }

  Widget _menuButton({required String title, required Color color, required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white24,
              child: Icon(icon, color: Colors.white),
            ),
            const SizedBox(width: 15),
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.white70),
          ],
        ),
      ),
    );
  }

  void _showJoinCodeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF221545),
        title: const Text('ادخل كود اللعبة المكون من 6 أرقام', textAlign: TextAlign.center),
        content: TextField(
          controller: _codeJoinController,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 24, letterSpacing: 4, color: Colors.amber),
          decoration: const InputDecoration(
            hintText: '469939',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (_codeJoinController.text.length == 6) {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RoomLobbyScreen(
                      playerName: userName,
                      roomCode: _codeJoinController.text,
                      isHost: false,
                    ),
                  ),
                );
              }
            },
            child: const Text('انضمام', style: TextStyle(fontSize: 18, color: Colors.greenAccent)),
          )
        ],
      ),
    );
  }
}

// ==================== واجهة الروم الشبيهة بـ باظي بارتي ====================
class RoomLobbyScreen extends StatelessWidget {
  final String playerName;
  final String roomCode;
  final bool isHost;

  const RoomLobbyScreen({
    super.key,
    required this.playerName,
    required this.roomCode,
    required this.isHost,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('كيفية اللعب'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // كارت نوع الجيم العلوي
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF221545),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.amber.withOpacity(0.5)),
              ),
              child: const Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.deepPurple,
                    child: Icon(Icons.sports_esports, color: Colors.amber),
                  ),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAlignment.start,
                    children: [
                      Text('على مزاج الحكم', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Text('مهام حقيقية بالبيت واجتماعات طارئة', style: TextStyle(fontSize: 12, color: Colors.white60)),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),

            // كود اللعبة
            const Text('كود اللعبة', style: TextStyle(fontSize: 16, color: Colors.white70)),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              decoration: BoxDecoration(
                color: const Color(0xFF1B0E3B),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: const Color(0xFFFB8500), width: 2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    roomCode,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFB8500),
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(width: 15),
                  IconButton(
                    icon: const Icon(Icons.copy, color: Colors.amber),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: roomCode));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('تم نسخ كود اللعبة!')),
                      );
                    },
                  )
                ],
              ),
            ),
            const SizedBox(height: 15),

            // زرار دعوة الأصدقاء
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFB8500),
                minimumSize: const Size(double.infinity, 45),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {},
              icon: const Icon(Icons.person_add),
              label: const Text('دعوة الأصدقاء', style: TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 20),

            // بطاقات اللاعبين المنضمين
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF221545),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Text('Y', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(playerName, style: const TextStyle(fontWeight: FontWeight.bold)),
                          if (isHost) const Icon(Icons.star, color: Colors.amber, size: 16),
                        ],
                      ),
                      Text(isHost ? "أنت صاحب الجيم" : "لاعب منضم", style: const TextStyle(fontSize: 12, color: Colors.white54)),
                    ],
                  )
                ],
              ),
            ),
            const Spacer(),

            // زرار بدء الجيم
            if (isHost)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('بدأت اللعبة وتوزيع الأدوار! 🚀')),
                  );
                },
                child: const Text('بدء اللعبة 🚀', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              )
          ],
        ),
      ),
    );
  }
}
