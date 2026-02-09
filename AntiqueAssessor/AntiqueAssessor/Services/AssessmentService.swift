import UIKit
import Vision
import CoreML

class AssessmentService: ObservableObject {
    private let baseURL = "https://www.todocoleccion.net"
    
    func assessAntique(image: UIImage) async throws -> AntiqueItem {
        // Analyze the image using Vision framework
        let imageAnalysis = try await analyzeImage(image)
        
        // Search for similar items on todocoleccion.net
        let similarItems = try await searchSimilarItems(description: imageAnalysis.description)
        
        // Calculate price estimation based on similar items
        let priceEstimate = calculatePriceEstimate(from: similarItems)
        
        // Determine authenticity using ML models and comparison
        let authenticityResult = await determineAuthenticity(image: image, similarItems: similarItems)
        
        // Determine period/era
        let periodResult = await determinePeriod(image: image, description: imageAnalysis.description)
        
        return AntiqueItem(
            name: imageAnalysis.name,
            description: imageAnalysis.description,
            estimatedPrice: priceEstimate.average,
            priceRange: AntiqueItem.PriceRange(min: priceEstimate.min, max: priceEstimate.max),
            isAuthentic: authenticityResult.isAuthentic,
            authenticityConfidence: authenticityResult.confidence,
            period: periodResult.period,
            periodConfidence: periodResult.confidence,
            source: baseURL,
            similarItems: similarItems
        )
    }
    
    private func analyzeImage(_ image: UIImage) async throws -> (name: String, description: String) {
        // Use Vision framework for image recognition
        guard let cgImage = image.cgImage else {
            throw AssessmentError.imageProcessingFailed
        }
        
        // Use Vision framework to classify the image
        let observations = try await performImageClassification(cgImage: cgImage)
        
        // Extract top classifications to build search query
        let topClassifications = observations.prefix(3).map { $0.identifier }
        
        // Build a search-friendly description from classifications
        var searchTerms: [String] = []
        
        // Map common Vision classifications to Spanish antique categories
        for classification in topClassifications {
            let lowercased = classification.lowercased()
            
            // Common antique categories
            if lowercased.contains("coin") || lowercased.contains("money") {
                searchTerms.append("moneda antigua")
            } else if lowercased.contains("furniture") || lowercased.contains("chair") || lowercased.contains("table") {
                searchTerms.append("mueble antiguo")
            } else if lowercased.contains("vase") || lowercased.contains("pot") || lowercased.contains("jar") {
                searchTerms.append("cerámica antigua")
            } else if lowercased.contains("painting") || lowercased.contains("art") {
                searchTerms.append("pintura antigua")
            } else if lowercased.contains("jewelry") || lowercased.contains("ring") || lowercased.contains("necklace") {
                searchTerms.append("joya antigua")
            } else if lowercased.contains("book") {
                searchTerms.append("libro antiguo")
            } else if lowercased.contains("watch") || lowercased.contains("clock") {
                searchTerms.append("reloj antiguo")
            } else if lowercased.contains("toy") {
                searchTerms.append("juguete antiguo")
            }
        }
        
        // If no specific category matched, use generic terms
        if searchTerms.isEmpty {
            searchTerms = ["antigüedad", "colección"]
        }
        
        let searchQuery = searchTerms.joined(separator: " ")
        
        return (
            name: "Objeto Antiguo",
            description: searchQuery
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
            // Perform the request - any errors will be reported to the completion handler
            // Don't wrap in do-catch to avoid resuming continuation twice
            try? handler.perform([request])
        }
    }
    
    private func searchSimilarItems(description: String) async throws -> [AntiqueItem.SimilarItem] {
        // Use the TodoColeccionScraper to fetch real items
        let scraper = TodoColeccionScraper()
        
        do {
            let scrapedItems = try await scraper.searchAntiques(query: description)
            
            // Convert scraped items to SimilarItem format
            let similarItems = scrapedItems.map { item in
                AntiqueItem.SimilarItem(
                    name: item.name,
                    price: item.price,
                    url: item.url
                )
            }
            
            // Return items if we found any
            if !similarItems.isEmpty {
                return similarItems
            }
            
            // If no items found, throw error
            throw AssessmentError.noSimilarItemsFound
            
        } catch AssessmentError.noSimilarItemsFound {
            // Propagate the "no similar items" condition to the caller
            throw AssessmentError.noSimilarItemsFound
        } catch {
            // If scraping fails, log the error and throw a network error
            print("Error scraping TodoColección.net: \(error.localizedDescription)")
            throw AssessmentError.networkError
        }
    }
    
    internal func calculatePriceEstimate(from items: [AntiqueItem.SimilarItem]) -> (average: Double, min: Double, max: Double) {
        guard !items.isEmpty else {
            return (average: 0, min: 0, max: 0)
        }
        
        let prices = items.map { $0.price }
        let average = prices.reduce(0, +) / Double(prices.count)
        let min = prices.min() ?? 0
        let max = prices.max() ?? 0
        
        return (average: average, min: min, max: max)
    }
    
    internal func determineAuthenticity(image: UIImage, similarItems: [AntiqueItem.SimilarItem]) async -> (isAuthentic: Bool, confidence: Double) {
        // In a real implementation, this would use ML models to detect fakes
        // For now, using a simulated assessment
        
        // Simulate ML processing delay
        try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        
        // Mock authenticity check based on image analysis
        let confidence = Double.random(in: 0.75...0.95)
        let isAuthentic = confidence > 0.80
        
        return (isAuthentic: isAuthentic, confidence: confidence)
    }
    
    private func determinePeriod(image: UIImage, description: String) async -> (period: String, confidence: Double) {
        // In a real implementation, this would use ML to identify time periods
        // For now, returning mock period data
        
        let periods = [
            "Siglo XIX (1800-1900)",
            "Principios del Siglo XX (1900-1940)",
            "Mediados del Siglo XX (1940-1970)",
            "Arte Deco (1920-1939)",
            "Época Victoriana (1837-1901)",
            "Edad Moderna (1500-1800)"
        ]
        
        let randomPeriod = periods.randomElement() ?? "Periodo desconocido"
        let confidence = Double.random(in: 0.70...0.90)
        
        return (period: randomPeriod, confidence: confidence)
    }
    
    enum AssessmentError: Error {
        case imageProcessingFailed
        case networkError
        case noSimilarItemsFound
    }
}
