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

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
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

  void _navigateToScreen(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget _buildCurrentScreen() {
    switch (_currentIndex) {
      case 0:
        return _buildHomeScreen();
      case 1:
        return const StatisticsScreen();
      case 2:
        return const SettingsScreen();
      case 3:
        return const ProfileScreen();
      default:
        return _buildHomeScreen();
    }
  }

  Widget _buildHomeScreen() {
    final provider = Provider.of<TaskProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: _isSearching 
          ? TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar tareas...',
                border: InputBorder.none,
                hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7)),
              ),
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
              onChanged: (value) {
                provider.setSearchQuery(value);
              },
              autofocus: true,
            )
          : const Text('Lista de Tareas'),
        centerTitle: true,
        elevation: 2,
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: _toggleSearch,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              icon: Icon(Icons.pending_actions),
              text: 'Pendientes',
            ),
            Tab(
              icon: Icon(Icons.task_alt),
              text: 'Completadas',
            ),
          ],
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorWeight: 3,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TaskList(
              tasks: provider.pendingTasks,
              emptyMessage: 'No hay tareas pendientes',
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TaskList(
              tasks: provider.completedTasks,
              emptyMessage: 'No hay tareas completadas',
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      body: _buildCurrentScreen(),
      bottomNavigationBar: BottomAppBar(
        color: colorScheme.surfaceContainerHighest,
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              tooltip: 'Inicio',
              icon: Icon(
                Icons.home,
                color: _currentIndex == 0 ? colorScheme.primary : null,
              ),
              onPressed: () => _navigateToScreen(0),
            ),
            IconButton(
              tooltip: 'Estadísticas',
              icon: Icon(
                Icons.bar_chart,
                color: _currentIndex == 1 ? colorScheme.primary : null,
              ),
              onPressed: () => _navigateToScreen(1),
            ),
            const SizedBox(width: 48),
            IconButton(
              tooltip: 'Ajustes',
              icon: Icon(
                Icons.settings,
                color: _currentIndex == 2 ? colorScheme.primary : null,
              ),
              onPressed: () => _navigateToScreen(2),
            ),
            IconButton(
              tooltip: 'Perfil',
              icon: Icon(
                Icons.person,
                color: _currentIndex == 3 ? colorScheme.primary : null,
              ),
              onPressed: () => _navigateToScreen(3),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const AddTaskDialog(),
          );
        },
        tooltip: 'Agregar Tarea',
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}