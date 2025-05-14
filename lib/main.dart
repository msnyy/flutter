import 'package:flutter/material.dart';
import 'menu_page.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'cart_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OrderHistoryPage(),
    );
  }
}

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  int? openedIndex;

  // เพิ่มตัวแปรเพื่อเก็บ Future ของรายการออเดอร์
  // late Future<List<Order>> _orders;

  @override
  void initState() {
    super.initState();
    // ดึงข้อมูลจาก Firestore เมื่อเริ่มต้น
    // _orders = fetchOrders();
  }

  // ฟังก์ชันดึงข้อมูลจาก Firestore
  // Future<List<Order>> fetchOrders() async {
  //   var snapshot = await FirebaseFirestore.instance.collection('orders').get();
  //   return snapshot.docs.map((doc) => Order.fromFirestore(doc)).toList();
  // }

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFFFFEDE3);
    const primaryDark = Color(0xFF48261D);
    const accentColor = Color(0xFFFC4D20);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        // ถ้าจะใช้ Firestore ต้องใช้ FutureBuilder แทน Column
        // child: FutureBuilder<List<Order>>(
        //   future: _orders,
        //   builder: (context, snapshot) {
        //     ... (จัดการ loading, error, และแสดง ListView) ...
        //   },
        // ),
        
        child: Stack(  // เปลี่ยนจาก Column เป็น Stack
          children: [
            Column(
              children: [
                // Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: primaryDark,
                    borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
                  ),
                  child: const Column(
                    children: [
                      SizedBox(height: 10),
                      Text(
                        'ORDER\nHISTORY',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ข้อมูลจำลอง ui
                OrderCard(
                  index: 0,
                  isOpen: openedIndex == 0,
                  onTap: () {
                    setState(() {
                      openedIndex = openedIndex == 0 ? null : 0;
                    });
                  },
                  itemCount: 3,
                  price: '90 BATH',
                  primaryDark: primaryDark,
                  accentColor: accentColor,
                  imagePath: 'assets/latte.png',
                  items: [
                    {'name': 'Latte', 'price': '30 BATH'},
                    {'name': 'Mocha', 'price': '30 BATH'},
                    {'name': 'Americano', 'price': '30 BATH'},
                  ],
                ),
                const SizedBox(height: 20),

                OrderCard(
                  index: 1,
                  isOpen: openedIndex == 1,
                  onTap: () {
                    setState(() {
                      openedIndex = openedIndex == 1 ? null : 1;
                    });
                  },
                  itemCount: 2,
                  price: '60 BATH',
                  primaryDark: primaryDark,
                  accentColor: accentColor,
                  imagePath: 'assets/espresso.png',
                  items: [
                    {'name': 'Espresso', 'price': '30 BATH'},
                    {'name': 'Cappuccino', 'price': '30 BATH'},
                  ],
                ),

                const Spacer(),
              ],
            ),

            // Manu Button
            Positioned(
              bottom: 20,
              right: 20,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryDark,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MenuPage()),
                  );
                },
                child: const Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ต้องเพิ่มคลาส Order และ Order.fromFirestore ถ้าจะใช้กับ Firestore

class OrderCard extends StatelessWidget {
  final int index;
  final bool isOpen;
  final VoidCallback onTap;
  final int itemCount;
  final String price;
  final Color primaryDark;
  final Color accentColor;
  final String imagePath;
  final List<Map<String, String>>? items;

  const OrderCard({
    super.key,
    required this.index,
    required this.isOpen,
    required this.onTap,
    required this.itemCount,
    required this.price,
    required this.primaryDark,
    required this.accentColor,
    required this.imagePath,
    this.items,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: accentColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(3, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: primaryDark,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Image.asset(imagePath, height: 32, width: 32),
              ),
              const SizedBox(width: 12),
              Text(
                'Order #$index\nx$itemCount',
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
              const Spacer(),
              Text(
                price,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),

          if (isOpen && items != null) ...[
            const SizedBox(height: 12),
            for (var item in items!)
              Padding(
                padding: const EdgeInsets.only(bottom: 6.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(item['name']!, style: const TextStyle(color: Colors.white)),
                    Text(item['price']!, style: const TextStyle(color: Colors.white)),
                  ],
                ),
              ),
          ],

          const SizedBox(height: 8),

          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryDark,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
              ),
              onPressed: () {
                if (isOpen) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CartPage()),
                  );
                } else {
                  onTap();
                }
              },
              child: Text(
                isOpen ? 'Buy again' : 'Show Detail',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
