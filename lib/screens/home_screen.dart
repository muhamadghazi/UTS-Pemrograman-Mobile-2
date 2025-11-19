import 'package:flutter/material.dart';
import '../models/menu_model.dart';
import 'pedagang_dashboard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<MenuModel> menus = [
    MenuModel(
        name: 'Air Mineral',
        price: 4000,
        image: 'assets/images/air_mineral.jpg',
        isAvailable: true),
    MenuModel(
        name: 'Bakso',
        price: 14000,
        image: 'assets/images/bakso.jpg',
        isAvailable: true),
    MenuModel(
        name: 'Baso Ikan',
        price: 13000,
        image: 'assets/images/baso_ikan.jpg',
        isAvailable: true),
    MenuModel(
        name: 'Basreng',
        price: 10000,
        image: 'assets/images/basreng.jpg',
        isAvailable: true),
    MenuModel(
        name: 'Batagor',
        price: 12000,
        image: 'assets/images/batagor.jpg',
        isAvailable: true),
    MenuModel(
        name: 'Cuanki',
        price: 12000,
        image: 'assets/images/cuanki.jpg',
        isAvailable: true),
    MenuModel(
        name: 'Es Kopi Susu',
        price: 8000,
        image: 'assets/images/es_kopi_susu.jpg',
        isAvailable: true),
    MenuModel(
        name: 'Es Teh Manis',
        price: 5000,
        image: 'assets/images/es_teh.jpg',
        isAvailable: true),
    MenuModel(
        name: 'Gorengan',
        price: 2000,
        image: 'assets/images/gorengan.jpg',
        isAvailable: true),
    MenuModel(
        name: 'Mie Ayam',
        price: 12000,
        image: 'assets/images/mie_ayam.jpg',
        isAvailable: true),
    MenuModel(
        name: 'Nasi Goreng',
        price: 15000,
        image: 'assets/images/nasi_goreng.jpg',
        isAvailable: true),
    MenuModel(
        name: 'Pempek',
        price: 15000,
        image: 'assets/images/pempek.jpg',
        isAvailable: true),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _orderItem(String menuName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$menuName ditambahkan ke pesanan!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Responsivitas
    double titleFontSize = screenWidth > 600 ? 28 : 24;
    double subtitleFontSize = screenWidth > 600 ? 16 : 14;
    double buttonFontSize = screenWidth > 600 ? 18 : 16;
    double paddingValue = screenWidth > 600
        ? 32.0
        : 16.0; // Kurangi padding untuk HP agar lebih hemat ruang

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          'KantinKu',
          style:
              TextStyle(fontSize: titleFontSize, fontWeight: FontWeight.w700),
        ),
        backgroundColor: const Color(0xFFFF9800),
        elevation: 0,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Color(0xFFFF9800)),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFFF3E0), Color(0xFFFFE0B2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(paddingValue),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Banner sambutan
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(paddingValue),
                    margin: const EdgeInsets.only(
                        bottom: 16), // Kurangi margin bawah
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFFE0B2), Color(0xFFFFCC80)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.withOpacity(0.15),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 4),
                        Text(
                          'Mau makan apa hari ini?',
                          style: TextStyle(
                            fontSize: subtitleFontSize,
                            color: Color(0xFFF57C00),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Tombol ke Dashboard Pedagang
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PedagangDashboard(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.store, color: Colors.white),
                      label: Text(
                        'Masuk ke Dashboard Pedagang',
                        style: TextStyle(
                          fontSize: buttonFontSize,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF9800),
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth > 600 ? 32 : 20,
                            vertical: 10), // Kurangi padding vertikal
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16), // Kurangi height

                  // Daftar Menu
                  LayoutBuilder(
                    builder: (context, constraints) {
                      int crossAxisCount =
                          2; // Default untuk HP (dua item per baris)
                      double aspectRatio =
                          0.65; // Kurangi aspectRatio agar kartu lebih pendek dan tidak overflow

                      if (constraints.maxWidth > 600) {
                        crossAxisCount = 3; // Tablet kecil
                        aspectRatio = 0.7;
                      }
                      if (constraints.maxWidth > 800) {
                        crossAxisCount = 4; // Tablet
                        aspectRatio = 0.65;
                      }
                      if (constraints.maxWidth > 1200) {
                        crossAxisCount = 5; // Desktop
                        aspectRatio = 0.6;
                      }

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: menus.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 12, // Kurangi spacing
                          mainAxisSpacing: 12, // Kurangi spacing
                          childAspectRatio: aspectRatio,
                        ),
                        itemBuilder: (context, index) {
                          final menu = menus[index];
                          return Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(16),
                                      topRight: Radius.circular(16),
                                    ),
                                    child: Image.asset(
                                      menu.image,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 5,
                                  child: Padding(
                                    padding: const EdgeInsets.all(
                                        8.0), // Kurangi padding dalam kartu
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(menu.name,
                                            style: TextStyle(
                                                fontSize: screenWidth > 600
                                                    ? 16
                                                    : 13, // Kurangi font size
                                                fontWeight: FontWeight.w600)),
                                        Text(
                                          'Rp${menu.price}',
                                          style: TextStyle(
                                            fontSize: screenWidth > 600
                                                ? 18
                                                : 15, // Kurangi font size
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFFFF9800),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 3), // Kurangi padding
                                          decoration: BoxDecoration(
                                            color: menu.isAvailable
                                                ? const Color(0xFFC8E6C9)
                                                : const Color(0xFFFFCDD2),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            menu.isAvailable
                                                ? 'Tersedia'
                                                : 'Habis',
                                            style: TextStyle(
                                              fontSize: screenWidth > 600
                                                  ? 12
                                                  : 10, // Kurangi font size
                                              fontWeight: FontWeight.w600,
                                              color: menu.isAvailable
                                                  ? const Color(0xFF2E7D32)
                                                  : const Color(0xFFC62828),
                                            ),
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: menu.isAvailable
                                              ? () => _orderItem(menu.name)
                                              : null,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: menu.isAvailable
                                                ? const Color(0xFFFF9800)
                                                : Colors.grey,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            minimumSize: const Size(
                                                double.infinity,
                                                32), // Kurangi tinggi button
                                          ),
                                          child: Text(
                                            'Pesan',
                                            style: TextStyle(
                                              fontSize: screenWidth > 600
                                                  ? 14
                                                  : 12, // Kurangi font size
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFFFF9800),
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt), label: 'Pesanan'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}
