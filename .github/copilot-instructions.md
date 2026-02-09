# Copilot Instructions for Antique Assessor / Tasador de Antigüedades

## Project Overview

This is an **iOS application** built with **SwiftUI** that helps users assess antiques found in Spanish markets. The app uses camera capture, image recognition, and price estimation based on data from TodoColección.net.

### Key Facts
- **Language**: Swift 5.0+
- **Framework**: SwiftUI (declarative UI)
- **Platform**: iOS 15.0+
- **Build Tool**: Xcode 15.0+
- **License**: MIT (open source)
- **Primary Language**: Spanish (with English localization)
- **No External Dependencies**: Uses only native iOS frameworks

## Repository Structure

```
antique-prices/
├── .github/
│   └── copilot-instructions.md     # This file
├── AntiqueAssessor/                # iOS app root
│   ├── AntiqueAssessor.xcodeproj/  # Xcode project (DO NOT modify directly)
│   └── AntiqueAssessor/            # Source code
│       ├── AntiqueAssessorApp.swift        # App entry point (@main)
│       ├── ContentView.swift               # Main UI view
│       ├── CameraView.swift                # Camera interface
│       ├── ResultsView.swift               # Results display
│       ├── Models/
│       │   └── AntiqueItem.swift          # Data models
│       ├── Services/
│       │   └── AssessmentService.swift    # Business logic
│       ├── Localization/
│       │   ├── es.lproj/                  # Spanish strings
│       │   └── en.lproj/                  # English strings
│       ├── Assets.xcassets/               # Images, icons, colors
│       └── Info.plist                     # App configuration
├── README.md                       # User-facing documentation
├── BUILD.md                        # Build and setup guide
├── IMPLEMENTATION.md               # Technical implementation details
├── CONTRIBUTING.md                 # Contribution guidelines
├── API_INTEGRATION.md              # TodoColección.net integration guide
├── PROJECT_SUMMARY.md              # Project overview
└── LICENSE                         # MIT License

```

## Technology Stack

### Frameworks and APIs
- **SwiftUI**: Modern declarative UI framework (all views use SwiftUI, NOT UIKit)
- **Vision Framework**: Image analysis and object recognition
- **CoreML**: Machine learning models for authenticity and period detection
- **UIKit**: Limited use for camera (UIImagePickerController)
- **Foundation**: Core data types and utilities
- **Async/Await**: Modern Swift concurrency (NOT completion handlers)

### Important Notes
- **NO CocoaPods, SPM, or Carthage dependencies** - This is a pure Apple frameworks project
- **NO Storyboards** - All UI is programmatic SwiftUI
- **NO Objective-C** - Pure Swift codebase
- **NO Unit Tests Yet** - Test infrastructure needs to be added

## Building and Testing

### Prerequisites
⚠️ **This project requires macOS and Xcode** - Linux/Windows cannot build iOS apps

```bash
# Verify Xcode is installed
xcode-select -p

# If not installed, install Xcode Command Line Tools
xcode-select --install
```

### Building the Project

**Option 1: Using Xcode GUI (Recommended)**
```bash
cd /path/to/antique-prices
open AntiqueAssessor/AntiqueAssessor.xcodeproj
# Then press Cmd+R to build and run
```

**Option 2: Command Line (for CI or non-macOS environments)**
⚠️ **Will NOT work in Linux environments** - xcodebuild requires macOS

```bash
cd AntiqueAssessor

# List available schemes
xcodebuild -list

# Build for simulator
xcodebuild -project AntiqueAssessor.xcodeproj \
           -scheme AntiqueAssessor \
           -destination 'platform=iOS Simulator,name=iPhone 14 Pro' \
           build

# Run tests (when implemented)
xcodebuild test -project AntiqueAssessor.xcodeproj \
                -scheme AntiqueAssessor \
                -destination 'platform=iOS Simulator,name=iPhone 14 Pro'
```

### Known Build Issues and Workarounds

