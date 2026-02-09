import Foundation

struct AntiqueItem: Identifiable, Codable {
    let id: UUID
    let name: String
    let description: String
    let estimatedPrice: Double
    let priceRange: PriceRange
    
    // User-provided data
    let userProvidedPrices: UserProvidedPrices
    let conditionAssessment: ConditionAssessment
    
    // Calculated factors
    let conditionFactor: Double
    let rarityFactor: Double
    
    // Image analysis results
    let suggestedCategory: String
    let suggestedKeywords: [String]
    let analysisConfidence: Double
    
    let assessmentDate: Date
    
    struct PriceRange: Codable {
        let min: Double
        let max: Double
    }
    
    init(id: UUID = UUID(),
         name: String,
         description: String,
         estimatedPrice: Double,
         priceRange: PriceRange,
         userProvidedPrices: UserProvidedPrices,
         conditionAssessment: ConditionAssessment,
         conditionFactor: Double,
         rarityFactor: Double,
         suggestedCategory: String,
         suggestedKeywords: [String],
         analysisConfidence: Double,
         assessmentDate: Date = Date()) {
        self.id = id
        self.name = name
        self.description = description
        self.estimatedPrice = estimatedPrice
        self.priceRange = priceRange
        self.userProvidedPrices = userProvidedPrices
        self.conditionAssessment = conditionAssessment
        self.conditionFactor = conditionFactor
        self.rarityFactor = rarityFactor
        self.suggestedCategory = suggestedCategory
        self.suggestedKeywords = suggestedKeywords
        self.analysisConfidence = analysisConfidence
        self.assessmentDate = assessmentDate
    }
}
