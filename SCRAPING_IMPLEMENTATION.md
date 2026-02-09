# TodoColección.net Web Scraping Implementation

## Overview

This document describes the implementation of real web scraping functionality for TodoColección.net to replace the mock data that was previously used in the app.

## Changes Made

### 1. Created TodoColeccionScraper.swift

**Location**: `AntiqueAssessor/AntiqueAssessor/Services/TodoColeccionScraper.swift`

A new service class that handles web scraping of todocoleccion.net using only native iOS frameworks:
- **Foundation**: URLSession for HTTP requests
- **No external dependencies**: Pure Swift string manipulation for HTML parsing

**Key Features**:
- Searches todocoleccion.net using query terms
- Parses HTML to extract item names, prices, and URLs
- Multiple parsing strategies for robustness
- HTML entity decoding (Spanish characters: ñ, á, é, etc.)
- Price parsing from various formats (125,50 €, 100 €, etc.)
- URL extraction and normalization
- Comprehensive error handling

**Methods**:
- `searchAntiques(query:)`: Main entry point for searching
- `parseSearchResults(html:)`: Primary HTML parsing method
- `parseAlternativeFormat(html:)`: Fallback parsing method
- `parseItemSection(_:)`: Parse individual item sections
- `extractURL(from:)`: Extract URLs from HTML
- `extractTitle(from:)`: Extract item titles
- `extractPrice(from:)`: Extract price information
- `parsePrice(_:)`: Convert price strings to Double
- `cleanText(_:)`: Clean HTML entities and whitespace

### 2. Updated AssessmentService.swift

**Enhanced Image Analysis**:
- Replaced mock implementation with real Vision framework integration
- Added `performImageClassification(cgImage:)` method using `VNClassifyImageRequest`
- Maps Vision framework classifications to Spanish antique categories:
  - Coins/money → "moneda antigua"
  - Furniture → "mueble antiguo"
  - Vases/pottery → "cerámica antigua"
  - Paintings → "pintura antigua"
  - Jewelry → "joya antigua"
  - Books → "libro antiguo"
  - Watches/clocks → "reloj antiguo"
  - Toys → "juguete antiguo"
- Falls back to generic "antigüedad colección" if no specific category matches

**Real Web Scraping**:
- `searchSimilarItems(description:)` now calls `TodoColeccionScraper`
- Converts scraped items to `AntiqueItem.SimilarItem` format
- Proper error handling with try-catch
- Throws `AssessmentError.noSimilarItemsFound` if no results
- Throws `AssessmentError.networkError` on scraping failures

### 3. Updated Localization Files

Added error messages in both Spanish and English:

**Spanish (es.lproj/Localizable.strings)**:
- "image_processing_error" = "Error al procesar la imagen"
- "network_error" = "Error de red"
- "no_similar_items" = "No se encontraron artículos similares"
- "invalid_response" = "Respuesta inválida del servidor"
- "search_in_progress" = "Buscando artículos similares..."

**English (en.lproj/Localizable.strings)**:
- "image_processing_error" = "Error processing image"
- "network_error" = "Network error"
- "no_similar_items" = "No similar items found"
- "invalid_response" = "Invalid server response"
- "search_in_progress" = "Searching for similar items..."

### 4. Updated Xcode Project

Modified `AntiqueAssessor.xcodeproj/project.pbxproj` to include:
- PBXBuildFile reference for TodoColeccionScraper.swift
- PBXFileReference for TodoColeccionScraper.swift
- Added to Services group
- Added to Sources build phase

## How It Works

### Flow Diagram

```
1. User takes photo
   ↓
2. Vision framework analyzes image (VNClassifyImageRequest)
   ↓
3. Classifications mapped to Spanish search terms
   ↓
4. TodoColeccionScraper searches todocoleccion.net
   ↓
5. HTML parsed to extract items (name, price, URL)
   ↓
6. Items returned as SimilarItem objects
   ↓
7. Price estimation calculated from similar items
   ↓
8. Results displayed to user
```

### Search Query Construction

The Vision framework returns English classifications like "vase", "furniture", "coin". These are mapped to Spanish search terms that work better on todocoleccion.net:

```swift
if classification.contains("coin") {
    searchTerms.append("moneda antigua")
} else if classification.contains("furniture") {
    searchTerms.append("mueble antiguo")
}
// etc...
```

### HTML Parsing Strategy

TodoColeccionScraper uses multiple strategies to parse HTML:

1. **Line-by-line parsing**: Scans each line looking for patterns
   - URLs: `href="/comprar/..."`
   - Titles: `title="..."` or text between tags
   - Prices: `125,50 €` or similar patterns

2. **Section-based parsing**: Splits HTML by item containers
   - Looks for `class="item` separators
   - Parses each section independently

3. **Fallback handling**: If primary method finds nothing, tries alternative

### Price Parsing

Handles various price formats:
- `125,50 €` → 125.50
- `100 €` → 100.00
- `€ 125,50` → 125.50
- `125.50 EUR` → 125.50

