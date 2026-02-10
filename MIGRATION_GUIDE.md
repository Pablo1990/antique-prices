# Migration Guide: From Scraping to Legal Architecture

This guide documents the migration from the illegal scraping-based architecture to the legal, user-assisted architecture.

## Breaking Changes

### 1. Removed Files
- **TodoColeccionScraper.swift** - Completely removed
  - All scraping logic deleted
  - No replacement needed - functionality replaced by user manual browsing

### 2. Changed Models

#### AntiqueItem (Breaking)

**Before**:
```swift
struct AntiqueItem {
    let estimatedPrice: Double
    let priceRange: PriceRange
    let isAuthentic: Bool
    let authenticityConfidence: Double
    let period: String
    let periodConfidence: Double
    let source: String
    let similarItems: [SimilarItem]
}
```

**After**:
```swift
struct AntiqueItem {
    let estimatedPrice: Double
    let priceRange: PriceRange
    
    // NEW: User-provided data
    let userProvidedPrices: UserProvidedPrices
    let conditionAssessment: ConditionAssessment
    
    // NEW: Calculated factors
    let conditionFactor: Double
    let rarityFactor: Double
    
    // NEW: Image analysis
    let suggestedCategory: String
    let suggestedKeywords: [String]
    let analysisConfidence: Double
    
    // REMOVED: isAuthentic, authenticityConfidence, period, 
    //          periodConfidence, source, similarItems
}
```

**Migration**: If you have stored `AntiqueItem` objects, they will need to be recreated with the new structure. Old assessments cannot be directly migrated.

### 3. Changed AssessmentService API

**Before**:
```swift
func assessAntique(image: UIImage) async throws -> AntiqueItem {
    // Performed scraping, returned complete assessment
}
```

**After**:
```swift
// Step 1: Analyze image
func analyzeImage(_ image: UIImage) async throws -> ImageAnalysisResult

// Step 2: User browses Safari manually (no API call)

// Step 3: Create final assessment with user data
func createFinalAssessment(
    imageAnalysis: ImageAnalysisResult,
    userPrices: UserProvidedPrices,
    condition: ConditionAssessment
) -> AntiqueItem
```

**Migration**: Replace single `assessAntique()` call with three-step process:
1. Call `analyzeImage()` to get keywords
2. Open Safari for user browsing
3. Call `createFinalAssessment()` with user inputs

### 4. New Required User Input

Your app now requires users to:
- **Browse todocoleccion.net manually** in Safari
- **Enter prices** they observed (min, median, max)
- **Rate condition** of the antique
- **Assess rarity** based on their research

### 5. New Views Required

You must integrate these new views into your app:
- `SafariView` - For displaying todocoleccion.net
- `PriceInputView` - For collecting price data
- `ConditionScoringView` - For collecting condition assessment

### 6. New Localization Keys

50+ new localization keys added. See:
- `Localization/en.lproj/Localizable.strings`
- `Localization/es.lproj/Localizable.strings`

## Step-by-Step Migration

### Step 1: Update Your UI Flow

**Before**:
```swift
// Old ContentView
Button("Assess Antique") {
    let result = await assessmentService.assessAntique(image: image)
    // Show results
}
```

**After**:
```swift
// New ContentView - Step-by-step
// Step 1: Analyze
let analysis = await assessmentService.analyzeImage(image)

// Step 2: Browse (user-triggered)
if let url = analysis.generateSearchURL() {
    showSafari = true  // Shows SFSafariViewController
}

// Step 3: Price input (after Safari)
showPriceInput = true  // Shows PriceInputView

// Step 4: Condition (after price input)
showConditionScoring = true  // Shows ConditionScoringView

// Step 5: Results (after condition)
let result = assessmentService.createFinalAssessment(
    imageAnalysis: analysis,
    userPrices: prices,
    condition: condition
)
```

### Step 2: Remove Scraping Dependencies

Remove any code that:
- Makes HTTP requests to todocoleccion.net
- Parses HTML
- Extracts data from web pages
- Caches scraped results

### Step 3: Add Legal Disclaimers

Add disclaimers to your UI:
```swift
VStack {
    HStack {
        Image(systemName: "info.circle.fill")
        Text("disclaimer_title")
    }
    Text("price_estimation_disclaimer")
    Text("todocoleccion_attribution")
}
```

### Step 4: Update Data Storage

If you persist `AntiqueItem` objects:
- Old format is incompatible
- Need to create new storage schema
- Consider versioning your data model

### Step 5: Test User Flow

Test complete flow:
1. Camera → Image
2. Analysis → Keywords
3. Safari → Browse
4. Price Input → User enters data
5. Condition → User rates item
6. Results → Show estimate

