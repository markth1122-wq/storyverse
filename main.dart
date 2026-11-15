import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const StoryVerseApp());
}

const ink = Color(0xFF172337);
const gold = Color(0xFFE8D49C);

class StoryVerseApp extends StatelessWidget {
  const StoryVerseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'StoryVerse AI',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: ink, brightness: Brightness.light),
        scaffoldBackgroundColor: const Color(0xFFF5F3EE),
        appBarTheme: const AppBarTheme(backgroundColor: ink, foregroundColor: Colors.white),
      ),
      home: const MainShell(),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int index = 0;
  final pages = const [HomePage(), NovelPage(), StoryboardPage(), GalleryPage(), SettingsPage()];
  final labels = const ['หน้าหลัก', 'นิยาย', 'สตอรี่บอร์ด', 'คลังภาพ', 'ตั้งค่า'];
  final icons = const [Icons.dashboard_outlined, Icons.menu_book_outlined,
    Icons.movie_creation_outlined, Icons.photo_library_outlined, Icons.settings_outlined];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('StoryVerse AI', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [IconButton(onPressed: () => setState(() => index = 4),
          icon: const Icon(Icons.settings_outlined))],
      ),
      body: IndexedStack(index: index, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (v) => setState(() => index = v),
        destinations: List.generate(5, (i) => NavigationDestination(
          icon: Icon(icons[i]), label: labels[i])),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(16),
    children: [
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: ink, borderRadius: BorderRadius.circular(22)),
        child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('สตูดิโอสร้างสรรค์ส่วนตัว', style: TextStyle(color: gold, fontSize: 13)),
          SizedBox(height: 8),
          Text('จากนิยาย\\nสู่ภาพยนตร์', style: TextStyle(color: Colors.white,
            fontSize: 30, fontWeight: FontWeight.bold, height: 1.2)),
          SizedBox(height: 8),
          Text('เขียนเรื่องราว วางฉาก และรวบรวมผลงานไว้ในที่เดียว',
            style: TextStyle(color: Colors.white70)),
        ]),
      ),
      const SizedBox(height: 20),
      const Text('เครื่องมือของฉัน', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
      const SizedBox(height: 12),
      const Wrap(spacing: 10, runSpacing: 10, children: [
        ToolTile(icon: Icons.menu_book, title: 'เขียนนิยาย', subtitle: 'สร้างและแก้ไขตอน'),
        ToolTile(icon: Icons.people_alt_outlined, title: 'ตัวละคร', subtitle: 'เก็บข้อมูลตัวละคร'),
        ToolTile(icon: Icons.movie, title: 'แบ่งฉาก', subtitle: 'วางช็อตและบทพูด'),
        ToolTile(icon: Icons.image_outlined, title: 'คลังภาพ', subtitle: 'รวมภาพอ้างอิง'),
      ]),
      const SizedBox(height: 20),
      const Text('โปรเจกต์ล่าสุด', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
      Card(child: ListTile(
        leading: const CircleAvatar(backgroundColor: ink, child: Icon(Icons.music_note, color: gold)),
        title: const Text('บทเพลงแรกแห่งยุคบรรพกาล'),
        subtitle: const Text('โปรเจกต์นิยาย • แตะเมนูนิยายเพื่อแก้ไข'),
      )),
    ],
  );
}

class ToolTile extends StatelessWidget {
  final IconData icon;
  final String title, subtitle;
  const ToolTile({super.key, required this.icon, required this.title, required this.subtitle});
  @override
  Widget build(BuildContext context) => SizedBox(
    width: (MediaQuery.sizeOf(context).width - 42) / 2,
    child: Card(child: Padding(
      padding: const EdgeInsets.all(14),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, color: ink, size: 28), const SizedBox(height: 10),
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.black54)),
      ]),
    )),
  );
}

