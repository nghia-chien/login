import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final displayName = user?.displayName ?? 'Guest';

    // Fake data
    final List<String> circleAvatars = List.generate(5, (i) => 'A${i+1}');
    final List<String> suggestedImages = ['Art', 'Photo', 'Design'];
    final String todaySuggestion = '🌤️  Try drawing a landscape today!';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: IndexedStack(
                index: _selectedIndex,
                children: [
                  // Home tab
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        // Header
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Hey, $displayName", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                              Row(
                                children: [
                                  Icon(Icons.chat_bubble_outline),
                                  SizedBox(width: 12),
                                  // Avatar + PopupMenu for logout
                                  PopupMenuButton<String>(
                                    icon: const Icon(Icons.person_outline),
                                    onSelected: (value) async {
                                      if (value == 'logout') {
                                        await FirebaseAuth.instance.signOut();
                                      }
                                    },
                                    itemBuilder: (context) => [
                                      const PopupMenuItem(
                                        value: 'logout',
                                        child: Text('Logout'),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        // Horizontal circles
                        SizedBox(
                          height: 60,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: circleAvatars.length,
                            itemBuilder: (context, index) => Container(
                              margin: const EdgeInsets.only(right: 12),
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Text(circleAvatars[index]),
                            ),
                          ),
                        ),
                        // Upload info
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Upload Gusts", style: TextStyle(fontSize: 14)),
                              Text("Art Stylist", style: TextStyle(fontSize: 14)),
                            ],
                          ),
                        ),
                        // Search box
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Row(
                              children: [
                                const Expanded(
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: "Ask",
                                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.arrow_forward),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Suggestion label
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Đề xuất", style: TextStyle(fontSize: 16)),
                          ),
                        ),
                        // Suggested images
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: suggestedImages.map((label) => Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              alignment: Alignment.center,
                              child: Text(label, style: const TextStyle(fontSize: 20)),
                            )).toList(),
                          ),
                        ),
                        // "Today Suggestion" box
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Container(
                            height: 100,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            alignment: Alignment.centerLeft,
                            child: Text(todaySuggestion, style: const TextStyle(fontSize: 20)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Feed tab
                  const Center(child: Text('Feed Page')), 
                  // Create tab
                  const Center(child: Text('Create Page')), 
                  // Closet tab
                  const Center(child: Text('Closet Page')), 
                ],
              ),
            ),
            // Bottom nav bar
            BottomNavigationBar(
              currentIndex: _selectedIndex,
              selectedFontSize: 10,
              unselectedFontSize: 10,
              type: BottomNavigationBarType.fixed,
              onTap: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
                BottomNavigationBarItem(icon: Icon(Icons.rss_feed), label: "Feed"),
                BottomNavigationBarItem(icon: Icon(Icons.brush), label: "Create"),
                BottomNavigationBarItem(icon: Icon(Icons.archive), label: "Closet"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
