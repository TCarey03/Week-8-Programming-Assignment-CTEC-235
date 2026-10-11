import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(const CosmicExplorerApp());
}

// PHASE 2: Planet data model
class Planet {
  final String name;
  final String type;
  final String description;

  const Planet({
    required this.name,
    required this.type,
    required this.description,
  });
}

// PHASE 2: Catalog containing five planets
class PlanetCatalog {
  static const List<Planet> planets = [
    Planet(
      name: 'Mercury',
      type: 'Terrestrial',
      description:
          'Mercury is the smallest planet in our solar system '
          'and the closest planet to the Sun. It has a rocky '
          'surface and extreme temperature changes.',
    ),
    Planet(
      name: 'Mars',
      type: 'Terrestrial',
      description:
          'Mars is known as the Red Planet because of its '
          'reddish surface. Scientists study Mars for evidence '
          'of past water and possible ancient microbial life.',
    ),
    Planet(
      name: 'Jupiter',
      type: 'Gas Giant',
      description:
          'Jupiter is the largest planet in our solar system. '
          'It is a gas giant known for its Great Red Spot '
          'and many moons.',
    ),
    Planet(
      name: 'Kepler-186f',
      type: 'Terrestrial',
      description:
          'Kepler-186f is an exoplanet orbiting a star smaller '
          'and cooler than our Sun. It was one of the first '
          'Earth-size planets found in its star’s habitable zone.',
    ),
    Planet(
      name: 'Proxima Centauri b',
      type: 'Exoplanet',
      description:
          'Proxima Centauri b is an exoplanet orbiting Proxima '
          'Centauri, the closest known star to our solar system. '
          'Its conditions for supporting life remain uncertain.',
    ),
  ];
}

// PHASE 4: Configure declarative routing
final GoRouter myRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MissionControl(),
    ),
    GoRoute(
      path: '/docking-bay',
      builder: (context, state) => const DockingBay(),
    ),
    GoRoute(
      path: '/planet/:id',
      builder: (context, state) {
        final id = int.tryParse(
          state.pathParameters['id'] ?? '',
        );

        // Handle invalid planet IDs safely.
        if (id == null ||
            id < 0 ||
            id >= PlanetCatalog.planets.length) {
          return const UnknownPlanetScreen();
        }

        final planet = PlanetCatalog.planets[id];

        return PlanetDetail(planet: planet);
      },
    ),
  ],
);

// Application entry point
class CosmicExplorerApp extends StatelessWidget {
  const CosmicExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: myRouter,
    );
  }
}

// Mission Control: displays the planetary catalog
class MissionControl extends StatelessWidget {
  const MissionControl({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cosmic Explorer - Mission Control',
        ),
      ),

      // PHASE 4: Navigation drawer
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'IEA Command Systems',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Mission Control'),
              onTap: () {
                Navigator.pop(context);
                context.go('/');
              },
            ),
            ListTile(
              leading: const Icon(Icons.rocket_launch),
              title: const Text('Docking Bay'),
              onTap: () {
                Navigator.pop(context);
                context.go('/docking-bay');
              },
            ),
          ],
        ),
      ),

      // PHASE 2 and 3: Planet list and returned messages
      body: ListView.builder(
        itemCount: PlanetCatalog.planets.length,
        itemBuilder: (context, index) {
          final planet = PlanetCatalog.planets[index];

          return ListTile(
            leading: const Icon(Icons.public),
            title: Text(planet.name),
            subtitle: Text(planet.type),
            trailing: const Icon(Icons.chevron_right),

            // PHASE 4: Navigate using a URL parameter.
            onTap: () async {
              final result = await context.push<String>(
                '/planet/$index',
              );

              if (!context.mounted) return;

              if (result != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(result),
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}

// Planet detail screen
class PlanetDetail extends StatelessWidget {
  final Planet planet;

  const PlanetDetail({
    super.key,
    required this.planet,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(planet.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              planet.name,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),
            Text(
              'Planet Type: ${planet.type}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Text(
              planet.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),

            // PHASE 3: Return a confirmation message.
            ElevatedButton(
              onPressed: () {
                context.pop(
                  'You visited ${planet.name}!',
                );
              },
              child: const Text('Confirm Visit'),
            ),
          ],
        ),
      ),
    );
  }
}

// Docking Bay: now uses declarative navigation
class DockingBay extends StatelessWidget {
  const DockingBay({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Docking Bay Telemetry'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            context.go('/');
          },
          child: const Text('Return to Control'),
        ),
      ),
    );
  }
}

// Fallback screen for invalid planet IDs
class UnknownPlanetScreen extends StatelessWidget {
  const UnknownPlanetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Planet Not Found'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'This planet is not in the mission catalog.',
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Return to Mission Control'),
            ),
          ],
        ),
      ),
    );
  }
}