class NovelPage extends StatefulWidget {
  const NovelPage({super.key});
  @override
  State<NovelPage> createState() => _NovelPageState();
}
class _NovelPageState extends State<NovelPage> {
  final titleController = TextEditingController(text: 'บทเพลงแรกแห่งยุคบรรพกาล');
  final contentController = TextEditingController(
    text: 'หลินเยว่ นักดนตรีจากโลกปัจจุบัน เกิดใหม่ในโลกโบราณที่ผู้คนยังไม่รู้จักดนตรี');
  String saved = 'ยังไม่ได้บันทึก';
  @override
  void dispose() { titleController.dispose(); contentController.dispose(); super.dispose(); }

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('novel_title', titleController.text);
    await prefs.setString('novel_content', contentController.text);
    setState(() => saved = 'บันทึกในเครื่องแล้ว');
  }
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    titleController.text = prefs.getString('novel_title') ?? titleController.text;
    contentController.text = prefs.getString('novel_content') ?? contentController.text;
    setState(() => saved = 'โหลดข้อมูลแล้ว');
  }
  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(16), children: [
    const Text('ห้องเขียนนิยาย', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
    const SizedBox(height: 14),
    TextField(controller: titleController, decoration: const InputDecoration(
      labelText: 'ชื่อเรื่อง', border: OutlineInputBorder())),
    const SizedBox(height: 12),
    TextField(controller: contentController, minLines: 12, maxLines: 20,
      decoration: const InputDecoration(labelText: 'เนื้อหานิยาย',
        alignLabelWithHint: true, border: OutlineInputBorder())),
    const SizedBox(height: 12),
    Row(children: [
      Expanded(child: FilledButton.icon(onPressed: save,
        icon: const Icon(Icons.save_outlined), label: const Text('บันทึก'))),
      const SizedBox(width: 8),
      OutlinedButton.icon(onPressed: load, icon: const Icon(Icons.refresh), label: const Text('โหลด')),
    ]),
    const SizedBox(height: 8),
    Text(saved, style: const TextStyle(color: Colors.green)),
    const SizedBox(height: 16),
    const InfoBox(text: 'รุ่นต้นแบบ: บันทึกนิยายไว้ในเครื่องได้แล้ว ส่วน AI เขียนต่อจะเพิ่มในขั้นถัดไปเมื่อเลือกผู้ให้บริการ AI'),
  ]);
}

class StoryboardPage extends StatelessWidget {
  const StoryboardPage({super.key});
  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(16), children: [
    const Text('สตอรี่บอร์ด', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
    const SizedBox(height: 8),
    const Text('ตัวอย่างโครงฉากสำหรับเรื่อง บทเพลงแรกแห่งยุคบรรพกาล'),
    for (final item in [
      ('ฉาก 1', 'การจากลาในโลกเดิม', 'ห้องบันทึกเสียง • Wide Shot'),
      ('ฉาก 2', 'การตื่นขึ้นในโลกใหม่', 'ห้องนอนจีนโบราณ • Close-up'),
      ('ฉาก 3', 'ความทรงจำของร่างใหม่', 'จวนตระกูลหลิน • Medium Shot'),
      ('ฉาก 4', 'โลกที่ไม่มีดนตรี', 'สวนไผ่ • Over Shoulder'),
      ('ฉาก 5', 'ความทรงจำจากโลกเก่า', 'ริมหน้าต่าง • Night Shot'),
      ('ฉาก 6', 'เครื่องดนตรีชิ้นแรก', 'ห้องทำงาน • Montage'),
      ('ฉาก 7', 'เสียงแรกของโลก', 'เครื่องสาย • Extreme Close-up'),
      ('ฉาก 8', 'จุดเริ่มต้นของประวัติศาสตร์', 'เมืองโบราณ • Aerial Shot'),
    ])
      Card(child: ListTile(
        leading: const CircleAvatar(backgroundColor: ink, foregroundColor: gold, child: Icon(Icons.movie_outlined)),
        title: Text('${item.$1} : ${item.$2}'),
        subtitle: Text(item.$3),
        trailing: const Icon(Icons.chevron_right),
      )),
    const InfoBox(text: 'ขั้นถัดไป: เพิ่มตัวแก้ไขฉาก จำนวนช็อต ระยะเวลา บทพูด และคำสั่งสร้างภาพ/วิดีโอ'),
  ]);
}

class GalleryPage extends StatelessWidget {
  const GalleryPage({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Padding(
    padding: EdgeInsets.all(24),
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      Icon(Icons.photo_library_outlined, size: 64, color: ink),
      SizedBox(height: 12),
      Text('คลังภาพของฉัน', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      SizedBox(height: 8),
      Text('พื้นที่สำหรับเก็บภาพตัวละคร ฉาก และภาพที่สร้างจาก AI\\nจะเพิ่มระบบนำเข้ารูปในขั้นถัดไป',
        textAlign: TextAlign.center),
    ]),
  ));
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(16), children: const [
    Text('ตั้งค่า', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
    Card(child: ListTile(leading: Icon(Icons.language), title: Text('ภาษา'), subtitle: Text('ไทย'))),
    Card(child: ListTile(leading: Icon(Icons.storage), title: Text('การจัดเก็บ'), subtitle: Text('บันทึกข้อมูลในเครื่อง'))),
    Card(child: ListTile(leading: Icon(Icons.cloud_off), title: Text('AI Services'), subtitle: Text('ยังไม่ได้เชื่อมต่อผู้ให้บริการ'))),
    InfoBox(text: 'แอปนี้เป็นต้นแบบส่วนตัว ยังไม่มีระบบบัญชีผู้ใช้หรือการส่งข้อมูลขึ้นคลาวด์'),
  ]);
}

class InfoBox extends StatelessWidget {
  final String text;
  const InfoBox({super.key, required this.text});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: const Color(0xFFE9E4D8), borderRadius: BorderRadius.circular(12)),
    child: Text(text, style: const TextStyle(fontSize: 13, height: 1.45)),
  );
}
