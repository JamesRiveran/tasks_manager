import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../widgets/task_list.dart';
import '../widgets/add_task_dialog.dart';
import 'statistics_screen.dart';
import 'settings_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  late PageController _pageController;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    SizedBox(),
    StatisticsScreen(),
    SettingsScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _pageController = PageController();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        Provider.of<TaskProvider>(context, listen: false).setSearchQuery('');
      }
    });
  }

  void _navigateTo(int index) {
    setState(() => _currentIndex = index);
  }

  Widget _buildHomeScreen() {
    final provider = Provider.of<TaskProvider>(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Buscar tareas...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                ),
                style: TextStyle(color: colorScheme.onSurface),
                onChanged: (value) => provider.setSearchQuery(value),
                autofocus: true,
              )
            : const Text('Lista de Tareas'),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: _toggleSearch,
            tooltip: _isSearching ? 'Cerrar búsqueda' : 'Buscar',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.pending_actions), text: 'Pendientes'),
            Tab(icon: Icon(Icons.task_alt), text: 'Completadas'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          TaskList(
            tasks: provider.pendingTasks,
            emptyMessage: 'No hay tareas pendientes',
          ),
          TaskList(
            tasks: provider.completedTasks,
            emptyMessage: 'No hay tareas completadas',
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: _currentIndex == 0 ? _buildHomeScreen() : _screens[_currentIndex],
      bottomNavigationBar: BottomAppBar(
        color: colorScheme.surfaceContainerHighest,
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.home,
                  color: _currentIndex == 0 ? colorScheme.primary : null),
              onPressed: () => _navigateTo(0),
              tooltip: 'Inicio',
            ),
            IconButton(
              icon: Icon(Icons.bar_chart,
                  color: _currentIndex == 1 ? colorScheme.primary : null),
              onPressed: () => _navigateTo(1),
              tooltip: 'Estadísticas',
            ),
            const SizedBox(width: 48),
            IconButton(
              icon: Icon(Icons.settings,
                  color: _currentIndex == 2 ? colorScheme.primary : null),
              onPressed: () => _navigateTo(2),
              tooltip: 'Ajustes',
            ),
            IconButton(
              icon: Icon(Icons.person,
                  color: _currentIndex == 3 ? colorScheme.primary : null),
              onPressed: () => _navigateTo(3),
              tooltip: 'Perfil',
            ),
          ],
        ),
      ),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
              tooltip: 'Agregar tarea',
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => const AddTaskDialog(),
                );
              },
              child: const Icon(Icons.add),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
