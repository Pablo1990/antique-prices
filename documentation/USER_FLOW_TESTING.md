# User Flow Testing Guide

## Overview

This guide provides step-by-step instructions for testing the complete user flow of the Antique Assessor app after the legal compliance redesign.

## Prerequisites

- macOS with Xcode 15.0+
- iOS device or simulator running iOS 15.0+
- Network connection (for Safari browsing)

## Complete User Flow Test

### Step 1: Launch and Photo Capture

**Expected Behavior:**
1. App launches with welcome screen
2. Shows app title: "Tasador de Antigüedades" / "Antique Assessor"
3. Shows description: "Obtén valoraciones expertas..." / "Get expert valuation..."
4. Legal disclaimer visible at bottom
5. "Take Photo" button is enabled and blue

**Test Actions:**
1. Launch app
2. Tap "Take Photo" button
3. Camera view opens (or photo picker in simulator)
4. Take/select a photo of an antique item
5. Photo appears in main view

**Success Criteria:**
- ✅ Camera opens without crashes
- ✅ Photo displays correctly after capture
- ✅ UI transitions smoothly

### Step 2: Image Analysis

**Expected Behavior:**
1. Step 2 "Analyze Image" becomes active (blue border)
2. Brain icon shows next to step
3. Tapping button shows processing indicator
4. Analysis completes in 1-3 seconds
5. Suggested keywords appear below step 3

**Test Actions:**
1. Tap "Analyze Image" button
2. Wait for processing
3. Observe suggested search keywords

**Success Criteria:**
- ✅ Processing indicator shows during analysis
- ✅ Keywords generated (e.g., "moneda antigua", "cerámica antigua")
- ✅ Step 2 shows checkmark when complete
- ✅ Step 3 "Browse Market" becomes active

**Verification:**
- Check console for "Vision framework" messages
- Verify NO network requests are made
- Keywords should be in Spanish

### Step 3: Browse Market (Safari)

**Expected Behavior:**
1. Step 3 shows Safari icon
2. Suggested keywords displayed in blue text
3. Tapping opens SFSafariViewController
4. Safari shows todocoleccion.net search results
5. User can browse listings normally
6. Dismissing Safari returns to app

**Test Actions:**
1. Tap "Browse Market" button
2. Safari opens with search URL
3. Browse 2-3 listings
4. Note prices (e.g., 50€, 75€, 100€)
5. Optionally copy listing URLs
6. Tap "Done" to close Safari

**Success Criteria:**
- ✅ Safari opens in-app (not external browser)
- ✅ URL is `https://www.todocoleccion.net/s/[keywords]`
- ✅ Search results display correctly
- ✅ User has full Safari functionality
- ✅ Returning to app preserves state

**Important Verification:**
- ❌ App does NOT extract any data from Safari
- ❌ App does NOT access page content
- ❌ No background network requests
- ✅ User must manually read prices

### Step 4: Enter Prices

**Expected Behavior:**
1. Step 4 "Enter Prices" becomes active
2. Tapping opens price input form
3. Form shows three price fields + optional URLs
4. Validation prevents invalid entries

**Test Actions:**
1. Tap "Enter Prices" button
2. Enter minimum price: `50`
3. Enter median price: `75`
4. Enter maximum price: `100`
5. (Optional) Paste listing URLs in text area
6. Tap "Continue"

**Test Invalid Inputs:**
- Try: Min > Median (should show error)
- Try: Median > Max (should show error)
- Try: Negative prices (should show error)
- Try: Non-numeric text (should show error)

**Success Criteria:**
- ✅ Form displays in Spanish/English based on device language
- ✅ Numeric keyboard appears for price fields
- ✅ Validation errors show clear messages
- ✅ Valid entries accepted and stored
- ✅ Step 4 shows checkmark after completion

### Step 5: Rate Condition

**Expected Behavior:**
1. Step 5 "Rate Condition" becomes active
2. Tapping opens condition scoring form
3. Multiple sections with pickers/toggles
4. All fields have sensible defaults

