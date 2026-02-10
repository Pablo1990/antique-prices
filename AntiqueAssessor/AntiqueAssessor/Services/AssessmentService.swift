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
            
            // Debug logging
            print("Vision framework returned \(observations.count) observations")
            if let topObservation = topClassifications.first {
                print("Top observation: \(topObservation.identifier) (confidence: \(topObservation.confidence))")
            }
            
            // Get confidence from top observation
            if let topObservation = topClassifications.first {
                confidence = Double(topObservation.confidence)
            }
            
            // Use actual Vision keywords directly instead of mapping
            // Extract the actual detected objects as keywords
            // Always include at least the top 3 results, then add more if confidence > 0.05
            var addedCount = 0
            for observation in topClassifications {
                let identifier = observation.identifier.lowercased()
                
                // Include top 3 results regardless of confidence, or any result with confidence > 0.05
                if addedCount < 3 || observation.confidence > 0.05 {
                    // Add the identifier itself as a keyword (no mapping)
                    keywords.append(identifier)
                    addedCount += 1
                    
                    print("Added keyword: \(identifier) (confidence: \(observation.confidence))")
                    
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
            }
            
            print("Total keywords added from Vision: \(keywords.count)")
            
            // Add generic era keywords for variety
            eraKeywords = ["antiguo", "vintage", "colección"]
            
        } catch {
            // Vision framework classification failed - try fallback analysis
            #if targetEnvironment(simulator)
            print("ℹ️ Vision framework classification limited on simulator: \(error.localizedDescription)")
            print("ℹ️ Attempting basic image analysis fallback...")
            #else
            print("ERROR: Vision framework classification failed: \(error.localizedDescription)")
            print("Attempting fallback image analysis...")
            #endif
            
            // Try basic image analysis as fallback
            do {
                let basicFeatures = try await performBasicImageAnalysis(cgImage: cgImage)
                if !basicFeatures.isEmpty {
                    print("✓ Basic image analysis successful, found features: \(basicFeatures)")
                    keywords = basicFeatures
                    suggestedCategory = basicFeatures.first ?? "antigüedad"
                } else {
                    throw AssessmentError.imageProcessingFailed
                }
            } catch {
                // Both attempts failed - use generic terms
                #if targetEnvironment(simulator)
                print("ℹ️ Basic analysis also limited on simulator")
                print("ℹ️ For full Vision functionality, test on a physical device")
                #else
                print("ERROR: All image analysis methods failed")
                #endif
                print("ℹ️ Using generic search terms as final fallback")
                
                keywords = ["colección", "vintage", "antiguo"]
            }
            
            suggestedCategory = keywords.first ?? "antigüedad"
            eraKeywords = ["antiguo", "retro", "histórico"]
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
        // Check if running on simulator
        #if targetEnvironment(simulator)
        print("⚠️ Running on simulator - VNClassifyImageRequest may have limited functionality")
        #endif
        
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
            
            // Configure request with more lenient settings for simulator compatibility
            request.imageCropAndScaleOption = .scaleFit
            
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
    
    /// Fallback image analysis using basic feature detection
    /// Used when VNClassifyImageRequest fails (e.g., in simulator)
    private func performBasicImageAnalysis(cgImage: CGImage) async throws -> [String] {
        return try await withCheckedThrowingContinuation { continuation in
            var hasResumed = false
            var detectedFeatures: [String] = []
            
            // Try to detect any recognizable features using simpler Vision requests
            let request = VNDetectFaceLandmarksRequest { request, error in
                // This is just to trigger some basic processing
                // Most antiques won't have faces, but the Vision framework initializes
            }
            
            let saliencyRequest = VNGenerateAttentionBasedSaliencyImageRequest { request, error in
                guard !hasResumed else { return }
                
                // Even if this fails, we'll return basic keywords
                if error == nil, let results = request.results as? [VNSaliencyImageObservation], !results.isEmpty {
                    // We have some visual features detected
                    detectedFeatures.append("object")
                }
            }
            
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            do {
                // Try the saliency request - it's more simulator-friendly
                try handler.perform([saliencyRequest])
                
                if !hasResumed {
                    hasResumed = true
                    // Return basic generic terms that can be used for any antique
                    detectedFeatures.append(contentsOf: ["artifact", "item", "piece"])
                    continuation.resume(returning: detectedFeatures)
                }
            } catch {
                guard !hasResumed else { return }
                hasResumed = true
                // Return basic keywords even on error
                continuation.resume(returning: ["artifact", "item", "object"])
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
