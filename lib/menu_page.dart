import 'package:flutter/material.dart';
import 'detail_page.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MenuPage(),
    );
  }
}

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final Color orangeColor = const Color(0xFFFC4D20);
  final Color brownColor = const Color(0xFF48261D);
  final Color lightOrangeColor = const Color(0xFFFFEDE3);

  String selectedCategory = 'COFFEE';
  String searchQuery = '';

  final Map<String, List<Map<String, String>>> menuData = {
    'COFFEE': [
      {
        'title': 'Espresso',
        'description': 'Strong and bold coffee shot',
        'price': '45 BAHT'
      },
      {
        'title': 'Latte',
        'description': 'Smooth and milky coffee',
        'price': '55 BAHT'
      },
    ],
    'NON-COFFEE': [
      {
        'title': 'Thai Tea',
        'description': 'Fresh and healthy',
        'price': '40 BAHT'
      },
      {
        'title': 'Milk shake',
        'description': 'Sweet and creamy',
        'price': '50 BAHT'
      },
    ],
  };

  // เพิ่มตัวแปรเก็บข้อมูลจาก Firebase 
  // List<Map<String, String>> firebaseMenuItems = [];

  @override
  void initState() {
    super.initState();
    // Sเรียกข้อมูลจาก Firebase 
    // fetchMenuFromFirebase();
  }

  // ฟังก์ชันโหลดเมนูจาก Firestore
  // Future<void> fetchMenuFromFirebase() async {
  //   final snapshot = await FirebaseFirestore.instance
  //       .collection('menu')
  //       .where('category', isEqualTo: selectedCategory)
  //       .get();

  //   firebaseMenuItems = snapshot.docs.map((doc) {
  //     final data = doc.data();
  //     return {
  //       'title': data['title'] ?? '',
  //       'description': data['description'] ?? '',
  //       'price': data['price'] ?? '',
  //       'imageUrl': data['imageUrl'] ?? '',
  //     };
  //   }).toList();

  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    final filteredMenu = menuData[selectedCategory]!
        .where((item) => item['title']!
            .toLowerCase()
            .contains(searchQuery.toLowerCase()))
        .toList();

    // ช้ของ Firebase แทน
    // final filteredMenu = firebaseMenuItems
    //     .where((item) => item['title']!
    //         .toLowerCase()
    //         .contains(searchQuery.toLowerCase()))
    //     .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFFDF1E9),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  children: [
                    Container(
                      height: 100,
                      color: brownColor,
                      padding: const EdgeInsets.only(top: 40, left: 16, right: 16),
                      child: const Center(
                        child: Text(
                          'Menu',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: orangeColor,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    offset: Offset(3, 3),
                                    blurRadius: 5,
                                  )
                                ],
                              ),
                              height: 45,
                              width: double.infinity,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      onChanged: (value) {
                                        setState(() {
                                          searchQuery = value;
                                        });
                                      },
                                      style: TextStyle(color: brownColor),
                                      decoration: const InputDecoration(
                                        hintText: 'Search',
                                        border: InputBorder.none,
                                        hintStyle: TextStyle(color: Color(0xFF48261D)),
                                      ),
                                    ),
                                  ),
                                  Icon(Icons.search, color: brownColor),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Category',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: brownColor,
                            ),
                          ),
                          const SizedBox(height: 10),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                for (var category in menuData.keys)
                                  HoverableCategoryTab(
                                    title: category,
                                    selected: selectedCategory == category,
                                    orange: orangeColor,
                                    brown: brownColor,
                                    onTap: () {
                                      setState(() {
                                        selectedCategory = category;
                                        // fetchMenuFromFirebase(); // อัปเดตข้อมูลเมื่อเปลี่ยนหมวด
                                      });
                                    },
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          filteredMenu.isEmpty
                              ? Center(
                                  child: Text(
                                    'No items match your search.',
                                    style: TextStyle(color: brownColor),
                                  ),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: filteredMenu.length,
                                  itemBuilder: (context, index) {
                                    final item = filteredMenu[index];
                                    return MenuItemCard(
                                      title: item['title']!,
                                      description: item['description']!,
                                      price: item['price']!,
                                      imagePath:
                                          'assets/${item['title']!.toLowerCase().replaceAll(' ', '')}.png',

                                      // ใช้ imageUrl แทน
                                      // imagePath: item['imageUrl']!,

                                      backgroundColor: orangeColor,
                                      textColor: lightOrangeColor,
                                      tagColor: lightOrangeColor,
                                      iconColor: brownColor,
                                    );
                                  },
                                ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class HoverableCategoryTab extends StatelessWidget {
  final String title;
  final bool selected;
  final Color orange;
  final Color brown;
  final VoidCallback onTap;

  const HoverableCategoryTab({
    super.key,
    required this.title,
    required this.selected,
    required this.orange,
    required this.brown,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? orange : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          boxShadow: selected
              ? [
                  const BoxShadow(
                    color: Colors.black26,
                    offset: Offset(3, 3),
                    blurRadius: 5,
                  )
                ]
              : [],
        ),
        child: Text(
          title,
          style: TextStyle(
            color: selected ? brown : orange,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class MenuItemCard extends StatelessWidget {
  final String title;
  final String description;
  final String price;
  final String imagePath;
  final Color backgroundColor;
  final Color textColor;
  final Color tagColor;
  final Color iconColor;

  const MenuItemCard({
    super.key,
    required this.title,
    required this.description,
    required this.price,
    required this.imagePath,
    required this.backgroundColor,
    required this.textColor,
    required this.tagColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                imagePath,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.image_not_supported),

                // ใช้ Image.network แทน
                // child: Image.network(
                //   imagePath,
                //   width: 60,
                //   height: 60,
                //   fit: BoxFit.cover,
                //   errorBuilder: (context, error, stackTrace) =>
                //       const Icon(Icons.image_not_supported),
                // ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(description, style: TextStyle(color: textColor)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Text(price, style: TextStyle(color: textColor)),
                ),
                const SizedBox(height: 8),
                GestureDetector(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const DetailPage(),
      ),
    );
  },
  child: CircleAvatar(
    radius: 12,
    backgroundColor: iconColor,
    child: const Icon(Icons.add, size: 16, color: Colors.white),
  ),
),
              ],
            )
          ],
        ),
      ),
    );
  }
}
