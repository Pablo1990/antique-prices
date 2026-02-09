# Testing Guide for TodoColección.net Web Scraping

## Overview

This guide explains how to test the newly implemented web scraping functionality that fetches real antique data from todocoleccion.net.

## Prerequisites

To test this implementation, you need:
- **macOS** (iOS apps can only be built on macOS)
- **Xcode 15.0+** installed
- **iOS Simulator** or a physical iOS device
- **Internet connection** (required for web scraping)

## Setup Instructions

### 1. Open the Project

```bash
cd /path/to/antique-prices
open AntiqueAssessor/AntiqueAssessor.xcodeproj
```

### 2. Configure Signing (if running on device)

If you want to test on a physical device:
1. Open the project in Xcode
2. Select the `AntiqueAssessor` target
3. Go to "Signing & Capabilities"
4. Check "Automatically manage signing"
5. Select your Apple ID team
6. Change the Bundle Identifier if needed (e.g., `com.yourname.AntiqueAssessor`)

### 3. Build and Run

1. Select your target device/simulator from the device dropdown
2. Press `Cmd + R` to build and run
3. Wait for the app to launch

## Testing Scenarios

### Test 1: Basic Web Scraping

**Objective**: Verify that the app fetches real data from todocoleccion.net

**Steps**:
1. Launch the app
2. Tap "Tomar Foto" (Take Photo) button
3. Capture or select any image (doesn't need to be an antique for this test)
4. Tap "Evaluar Antigüedad" (Assess Antique)
5. Wait for the loading indicator
6. Observe the results

**Expected Results**:
- ✅ Loading indicator appears during assessment
- ✅ Results screen shows similar items
- ✅ Item names are NOT "Antigüedad Similar 1, 2, 3..." (mock data)
- ✅ Item names are real descriptions from todocoleccion.net
- ✅ Prices are real market prices (not 125, 180, 150, 200)
- ✅ URLs point to actual todocoleccion.net listings
- ✅ Price estimation is calculated from real data

**How to Verify Mock vs Real Data**:

Mock data (OLD):
```
Antigüedad Similar 1    125,00 €
Antigüedad Similar 2    180,00 €
Antigüedad Similar 3    150,00 €
Antigüedad Similar 4    200,00 €
```

Real data (NEW):
```
Moneda de plata 1870    45,00 €
Reloj de bolsillo antiguo    120,00 €
Cerámica vintage años 60    75,50 €
...
```

### Test 2: Vision Framework Integration

**Objective**: Verify that image classification produces appropriate search terms

**Steps**:
1. Take a photo of a coin, watch, vase, or similar object
2. Start the assessment
3. Check the Console output in Xcode (View > Debug Area > Activate Console)

**Expected Console Output**:
```
Searching for: moneda antigua
```
or
```
Searching for: reloj antiguo
```

**Expected Results**:
- ✅ Search terms are in Spanish
- ✅ Search terms are relevant to the object type
- ✅ Results match the search category

### Test 3: Error Handling

**Objective**: Verify that network errors are handled gracefully

**Steps**:
1. Put device in Airplane Mode or disable Wi-Fi
2. Try to assess an antique
3. Observe the error handling

**Expected Results**:
- ✅ App doesn't crash
- ✅ Error message is shown to user
- ✅ Error message is localized (Spanish or English depending on device language)
- ✅ User can try again after reconnecting

### Test 4: Multiple Searches

**Objective**: Verify that different images produce different results

**Steps**:
1. Test with 3-5 different images
2. Compare the results for each

**Expected Results**:
- ✅ Different images produce different search results
- ✅ Similar objects (e.g., two coins) produce similar results
- ✅ Diverse objects produce diverse results

### Test 5: Price Calculation

**Objective**: Verify that price estimation is correct

**Steps**:
1. Complete an assessment
2. Note the similar item prices
3. Calculate the average manually
4. Compare with the estimated price shown

**Expected Results**:
- ✅ Estimated price = average of similar item prices
- ✅ Price range shows min and max correctly
- ✅ All prices are positive numbers
- ✅ Prices are formatted correctly (€ symbol, comma for decimal)

### Test 6: Localization

**Objective**: Verify bilingual support works correctly

**Steps**:
1. Run app in Spanish (default on Spanish iOS)
2. Change iOS language to English: Settings > General > Language & Region > iPhone Language
3. Relaunch app

**Expected Results**:
- ✅ Spanish: "Tomar Foto", "Evaluar Antigüedad", "Resultados de Evaluación"
- ✅ English: "Take Photo", "Assess Antique", "Assessment Results"
- ✅ Error messages localized in both languages
- ✅ No missing translations (no keys like "network_error" shown)

## Debugging Tips

### Enable Network Logging

Add this to `TodoColeccionScraper.swift` for debugging:

```swift
func searchAntiques(query: String) async throws -> [ScrapedItem] {
    print("🔍 Searching todocoleccion.net for: \(query)")
    
    // ... existing code ...
    
    print("✅ Found \(items.count) items")
    for item in items {
        print("  - \(item.name): \(item.price) €")
    }
    
    return items
}
```

### Check Raw HTML

To inspect the HTML being parsed:

```swift
let (data, response) = try await URLSession.shared.data(for: request)
let html = String(data: data, encoding: .utf8) ?? ""
print("📄 HTML Length: \(html.count) characters")
// Optionally save to file for inspection
```

### Breakpoint Locations

Set breakpoints at these key locations:
1. `TodoColeccionScraper.searchAntiques()` - Start of search
2. `parseSearchResults(html:)` - HTML parsing
3. `AssessmentService.searchSimilarItems()` - Integration point
4. Error catch blocks - Error handling

## Known Issues and Limitations

### Website Structure Changes

⚠️ **Issue**: If todocoleccion.net changes their HTML structure, scraping may fail

**Symptoms**:
- No items found
- Parsing errors
- Empty results

**Solution**: Update the parsing patterns in `TodoColeccionScraper.swift`

### Network Dependency

⚠️ **Issue**: App requires internet connection

**Impact**: Doesn't work offline

**Workaround**: Ensure Wi-Fi/cellular is available during testing

### Rate Limiting

⚠️ **Issue**: Too many requests may be rate-limited

**Symptoms**: HTTP 429 errors or empty results

**Solution**: Wait a few minutes between tests

### Simulator Camera

⚠️ **Issue**: iOS Simulator doesn't have camera access

**Workaround**: Use a physical device for camera testing, or add photo library picker

## Success Criteria

The implementation is successful if:

✅ App fetches real data from todocoleccion.net (not mock data)
✅ Item names are descriptive and varied
✅ Prices are realistic and change between searches
✅ URLs point to real listings
✅ Vision framework classifies images appropriately
✅ Search terms are in Spanish
✅ Errors are handled gracefully
✅ App works in both Spanish and English
✅ No crashes or force unwraps
✅ Performance is acceptable (< 10 seconds per assessment)

## Performance Benchmarks

Expected timings:
- Image classification: 0.5-2 seconds
- Web scraping: 2-5 seconds
- Total assessment: 3-8 seconds

If slower:
- Check network connection speed
- Verify todocoleccion.net is responding
- Look for parsing bottlenecks

## Reporting Issues

If you encounter issues during testing:

1. **Check Console Output**: Look for error messages
2. **Verify Internet**: Ensure connection is working
3. **Test with Different Images**: Try various object types
4. **Check todocoleccion.net**: Verify website is accessible in browser
5. **Document the Issue**: Note steps to reproduce, expected vs actual results

## Next Steps After Testing

Once testing confirms the implementation works:

1. ✅ Create before/after screenshots
2. ✅ Document any bugs found
3. ✅ Measure performance metrics
4. ✅ Test on multiple devices (iPhone SE, iPhone 14, iPad)
5. ✅ Test with various antique categories
6. ✅ Verify edge cases (no results, network errors, etc.)

## Contact

If you need help with testing or encounter issues:
- Open an issue on GitHub
- Include: device info, iOS version, steps to reproduce
- Attach: screenshots, console logs, sample images

---

**Happy Testing!** 🎉

This implementation replaces mock data with real web scraping, making the app actually useful for assessing antiques based on real market data.
