import Foundation

/// User-provided price data after browsing todocoleccion.net
struct UserProvidedPrices: Codable {
    let minimumPrice: Double
    let medianPrice: Double
    let maximumPrice: Double
    let listingURLs: [String] // User can optionally paste URLs (stored as strings only, never fetched)
    
    init(minimumPrice: Double, medianPrice: Double, maximumPrice: Double, listingURLs: [String] = []) {
        self.minimumPrice = minimumPrice
        self.medianPrice = medianPrice
        self.maximumPrice = maximumPrice
        self.listingURLs = listingURLs
    }
    
    var priceRange: Double {
        return maximumPrice - minimumPrice
    }
}

/// User's assessment of the item's condition
struct ConditionAssessment: Codable {
    let overallCondition: ConditionLevel
    let hasRestoration: Bool
    let restorationQuality: RestorationQuality?
    let believedAuthenticity: AuthenticityBelief
    let completeness: CompletenessLevel
    let rarity: RarityLevel
    
    enum ConditionLevel: String, Codable, CaseIterable {
        case mint = "mint"
        case excellent = "excellent"
        case good = "good"
        case fair = "fair"
        case poor = "poor"
        
        var localizedKey: String {
            return "condition_\(rawValue)"
        }
        
        var factor: Double {
            switch self {
            case .mint: return 1.2
            case .excellent: return 1.1
            case .good: return 1.0
            case .fair: return 0.85
            case .poor: return 0.6
            }
        }
    }
    
    enum RestorationQuality: String, Codable, CaseIterable {
        case professional = "professional"
        case amateur = "amateur"
        case none = "none"
        
        var localizedKey: String {
            return "restoration_\(rawValue)"
        }
        
        var factor: Double {
            switch self {
            case .professional: return 0.95
            case .amateur: return 0.8
            case .none: return 1.0
            }
        }
    }
    
    enum AuthenticityBelief: String, Codable, CaseIterable {
        case definitelyAuthentic = "definitely_authentic"
        case probablyAuthentic = "probably_authentic"
        case uncertain = "uncertain"
        case probablyReplica = "probably_replica"
        
        var localizedKey: String {
            return "authenticity_\(rawValue)"
        }
        
        var factor: Double {
            switch self {
            case .definitelyAuthentic: return 1.0
            case .probablyAuthentic: return 0.95
            case .uncertain: return 0.8
            case .probablyReplica: return 0.4
            }
        }
    }
    
    enum CompletenessLevel: String, Codable, CaseIterable {
        case complete = "complete"
        case mostlyComplete = "mostly_complete"
        case incomplete = "incomplete"
        
        var localizedKey: String {
            return "completeness_\(rawValue)"
        }
        
        var factor: Double {
            switch self {
            case .complete: return 1.0
            case .mostlyComplete: return 0.9
            case .incomplete: return 0.7
            }
        }
    }
    
    enum RarityLevel: String, Codable, CaseIterable {
        case veryRare = "very_rare"
        case rare = "rare"
        case uncommon = "uncommon"
        case common = "common"
        
        var localizedKey: String {
            return "rarity_\(rawValue)"
        }
        
        var factor: Double {
            switch self {
            case .veryRare: return 1.3
            case .rare: return 1.15
            case .uncommon: return 1.0
            case .common: return 0.9
            }
        }
    }
    
    /// Calculate overall condition factor
    var conditionFactor: Double {
        var factor = overallCondition.factor
        
        if hasRestoration, let restoration = restorationQuality {
            factor *= restoration.factor
        }
        
        factor *= believedAuthenticity.factor
        factor *= completeness.factor
        
        return factor
    }
    
    /// Calculate rarity factor
    var rarityFactor: Double {
        return rarity.factor
    }
}

/// Complete user-provided assessment data
struct UserAssessmentData: Codable {
    let prices: UserProvidedPrices
    let condition: ConditionAssessment
    let userNotes: String?
    
    init(prices: UserProvidedPrices, condition: ConditionAssessment, userNotes: String? = nil) {
        self.prices = prices
        self.condition = condition
        self.userNotes = userNotes
    }
}