**Test Actions:**
1. Tap "Rate Condition" button
2. Select "Overall Condition": **Good**
3. Toggle "Has been restored": **No**
4. Select "Authenticity Belief": **Probably Authentic**
5. Select "Completeness": **Complete**
6. Select "Rarity": **Uncommon**
7. Tap "Continue"

**Test Different Combinations:**
- Set condition to "Mint" → factor should be 1.2
- Enable restoration → factor should decrease
- Set authenticity to "Probably Replica" → factor 0.4

**Success Criteria:**
- ✅ All pickers work smoothly
- ✅ Restoration options appear when toggle enabled
- ✅ Descriptions show for each selection
- ✅ Form validates and saves
- ✅ Step 5 shows checkmark

### Step 6: View Results

**Expected Behavior:**
1. Step 6 "View Results" becomes active
2. Brief processing indicator
3. Results sheet opens with full assessment
4. All sections populated with data

**Test Actions:**
1. Tap "View Results" button
2. Review displayed information:
   - Legal disclaimer (blue box at top)
   - Estimated value
   - Calculation breakdown
   - User-provided prices
   - Condition assessment
   - Reference URLs (if provided)

**Expected Calculations (Example):**
```
User median price: 75€
Condition factor: 1.0 (Good) × 1.0 (No restoration) × 0.95 (Probably authentic) × 1.0 (Complete) = 0.95
Rarity factor: 1.0 (Uncommon)
Estimated price: 75 × 0.95 × 1.0 = 71.25€
```

**Success Criteria:**
- ✅ Legal disclaimer visible at top
- ✅ Estimated price calculated correctly
- ✅ Breakdown shows formula components
- ✅ User prices displayed correctly
- ✅ Condition ratings shown
- ✅ All text localized properly

**Verification Checklist:**
- [ ] Disclaimer says "Not an official appraisal"
- [ ] Attribution mentions todocoleccion.net
- [ ] States "No affiliation"
- [ ] Says "All browsing done manually by you"
- [ ] Says "Does not scrape or automate"

### Step 7: Start Over

**Test Actions:**
1. From results view, tap "Done"
2. From main view, tap "Start Over"
3. All state resets
4. Can begin new assessment

**Success Criteria:**
- ✅ All steps reset to initial state
- ✅ Previous photo cleared
- ✅ Can start fresh assessment
- ✅ No data carried over

## Legal Compliance Verification

### Network Traffic Monitoring

**Using Charles Proxy or similar:**

1. Install network monitoring tool
2. Configure iOS device/simulator to use proxy
3. Run complete app flow
4. Review captured requests

**Expected Results:**
- ✅ NO requests to todocoleccion.net from app code
- ✅ ONLY Safari makes requests (user-initiated)
- ✅ NO HTML content in app memory
- ✅ NO parsing of web content

### Code Verification

**Search for forbidden patterns:**

```bash
# Should return NO results:
grep -r "URLSession.*todocoleccion" AntiqueAssessor/
grep -r "HTMLParser" AntiqueAssessor/
grep -r "parseSearchResults" AntiqueAssessor/
grep -r "TodoColeccionScraper" AntiqueAssessor/

# Should find only URL construction:
grep -r "todocoleccion" AntiqueAssessor/
# Expected: Only in ImageAnalysisResult.swift for URL construction
```

### UI Text Verification

**Check all localized strings appear:**

**English:**
- [ ] "Take Photo"
- [ ] "Analyze Image"
- [ ] "Browse Market"
- [ ] "Enter Prices"
- [ ] "Rate Condition"
- [ ] "View Results"
- [ ] "Estimated value based on your market research..."
- [ ] "Market references may include todocoleccion.net. No affiliation..."
- [ ] "This app respects robots.txt..."

**Spanish:**
- [ ] "Tomar Foto"
- [ ] "Analizar Imagen"
- [ ] "Explorar Mercado"
- [ ] "Ingresar Precios"
- [ ] "Evaluar Condición"
- [ ] "Ver Resultados"
- [ ] "Valor estimado basado en tu investigación..."
- [ ] "Las referencias de mercado pueden incluir..."
- [ ] "Esta app respeta robots.txt..."

## Edge Cases and Error Handling

### Test Error Scenarios

**1. Vision Framework Unavailable:**
- Simulator may not have ML model
- Should fallback to generic keywords
- App should not crash