#### Issue 1: "No Development Team Selected"
**Symptom**: Code signing error when trying to run on device
**Workaround**:
1. Open project in Xcode
2. Go to Signing & Capabilities tab
3. Check "Automatically manage signing"
4. Select your Apple ID team (free account works)
5. If needed, change Bundle Identifier to something unique

#### Issue 2: "xcodebuild command not found"
**Symptom**: Command line builds fail
**Root Cause**: Running in non-macOS environment or Xcode not installed
**Workaround**: 
- This project **requires macOS and Xcode** to build
- Cannot be built on Linux/Windows/Docker
- For code analysis only, you can view Swift files without building

#### Issue 3: Camera doesn't work in Simulator
**Symptom**: Camera UI doesn't open in iOS Simulator
**Root Cause**: Simulators don't have camera hardware
**Workaround**: 
- Must test camera features on physical device
- Or use photo library (feature not yet implemented)

#### Issue 4: DerivedData corruption
**Symptom**: Random build failures, "Module not found" errors
**Workaround**:
```bash
# Clean build folder in Xcode: Cmd+Shift+K
# Or delete DerivedData:
rm -rf ~/Library/Developer/Xcode/DerivedData
```

## Development Workflow

### Making Code Changes

1. **Understand the Architecture**:
   - **View Layer**: ContentView, CameraView, ResultsView (SwiftUI)
   - **Model Layer**: AntiqueItem.swift (data structures)
   - **Service Layer**: AssessmentService.swift (business logic)
   - **Localization**: Strings in es.lproj and en.lproj

2. **Follow SwiftUI Patterns**:
   - Use `@State` for view-local state
   - Use `@StateObject` for observable objects
   - Use `@Binding` for two-way data flow
   - Keep views small and composable

3. **Use Modern Swift**:
   - Prefer `async/await` over completion handlers
   - Use `Task` for async operations
   - Use `MainActor` for UI updates
   - Avoid force unwrapping (`!`) - use optional binding

4. **Localization is Required**:
   - All user-facing strings must be in both Spanish and English
   - Use `Text("key")` in SwiftUI (auto-localizes)
   - Update both `es.lproj/Localizable.strings` and `en.lproj/Localizable.strings`

### Common Development Tasks

#### Adding a New View
```swift
// 1. Create new Swift file in AntiqueAssessor/AntiqueAssessor/
// 2. Import SwiftUI
import SwiftUI

struct MyNewView: View {
    var body: some View {
        Text("Hello")
    }
}

// 3. Add preview
struct MyNewView_Previews: PreviewProvider {
    static var previews: some View {
        MyNewView()
    }
}
```

#### Adding a New Model
```swift
// Add to Models/AntiqueItem.swift or create new file
struct MyModel: Identifiable, Codable {
    let id: UUID
    let name: String
    
    init(id: UUID = UUID(), name: String) {
        self.id = id
        self.name = name
    }
}
```

#### Adding Localized Strings
```
// In Localization/es.lproj/Localizable.strings
"my_key" = "Mi texto en español";

// In Localization/en.lproj/Localizable.strings
"my_key" = "My text in English";

// In SwiftUI view
Text("my_key") // Will show correct language based on device settings
```

#### Modifying the Assessment Logic
- Edit `Services/AssessmentService.swift`
- Current implementation uses **mock data** - see comments for integration points
- Key methods:
  - `assessAntique(image:)` - Main entry point
  - `analyzeImage(_:)` - Vision framework integration point
  - `searchSimilarItems(description:)` - TodoColección.net integration point
  - `calculatePriceEstimate(from:)` - Price calculation logic
  - `determineAuthenticity(image:similarItems:)` - ML authenticity check
  - `determinePeriod(image:description:)` - Historical period identification

### Testing Your Changes

1. **Manual Testing** (current approach):
   - Build and run in Xcode
   - Test on multiple simulators (small/medium/large screens)
   - Test on physical device for camera features
   - Test in both Spanish and English (Settings > General > Language)

2. **Unit Testing** (not yet implemented):
   - No test target exists yet
   - To add tests: File > New > Target > iOS Unit Testing Bundle
   - Follow Apple's XCTest framework

