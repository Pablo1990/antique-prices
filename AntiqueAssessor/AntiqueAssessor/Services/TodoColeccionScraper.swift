import Foundation

/// Service for scraping todocoleccion.net without external dependencies
/// Uses native URLSession and Swift string parsing
class TodoColeccionScraper {
    private let baseURL = "https://www.todocoleccion.net"
    
    /// Search for antiques on todocoleccion.net
    /// - Parameter query: Search query (e.g., "antigüedad", "moneda antigua")
    /// - Returns: Array of scraped items with name, price, and URL
    func searchAntiques(query: String) async throws -> [ScrapedItem] {
        // URL encode the query
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            throw ScraperError.invalidQuery
        }
        
        // Construct search URL - todocoleccion.net uses /buscar/ for search
        let searchURLString = "\(baseURL)/buscar/\(encodedQuery)"
        guard let searchURL = URL(string: searchURLString) else {
            throw ScraperError.invalidURL
        }
        
        // Create request with proper headers to mimic browser
        var request = URLRequest(url: searchURL)
        request.setValue("Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15", forHTTPHeaderField: "User-Agent")
        request.setValue("text/html,application/xhtml+xml", forHTTPHeaderField: "Accept")
        request.timeoutInterval = 30
        
        // Fetch the HTML
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Check response status
        guard let httpResponse = response as? HTTPURLResponse else {
            throw ScraperError.invalidResponse
        }
        
        guard httpResponse.statusCode == 200 else {
            throw ScraperError.httpError(statusCode: httpResponse.statusCode)
        }
        
        // Parse HTML string
        guard let html = String(data: data, encoding: .utf8) else {
            throw ScraperError.invalidEncoding
        }
        
        // Parse items from HTML
        let items = try parseSearchResults(html: html)
        
