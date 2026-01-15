#  Rick and Morty App

A production-style SwiftUI iOS app that lists Rick and Morty characters, supports search and filtering, and navigates to a character details screen.

## Requirements

- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+

## How to Run

1. Clone the repository
2. Open `RickyMortyApp.xcodeproj` in Xcode
3. Select a simulator (iOS 16+)
4. Press `Cmd + R` to build and run

To run tests: `Cmd + U`

## Architecture

### MVVM + Coordinator with Clean Layers

The project follows **MVVM (Model-View-ViewModel)** architecture with a **Coordinator** pattern for clean separation of concerns:

```
RickyMortyApp/
├── App/              # Application entry & coordination
│   └── AppCoordinator.swift  # ViewModel factory & navigation
├── Domain/           # Business logic layer
│   ├── Models/       # Character, CharacterPage, enums
│   ├── Errors/       # APIError
│   └── Logger/       # Logging protocol & implementation
├── Data/             # Data access layer
│   ├── Network/      # URLSessionProtocol, Endpoint, APIClient
│   └── Repositories/ # CharacterRepository protocol & implementation
├── Presentation/     # Presentation logic layer
│   ├── CharacterList/    # ViewModel & ViewState
│   └── CharacterDetail/  # ViewModel & ViewState
└── UI/               # View layer
    ├── Components/   # Reusable views (Loading, Error, Empty)
    ├── CharacterList/    # List & Row views
    └── CharacterDetail/  # Detail view
```

### Why MVVM + Coordinator?

- **Single Responsibility**: ViewModels only handle their own logic, not other ViewModels
- **Testability**: ViewModels are isolated from UI, making unit testing straightforward
- **Separation of Concerns**: Clear boundaries between UI, business logic, and data
- **SwiftUI Native**: `@Published` properties work naturally with SwiftUI's reactive updates
- **Scalability**: Easy to extend with new features without touching existing code
- **Clean Architecture**: Views don't know about Repositories, only ViewModels

## Dependency Injection

All dependencies are injected via **constructor injection** with a **Coordinator**:

- `AppCoordinator` holds the `Repository` and creates ViewModels via factory methods
- `RickyMortyAppApp` (entry point) wires all dependencies and injects the Coordinator
- Views receive ViewModels through initializers, never creating them directly

**Benefits:**
- No global singletons for core dependencies
- Easy to swap implementations (e.g., mock repository for tests)
- Dependencies are explicit and traceable
- **Coordinator pattern** keeps View layer clean (Views only know ViewModels)
- **ViewModels don't create other ViewModels** (Single Responsibility)

## Testing

### What's Tested

#### 1. ViewModel Tests (`CharacterListViewModelTests.swift`)
- **State transitions**: Loading → Loaded, Loading → Empty, Loading → Error
- **Search behavior**: Debounce triggers fetch, resets pagination to page 1
- **Filter behavior**: Status filter changes trigger fetch with correct parameter
- **Pagination**: Load more appends results, stops when no more pages
- **Retry**: Error state allows retry and recovers to loaded state

#### 2. API/Service Tests (`APIClientTests.swift`)
- **Success decoding**: Valid JSON decodes to correct model
- **404 handling**: Returns `.notFound` error
- **500 handling**: Returns `.unknown(statusCode:)` error
- **Invalid JSON**: Returns `.decodingError` with context
- **Network errors**: URLError maps to `.networkError`

### Why These Tests?

- **Deterministic**: All tests use mocked dependencies, no real network calls
- **Fast**: Tests run in milliseconds
- **Comprehensive**: Cover happy paths and error scenarios
- **Requirement-driven**: Directly verify spec requirements (debounce, pagination reset)

## Observability & Security

### Observability

A **`Logger` protocol** was implemented to abstract logging functionality. This design enables:

- **Swappable implementations**: The current `ConsoleLogger` can be replaced with production-grade tools without changing application code
- **Scalability**: Ready to integrate with services like **Datadog**, **Bugsnag**, **Crashlytics**, **Sentry**, or **New Relic**
- **Separation of concerns**: User-friendly messages for UI, technical details for logs
- **Contextual logging**: Errors logged with URL, response type, and status codes

**In practice:** Users see friendly messages like "Something went wrong. Please try again later." while logs capture technical details like "DecodingError: keyNotFound at results.0" along with the URL and response type.

### Security

- **No secrets**: API requires no authentication
- **No persistent storage**: Data is fetched fresh, no local caching of sensitive info
- **HTTPS only**: All API calls use secure connections

## Features Implemented

- [x] Character list with image, name, status, species
- [x] Search by name (case-insensitive)
- [x] Filter by status (All / Alive / Dead / Unknown)
- [x] Debounce search input (300ms)
- [x] Pagination (infinite scroll)
- [x] Stete Handling: Loading / Error / Empty states
- [x] Retry on error
- [x] Character detail screen (fetches by ID)
- [x] Detail shows: image, name, status, species, gender, origin, location, episode count

## What I Would Improve Next

With more time, I would add:

### Code Organization
1. **Constants file**: Centralize magic values (API base URL, debounce interval, pagination size) in a single `Constants.swift`
2. **Design system**: Extract colors, fonts, spacing into reusable tokens
3. **SwiftLint**: Add linting rules for consistent code style

### Features
4. **Image caching**: Custom cache or third-party library for better performance
5. **Pull-to-refresh**: Allow manual refresh of character list
6. **Skeleton loading**: Placeholder shimmer effect while loading
7. **Offline support**: Cache last successful response with expiration
8. **Locations/Episodes tabs section**: Expand app with additional API endpoints

### Quality & Testing
9. **UI tests**: Snapshot tests for visual regression
10. **Accessibility**: VoiceOver labels, Dynamic Type support
11. **Error analytics**: Send errors to monitoring service (Crashlytics/Sentry)

### Infrastructure
12. **Environment configuration**: Dev/Staging/Prod API endpoints
13. **CI/CD pipeline**: GitHub Actions for automated testing
14. **Localization**: Support multiple languages

### Alternative Approaches Considered
15. **Combine for reactive streams**: The current debounce uses `Task.sleep` + cancellation (pure Swift Concurrency). For apps with more complex reactive needs (multiple streams, throttling, merging), Combine's `.debounce()` operator could be an alternative. The Task-based approach was chosen for consistency with async/await throughout the codebase and simpler testability (injectable debounce interval).

## API Reference

- Base URL: `https://rickandmortyapi.com/api`
- [Documentation](https://rickandmortyapi.com/documentation)

### Endpoints Used

| Endpoint | Description |
|----------|-------------|
| `GET /character?page=1` | List characters (paginated) |
| `GET /character?name=rick` | Filter by name |
| `GET /character?status=alive` | Filter by status |
| `GET /character/{id}` | Get character details |
