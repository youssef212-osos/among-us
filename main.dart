import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() {
  runApp(const ImposterApp());
}

class ImposterApp extends StatelessWidget {
  const ImposterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Imposter Real-Life',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        colorScheme: const ColorScheme.dark(
          primary: Colors.redAccent,
          secondary: Colors.cyanAccent,
        ),
      ),
      home: const LoginScreen(),
    );
  }
}

// ==================== 1. شاشة تسجيل الدخول واليوزر نيم ====================
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  void _proceedToLobby() {
    if (_usernameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('برجاء كتابة اسم المستخدم أولاً!')),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MainMenuScreen(username: _usernameController.text.trim()),
      ),
    );
  }

  Future<void> _handleGoogleSignIn() async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account != null) {
        setState(() {
          _usernameController.text = account.displayName ?? "Player_Google";
        });
        _proceedToLobby();
      }
    } catch (error) {
      debugPrint("خطأ في تسجيل الدخول بجوجل: $error");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تعذر تسجيل الدخول بحساب Google: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.security, size: 90, color: Colors.redAccent),
              const SizedBox(height: 10),
              const Text(
                'IMPOSTER',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3,
                  color: Colors.redAccent,
                ),
              ),
              const Text('Real-Life Edition', style: TextStyle(color: Colors.grey, fontSize: 16)),
              const SizedBox(height: 40),

              // خانة إدخال اليوزر نيم
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'اسم اللاعب (Username)',
                  prefixIcon: const Icon(Icons.person, color: Colors.cyanAccent),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                  filled: true,
                  fillColor: const Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 20),

              // زرار الدخول السريع
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _proceedToLobby,
                  child: const Text('دخول اللعبة', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 15),

              // زرار تسجيل الدخول بجوجل
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white38),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.g_mobiledata, size: 30, color: Colors.white),
                  label: const Text('تسجيل الدخول بحساب Google', style: TextStyle(color: Colors.white)),
                  onPressed: _handleGoogleSignIn,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== 2. القائمة الرئيسية (Host / Join) ====================
class MainMenuScreen extends StatelessWidget {
  final String username;
  const MainMenuScreen({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('أهلاً بك، $username'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              color: const Color(0xFF1E293B),
              child: ListTile(
                leading: const CircleAvatar(backgroundColor: Colors.redAccent, child: Icon(Icons.person, color: Colors.white)),
                title: Text(username, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                subtitle: const Text('الحالة: متصل (Ready)', style: TextStyle(color: Colors.greenAccent)),
              ),
            ),
            const SizedBox(height: 40),

            // إنشاء غرفة
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                icon: const Icon(Icons.add_circle, color: Colors.white, size: 28),
                label: const Text('إنشاء غرفة (Host)', style: TextStyle(fontSize: 20, color: Colors.white)),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => HostScreen(hostName: username)));
                },
              ),
            ),
            const SizedBox(height: 20),

            // انضمام لغرفة
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                icon: const Icon(Icons.qr_code_scanner, color: Colors.white, size: 28),
                label: const Text('انضمام لغرفة (Join)', style: TextStyle(fontSize: 20, color: Colors.white)),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => ScannerScreen(playerName: username)));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== 3. شاشة الهوست (Host Room) ====================
class HostScreen extends StatefulWidget {
  final String hostName;
  const HostScreen({super.key, required this.hostName});

  @override
  State<HostScreen> createState() => _HostScreenState();
}

class _HostScreenState extends State<HostScreen> {
  String localIp = '192.168.43.1'; // IP افتراضي للهوتسبوت
  ServerSocket? server;
  List<String> connectedPlayers = [];

  @override
  void initState() {
    super.initState();
    connectedPlayers.add("${widget.hostName} (الأدمن)");
    _setupServer();
  }

  Future<void> _setupServer() async {
    if (!kIsWeb) {
      try {
        final info = NetworkInfo();
        final ip = await info.getWifiIP();
        if (ip != null && ip.isNotEmpty) {
          setState(() {
            localIp = ip;
          });
        }
        server = await ServerSocket.bind(InternetAddress.anyIPv4, 8080);
        server!.listen((Socket client) {
          setState(() {
            connectedPlayers.add("لاعب جديد (${client.remoteAddress.address})");
          });
        });
      } catch (e) {
        debugPrint("خطأ السيرفر: $e");
      }
    }
  }

  @override
  void dispose() {
    server?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('غرفة التحكم (Host)')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.wifi_tethering, color: Colors.orangeAccent),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text('افتَح الهوتسبوت (Hotspot) واطلب من أصحابك الاتصال به للانضمام.', style: TextStyle(fontSize: 13)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // كود الـ QR
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(12),
              child: QrImageView(
                data: localIp,
                version: QrVersions.auto,
                size: 180.0,
              ),
            ),
            const SizedBox(height: 10),
            Text('IP الغرفة: $localIp', style: const TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('اللاعبون المنضمون:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Chip(label: Text('${connectedPlayers.length} / 10'), backgroundColor: Colors.redAccent),
              ],
            ),
            const Divider(),

            Expanded(
              child: ListView.builder(
                itemCount: connectedPlayers.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: const Color(0xFF1E293B),
                    child: ListTile(
                      leading: const Icon(Icons.sports_esports, color: Colors.cyanAccent),
                      title: Text(connectedPlayers[index]),
                      trailing: index == 0 ? const Chip(label: Text('HOST'), backgroundColor: Colors.amber) : null,
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

// ==================== 4. شاشة الماسح (Join Room) ====================
class ScannerScreen extends StatefulWidget {
  final String playerName;
  const ScannerScreen({super.key, required this.playerName});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  bool isConnected = false;

  void _connectToHost(String hostIp) async {
    try {
      final socket = await Socket.connect(hostIp, 8080, timeout: const Duration(seconds: 5));
      setState(() {
        isConnected = true;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تأكد من الاتصال بهوتسبوت الأدمن أولاً!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('مسح كود الانضمام')),
      body: isConnected
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, color: Colors.greenAccent, size: 90),
                  SizedBox(height: 20),
                  Text('تم الانضمام للغرفة بنجاح!', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text('في انتظار بدء الأدمن للعبة...', style: TextStyle(color: Colors.grey)),
                ],
              ),
            )
          : kIsWeb
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('الكاميرا تعمل على الهواتف فقط.'),
                      const SizedBox(height: 15),
                      ElevatedButton(
                        onPressed: () => _connectToHost('127.0.0.1'),
                        child: const Text('تجربة اتصال وهمي (Test)'),
                      )
                    ],
                  ),
                )
              : MobileScanner(
                  onDetect: (capture) {
                    final List<Barcode> barcodes = capture.barcodes;
                    for (final barcode in barcodes) {
                      if (barcode.rawValue != null) {
                        _connectToHost(barcode.rawValue!);
                        break;
                      }
                    }
                  },
                ),
    );
  }
}