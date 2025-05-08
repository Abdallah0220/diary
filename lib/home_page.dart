import 'package:flutter/material.dart';
import 'add_entry_page.dart';
import 'diary_service.dart';
import 'entry_detail_page.dart'; // سنحتاج هذه الصفحة الجديدة

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> entries = [];
  final Color _primaryColor = Colors.deepPurple;
  final Color _accentColor = Colors.tealAccent[400]!;

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    final loadedEntries = await DiaryService.getEntries();
    setState(() => entries = loadedEntries);
  }

  Future<void> _navigateToAddEntry() async {
    await Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, __, ___) => const AddEntryPage(),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
    _loadEntries();
  }

  void _openEntryDetail(int index) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder:
            (_, __, ___) => EntryDetailPage(
              entry: entries[index],
              entryIndex: index,
              onDelete: (int) async {
                await DiaryService.deleteEntry(index);
                _loadEntries();
              },
              onEdit: (int index, String updatedText) async {
                await DiaryService.updateEntry(index, updatedText);
                _loadEntries();
              },
            ),
        transitionsBuilder: (_, animation, __, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
      ),
    );
  }

  Widget _buildEmptyDiary() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedOpacity(
            duration: const Duration(seconds: 1),
            opacity: 1,
            child: Text(
              'Welcome to Diary',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: _primaryColor,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "Let's make your first post",
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          const SizedBox(height: 40),
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: _primaryColor.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: _navigateToAddEntry,
              child: const Text('Create First Entry'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiaryList() {
    return ListView.builder(
      itemCount: entries.length,
      itemBuilder:
          (context, index) => AnimatedContainer(
            duration: Duration(milliseconds: 200 + (index * 100)),
            curve: Curves.easeInOut,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color:
                  index.isEven
                      ? _primaryColor.withOpacity(0.4)
                      : _accentColor.withOpacity(0.2),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => _openEntryDetail(index),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          entries[index].length > 50
                              ? '${entries[index].substring(0, 50)}...'
                              : entries[index],

                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[800],
                          ),
                        ),
                      ),
                      Icon(Icons.chevron_right, color: _primaryColor),
                    ],
                  ),
                ),
              ),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Diary'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: _primaryColor,
        elevation: 0,
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: entries.isEmpty ? _buildEmptyDiary() : _buildDiaryList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddEntry,
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
        child: const Icon(Icons.add),
      ),
    );
  }
}
