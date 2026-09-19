import 'package:flutter/material.dart';

void main() {
  runApp(const BuzzyApp());
}

class BuzzyApp extends StatelessWidget {
  const BuzzyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF130924),
      ),
      home: const ProfileScreen(),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  int selectedIndex = 0;

  final List<String> avatars = [
    'https://cdn.jsdelivr.net/gh/alohe/avatars/png/3d_1.png',
    'https://cdn.jsdelivr.net/gh/alohe/avatars/png/3d_2.png',
    'https://cdn.jsdelivr.net/gh/alohe/avatars/png/3d_3.png',
    'https://cdn.jsdelivr.net/gh/alohe/avatars/png/3d_4.png',
  ];

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'اختر شخصيتك واسمك',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFFFACC15)),
                  ),
                  const SizedBox(height: 20),
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: const Color(0xFF231145),
                    backgroundImage: NetworkImage(avatars[selectedIndex]),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    height: 60,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: avatars.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => setState(() => selectedIndex = index),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: selectedIndex == index ? Colors.white : Colors.transparent,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(avatars[index]),
                              radius: 22,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'أدخل اسمك',
                      filled: true,
                      fillColor: const Color(0xFF231145),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8B5CF6),
                      minimumSize: const Size.fromHeight(50),
                    ),
                    onPressed: () {
                      String name = nameController.text.trim();
                      if (name.isEmpty) {
                        name = 'لاعب مجهول';
                      }
                      
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GameScreen(
                            playerName: name,
                            avatarUrl: avatars[selectedIndex],
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      'دخول للعبة 🚀',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GameScreen extends StatelessWidget {
  final String playerName;
  final String avatarUrl;

  const GameScreen({super.key, required this.playerName, required this.avatarUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buzzy Party: Imposter'),
        backgroundColor: const Color(0xFF231145),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(avatarUrl),
            ),
            const SizedBox(height: 20),
            Text(
              'أهلاً بيك يا $playerName!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFFACC15)),
            ),
            const SizedBox(height: 10),
            const Text(
              'جاري تجهيز الجيم...',
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
