# Implementation Notes

## Current Status

This iOS app implements the core functionality for assessing antiques found in Spanish markets. The app is fully open-source and free to use.

## Features Implemented

### 1. Camera Integration ✅
- Native iOS camera access via `UIImagePickerController`
- Real-time photo capture
- Camera permission handling with bilingual descriptions

### 2. Assessment Service ✅
- Image analysis using Vision framework foundation
- Price estimation algorithm based on similar items
- Authenticity detection with confidence percentages
- Historical period identification with accuracy percentages
- Integration point for todocoleccion.net data

### 3. User Interface ✅
- **Main Screen (ContentView)**: 
  - Camera button for photo capture
  - Image preview
  - Assessment button
  - Loading states
  
- **Results Screen (ResultsView)**:
  - Price estimation with range
  - Authenticity verdict with confidence meter
  - Historical period with accuracy percentage
  - List of similar items from todocoleccion.net
  - Source attribution

### 4. Bilingual Support ✅
- Complete Spanish localization (primary language)
- Complete English localization (secondary language)
- All UI text properly localized
- System language detection

## Technical Architecture

### Data Models
- `AntiqueItem`: Main model containing all assessment data
- `PriceRange`: Min/max price estimates
- `SimilarItem`: Reference items from todocoleccion.net

### Services
- `AssessmentService`: Core business logic
  - Image analysis
  - Price calculation
  - Authenticity determination
  - Period identification
  - Network integration point for todocoleccion.net

### Views
- `ContentView`: Main application view
- `CameraView`: Camera interface wrapper
- `ResultsView`: Detailed assessment results display

## Data Sources

### TodoColección.net Integration ✅
The app now integrates with [TodoColección.net](https://www.todocoleccion.net/), a trusted Spanish antiques marketplace.

**Current Implementation:**
- ✅ Real web scraping using native URLSession
- ✅ HTML parsing without external dependencies (pure Swift)
- ✅ Vision framework integration for image classification
- ✅ Spanish search term mapping for better results
- ✅ Price extraction and parsing
- ✅ Comprehensive error handling

**Features:**
- Searches todocoleccion.net based on image analysis
- Extracts real item names, prices, and URLs
- Returns top 10 similar items
- Handles Spanish characters and formatting
- Multiple parsing strategies for robustness

For detailed information about the web scraping implementation, see [SCRAPING_IMPLEMENTATION.md](SCRAPING_IMPLEMENTATION.md).

## Machine Learning Capabilities

### FastViT Integration ✅
The app uses **FastViT T8 F16** (Fast Vision Transformer) for reliable object recognition:
- State-of-the-art vision transformer optimized for mobile
- Float16 precision for efficiency
- 224x224 input images
- Provides accurate object classifications with confidence scores
- Primary classifier for identifying antique objects

**Implementation:**
- `FastViTService` class handles model loading and inference
- Graceful fallback to Vision framework if model not available
- Model file: `FastViTT8F16.mlpackage` in `MLModels/` directory
- Async/await for non-blocking processing
- Top-N predictions with adaptive confidence thresholding

### Vision Framework (Fallback) ✅
The app uses Apple's Vision framework as a fallback when FastViT is not available:
- Object detection and recognition
- Image classification with VNClassifyImageRequest
- Feature extraction
- Mapping classifications to Spanish antique categories

**Current Implementation:**
- Real Vision framework integration
- Classification mapping (e.g., "coin" → "moneda antigua")
- Async/await for non-blocking image processing
- Error handling for image processing failures

### Authenticity Detection
Current approach:
- Compares captured image features with similar items
- Analyzes image quality and characteristics
- Provides confidence percentage (75-95%)

**Enhancement Opportunities:**
- Train custom CoreML model on antique vs. fake dataset
- Implement material analysis
- Add manufacturing mark detection

### Period Identification
Current approach:
- Analyzes style and features
- Provides historical period estimates
- Returns confidence percentage (70-90%)

**Enhancement Opportunities:**
- Train custom model on historical periods
- Integrate art history databases
- Add style classification (Art Deco, Victorian, etc.)

## Testing Recommendations

### Manual Testing Checklist
- [ ] Camera access permission request
- [ ] Photo capture functionality
- [ ] Image display in main view
- [ ] Assessment button enables after photo capture
- [ ] Loading indicator during assessment
- [ ] Results view displays all data correctly
- [ ] Language switching works (Settings > Language)
- [ ] App icon displays correctly
- [ ] Both orientations work (portrait/landscape)

### Device Testing
- [ ] iPhone SE (small screen)
- [ ] iPhone 14 Pro (standard size)
- [ ] iPhone 14 Pro Max (large screen)
- [ ] iPad (tablet layout)

## Known Limitations

1. **Mock Authenticity/Period Data**: Authenticity and period detection still use simulated data (ML models not trained yet)
2. **Website Structure Dependent**: Web scraping depends on todocoleccion.net's HTML structure
3. **Network Required**: App requires internet connection to search for similar items
4. **No Official API**: Uses web scraping, not an official todocoleccion.net API
5. **No Rate Limiting**: Heavy usage may be rate-limited by todocoleccion.net
6. **No History**: No user history or saved assessments yet

## Future Enhancements

### High Priority
- Custom CoreML models for authenticity detection
- Custom CoreML models for period identification
- User authentication and history
- Caching of search results
- Retry logic with exponential backoff

### Medium Priority
- Official API integration (if todocoleccion.net provides one)
- Export assessment reports (PDF/Share)
- Multiple photo support for single item
- Category-specific assessment (coins, paintings, furniture)
- Community feedback system

### Low Priority
- AR mode for 3D object scanning
- Price trend tracking
- Auction integration
- Social sharing features

## Security Considerations

- Camera permissions properly requested
- No sensitive data stored
- Network requests should use HTTPS
- Input validation for all user data
- Secure storage for user preferences

## Performance

- Lightweight SwiftUI implementation
- Efficient image handling
- Async/await for non-blocking operations
- Memory management for camera resources

## Accessibility

- VoiceOver support via semantic UI elements
- Dynamic Type support for text scaling
- High contrast colors for visibility
- Localized for screen readers

## License

MIT License - See LICENSE file for complete terms.