## API Changes Reference

### Removed Methods
```swift
// REMOVED
func assessAntique(image: UIImage) async throws -> AntiqueItem
func searchSimilarItems(description: String) async throws -> [SimilarItem]
func calculatePriceEstimate(from items: [SimilarItem]) -> (average: Double, min: Double, max: Double)
func determineAuthenticity(image: UIImage, similarItems: [SimilarItem]) async -> (isAuthentic: Bool, confidence: Double)
func determinePeriod(image: UIImage, description: String) async -> (period: String, confidence: Double)
```

### New Methods
```swift
// NEW
func analyzeImage(_ image: UIImage) async throws -> ImageAnalysisResult

func createFinalAssessment(
    imageAnalysis: ImageAnalysisResult,
    userPrices: UserProvidedPrices,
    condition: ConditionAssessment
) -> AntiqueItem

func calculatePriceEstimate(
    userPrices: UserProvidedPrices,
    condition: ConditionAssessment
) -> AntiqueItem
```

### Error Handling Changes

**Before**:
```swift
enum AssessmentError: Error {
    case imageProcessingFailed
    case networkError
    case noSimilarItemsFound
}
```

**After**:
```swift
enum AssessmentError: Error {
    case imageProcessingFailed
    case missingUserData
}
```

## Xcode Project Changes

The Xcode project file (`project.pbxproj`) has been updated:

**Removed from Build Phases**:
- TodoColeccionScraper.swift

**Added to Build Phases**:
- SafariView.swift
- PriceInputView.swift
- ConditionScoringView.swift
- UserProvidedData.swift
- ImageAnalysisResult.swift

**If your build fails**: Clean build folder (Cmd+Shift+K) and rebuild.

## Data Flow Changes

### Before (Automated)
```
Image → Vision Analysis → Web Scraping → Price Extraction → Result
        (automated)       (automated)     (automated)
```

### After (User-Assisted)
```
Image → Vision Analysis → Safari Browse → Price Input → Condition Rating → Result
        (automated)       (manual)         (manual)      (manual)
```

## Testing Migration

### Before Testing
- Remove any cached scraped data
- Clear app data/preferences
- Delete old saved assessments

### Test Cases
1. **Image Analysis**:
   - Verify keywords are Spanish
   - Verify search URL is valid
   - Verify no network calls occur

2. **Safari Browsing**:
   - Verify Safari opens correctly
   - Verify correct search URL
   - Verify user can dismiss Safari

3. **Price Input**:
   - Verify validation (min ≤ median ≤ max)
   - Verify decimal input works
   - Verify optional URL entry

4. **Condition Rating**:
   - Verify all options available
   - Verify restoration toggle works
   - Verify factors calculate correctly

5. **Results**:
   - Verify price calculation correct
   - Verify disclaimers shown
   - Verify user data displayed

## Common Migration Issues

### Issue 1: Build Errors
**Error**: "Use of unresolved identifier 'TodoColeccionScraper'"
**Fix**: Remove all references to the deleted scraper

### Issue 2: Type Mismatch
**Error**: "Cannot convert value of type 'AntiqueItem' (old) to expected type 'AntiqueItem' (new)"
**Fix**: Update code to use new AntiqueItem initializer with user data

### Issue 3: Missing Localization
**Error**: String keys not found
**Fix**: Ensure both `en.lproj` and `es.lproj` have new keys

### Issue 4: Safari Not Opening
**Error**: SafariView not displaying
**Fix**: Verify URL is valid before showing SafariView

## Rollback Instructions

If you need to rollback (not recommended for legal reasons):

1. Checkout the commit before this PR:
   ```bash
   git checkout <previous-commit-hash>
   ```

2. Be aware: The old code is **illegal** and violates:
   - robots.txt
   - Terms of Service
   - App Store guidelines

## Support and Questions

For questions about this migration:
1. Review `LEGAL_COMPLIANCE.md`
2. Check `IMPLEMENTATION.md`
3. Examine the new code structure
4. Open an issue with specific questions

## Timeline

- **Old Architecture**: Removed in this PR
- **New Architecture**: Available now
- **Support Window**: Old architecture is deprecated and unsupported
- **App Store Submission**: Only new architecture is compliant

## Conclusion

This migration is **mandatory** for legal compliance. The old scraping-based architecture:
- ❌ Violates todocoleccion.net's robots.txt
- ❌ Risks App Store rejection
- ❌ May violate terms of service
- ❌ Is unethical

The new user-assisted architecture:
- ✅ Is fully legal and compliant
- ✅ Respects website policies
- ✅ Is App Store ready
- ✅ Is transparent to users
