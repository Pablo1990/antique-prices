import UIKit
import Vision
import CoreML

class AssessmentService: ObservableObject {
    
    /// Analyze image using Vision framework to generate search keywords
    /// Returns suggestions for category and keywords, but does NOT fetch any data
    func analyzeImage(_ image: UIImage) async throws -> ImageAnalysisResult {
        guard let cgImage = image.cgImage else {
            throw AssessmentError.imageProcessingFailed
        }
        
        // Try to use Vision framework to classify the image
        var suggestedCategory = "antigüedad"
        var keywords: [String] = []
        var eraKeywords: [String] = []
        var confidence = 0.5
        var suggestedCondition: ConditionAssessment.ConditionLevel = .good
        var suggestedRarity: ConditionAssessment.RarityLevel = .uncommon
        
        do {
            let observations = try await performImageClassification(cgImage: cgImage)
            
            // Extract top classifications to build search query
            let topClassifications = observations.prefix(10)
            
            // Get confidence from top observation
            if let topObservation = topClassifications.first {
                confidence = Double(topObservation.confidence)
            }
            
            // Use actual Vision keywords directly instead of mapping
            // Extract the actual detected objects as keywords
            for observation in topClassifications where observation.confidence > 0.1 {
                let identifier = observation.identifier.lowercased()
                
                // Add the identifier itself as a keyword (no mapping)
                keywords.append(identifier)
                
                // Determine suggested category based on top detection
                if observation == topClassifications.first {
                    suggestedCategory = identifier
                }
                
                // Analyze object type to suggest condition defaults
                // Delicate items tend to be in better condition if still intact
                if identifier.contains("glass") || identifier.contains("ceramic") || identifier.contains("porcelain") || 
                   identifier.contains("vase") || identifier.contains("crystal") {
                    suggestedCondition = .excellent // Glass/ceramic that survived is usually well-preserved
                    suggestedRarity = .rare // Fragile items that survived are often rare
                } else if identifier.contains("jewelry") || identifier.contains("ring") || identifier.contains("necklace") ||
                          identifier.contains("gold") || identifier.contains("silver") {
                    suggestedCondition = .excellent // Precious metals preserve well
                    suggestedRarity = .rare // Jewelry is often unique
                } else if identifier.contains("coin") || identifier.contains("money") {
                    suggestedCondition = .good // Coins often show wear
                    suggestedRarity = .uncommon // Most coins are somewhat common
                } else if identifier.contains("furniture") || identifier.contains("chair") || identifier.contains("table") {
                    suggestedCondition = .good // Furniture typically shows use
                    suggestedRarity = .common // Furniture is often mass-produced
                } else if identifier.contains("book") || identifier.contains("document") || identifier.contains("paper") {
                    suggestedCondition = .fair // Paper deteriorates over time
                    suggestedRarity = .uncommon // Old books vary in rarity
                } else if identifier.contains("painting") || identifier.contains("art") || identifier.contains("canvas") {
                    suggestedCondition = .good // Art pieces often preserved
                    suggestedRarity = .rare // Art is typically unique
                } else if identifier.contains("toy") || identifier.contains("doll") {
                    suggestedCondition = .fair // Toys usually show play wear
                    suggestedRarity = .uncommon // Vintage toys vary
                } else if identifier.contains("watch") || identifier.contains("clock") {
                    suggestedCondition = .good // Timepieces often maintained
                    suggestedRarity = .rare // Mechanical watches are valuable
                } else if identifier.contains("bottle") {
                    suggestedCondition = .good // Glass bottles preserve well
                    suggestedRarity = .uncommon // Old bottles are collectible
                }
            }
            
            // Add generic era keywords for variety
            eraKeywords = ["antiguo", "vintage", "colección"]
            
        } catch {
            // Vision framework failed - use generic terms
            print("ERROR: Vision framework unavailable, using generic search terms: \(error.localizedDescription)")
            suggestedCategory = "antigüedad"
            keywords = ["colección", "vintage"]
            eraKeywords = ["antiguo"]
        }
        
        // Remove duplicates and limit keywords
        keywords = Array(Set(keywords)).prefix(5).map { $0 }
        
        return ImageAnalysisResult(
            suggestedCategory: suggestedCategory,
            suggestedKeywords: keywords,
            eraStyleKeywords: eraKeywords,
            confidence: confidence,
            suggestedCondition: suggestedCondition,
            suggestedRarity: suggestedRarity
        )
    }
    
