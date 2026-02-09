import Foundation

/// Result from Vision/CoreML image analysis
struct ImageAnalysisResult {
    let suggestedCategory: String
    let suggestedKeywords: [String]
    let eraStyleKeywords: [String]
    let confidence: Double
    
    /// Generate search query for todocoleccion.net
    var searchQuery: String {
        var terms: [String] = []
        
        // Add category
        terms.append(suggestedCategory)
        
        // Add era/style keywords
        terms.append(contentsOf: eraStyleKeywords)
        
        // Add other keywords (limit to top 2)
        terms.append(contentsOf: suggestedKeywords.prefix(2))
        
        return terms.joined(separator: " ")
    }
    
    /// Generate todocoleccion.net search URL
    func generateSearchURL() -> URL? {
        let baseURL = "https://www.todocoleccion.net/s/"
        let query = searchQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        return URL(string: "\(baseURL)\(query)")
    }
}
