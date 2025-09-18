# Google Keep Clone - Flutter

A Flutter implementation of Google Keep with Firebase integration, featuring a modern UI and full note-taking functionality.

## Features

### Core Features
- ✅ Create, edit, and delete notes
- ✅ Pin/unpin notes
- ✅ Archive and restore notes
- ✅ Color-coded notes (6 colors)
- ✅ Labels system
- ✅ Reminders with date/time picker
- ✅ Search functionality
- ✅ Dark/Light theme support

### UI/UX Features
- ✅ Material Design 3
- ✅ Responsive grid layout
- ✅ Sticky note aesthetic
- ✅ Smooth animations
- ✅ Hover effects
- ✅ Empty states
- ✅ Loading states
- ✅ Error handling

### Technical Features
- ✅ Firebase Firestore integration
- ✅ State management with Provider
- ✅ Clean architecture
- ✅ Type-safe models
- ✅ Error handling
- ✅ Offline support (Firestore)

## Project Structure

```
lib/
├── constants/          # App constants and strings
├── models/            # Data models (Note, etc.)
├── providers/         # State management (NoteProvider, ThemeProvider)
├── services/          # Firebase and API services
├── screens/           # Main app screens
├── widgets/           # Reusable UI components
└── utils/             # Utility functions
```

## Getting Started

### Prerequisites
- Flutter SDK (3.8.1 or higher)
- Dart SDK
- Android Studio / VS Code
- Firebase project

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd google_keep_clone_flutter
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**
   - Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
   - Enable Firestore Database
   - Download `google-services.json` and place it in `android/app/`
   - Update the Firebase configuration in `lib/services/firebase_service.dart`

4. **Run the app**
   ```bash
   flutter run
   ```

## Configuration

### Firebase Configuration
The app uses the same Firebase project as the Next.js version. Update the configuration in:
- `lib/services/firebase_service.dart`
- `android/app/google-services.json`

### Theme Configuration
Customize themes in:
- `lib/providers/theme_provider.dart`
- `lib/constants/app_constants.dart`

## Architecture

### State Management
- **Provider**: Used for state management
- **NoteProvider**: Manages note-related state and operations
- **ThemeProvider**: Manages theme and UI preferences

### Data Layer
- **FirebaseService**: Firebase initialization and configuration
- **NoteService**: CRUD operations for notes
- **Models**: Type-safe data structures

### UI Layer
- **Screens**: Main app screens (Home, Archive, Trash, etc.)
- **Widgets**: Reusable UI components
- **Providers**: State management integration

## Key Components

### NoteCard
- Displays individual notes with sticky note styling
- Hover effects for action buttons
- Color-coded backgrounds
- Label and reminder display

### CreateNoteWidget
- Expandable note creation interface
- Color picker
- Label management
- Reminder picker

### NavigationDrawer
- Side navigation for different sections
- Material Design 3 styling

## Features Comparison with Next.js Version

| Feature | Next.js | Flutter | Status |
|---------|---------|---------|--------|
| Create Notes | ✅ | ✅ | Complete |
| Edit Notes | ✅ | 🔄 | In Progress |
| Delete Notes | ✅ | ✅ | Complete |
| Pin/Unpin | ✅ | ✅ | Complete |
| Archive | ✅ | ✅ | Complete |
| Color Coding | ✅ | ✅ | Complete |
| Labels | ✅ | 🔄 | Partial |
| Reminders | ✅ | ✅ | Complete |
| Search | ✅ | ✅ | Complete |
| Dark Theme | ✅ | ✅ | Complete |
| Responsive | ✅ | ✅ | Complete |
| Firebase | ✅ | ✅ | Complete |

## Development

### Adding New Features
1. Create models in `lib/models/`
2. Add services in `lib/services/`
3. Update providers in `lib/providers/`
4. Create UI components in `lib/widgets/`
5. Add screens in `lib/screens/`

### Code Style
- Follow Flutter/Dart conventions
- Use meaningful variable names
- Add comments for complex logic
- Maintain consistent formatting

## Dependencies

### Core
- `flutter`: SDK
- `provider`: State management
- `firebase_core`: Firebase initialization
- `cloud_firestore`: Database
- `firebase_auth`: Authentication

### UI
- `material_design_icons_flutter`: Icons
- `flutter_colorpicker`: Color selection
- `flutter_staggered_grid_view`: Grid layout

### Utilities
- `intl`: Date formatting
- `uuid`: Unique IDs
- `shared_preferences`: Local storage

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is for educational purposes. Please respect Google's trademarks and terms of service.

## Acknowledgments

- Google Keep for the original design inspiration
- Flutter team for the amazing framework
- Firebase for backend services
- Material Design for UI guidelines