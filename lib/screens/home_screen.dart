import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/notes_provider.dart';
import '../themes/app_theme.dart';
import '../widgets/note_card.dart';
import '../widgets/glass_card.dart';
import 'note_detail_screen.dart';
import 'chat_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final notesProvider = Provider.of<NotesProvider>(context);

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: const Text('AI Notes Assistant'),
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundImage: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuBwTq4BjIGIykVht2HlE8lr5igDHVDI04VDAIk7dFmWf8HWRF6XCxwfyfoXsj83MifAczblZ7jE_R5v4Psjc9yIq2XDsREJm4N5002d_YOk7uLyFKWznlZai3H3tytXaheeBlwcN7y8wQnty79fFJJ4PQtrqZmDkbYa02dIPSAXjC8fGu98bmOAoY4LIrWbr0UX8DWVtTPTQNEp_6AL1AMhsaafkAtTXX-VeRKiWJJsKgfL2pKX5x8jRaqN60crbRXuEzAA_PqcLvpA'),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppTheme.primary),
            onPressed: () {},
          ),
        ],
      ),
      body: _selectedIndex == 0 
        ? _buildHomeContent(notesProvider)
        : _selectedIndex == 1 
          ? const ChatScreen() 
          : _selectedIndex == 3
            ? const SettingsScreen()
            : const Center(child: Text("Coming Soon")),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NoteDetailScreen()),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          width: 60,
          height: 60,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Color(0xFF4F46E5), Color(0xFF29A195)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const Icon(Icons.add, color: Colors.white, size: 30),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHomeContent(NotesProvider provider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          _buildSearchBar(provider),
          const SizedBox(height: 24),
          _buildCategories(),
          const SizedBox(height: 24),
          const Text('AI Insights', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.primary)),
          const SizedBox(height: 16),
          _buildAIQuickActions(),
          const SizedBox(height: 24),
          _buildPinnedSection(provider),
          const SizedBox(height: 24),
          const Text('Recent Notes', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.primary)),
          const SizedBox(height: 16),
          _buildRecentGrid(provider),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildSearchBar(NotesProvider provider) {
    return GlassCard(
      child: TextField(
        onChanged: provider.setSearchQuery,
        decoration: const InputDecoration(
          hintText: 'Search your intelligent notes...',
          prefixIcon: Icon(Icons.search, color: AppTheme.onSurfaceVariant),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }

  Widget _buildCategories() {
    final categories = ['All', 'Work', 'Personal', 'Ideas'];
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final isSelected = index == 0;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? AppTheme.primaryContainer : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              border: isSelected ? null : Border.all(color: Colors.white10),
            ),
            child: Text(
              categories[index],
              style: TextStyle(
                color: isSelected ? Colors.white : AppTheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAIQuickActions() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 100,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF4F46E5), Color(0xFF29A195)]),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.auto_awesome, color: Colors.white),
                SizedBox(height: 8),
                Text('Summarize', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: GlassCard(
            height: 100,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.document_scanner, color: AppTheme.onSurface),
                SizedBox(height: 8),
                Text('Scan OCR', style: TextStyle(color: AppTheme.onSurface, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPinnedSection(NotesProvider provider) {
    if (provider.pinnedNotes.isEmpty) return const SizedBox();
    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.between,
          children: [
            Text('Pinned Notes', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.primary)),
            Icon(Icons.push_pin, color: AppTheme.primary),
          ],
        ),
        const SizedBox(height: 16),
        ...provider.pinnedNotes.map((note) => NoteCard(note: note)).toList(),
      ],
    );
  }

  Widget _buildRecentGrid(NotesProvider provider) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.1,
      ),
      itemCount: provider.recentNotes.length,
      itemBuilder: (context, index) => NoteCard(note: provider.recentNotes[index], isSmall: true),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      margin: const EdgeInsets.only(bottom: 24, left: 20, right: 20),
      height: 70,
      decoration: BoxDecoration(
        color: AppTheme.surface.withOpacity(0.8),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(Icons.home, 'Home', 0),
          _navItem(Icons.smart_toy, 'Chat', 1),
          _navItem(Icons.mic, 'Voice', 2),
          _navItem(Icons.settings, 'Settings', 3),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, String label, int index) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: isSelected ? AppTheme.primary : AppTheme.onSurfaceVariant.withOpacity(0.5)),
          Text(label, style: TextStyle(
            color: isSelected ? AppTheme.primary : AppTheme.onSurfaceVariant.withOpacity(0.5),
            fontSize: 10,
          )),
        ],
      ),
    );
  }
}