Handles Spanish decimal format (comma instead of period).

### HTML Entity Decoding

Properly decodes Spanish characters:
- `&ntilde;` → ñ
- `&aacute;` → á
- `&eacute;` → é
- `&iacute;` → í
- `&oacute;` → ó
- `&uacute;` → ú
- `&nbsp;` → (space)

## Technical Details

### No External Dependencies

The implementation uses **only native iOS frameworks**:
- ✅ Foundation (URLSession, String, Data)
- ✅ Vision (VNClassifyImageRequest)
- ✅ UIKit (UIImage, CGImage)
- ❌ No SwiftSoup or other HTML parsing libraries
- ❌ No third-party networking libraries

### Error Handling

Comprehensive error types:
```swift
enum ScraperError: LocalizedError {
    case invalidQuery
    case invalidURL
    case invalidResponse
    case invalidEncoding
    case httpError(statusCode: Int)
    case noItemsFound
}
```

### Performance Considerations

- Limits results to top 10 items for performance
- Uses async/await for non-blocking network calls
- 30-second timeout on requests
- Proper User-Agent header to avoid blocking

### Robustness

- Multiple HTML parsing strategies
- Fallback to alternative parsing if primary fails
- Handles various price formats
- Decodes HTML entities
- Validates data before returning (non-empty names, positive prices, valid URLs)

## Testing

### Manual Testing Checklist

To test the implementation:

1. ✅ **Build the project** in Xcode
2. ✅ **Run on simulator** or device
3. ✅ **Take a photo** of an antique-like object
4. ✅ **Tap "Assess Antique"**
5. ✅ **Verify loading indicator** appears
6. ✅ **Check results** show:
   - Real item names (not "Antigüedad Similar 1")
   - Real prices from todocoleccion.net
   - Valid URLs to actual listings
   - Price estimation based on real data

### Expected Behavior

**Success Case**:
- App searches todocoleccion.net with relevant terms
- Returns 1-10 similar items
- Each item has: name, price (> 0), URL
- Price estimation calculated from real data

**Error Cases**:
- No items found → "No se encontraron artículos similares"
- Network error → "Error de red"
- Image processing error → "Error al procesar la imagen"

## Known Limitations

1. **Website Structure Changes**: If todocoleccion.net changes their HTML structure, the scraper may need updates
2. **Network Required**: App now requires internet connection to function
3. **No API**: Uses web scraping, not an official API
4. **Rate Limiting**: Heavy usage may be rate-limited by todocoleccion.net
5. **Language Barrier**: Vision framework returns English terms, which we map to Spanish

## Future Enhancements

1. **Caching**: Cache search results to reduce network calls
2. **Better Image Recognition**: Train custom CoreML model for antiques
3. **Category Detection**: Improve mapping of Vision classifications
4. **Retry Logic**: Add exponential backoff for failed requests
5. **User Feedback**: Allow users to report incorrect results
6. **Official API**: If todocoleccion.net provides an API, migrate to it

## Troubleshooting

### Common Issues

**Issue**: No items found
- **Cause**: Search query too specific or website structure changed
- **Solution**: Check Vision framework output, verify website is accessible

**Issue**: Network error
- **Cause**: No internet connection or website down
- **Solution**: Check internet connection, verify todocoleccion.net is up

**Issue**: Incorrect prices
- **Cause**: Price parsing failed or unusual format
- **Solution**: Check price extraction regex patterns

**Issue**: App crashes on assessment
- **Cause**: Image processing error
- **Solution**: Check image is valid, CGImage conversion succeeds

## Code Quality

### Follows Best Practices

- ✅ Async/await for modern concurrency
- ✅ Proper error handling with typed errors
- ✅ Comprehensive documentation
- ✅ No force unwrapping (uses optional binding)
- ✅ Clean code structure with private methods
- ✅ Localized error messages
- ✅ Defensive programming (validates data)

### Security Considerations

- ✅ HTTPS only (todocoleccion.net uses HTTPS)
- ✅ No hardcoded credentials
- ✅ Proper URL encoding
- ✅ Timeout on requests (prevents hanging)
- ✅ No arbitrary code execution
- ✅ Safe string manipulation

## Maintenance

### Updating for Website Changes

If todocoleccion.net changes their HTML structure:

1. Inspect the new HTML structure
2. Update regex patterns in:
   - `extractURL(from:)`
   - `extractTitle(from:)`
   - `extractPrice(from:)`
3. Test with multiple queries
4. Update fallback methods if needed

### Adding New Categories

To add new antique categories:

1. Update `analyzeImage(_:)` mapping:
```swift
else if lowercased.contains("new_category") {
    searchTerms.append("nueva_categoria_antigua")
}
```

2. Test with relevant images

## Summary

This implementation provides **real web scraping** of todocoleccion.net using **only native iOS frameworks**, replacing the mock data with actual market information. The solution is robust, well-documented, and follows iOS best practices.

**Key Achievement**: Users now get real antique prices and similar items from todocoleccion.net instead of fake data.
