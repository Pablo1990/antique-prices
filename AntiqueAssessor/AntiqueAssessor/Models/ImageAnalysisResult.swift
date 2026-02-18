import Foundation

/// Result from Vision/CoreML image analysis
struct ImageAnalysisResult {
    let suggestedCategory: String
    let suggestedKeywords: [String]
    let eraStyleKeywords: [String]
    let confidence: Double
    let suggestedCondition: ConditionAssessment.ConditionLevel
    let suggestedRarity: ConditionAssessment.RarityLevel
    
    /// Generate search query for todocoleccion.net
    var searchQuery: String {
        var terms: [String] = []
        

    }

    /// Generate search query with automatic translated to Spanish if the current locale is Spanish
    var searchQuery: String {
        var terms: [String] = []

        if Locale.current.languageCode == "es" {

            // Add category (translate to Spanish)
            let category_es = translateToSpanish(suggestedCategory)
            terms.append(category_es)

            // Add era/style keywords (translate to Spanish)
            let eraStyleKeywords_es = eraStyleKeywords.map { translateToSpanish($0) }
            terms.append(contentsOf: eraStyleKeywords_es)

            // Add other keywords (limit to top 2, translate to Spanish)
            let suggestedKeywords_es = suggestedKeywords.prefix(2).map { translateToSpanish($0) }
            terms.append(contentsOf: suggestedKeywords_es)

            return terms.joined(separator: " ")
        } else {
            // Add category
            terms.append(suggestedCategory)

            // Add era/style keywords
            terms.append(contentsOf: eraStyleKeywords)

            // Add other keywords (limit to top 2)
            terms.append(contentsOf: suggestedKeywords.prefix(2))

            return terms.joined(separator: " ")
        }
    }


    
    /// Generate todocoleccion.net search URL
    func generateSearchURL() -> URL? {
        # If language is Spanish, use Spanish base URL, otherwise use English
        if Locale.current.languageCode == "es" {
            let baseURL = "https://www.todocoleccion.net/orientaprecios/-1/g/reciente/0/1?autocompletado="
            let query = searchQuery_es.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            return URL(string: "\(baseURL)\(query)")
        } else {
            let baseURL = "https://en.todocoleccion.net/orientaprecios/-1/g/reciente/0/1?autocompletado="
            let query = searchQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            return URL(string: "\(baseURL)\(query)")
        }
    }
}
