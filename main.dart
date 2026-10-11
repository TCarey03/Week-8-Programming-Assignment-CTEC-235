import 'package:flutter/material.dart';

void main() {
  runApp(const CosmicExplorerApp());
}

// Phase 2: Planet data model
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

// Phase 2: Catalog containing exactly five planets
class PlanetCatalog {
  static const List<Planet> planets = [
    Planet(
      name: 'Mercury',
      type: 'Terrestrial',
      description:
          'Mercury is the smallest planet in our solar system and the '
          'closest planet to the Sun. It has a rocky surface and extreme '
          'temperature changes.',
    ),
    Planet(
      name: 'Mars',
      type: 'Terrestrial',
      description:
          'Mars is known as the Red Planet because of its reddish surface. '
          'Scientists study Mars for evidence of past water and the '
          'possibility of ancient microbial life.',
    ),
    Planet(
      name: 'Jupiter',
      type: 'Gas Giant',
      description:
          'Jupiter is the largest planet in our solar system. It is a gas '
          'giant known for its Great Red Spot and many moons.',
    ),
    Planet(
      name: 'Kepler-186f',
      type: 'Terrestrial',
      description:
          'Kepler-186f is an exoplanet orbiting a star smaller and cooler '
          'than our Sun. It was one of the first Earth-size planets found '
          'in its star’s habitable zone.',
    ),
    Planet(
      name: 'Proxima Centauri b',
      type: 'Exoplanet',
      description:
          'Proxima Centauri b is an exoplanet orbiting Proxima Centauri, '
          'the closest known star to our solar system. Its conditions '
          'for supporting life remain uncertain.',
    ),
  ];
}

// Application entry point
class CosmicExplorerApp extends StatelessWidget {
  const CosmicExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MissionControl(),
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
        title: const Text('Cosmic Explorer - Mission Control'),
      ),
      body: ListView.builder(
        itemCount: PlanetCatalog.planets.length,
        itemBuilder: (context, index) {
          final planet = PlanetCatalog.planets[index];

          return ListTile(
            leading: const Icon(Icons.public),
            title: Text(planet.name),
            subtitle: Text(planet.type),
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              // Open PlanetDetail and wait for a return value.
              final result = await Navigator.push<String>(
                context,
                MaterialPageRoute(
                  builder: (context) => PlanetDetail(
                    planet: planet,
                  ),
                ),
              );

              // Check that the widget is still active.
              if (!context.mounted) return;

              // Display the returned confirmation message.
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

// Planet Detail: displays information about a selected planet
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

            // Phase 3: Return a visit confirmation.
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  context,
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

// Docking Bay: retained from Phase 1 for Phase 4
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
            Navigator.pop(context);
          },
          child: const Text('Return to Control'),
        ),
      ),
    );
  }
}
