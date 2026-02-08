import Foundation

struct AntiqueItem: Identifiable, Codable {
    let id: UUID
    let name: String
    let description: String
    let estimatedPrice: Double
    let priceRange: PriceRange
    let isAuthentic: Bool
    let authenticityConfidence: Double
    let period: String
    let periodConfidence: Double
    let source: String
    let similarItems: [SimilarItem]
    let assessmentDate: Date
    
    struct PriceRange: Codable {
        let min: Double
        let max: Double
    }
    
    struct SimilarItem: Codable, Identifiable {
        let id: UUID
        let name: String
        let price: Double
        let url: String
        
        init(id: UUID = UUID(), name: String, price: Double, url: String) {
            self.id = id
            self.name = name
            self.price = price
            self.url = url
        }
    }
    
    init(id: UUID = UUID(), name: String, description: String, estimatedPrice: Double, 
         priceRange: PriceRange, isAuthentic: Bool, authenticityConfidence: Double,
         period: String, periodConfidence: Double, source: String, 
         similarItems: [SimilarItem], assessmentDate: Date = Date()) {
        self.id = id
        self.name = name
        self.description = description
        self.estimatedPrice = estimatedPrice
        self.priceRange = priceRange
        self.isAuthentic = isAuthentic
        self.authenticityConfidence = authenticityConfidence
        self.period = period
        self.periodConfidence = periodConfidence
        self.source = source
        self.similarItems = similarItems
        self.assessmentDate = assessmentDate
    }
}
