import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const StoryVerseApp());

class StoryVerseApp extends StatelessWidget {
  const StoryVerseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'StoryVerse AI',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6653C7)),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int tab = 0;
  final titleController = TextEditingController();
  final storyController = TextEditingController();
  String savedTitle = '';
  String savedStory = '';

  @override
  void initState() {
    super.initState();
    loadStory();
  }

  Future<void> loadStory() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      savedTitle = prefs.getString('story_title') ?? '';
      savedStory = prefs.getString('story_body') ?? '';
      titleController.text = savedTitle;
      storyController.text = savedStory;
    });
  }

  Future<void> saveStory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('story_title', titleController.text);
    await prefs.setString('story_body', storyController.text);
    setState(() {
      savedTitle = titleController.text;
      savedStory = storyController.text;
    });
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('บันทึกนิยายไว้ในเครื่องแล้ว')),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    storyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _home(),
      _novel(),
      _storyboard(),
      _library(),
      _settings(),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('StoryVerse AI'),
        centerTitle: true,
      ),
      body: SafeArea(child: pages[tab]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab,
        onDestinationSelected: (value) => setState(() => tab = value),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'หน้าหลัก'),
          NavigationDestination(icon: Icon(Icons.edit_note), label: 'นิยาย'),
          NavigationDestination(icon: Icon(Icons.movie_outlined), label: 'สตอรี่บอร์ด'),
          NavigationDestination(icon: Icon(Icons.photo_library_outlined), label: 'คลังงาน'),
          NavigationDestination(icon: Icon(Icons.settings_outlined), label: 'ตั้งค่า'),
        ],
      ),
    );
  }

  Widget _home() => ListView(
    padding: const EdgeInsets.all(20),
    children: [
      const SizedBox(height: 12),
      const Icon(Icons.auto_awesome, size: 64, color: Color(0xFF6653C7)),
      const SizedBox(height: 12),
      const Text('สร้างโลกจินตนาการของคุณ', textAlign: TextAlign.center,
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      const Text('เขียนนิยาย วางฉาก และเตรียมสร้างภาพยนตร์ AI ในที่เดียว',
        textAlign: TextAlign.center),
      const SizedBox(height: 24),
      _tile(Icons.edit, 'เขียนนิยาย', 'สร้างและบันทึกเรื่องราว', () => setState(() => tab = 1)),
      _tile(Icons.movie, 'สร้างสตอรี่บอร์ด', 'แบ่งเรื่องเป็นฉากและช็อต', () => setState(() => tab = 2)),
      _tile(Icons.folder, 'คลังโปรเจกต์', 'ดูงานที่บันทึกไว้', () => setState(() => tab = 3)),
      const SizedBox(height: 12),
      const Card(child: Padding(
        padding: EdgeInsets.all(16),
        child: Text('รุ่นเริ่มต้น: บันทึกนิยายในเครื่องได้ ส่วน AI สร้างภาพ วิดีโอ และเสียง จะเชื่อมต่อในรุ่นถัดไป'),
      )),
    ],
  );

  Widget _tile(IconData icon, String title, String subtitle, VoidCallback action) =>
    Card(child: ListTile(leading: Icon(icon), title: Text(title),
      subtitle: Text(subtitle), trailing: const Icon(Icons.chevron_right), onTap: action));

  Widget _novel() => ListView(
    padding: const EdgeInsets.all(16),
    children: [
      const Text('เขียนนิยาย', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      const SizedBox(height: 12),
      TextField(controller: titleController, decoration: const InputDecoration(
        labelText: 'ชื่อนิยาย', border: OutlineInputBorder())),
      const SizedBox(height: 12),
      TextField(controller: storyController, minLines: 12, maxLines: 22,
        decoration: const InputDecoration(labelText: 'เนื้อหานิยาย',
          alignLabelWithHint: true, border: OutlineInputBorder())),
      const SizedBox(height: 12),
      FilledButton.icon(onPressed: saveStory,
        icon: const Icon(Icons.save), label: const Text('บันทึกในเครื่อง')),
    ],
  );

  Widget _storyboard() => ListView(
    padding: const EdgeInsets.all(16),
    children: const [
      Text('สตอรี่บอร์ด', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      SizedBox(height: 12),
      Text('ตัวอย่างโครงฉากสำหรับเรื่อง “บทเพลงแรกแห่งยุคบรรพกาล”'),
      SizedBox(height: 12),
      _Scene(number: 1, title: 'โลกที่ไร้เสียงดนตรี', detail: 'ภาพเปิดเมืองโบราณ ผู้คนใช้ชีวิตท่ามกลางเสียงธรรมชาติ'),
      _Scene(number: 2, title: 'เด็กชายผู้แตกต่าง', detail: 'หลินเยว่ เด็กวัย 7 ปี เฝ้าฟังเสียงรอบตัวอย่างสงบนิ่ง'),
      _Scene(number: 3, title: 'ความทรงจำจากอีกโลก', detail: 'เขาจดจำแนวคิดเรื่องจังหวะ ทำนอง และเครื่องดนตรี'),
      _Scene(number: 4, title: 'กำเนิดเสียงแรก', detail: 'เด็กชายทดลองสร้างท่วงทำนองด้วยสิ่งของใกล้ตัว'),
      _Scene(number: 5, title: 'เสียงที่ไม่มีใครรู้จัก', detail: 'ผู้คนเริ่มสงสัยต่อเสียงประหลาดที่ไม่เคยได้ยิน'),
      _Scene(number: 6, title: 'ความเงียบและคำถาม', detail: 'หลินเยว่คิดว่าโลกอาจไม่ได้ไร้ดนตรี แค่ยังไม่มีใครค้นพบ'),
      _Scene(number: 7, title: 'จุดเริ่มต้น', detail: 'เขาตัดสินใจทดลองสร้างเครื่องดนตรีชิ้นแรก'),
      _Scene(number: 8, title: 'บทเพลงแรก', detail: 'เสียงทำนองสั้น ๆ ถือกำเนิดขึ้นในโลกที่ไม่เคยมีเพลง'),
    ],
  );

  Widget _library() => ListView(padding: const EdgeInsets.all(16), children: [
    const Text('คลังโปรเจกต์', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
    const SizedBox(height: 12),
    Card(child: ListTile(leading: const Icon(Icons.description),
      title: Text(savedTitle.isEmpty ? 'ยังไม่มีชื่อนิยาย' : savedTitle),
      subtitle: Text(savedStory.isEmpty ? 'ยังไม่มีเนื้อหาที่บันทึก' : 'มีเนื้อหาที่บันทึกไว้ในเครื่อง'),
      onTap: () => setState(() => tab = 1))),
  ]);

  Widget _settings() => const ListView(padding: EdgeInsets.all(16), children: [
    Text('ตั้งค่า', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
    SizedBox(height: 12),
    ListTile(leading: Icon(Icons.language), title: Text('ภาษา'), subtitle: Text('ภาษาไทย')),
    ListTile(leading: Icon(Icons.storage), title: Text('การจัดเก็บ'), subtitle: Text('บันทึกข้อมูลนิยายไว้ในอุปกรณ์')),
    ListTile(leading: Icon(Icons.info_outline), title: Text('เกี่ยวกับ'), subtitle: Text('StoryVerse AI รุ่นต้นแบบ')),
  ]);
}

class _Scene extends StatelessWidget {
  final int number;
  final String title;
  final String detail;
  const _Scene({required this.number, required this.title, required this.detail});

  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      leading: CircleAvatar(child: Text('$number')),
      title: Text(title),
      subtitle: Text(detail),
    ),
  );
}