## Code Style and Conventions

### Swift Style
- **Naming**: Use camelCase for variables/functions, PascalCase for types
- **Indentation**: 4 spaces (no tabs)
- **Line Length**: Keep lines under 120 characters
- **Braces**: Opening brace on same line
- **Optionals**: Prefer optional binding over force unwrapping
- **Access Control**: Use `private` for internal implementation details

### SwiftUI Best Practices
```swift
// ✅ Good - Small, focused views
struct MyButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
    }
}

// ❌ Bad - Mixing business logic with view
struct MyView: View {
    var body: some View {
        Button("Click") {
            // Don't put complex logic here
            let result = complexCalculation()
            saveToDatabase(result)
        }
    }
}

// ✅ Good - Separate concerns
struct MyView: View {
    @StateObject private var viewModel = MyViewModel()
    
    var body: some View {
        Button("Click") {
            viewModel.performAction()
        }
    }
}
```

### Error Handling
```swift
// ✅ Good - Proper async error handling
func loadData() async {
    do {
        let result = try await service.fetchData()
        await MainActor.run {
            self.data = result
        }
    } catch {
        await MainActor.run {
            self.errorMessage = error.localizedDescription
        }
    }
}

// ❌ Bad - Ignoring errors
func loadData() {
    Task {
        try? await service.fetchData() // Error silently ignored
    }
}
```

## Integration Points

### TodoColección.net Integration
**Status**: Currently using **mock data** - real integration needed

**Where to Implement**: `AssessmentService.swift` > `searchSimilarItems(description:)`

**Approaches**:
1. **Web Scraping** (no API key needed, but fragile)
2. **Official API** (if available - needs API key)

See `API_INTEGRATION.md` for detailed examples and code samples.

### Vision Framework Usage
**Status**: Basic structure in place, needs enhancement

**Current**: Placeholder logic in `analyzeImage(_:)` method

**Enhancement Needed**:
- Implement actual Vision requests (VNImageRequestHandler)
- Add object recognition
- Add text recognition (for signatures, marks)
- Train custom CoreML model for antique-specific recognition

### CoreML Model Integration
**Status**: Not implemented yet

**To Add**:
1. Train model in Create ML or TensorFlow
2. Export as .mlmodel file
3. Add to Xcode project (drag into navigator)
4. Import and use in AssessmentService

Example structure provided in `API_INTEGRATION.md`.

## Localization

### Supported Languages
- **Spanish (es)**: Primary language, default
- **English (en)**: Secondary language

### Adding Translations
1. Add key to `Localization/es.lproj/Localizable.strings`
2. Add same key to `Localization/en.lproj/Localizable.strings`
3. Use in code: `Text("your_key")` or `NSLocalizedString("your_key", comment: "")`

### Testing Different Languages
- iOS Simulator: Settings > General > Language & Region > iPhone Language
- Xcode Scheme: Edit Scheme > Run > Options > App Language

## Common Pitfalls and Solutions

### 1. Modifying .xcodeproj Directly
❌ **Don't**: Edit .xcodeproj files manually (they're XML/JSON but managed by Xcode)
✅ **Do**: Use Xcode GUI to add files, change settings, manage targets

### 2. UIKit vs SwiftUI Mixing
❌ **Don't**: Mix UIKit view controllers with SwiftUI unnecessarily
✅ **Do**: Use SwiftUI-native components when available
✅ **Exception**: Camera uses `UIViewControllerRepresentable` wrapper (required)

### 3. Synchronous Network Calls
❌ **Don't**: Use URLSession synchronous methods
✅ **Do**: Use `async/await` with URLSession:
```swift
let (data, response) = try await URLSession.shared.data(from: url)
```

### 4. Ignoring Localization
❌ **Don't**: Hardcode strings in English only
✅ **Do**: Always use localization keys for user-facing text

