import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() {
  runApp(const RealImposterApp());
}

class RealImposterApp extends StatelessWidget {
  const RealImposterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Real Imposter EG',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        cardColor: const Color(0xFF1E293B),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF10B981),
          brightness: Brightness.dark,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _currentUser;

  String userName = "Youssef Aly";
  String? userPhotoUrl;
  final TextEditingController _codeJoinController = TextEditingController();

  final List<String> quotes = [
    "🔥 أنا جيت.. أنا جيت!",
    "⚽ باصي بارتي يا معلم!",
    "🦀 مين اللي بلع الكابوريا؟",
    "👀 فيه واحد امبوستر بينّا هنا!",
    "🚨 يا لهوييييي!"
  ];

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
        if (account != null) {
          userName = account.displayName ?? "Youssef Aly";
          userPhotoUrl = account.photoUrl;
        }
      });
    });
    _googleSignIn.signInSilently();
  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل تسجيل الدخول: $error')),
      );
    }
  }

  Future<void> _handleSignOut() => _googleSignIn.disconnect();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // الهيدر الحديث مع زرار Google Sign In
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: _currentUser == null ? _handleSignIn : _handleSignOut,
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: const Color(0xFF10B981),
                          backgroundImage: userPhotoUrl != null ? NetworkImage(userPhotoUrl!) : null,
                          child: userPhotoUrl == null
                              ? Text(
                                  userName.isNotEmpty ? userName[0].toUpperCase() : "Y",
                                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                                )
                              : null,
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAlignment.start,
                          children: [
                            Text(userName, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                            Text(
                              _currentUser != null ? "مُسجل بحساب Google" : "اضغط للتسجيل بجوجل 🔑",
                              style: TextStyle(
                                color: _currentUser != null ? Colors.greenAccent : Colors.amber,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(20)),
                    child: const Row(
                      children: [
                        Icon(Icons.bolt, color: Colors.amber, size: 18),
                        SizedBox(width: 4),
                        Text("100%", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),

              // شريط إفيهات متحرك عشوائي
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF334155),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  (quotes..shuffle()).first,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),

              const Spacer(),

              // اللوجو الرئيسي
              const Column(
                children: [
                  Icon(Icons.radar, size: 70, color: Color(0xFF10B981)),
                  SizedBox(height: 10),
                  Text(
                    "REAL IMPOSTER",
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 2),
                  ),
                  Text("النسخة المصرية Real-Life", style: TextStyle(color: Colors.white54, fontSize: 13)),
                ],
              ),

              const Spacer(),

              // زر تسجيل دخول جوجل بارز لو مش مسجل
              if (_currentUser == null) ...[
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    side: const BorderSide(color: Colors.white70),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  onPressed: _handleSignIn,
                  icon: const Icon(Icons.login, color: Colors.white),
                  label: const Text("تسجيل الدخول بواسطة Google", style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
                const SizedBox(height: 12),
              ],

              // أزرار القائمة
              _customButton(
                title: "إنشاء روم جديدة 🚀",
                color: const Color(0xFF10B981),
                icon: Icons.add_circle_outline,
                onTap: () {
                  String newCode = (Random().nextInt(899999) + 100000).toString();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RoomScreen(
                        playerName: userName,
                        photoUrl: userPhotoUrl,
                        roomCode: newCode,
                        isHost: true,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),

              _customButton(
                title: "دخول بكود الغرفة 🔑",
                color: const Color(0xFF3B82F6),
                icon: Icons.key,
                onTap: () => _showJoinDialog(),
              ),
              const SizedBox(height: 12),

              _customButton(
                title: "بحث عن روم قريبة (Local Wi-Fi) 📡",
                color: const Color(0xFF8B5CF6),
                icon: Icons.wifi,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RoomScreen(
                        playerName: userName,
                        photoUrl: userPhotoUrl,
                        roomCode: "LOCAL-NET",
                        isHost: false,
                      ),
                    ),
                  );
                },
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _customButton({required String title, required Color color, required IconData icon, required VoidCallback onTap}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        minimumSize: const Size(double.infinity, 55),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 4,
      ),
      onPressed: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 10),
          Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white)),
        ],
      ),
    );
  }

  void _showJoinDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('ادخل كود الروم', textAlign: TextAlign.center),
        content: TextField(
          controller: _codeJoinController,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 26, letterSpacing: 3, color: Color(0xFF10B981)),
          decoration: const InputDecoration(hintText: '981228', border: OutlineInputBorder()),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (_codeJoinController.text.isNotEmpty) {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RoomScreen(
                      playerName: userName,
                      photoUrl: userPhotoUrl,
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

// ==================== شاشة الروم ====================
class RoomScreen extends StatefulWidget {
  final String playerName;
  final String? photoUrl;
  final String roomCode;
  final bool isHost;

  const RoomScreen({
    super.key,
    required this.playerName,
    this.photoUrl,
    required this.roomCode,
    required this.isHost,
  });

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  final List<String> soundEffects = [
    "🔥 أنا جيت.. أنا جيت!",
    "⚽ باصي بارتي!",
    "🦀 مين بلع الكابوريا؟",
    "🏃‍♂️ اخلع يا جدع!",
    "😱 يا لهوييييي!"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('غرفة الانتظار'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // كارت الكود
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF10B981), width: 2),
              ),
              child: Column(
                children: [
                  const Text('كود الغرفة الخاص بك', style: TextStyle(color: Colors.white70, fontSize: 13)),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.roomCode,
                        style: const TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: Color(0xFF10B981)),
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        icon: const Icon(Icons.copy, color: Colors.amber),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: widget.roomCode));
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم نسخ كود الروم!')));
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),

            // قائمة اللعيبة
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: const Color(0xFF10B981),
                    backgroundImage: widget.photoUrl != null ? NetworkImage(widget.photoUrl!) : null,
                    child: widget.photoUrl == null
                        ? Text(
                            widget.playerName.isNotEmpty ? widget.playerName[0].toUpperCase() : "Y",
                            style: const TextStyle(color: Colors.white),
                          )
                        : null,
                  ),
                  const SizedBox(width: 10),
                  Text(widget.playerName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  if (widget.isHost) ...[
                    const SizedBox(width: 6),
                    const Icon(Icons.star, color: Colors.amber, size: 18),
                    const Text(" (صاحب الروم)", style: TextStyle(color: Colors.amber, fontSize: 12))
                  ]
                ],
              ),
            ),
            const SizedBox(height: 20),

            // لوحة الإفيهات
            const Align(
              alignment: Alignment.centerRight,
              child: Text('🎭 بنك الإفيهات (اضغط لإرسال صوت):', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.cyanAccent)),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: soundEffects.map((quote) {
                return ActionChip(
                  backgroundColor: const Color(0xFF334155),
                  label: Text(quote, style: const TextStyle(color: Colors.white)),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('📣 $quote'), duration: const Duration(seconds: 1)),
                    );
                  },
                );
              }).toList(),
            ),

            const Spacer(),

            if (widget.isHost)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('بدأت اللعبة وتوزيع المهام! 🚀')));
                },
                child: const Text('بدء اللعبة 🚀', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              )
          ],
        ),
      ),
    );
  }
}
