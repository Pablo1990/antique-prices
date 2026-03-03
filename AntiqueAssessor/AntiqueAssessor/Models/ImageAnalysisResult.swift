import Foundation

/// Result from Vision/CoreML image analysis
struct ImageAnalysisResult {
    let suggestedCategory: String
    let suggestedKeywords: [String]
    let eraStyleKeywords: [String]
    let confidence: Double
    let suggestedCondition: ConditionAssessment.ConditionLevel
    let suggestedRarity: ConditionAssessment.RarityLevel
    /// Pre-translated Spanish keywords produced by TranslationService.
    /// Empty when translation was not performed (e.g. non-Spanish locale or iOS < 17.4).
    let translatedKeywords: [String]

    /// Generate search query, using pre-translated Spanish keywords when available.
    var searchQuery: String {
        if Locale.current.languageCode == "es" {
            // Use the async-translated keywords if available; otherwise fall back to originals.
            let terms = translatedKeywords.isEmpty ? suggestedKeywords : translatedKeywords
            return terms.prefix(2).joined(separator: " ")
        } else {
            return suggestedKeywords.prefix(2).joined(separator: " ")
        }
    }
    
    /// Generate todocoleccion.net search URL
    func generateSearchURL() -> URL? {
        var baseURL = "https://en.todocoleccion.net/orientaprecios/-1/g/reciente/0/1?autocompletado="
        /// If language is Spanish, use Spanish base URL, otherwise use English
        if Locale.current.languageCode == "es" {
            baseURL = "https://www.todocoleccion.net/orientaprecios/-1/g/reciente/0/1?autocompletado="
        }
        
        let query = searchQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        return URL(string: "\(baseURL)\(query)")
    }
}