### 5. Force Unwrapping
❌ **Don't**: Use `!` unless absolutely necessary
✅ **Do**: Use optional binding:
```swift
// Bad
let image = UIImage(named: "icon")!

// Good
guard let image = UIImage(named: "icon") else { return }
```

## Project-Specific Notes

### Mock Data vs Real Data
**Important**: The app currently returns **simulated assessment results**

**Mock Data Locations**:
- `AssessmentService.swift` > `searchSimilarItems()` - Returns fake similar items
- `AssessmentService.swift` > `determineAuthenticity()` - Returns random confidence
- `AssessmentService.swift` > `determinePeriod()` - Returns random period

**To Implement Real Data**:
1. See `API_INTEGRATION.md` for TodoColección.net integration
2. Replace mock methods with actual API/scraping calls
3. Train CoreML models for authenticity and period detection

### Camera Permissions
- Camera usage description in `Info.plist`: "NSCameraUsageDescription"
- Permission requested automatically on first camera use
- Already configured with bilingual descriptions

### No User Authentication
- App doesn't store user data currently
- No backend server or database
- All assessments are ephemeral (not saved)
- Future enhancement: Add user history and cloud sync

### No CI/CD Yet
- No GitHub Actions workflows configured
- No automated testing
- No automated deployment
- Recommended: Add CI workflow for builds (requires macOS runner)

## Documentation Files

When making changes, update relevant documentation:

- **README.md**: User-facing features, installation, usage
- **BUILD.md**: Build instructions, troubleshooting, setup
- **IMPLEMENTATION.md**: Technical architecture, implementation status
- **CONTRIBUTING.md**: Contribution guidelines, coding standards
- **API_INTEGRATION.md**: Integration examples, code samples
- **PROJECT_SUMMARY.md**: High-level project overview

## Security Considerations

- ✅ No hardcoded credentials (API keys should go in Keychain)
- ✅ Camera permissions properly requested
- ✅ HTTPS for network requests (when implemented)
- ❌ No input validation yet (needs to be added)
- ❌ No rate limiting (needs to be added for API calls)

## Performance Notes

- **Image Processing**: Images should be resized before analysis (max 1024px)
- **Network Calls**: Use async/await to avoid blocking UI
- **Memory**: Dispose of large images after processing
- **Caching**: No caching implemented yet (recommended for similar items)

## Getting Help

If you encounter issues:

1. **Check BUILD.md** for build troubleshooting
2. **Check IMPLEMENTATION.md** for technical details
3. **Check API_INTEGRATION.md** for integration examples
4. **Search Issues** on GitHub for known problems
5. **Ask in Discussions** for general questions

## Quick Reference Commands

```bash
# Open project in Xcode
open AntiqueAssessor/AntiqueAssessor.xcodeproj

# Check Swift version
swift --version

# Clean build artifacts
rm -rf ~/Library/Developer/Xcode/DerivedData

# Find Swift files
find AntiqueAssessor -name "*.swift"

# Search for text in code
grep -r "searchText" AntiqueAssessor --include="*.swift"

# View project structure
tree AntiqueAssessor -I DerivedData
```

## Summary for AI Agents

When working on this project:

1. ✅ This is an **iOS/Swift/SwiftUI** project requiring **macOS + Xcode**
2. ✅ **No external dependencies** - only native Apple frameworks
3. ✅ Use **async/await**, not completion handlers
4. ✅ All UI is **SwiftUI**, not UIKit (except camera wrapper)
5. ✅ **Localization required** for all user-facing strings (Spanish + English)
6. ✅ Current implementation uses **mock data** - integration points documented
7. ✅ **No tests** exist yet - add test infrastructure as needed
8. ✅ Follow **Apple's Swift style guide** and SwiftUI best practices
9. ⚠️ Cannot build on Linux/Windows - requires macOS
10. ⚠️ Camera features require physical device testing

Read the comprehensive documentation files for detailed information:
- User guide: `README.md`
- Build guide: `BUILD.md`  
- Technical details: `IMPLEMENTATION.md`
- Contribution guide: `CONTRIBUTING.md`
- Integration guide: `API_INTEGRATION.md`