**2. Safari Cannot Open URL:**
- Invalid URL construction
- Network unavailable
- Should show error message

**3. Invalid Price Entry:**
- Non-numeric input
- Negative prices
- Min > Max
- Should show validation errors

**4. Cancel at Any Step:**
- Cancel price input → Step 4 remains incomplete
- Cancel condition scoring → Step 5 remains incomplete
- Should handle gracefully

## Performance Testing

### Image Analysis Speed
- **Expected**: 1-3 seconds on device
- **Simulator**: May be slower without ML acceleration
- Should show progress indicator

### Memory Usage
- Take 10 photos sequentially
- Complete flow for each
- Check for memory leaks
- Should remain stable

### UI Responsiveness
- All transitions should be smooth
- No blocking of main thread
- Progress indicators for async operations

## Accessibility Testing

### VoiceOver Support
1. Enable VoiceOver
2. Navigate through all steps
3. Verify labels are descriptive
4. Test with Eyes-Free mode

### Dynamic Type
1. Change text size in Settings
2. Verify all text scales appropriately
3. No text truncation
4. Layouts adjust properly

### Color Contrast
- Blue buttons have sufficient contrast
- Disclaimer box is readable
- Step indicators clear

## Localization Testing

### Spanish Language
1. Settings → General → Language → Español
2. Restart app
3. Verify all UI text in Spanish
4. Test complete flow
5. Check results view

### English Language
1. Settings → General → Language → English
2. Restart app
3. Verify all UI text in English
4. Test complete flow
5. Check results view

## App Store Compliance Checklist

Before submission, verify:

- [ ] No scraping or automated data extraction
- [ ] All browsing via SFSafariViewController
- [ ] Clear legal disclaimers displayed
- [ ] Proper attribution without false affiliation
- [ ] User consent for all actions
- [ ] No misleading claims
- [ ] Privacy policy (if required)
- [ ] Terms of service (if required)
- [ ] App Store description accurate
- [ ] Screenshots show legal disclaimers

## Known Limitations

### Expected Behaviors
1. **Simulator Camera**: May not work, use photo picker instead
2. **Vision Framework**: May use generic keywords if model unavailable
3. **Network Required**: Safari browsing requires internet
4. **Manual Entry**: User must enter all prices (by design)

### Not Bugs
- App doesn't automatically extract prices → **Correct, legal design**
- Safari opens external to app inspection → **Correct, legal design**
- User must type prices manually → **Correct, legal design**

## Troubleshooting

### Common Issues

**Issue**: Camera doesn't open in simulator
- **Solution**: Use "Choose Photo" option or test on device

**Issue**: Vision analysis returns generic keywords
- **Solution**: Normal on simulator, test on device for better results

**Issue**: Safari doesn't open
- **Solution**: Check URL construction, verify network connection

**Issue**: Prices won't save
- **Solution**: Check validation (min ≤ median ≤ max, positive values)

**Issue**: Results calculation seems wrong
- **Solution**: Verify factor formula, check condition selections

## Test Report Template

```
Date: ___________
Tester: ___________
Device: ___________ (iPhone X, iOS 17.0)
Build: ___________

Test Results:
[ ] Step 1 - Photo Capture: PASS / FAIL
[ ] Step 2 - Image Analysis: PASS / FAIL
[ ] Step 3 - Safari Browse: PASS / FAIL
[ ] Step 4 - Price Entry: PASS / FAIL
[ ] Step 5 - Condition Rating: PASS / FAIL
[ ] Step 6 - View Results: PASS / FAIL
[ ] Legal Disclaimers: PASS / FAIL
[ ] Network Traffic: PASS / FAIL (no scraping detected)

Issues Found:
1. ___________
2. ___________

Overall: PASS / FAIL
```

## Conclusion

This comprehensive testing guide ensures:
- ✅ Complete user flow works as designed
- ✅ Legal compliance is maintained
- ✅ No scraping or automation occurs
- ✅ User experience is smooth and clear
- ✅ App is ready for App Store submission

For any issues or questions, refer to LEGAL_COMPLIANCE.md for architectural details.