        // Limit to top 10 results for performance
        return Array(items.prefix(10))
    }
    
    /// Parse search results from HTML
    private func parseSearchResults(html: String) throws -> [ScrapedItem] {
        var items: [ScrapedItem] = []
        
        // Find all item listings - todocoleccion.net uses various patterns
        // We'll look for common patterns in their HTML structure
        let lines = html.components(separatedBy: .newlines)
        
        var currentItem: (name: String?, price: String?, url: String?) = (nil, nil, nil)
        
        for line in lines {
            let trimmedLine = line.trimmingCharacters(in: .whitespaces)
            
            // Look for item links (contains "/comprar/")
            if trimmedLine.contains("href=\"/comprar/") || trimmedLine.contains("href='/comprar/") {
                if let url = extractURL(from: trimmedLine) {
                    currentItem.url = url
                }
            }
            
            // Look for item titles (usually in <h2>, <h3>, or title attributes)
            if let title = extractTitle(from: trimmedLine) {
                currentItem.name = title
            }
            
            // Look for prices (contains "€" symbol)
            if trimmedLine.contains("€") || trimmedLine.contains("EUR") {
                if let price = extractPrice(from: trimmedLine) {
                    currentItem.price = price
                }
            }
            
            // When we have all components, save the item
            if let name = currentItem.name, 
               let priceStr = currentItem.price,
               let url = currentItem.url {
                
                if let priceValue = parsePrice(priceStr) {
                    items.append(ScrapedItem(
                        name: cleanText(name),
                        price: priceValue,
                        url: url.hasPrefix("http") ? url : "\(baseURL)\(url)"
                    ))
                    
                    // Reset current item
                    currentItem = (nil, nil, nil)
                }
            }
        }
        
        // If no items found, try alternative parsing method
        if items.isEmpty {
            items = try parseAlternativeFormat(html: html)
        }
        
        return items
    }
    
    /// Alternative parsing method for different HTML structures
    private func parseAlternativeFormat(html: String) throws -> [ScrapedItem] {
        var items: [ScrapedItem] = []
        
        // Split by common item separators
        let itemSections = html.components(separatedBy: "class=\"item")
        
        for section in itemSections.dropFirst() { // Skip first empty section
            if let item = parseItemSection(section) {
                items.append(item)
            }
        }
        
        return items
    }
    
    /// Parse a single item section
    private func parseItemSection(_ section: String) -> ScrapedItem? {
        var name: String?
        var price: Double?
        var url: String?
        
        let lines = section.components(separatedBy: .newlines)
        
        for line in lines {
            if name == nil, let title = extractTitle(from: line) {
                name = cleanText(title)
            }
            
            if url == nil, let extractedURL = extractURL(from: line) {
                url = extractedURL.hasPrefix("http") ? extractedURL : "\(baseURL)\(extractedURL)"
            }
            
            if price == nil, let priceStr = extractPrice(from: line) {
                price = parsePrice(priceStr)
            }
            
            // If we have all components, return early
            if name != nil && price != nil && url != nil {
                break
            }
        }
        
        guard let finalName = name,
              let finalPrice = price,
              let finalURL = url else {
            return nil
        }
        
        return ScrapedItem(name: finalName, price: finalPrice, url: finalURL)
    }
    
    /// Extract URL from HTML line
    private func extractURL(from line: String) -> String? {
        // Look for href attributes
        let patterns = [
            "href=\"([^\"]+)\"",
            "href='([^']+)'"
        ]
        
        for pattern in patterns {
            if let range = line.range(of: pattern, options: .regularExpression) {
                let match = String(line[range])
                // Extract URL between quotes
                let components = match.components(separatedBy: CharacterSet(charactersIn: "\"'"))
                for component in components {
                    if component.hasPrefix("/comprar/") || component.hasPrefix("http") {
                        return component
                    }
                }
            }
        }
        
        return nil
    }
    
    /// Extract title from HTML line
    private func extractTitle(from line: String) -> String? {
        // Look for title in various places
        let patterns = [
            "title=\"([^\"]+)\"",
            "title='([^']+)'",
            ">([^<]{10,200})</",  // Text between tags (10-200 chars)
            "alt=\"([^\"]+)\"",
            "alt='([^']+)'"
        ]
        
        for pattern in patterns {
            if let range = line.range(of: pattern, options: .regularExpression) {
                var match = String(line[range])
                // Remove HTML tags and attributes
                match = match.replacingOccurrences(of: "title=", with: "")
                match = match.replacingOccurrences(of: "alt=", with: "")
                match = match.replacingOccurrences(of: ">", with: "")
                match = match.replacingOccurrences(of: "<", with: "")
                match = match.replacingOccurrences(of: "\"", with: "")
                match = match.replacingOccurrences(of: "'", with: "")
                match = match.trimmingCharacters(in: .whitespacesAndNewlines)
                
                // Only accept if it looks like a meaningful title
                if match.count >= 10 && match.count <= 200 && !match.contains("http") {
                    return match
                }
            }
        }
        
        return nil
    }
    
    /// Extract price from HTML line
    private func extractPrice(from line: String) -> String? {
        // Look for price patterns with € or EUR
        let patterns = [
            "([0-9]{1,6}[.,][0-9]{2})\\s*€",
            "([0-9]{1,6})\\s*€",
            "€\\s*([0-9]{1,6}[.,][0-9]{2})",
            "([0-9]{1,6}[.,][0-9]{2})\\s*EUR"
        ]
        
        for pattern in patterns {
            if let range = line.range(of: pattern, options: .regularExpression) {
                var match = String(line[range])
                // Clean up the match
                match = match.replacingOccurrences(of: "€", with: "")
                match = match.replacingOccurrences(of: "EUR", with: "")
                match = match.trimmingCharacters(in: .whitespacesAndNewlines)
                return match
            }
        }
        
        return nil
    }
    
    /// Parse price string to Double
    private func parsePrice(_ priceString: String) -> Double? {
        // Clean the string
        var cleaned = priceString
            .replacingOccurrences(of: "€", with: "")
            .replacingOccurrences(of: "EUR", with: "")
            .replacingOccurrences(of: " ", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Replace comma with period for decimal point
        cleaned = cleaned.replacingOccurrences(of: ",", with: ".")
        
        return Double(cleaned)
    }
    
    /// Clean text by removing HTML entities and extra whitespace
    private func cleanText(_ text: String) -> String {
        var cleaned = text
        
        // Decode common HTML entities
        let entities = [
            "&nbsp;": " ",
            "&amp;": "&",
            "&lt;": "<",
            "&gt;": ">",
            "&quot;": "\"",
            "&#39;": "'",
            "&apos;": "'",
            "&ntilde;": "ñ",
            "&Ntilde;": "Ñ",
            "&aacute;": "á",
            "&eacute;": "é",
            "&iacute;": "í",
            "&oacute;": "ó",
            "&uacute;": "ú",
            "&Aacute;": "Á",
            "&Eacute;": "É",
            "&Iacute;": "Í",
            "&Oacute;": "Ó",
            "&Uacute;": "Ú"
        ]
        
        for (entity, replacement) in entities {
            cleaned = cleaned.replacingOccurrences(of: entity, with: replacement)
        }
        
        // Remove extra whitespace
        let components = cleaned.components(separatedBy: .whitespacesAndNewlines)
        cleaned = components.filter { !$0.isEmpty }.joined(separator: " ")
        
        return cleaned
    }
    
    /// Scraped item structure
    struct ScrapedItem {
        let name: String
        let price: Double
        let url: String
    }
    
    /// Scraper errors
    enum ScraperError: LocalizedError {
        case invalidQuery
        case invalidURL
        case invalidResponse
        case invalidEncoding
        case httpError(statusCode: Int)
        case noItemsFound
        
        var errorDescription: String? {
            switch self {
            case .invalidQuery:
                return "Invalid search query"
            case .invalidURL:
                return "Invalid URL format"
            case .invalidResponse:
                return "Invalid server response"
            case .invalidEncoding:
                return "Unable to parse response encoding"
            case .httpError(let code):
                return "HTTP error: \(code)"
            case .noItemsFound:
                return "No items found matching the search"
            }
        }
    }
}
