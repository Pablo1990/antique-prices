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
        
        do {
            let observations = try await performImageClassification(cgImage: cgImage)
            
            // Extract top classifications to build search query
            let topClassifications = observations.prefix(5)
            
            // Get confidence from top observation
            if let topObservation = topClassifications.first {
                confidence = Double(topObservation.confidence)
            }
            
            // Map common Vision classifications to Spanish antique categories
            for observation in topClassifications {
                let lowercased = observation.identifier.lowercased()
                
                // Common antique categories
                if lowercased.contains("coin") || lowercased.contains("money") {
                    suggestedCategory = "moneda antigua"
                    keywords.append("numismática")
                } else if lowercased.contains("furniture") || lowercased.contains("chair") || lowercased.contains("table") {
                    suggestedCategory = "mueble antiguo"
                    keywords.append("mobiliario")
                } else if lowercased.contains("vase") || lowercased.contains("pot") || lowercased.contains("jar") || lowercased.contains("ceramic") {
                    suggestedCategory = "cerámica antigua"
                    keywords.append("porcelana")
                } else if lowercased.contains("painting") || lowercased.contains("art") {
                    suggestedCategory = "pintura antigua"
                    keywords.append("arte")
                } else if lowercased.contains("jewelry") || lowercased.contains("ring") || lowercased.contains("necklace") {
                    suggestedCategory = "joya antigua"
                    keywords.append("bisutería")
                } else if lowercased.contains("book") {
                    suggestedCategory = "libro antiguo"
                    keywords.append("bibliofilia")
                } else if lowercased.contains("watch") || lowercased.contains("clock") {
                    suggestedCategory = "reloj antiguo"
                    keywords.append("relojería")
                } else if lowercased.contains("toy") {
                    suggestedCategory = "juguete antiguo"
                    keywords.append("colección")
                } else if lowercased.contains("bottle") || lowercased.contains("glass") {
                    keywords.append("cristal")
                } else if lowercased.contains("metal") || lowercased.contains("bronze") || lowercased.contains("silver") {
                    keywords.append("metal")
                }
            }
            
            // Add generic era keywords for variety
            eraKeywords = ["antiguo", "vintage", "colección"]
            
        } catch {
            // Vision framework failed - use generic terms
            print("Vision framework unavailable, using generic search terms: \(error.localizedDescription)")
            suggestedCategory = "antigüedad"
            keywords = ["colección", "vintage"]
            eraKeywords = ["antiguo"]
        }
        
        // Remove duplicates
        keywords = Array(Set(keywords))
        
        return ImageAnalysisResult(
            suggestedCategory: suggestedCategory,
            suggestedKeywords: keywords,
            eraStyleKeywords: eraKeywords,
            confidence: confidence
        )
    }
    
    /// Perform image classification using Vision framework
    private func performImageClassification(cgImage: CGImage) async throws -> [VNClassificationObservation] {
        return try await withCheckedThrowingContinuation { continuation in
            let request = VNClassifyImageRequest { request, error in
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
            try? handler.perform([request])
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
