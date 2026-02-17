import UIKit
import CoreML
import Vision

/// Service for FastViT-based object recognition
/// Uses the FastViT T8 F16 model for efficient and accurate object classification
class FastViTService {
    
    // MARK: - Properties
    
    /// Shared singleton instance
    static let shared = FastViTService()
    
    /// The Vision Core ML model
    private var visionModel: VNCoreMLModel?
    
    /// Model loading error if initialization failed
    private var modelLoadError: Error?
    
    /// Whether the model is available and ready to use
    var isModelAvailable: Bool {
        return visionModel != nil
    }
    
    // MARK: - Initialization
    
    private init() {
        loadModel()
    }
    
    /// Load the FastViT model
    private func loadModel() {
        do {
            // Try to load the FastViT model
            // Note: The model file should be named "FastViTT8F16" without extension
            // Xcode automatically handles .mlpackage files
            guard let modelURL = Bundle.main.url(forResource: "FastViTT8F16", withExtension: "mlmodelc") else {
                // If compiled model not found, try loading from package
                print("⚠️ FastViT model not found in bundle. Please add FastViTT8F16.mlpackage to MLModels directory.")
                print("ℹ️ Falling back to Vision framework default classifier")
                modelLoadError = FastViTError.modelNotFound
                return
            }
            
            let mlModel = try MLModel(contentsOf: modelURL)
            visionModel = try VNCoreMLModel(for: mlModel)
            print("✓ FastViT model loaded successfully")
            
        } catch {
            print("❌ Failed to load FastViT model: \(error.localizedDescription)")
            print("ℹ️ Falling back to Vision framework default classifier")
            modelLoadError = error
        }
    }
    
    // MARK: - Object Classification
    
    /// Classify objects in an image using FastViT
    /// - Parameter image: The UIImage to classify
    /// - Returns: Array of classification observations with labels and confidence scores
    func classifyImage(_ image: UIImage) async throws -> [VNClassificationObservation] {
        // Check if model is available
        guard let visionModel = visionModel else {
            throw modelLoadError ?? FastViTError.modelNotAvailable
        }
        
        // Convert UIImage to CGImage
        guard let cgImage = image.cgImage else {
            throw FastViTError.imageProcessingFailed
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            var hasResumed = false
            
            // Create Core ML Vision request
            let request = VNCoreMLRequest(model: visionModel) { request, error in
                guard !hasResumed else { return }
                hasResumed = true
                
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let observations = request.results as? [VNClassificationObservation] else {
                    continuation.resume(throwing: FastViTError.invalidResults)
                    return
                }
                
                continuation.resume(returning: observations)
            }
            
            // Configure request
            request.imageCropAndScaleOption = .centerCrop
            
            // Perform request
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            do {
                try handler.perform([request])
            } catch {
                guard !hasResumed else { return }
                hasResumed = true
                continuation.resume(throwing: error)
            }
        }
    }
    
    /// Get the top N predictions from FastViT
    /// - Parameters:
    ///   - image: The UIImage to classify
    ///   - topN: Number of top predictions to return (default: 5)
    ///   - minimumConfidence: Minimum confidence threshold (default: 0.05)
    /// - Returns: Array of tuples containing (label, confidence)
    func getTopPredictions(
        from image: UIImage,
        topN: Int = 5,
        minimumConfidence: Float = 0.05
    ) async throws -> [(label: String, confidence: Float)] {
        let observations = try await classifyImage(image)
        
        // Filter by confidence and take top N
        return observations
            .filter { $0.confidence >= minimumConfidence }
            .prefix(topN)
            .map { (label: $0.identifier, confidence: $0.confidence) }
    }
    
    /// Get classification keywords suitable for searching antiques
    /// - Parameter image: The UIImage to analyze
    /// - Returns: Array of keywords extracted from top predictions
    func getSearchKeywords(from image: UIImage) async throws -> [String] {
        // Get top 10 predictions with adaptive confidence
        let observations = try await classifyImage(image)
        
        var keywords: [String] = []
        var addedCount = 0
        
        // Always include top 3 results, then add more if confidence > 0.05
        for observation in observations.prefix(10) {
            if addedCount < 3 || observation.confidence > 0.05 {
                let identifier = observation.identifier.lowercased()
                keywords.append(identifier)
                addedCount += 1
                
                print("FastViT keyword: \(identifier) (confidence: \(observation.confidence))")
            }
        }
        
        // Remove duplicates while preserving order
        var seen = Set<String>()
        return keywords.filter { keyword in
            guard !seen.contains(keyword) else { return false }
            seen.insert(keyword)
            return true
        }
    }
    
    // MARK: - Error Types
    
    enum FastViTError: Error, LocalizedError {
        case modelNotFound
        case modelNotAvailable
        case imageProcessingFailed
        case invalidResults
        
        var errorDescription: String? {
            switch self {
            case .modelNotFound:
                return "FastViT model file not found. Please add FastViTT8F16.mlpackage to the project."
            case .modelNotAvailable:
                return "FastViT model is not available or failed to load."
            case .imageProcessingFailed:
                return "Failed to process image for FastViT classification."
            case .invalidResults:
                return "FastViT returned invalid classification results."
            }
        }
    }
}