    /// Perform image classification using Vision framework
    private func performImageClassification(cgImage: CGImage) async throws -> [VNClassificationObservation] {
        return try await withCheckedThrowingContinuation { continuation in
            var hasResumed = false
            
            let request = VNClassifyImageRequest { request, error in
                guard !hasResumed else { return }
                hasResumed = true
                
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let observations = request.results as? [VNClassificationObservation] else {
                    continuation.resume(throwing: AssessmentError.imageProcessingFailed)
                    return
                }
                
                continuation.resume(returning: observations)
            }
            
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            do {
                try handler.perform([request])
            } catch {
                // If perform() throws synchronously before completion handler runs
                guard !hasResumed else { return }
                hasResumed = true
                continuation.resume(throwing: error)
            }
        }
    }
    
    /// Calculate final price estimate using user-provided data
    /// Formula: estimated_price = user_median_price × condition_factor × rarity_factor
    func calculatePriceEstimate(
        userPrices: UserProvidedPrices,
        condition: ConditionAssessment
    ) -> AntiqueItem {
        let conditionFactor = condition.conditionFactor
        let rarityFactor = condition.rarityFactor
        
        // Calculate estimated price
        let estimatedPrice = userPrices.medianPrice * conditionFactor * rarityFactor
        
        // Calculate adjusted price range
        let minPrice = userPrices.minimumPrice * conditionFactor * rarityFactor
        let maxPrice = userPrices.maximumPrice * conditionFactor * rarityFactor
        
        return AntiqueItem(
            name: NSLocalizedString("antique_object", comment: ""),
            description: NSLocalizedString("user_assessed_item", comment: ""),
            estimatedPrice: estimatedPrice,
            priceRange: AntiqueItem.PriceRange(min: minPrice, max: maxPrice),
            userProvidedPrices: userPrices,
            conditionAssessment: condition,
            conditionFactor: conditionFactor,
            rarityFactor: rarityFactor,
            suggestedCategory: "",
            suggestedKeywords: [],
            analysisConfidence: 1.0
        )
    }
    
    /// Create final assessment result combining image analysis and user data
    func createFinalAssessment(
        imageAnalysis: ImageAnalysisResult,
        userPrices: UserProvidedPrices,
        condition: ConditionAssessment
    ) -> AntiqueItem {
        let conditionFactor = condition.conditionFactor
        let rarityFactor = condition.rarityFactor
        
        // Calculate estimated price using the formula
        let estimatedPrice = userPrices.medianPrice * conditionFactor * rarityFactor
        
        // Calculate adjusted price range
        let minPrice = userPrices.minimumPrice * conditionFactor * rarityFactor
        let maxPrice = userPrices.maximumPrice * conditionFactor * rarityFactor
        
        return AntiqueItem(
            name: imageAnalysis.suggestedCategory.capitalized,
            description: imageAnalysis.searchQuery,
            estimatedPrice: estimatedPrice,
            priceRange: AntiqueItem.PriceRange(min: minPrice, max: maxPrice),
            userProvidedPrices: userPrices,
            conditionAssessment: condition,
            conditionFactor: conditionFactor,
            rarityFactor: rarityFactor,
            suggestedCategory: imageAnalysis.suggestedCategory,
            suggestedKeywords: imageAnalysis.suggestedKeywords,
            analysisConfidence: imageAnalysis.confidence
        )
    }
    
    enum AssessmentError: Error {
        case imageProcessingFailed
        case missingUserData
    }
}
