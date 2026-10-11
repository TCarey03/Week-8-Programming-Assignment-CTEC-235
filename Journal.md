Cosmic Explorer App — Development Journal

Phase 1: The Communications Link

Implementation:

I created CosmicExplorerApp, MissionControl, and DockingBay in lib/main.dart. The app starts on Mission Control using the home property of MaterialApp.

I used Navigator.push() with MaterialPageRoute to navigate from Mission Control to the Docking Bay. I used Navigator.pop(context) to return to Mission Control.

Journal Prompt: How does the navigation stack metaphor describe what happens in memory when a user navigates to DockingBay and then taps Return?**

The navigation stack works like a stack of screens. Mission Control is the first screen. When the user taps Enter Docking Bay, the Docking Bay screen is pushed onto the stack above Mission Control. When the user taps Return to Control, Navigator.pop(context) removes the Docking Bay route, revealing Mission Control again. This lets the app return to the previous screen without creating a new Mission Control screen.
