import 'package:flutter/material.dart';
import '../widgets/photo_detail_modal.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 4; // Index 4 para o perfil (última aba)

  // Dados mock do perfil
  final String displayName = "Luiz Bernardi";
  final String username = "Luiz_b_silva";
  final String bio = "Desenvolvedor Pleno Angular / Spring Boot / Java";
  final int postsCount = 312;
  final int followersCount = 3124;
  final int followingCount = 52222;

  // URLs de imagens aleatórias do Picsum
  final String profileImageUrl = "https://picsum.photos/150/150?random=profile";
  
  final List<String> highlightImages = [
    "https://picsum.photos/80/80?random=1",
    "https://picsum.photos/80/80?random=2",
    "https://picsum.photos/80/80?random=3",
    "https://picsum.photos/80/80?random=4",
    "https://picsum.photos/80/80?random=5",
  ];

  final List<String> highlightTitles = [
    "Viagem", "Trabalho", "Família", "Hobbies", "Eventos"
  ];

  final List<String> gridImages = List.generate(
    24,
    (index) => "https://picsum.photos/200/200?random=${index + 10}",
  );

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(username),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Seção do perfil
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Foto de perfil e estatísticas
                Row(
                  children: [
                    // Foto de perfil
                    CircleAvatar(
                      radius: 45,
                      backgroundImage: NetworkImage(profileImageUrl),
                    ),
                    const SizedBox(width: 20),
                    // Estatísticas
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatColumn("Posts", postsCount),
                          _buildStatColumn("Seguidores", followersCount),
                          _buildStatColumn("Seguindo", followingCount),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Nome e bio
                Text(
                  displayName,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  bio,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                // Botão Editar Perfil
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {},
                    child: const Text("Editar perfil"),
                  ),
                ),
                const SizedBox(height: 16),
                // Destaques (Stories Highlights)
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: highlightImages.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 32,
                              backgroundImage: NetworkImage(highlightImages[index]),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              highlightTitles[index],
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          // TabBar
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(icon: Icon(Icons.grid_on)),
              Tab(icon: Icon(Icons.video_library)),
              Tab(icon: Icon(Icons.person_pin)),
            ],
          ),
          // TabBarView com a grade de fotos
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Aba Posts
                GridView.builder(
                  padding: const EdgeInsets.all(2),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 2,
                  ),
                  itemCount: gridImages.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        _showPhotoModal(context, gridImages[index], index);
                      },
                      child: Image.network(
                        gridImages[index],
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: Colors.grey.shade200,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey.shade300,
                            child: const Icon(Icons.error),
                          );
                        },
                      ),
                    );
                  },
                ),
                // Aba Reels
                const Center(
                  child: Text("Nenhum Reel disponível no momento"),
                ),
                // Aba Tagged
                const Center(
                  child: Text("Nenhuma foto marcada disponível"),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_outlined),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_library),
            label: 'Reels',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    
    // Aqui você pode implementar a navegação para as outras telas
    switch (index) {
      case 0:
        // Navegar para Home
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Home clicado')),
        );
        break;
      case 1:
        // Navegar para Search
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Search clicado')),
        );
        break;
      case 2:
        // Navegar para Add
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Add clicado')),
        );
        break;
      case 3:
        // Navegar para Reels
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Reels clicado')),
        );
        break;
      case 4:
        // Já está no perfil
        break;
    }
  }

  Widget _buildStatColumn(String label, int count) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  void _showPhotoModal(BuildContext context, String imageUrl, int index) {
    showPhotoDetailModal(
      context: context,
      imageUrl: imageUrl,
      likes: 42 + index * 3,
      description: "Foto número ${index + 1}! ",
    );
  }
}
