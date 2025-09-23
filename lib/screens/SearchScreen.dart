import 'package:flutter/material.dart';

// This is the main widget for your 'Search' tab.
// It needs to be a StatefulWidget to handle the text input and search results.
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // Controller to get the text from the search bar
  final TextEditingController _searchController = TextEditingController();

  // A list to hold the search results. In a real app, this would be a list of Track objects.
  final List<String> _searchResults = [];

  // A flag to show a loading indicator
  bool _isLoading = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // This function simulates a search operation
  void _performSearch() {
    if (_searchController.text.isEmpty) {
      return; // Don't search for nothing
    }

    setState(() {
      _isLoading = true;
      _searchResults.clear(); // Clear previous results
    });

    // Simulate a network call to fetch search results
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() {
        // Add some dummy data
        _searchResults.addAll([
          'Bohemian Rhapsody - Queen',
          'Stairway to Heaven - Led Zeppelin',
          'Hotel California - Eagles',
          'Smells Like Teen Spirit - Nirvana',
          'Imagine - John Lennon',
          'Like a Rolling Stone - Bob Dylan',
        ]);
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // The Stack allows us to layer the main content and the fixed playback bar.
    return Stack(
      children: [
        // Main content area
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              // Search Bar
              TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white),
                textInputAction: TextInputAction.search,
                onSubmitted: (_) => _performSearch(),
                decoration: InputDecoration(
                  hintText: 'Search for music...',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  // Creates the underline
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[600]!),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Search Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _performSearch,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF222222),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Search'),
                ),
              ),
              const SizedBox(height: 20),

              // Results Label
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Results',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Results List
              // The Expanded widget is crucial. It tells the ListView to take up
              // all the remaining vertical space in the Column.
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    return _SearchResultTile(title: _searchResults[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// A simple tile to display a search result.
class _SearchResultTile extends StatelessWidget {
  final String title;
  const _SearchResultTile({required this.title});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.music_note, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: () {
        print('Tapped on: $title');
      },
    );
  }
}