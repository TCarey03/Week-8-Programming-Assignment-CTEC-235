Cosmic Explorer App — Development Journal

Phase 1: The Communications Link

Implementation:

I created CosmicExplorerApp, MissionControl, and DockingBay in lib/main.dart. The app starts on Mission Control using the home property of MaterialApp.

I used Navigator.push() with MaterialPageRoute to navigate from Mission Control to the Docking Bay. I used Navigator.pop(context) to return to Mission Control.

Journal Prompt: How does the navigation stack metaphor describe what happens in memory when a user navigates to DockingBay and then taps Return?**

The navigation stack works like a stack of screens. Mission Control is the first screen. When the user taps Enter Docking Bay, the Docking Bay screen is pushed onto the stack above Mission Control. When the user taps Return to Control, Navigator.pop(context) removes the Docking Bay route, revealing Mission Control again. This lets the app return to the previous screen without creating a new Mission Control screen.

-------------------------

Phase 2: The Planetary Database

Implementation

I created a Planet class with three final fields: name, type, and description. I added a const constructor to make the planet records immutable. I also created a PlanetCatalog class with a static const list containing five planets.

I replaced the Mission Control button with a ListView.builder. Each planet appears in a ListTile showing its name and type. When a user taps a planet, Navigator.push() opens PlanetDetail and passes the selected Planet object through its constructor.

Journal Prompt

Why is ListView.builder preferred over a basic ListView or Column? Explain how data is transferred from PlanetCatalog to PlanetDetail.

ListView.builder is preferred for larger collections because it builds list items as they are needed instead of creating every item at once. This can improve performance and reduce unnecessary widget creation. A Column or a ListView with a predefined children list creates the widgets in advance.

The data is transferred by retrieving a Planet object from PlanetCatalog.planets using its index. When the user taps its ListTile, the app passes that object to PlanetDetail using PlanetDetail(planet: planet). The detail screen stores it in its final planet field and uses it to display the name, type, and description.

-----------------------

Phase 3: The Observation Log

Implementation

I added a Confirm Visit button to the PlanetDetail screen. When the user taps it, Navigator.pop() closes the detail screen and returns a confirmation string containing the planet's name.

I updated the MissionControl onTap handler to be asynchronous. It uses await Navigator.push<String>() to wait for the result. After checking context.mounted, the app displays the returned message using a SnackBar.

Journal Prompt

Explain the flow of data in this round-trip navigation. How does MissionControl know when the user has returned from PlanetDetail, and how is the specific return value captured?

MissionControl uses Navigator.push() to open PlanetDetail. The navigation call returns a Future that completes when the detail screen closes. Using await allows MissionControl to capture the returned value in the result variable. PlanetDetail sends the confirmation message through Navigator.pop(context, 'You visited ${planet.name}!'). MissionControl then checks that the result is not null and displays it in a SnackBar. The context.mounted check ensures that the widget is still active before showing the message.

------------------

Phase 4: Mission Command Center

Implementation

I added the go_router package and configured a GoRouter instance with routes for Mission Control, the Docking Bay, and planet details. I replaced MaterialApp with MaterialApp.router.

The planet detail route uses /planet/:id. Mission Control passes the selected planet's index through the URL, and the router uses that index to retrieve the correct planet from PlanetCatalog.

I added a navigation drawer with destinations for Mission Control and the Docking Bay. I used context.go() for drawer navigation and returning from the Docking Bay. I used context.push() for planet details so that the previous screen remains available and can receive the visit confirmation.

I also added a fallback screen for invalid planet IDs.

Journal Prompt

Contrast imperative navigation (Navigator.push) with declarative routing (context.go and GoRouter). How do URL routes make mobile applications more versatile?

Imperative navigation uses commands such as Navigator.push() and Navigator.pop() to add or remove screens from the navigation stack. Declarative routing uses a central router to define which screen corresponds to a particular route.

URLs such as /planet/1 identify a particular destination and allow parameters to determine which data appears. This makes the app easier to organize and supports features such as deep linking and browser navigation in Flutter Web. context.push() also allows a detail page to return data to the previous screen.
