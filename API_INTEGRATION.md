# API and Integration Guide / Guía de API e Integración

## TodoColección.net Integration / Integración con TodoColección.net

### Overview / Visión General

**English:**
This document describes how to integrate with TodoColección.net to fetch real antique pricing data. The current implementation uses mock data as a placeholder.

**Español:**
Este documento describe cómo integrar con TodoColección.net para obtener datos reales de precios de antigüedades. La implementación actual usa datos simulados como marcador de posición.

### Integration Approaches / Enfoques de Integración

#### 1. Web Scraping / Raspado Web

**Pros:**
- No API key needed
- Free to use
- Access to all public data

**Cons:**
- Website structure changes can break integration
- Slower than API
- May violate terms of service
- Requires more maintenance

**Implementation Example:**

```swift
import SwiftSoup

class TodoColeccionScraper {
    private let baseURL = "https://www.todocoleccion.net"
    
    func searchAntiques(query: String) async throws -> [AntiqueData] {
        let searchURL = "\(baseURL)/buscar/\(query.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "")"
        
        let (data, _) = try await URLSession.shared.data(from: URL(string: searchURL)!)
        let html = String(data: data, encoding: .utf8) ?? ""
        let doc = try SwiftSoup.parse(html)
        
        let items = try doc.select(".listing-item")
        
        return try items.array().map { item in
            let title = try item.select(".title").text()
            let priceText = try item.select(".price").text()
            let price = extractPrice(from: priceText)
            let url = try item.select("a").attr("href")
            
            return AntiqueData(name: title, price: price, url: "\(baseURL)\(url)")
        }
    }
    
    private func extractPrice(from text: String) -> Double {
        // Extract numeric price from string like "125,50 €"
        let cleaned = text.replacingOccurrences(of: "[^0-9,]", with: "", options: .regularExpression)
        let normalized = cleaned.replacingOccurrences(of: ",", with: ".")
        return Double(normalized) ?? 0.0
    }
}
```

#### 2. Official API (If Available) / API Oficial (Si Está Disponible)

**Recommended if available / Recomendado si está disponible**

```swift
class TodoColeccionAPI {
    private let apiKey: String
    private let baseURL = "https://api.todocoleccion.net/v1"
    
    func searchItems(query: String, category: String? = nil) async throws -> SearchResponse {
        var components = URLComponents(string: "\(baseURL)/search")!
        components.queryItems = [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "api_key", value: apiKey)
        ]
        
        if let category = category {
            components.queryItems?.append(URLQueryItem(name: "category", value: category))
        }
        
        let (data, _) = try await URLSession.shared.data(from: components.url!)
        return try JSONDecoder().decode(SearchResponse.self, from: data)
    }
}

struct SearchResponse: Codable {
    let items: [ApiAntiqueItem]
    let total: Int
    let page: Int
}

struct ApiAntiqueItem: Codable {
    let id: String
    let name: String
    let description: String
    let price: Double
    let currency: String
    let imageUrl: String
    let seller: String
    let category: String
    let url: String
}
```

### Updating AssessmentService / Actualizando AssessmentService

Replace the mock implementation in `AssessmentService.swift`:

```swift
private func searchSimilarItems(description: String) async throws -> [AntiqueItem.SimilarItem] {
    // Option 1: Using web scraping
    let scraper = TodoColeccionScraper()
    let results = try await scraper.searchAntiques(query: description)
    
    return results.map { item in
        AntiqueItem.SimilarItem(
            name: item.name,
            price: item.price,
            url: item.url
        )
    }
    
    // Option 2: Using API (if available)
    // let api = TodoColeccionAPI(apiKey: "YOUR_API_KEY")
    // let response = try await api.searchItems(query: description)
    // return response.items.map { ... }
}
```

## Image Recognition / Reconocimiento de Imágenes

### Using Vision Framework / Usando Vision Framework

```swift
import Vision

extension AssessmentService {
    func analyzeImageWithVision(_ image: UIImage) async throws -> [VNClassificationObservation] {
        guard let cgImage = image.cgImage else {
            throw AssessmentError.imageProcessingFailed
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            // Create image classification request
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
            
            // Execute request
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            do {
                try handler.perform([request])
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
}
```

### Custom CoreML Model / Modelo CoreML Personalizado

**English:**
To train a custom model for antique recognition:

1. Collect training data (images of authentic vs. fake antiques)
2. Use Create ML or TensorFlow to train model
3. Convert to CoreML format (.mlmodel)
4. Add to Xcode project
5. Use in app

**Español:**
Para entrenar un modelo personalizado para reconocimiento de antigüedades:

1. Recolecta datos de entrenamiento (imágenes de antigüedades auténticas vs. falsas)
2. Usa Create ML o TensorFlow para entrenar el modelo
3. Convierte a formato CoreML (.mlmodel)
4. Agrega al proyecto de Xcode
5. Usa en la app

```swift
import CoreML

class AntiqueClassifier {
    private let model: AntiqueAuthenticityModel
    
    init() throws {
        self.model = try AntiqueAuthenticityModel(configuration: MLModelConfiguration())
    }
    
    func classifyAntique(image: UIImage) throws -> (isAuthentic: Bool, confidence: Double) {
        guard let pixelBuffer = image.pixelBuffer() else {
            throw ClassificationError.invalidImage
        }
        
        let prediction = try model.prediction(image: pixelBuffer)
        
        return (
            isAuthentic: prediction.classLabel == "authentic",
            confidence: prediction.classProbability["authentic"] ?? 0.0
        )
    }
}
```

## Data Models / Modelos de Datos

### Complete AntiqueItem Model / Modelo AntiqueItem Completo

```swift
struct AntiqueItem {
    // Basic Information
    let id: UUID
    let name: String
    let description: String
    let category: AntiqueCategory
    
    // Price Information
    let estimatedPrice: Double
    let priceRange: PriceRange
    let currency: String
    
    // Authenticity
    let isAuthentic: Bool
    let authenticityConfidence: Double
    let authenticityFactors: [AuthenticityFactor]
    
    // Historical Information
    let period: String
    let periodConfidence: Double
    let era: HistoricalEra
    let estimatedYear: YearRange?
    
    // Source and References
    let source: String
    let similarItems: [SimilarItem]
    let references: [Reference]
    
    // Metadata
    let assessmentDate: Date
    let imageData: Data?
    
    enum AntiqueCategory: String, Codable {
        case coins = "monedas"
        case stamps = "sellos"
        case paintings = "pinturas"
        case furniture = "muebles"
        case jewelry = "joyas"
        case pottery = "cerámica"
        case books = "libros"
        case other = "otros"
    }
    
    struct AuthenticityFactor {
        let name: String
        let score: Double
        let description: String
    }
    
    enum HistoricalEra: String, Codable {
        case ancient = "antiguo"
        case medieval = "medieval"
        case renaissance = "renacimiento"
        case baroque = "barroco"
        case victorian = "victoriano"
        case artNouveau = "art_nouveau"
        case artDeco = "art_deco"
        case modern = "moderno"
        case contemporary = "contemporáneo"
    }
    
    struct YearRange {
        let start: Int
        let end: Int
    }
    
    struct Reference {
        let title: String
        let url: String
        let source: String
    }
}
```

## Caching Strategy / Estrategia de Caché

### Local Cache Implementation / Implementación de Caché Local

```swift
import Foundation

class AssessmentCache {
    private let fileManager = FileManager.default
    private let cacheDirectory: URL
    
    init() {
        let urls = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
        cacheDirectory = urls[0].appendingPathComponent("Assessments")
        try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
    }
    
    func save(assessment: AntiqueItem) throws {
        let encoder = JSONEncoder()
        let data = try encoder.encode(assessment)
        let url = cacheDirectory.appendingPathComponent("\(assessment.id.uuidString).json")
        try data.write(to: url)
    }
    
    func load(id: UUID) throws -> AntiqueItem? {
        let url = cacheDirectory.appendingPathComponent("\(id.uuidString).json")
        guard fileManager.fileExists(atPath: url.path) else {
            return nil
        }
        
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        return try decoder.decode(AntiqueItem.self, from: data)
    }
    
    func clearCache() throws {
        let contents = try fileManager.contentsOfDirectory(at: cacheDirectory, includingPropertiesForKeys: nil)
        for url in contents {
            try fileManager.removeItem(at: url)
        }
    }
}
```

## Error Handling / Manejo de Errores

### Comprehensive Error Types / Tipos de Error Completos

```swift
enum AssessmentError: LocalizedError {
    case imageProcessingFailed
    case networkError(Error)
    case noSimilarItemsFound
    case invalidResponse
    case authenticationRequired
    case rateLimitExceeded
    case serviceUnavailable
    case invalidAPIKey
    
    var errorDescription: String? {
        switch self {
        case .imageProcessingFailed:
            return NSLocalizedString("image_processing_error", comment: "")
        case .networkError(let error):
            return NSLocalizedString("network_error", comment: "") + ": \(error.localizedDescription)"
        case .noSimilarItemsFound:
            return NSLocalizedString("no_similar_items", comment: "")
        case .invalidResponse:
            return NSLocalizedString("invalid_response", comment: "")
        case .authenticationRequired:
            return NSLocalizedString("authentication_required", comment: "")
        case .rateLimitExceeded:
            return NSLocalizedString("rate_limit_exceeded", comment: "")
        case .serviceUnavailable:
            return NSLocalizedString("service_unavailable", comment: "")
        case .invalidAPIKey:
            return NSLocalizedString("invalid_api_key", comment: "")
        }
    }
}
```

## Testing / Pruebas

### Unit Test Example / Ejemplo de Prueba Unitaria

```swift
import XCTest
@testable import AntiqueAssessor

class AssessmentServiceTests: XCTestCase {
    var service: AssessmentService!
    
    override func setUp() {
        super.setUp()
        service = AssessmentService()
    }
    
    func testPriceCalculation() {
        let items = [
            AntiqueItem.SimilarItem(name: "Item 1", price: 100, url: ""),
            AntiqueItem.SimilarItem(name: "Item 2", price: 200, url: ""),
            AntiqueItem.SimilarItem(name: "Item 3", price: 150, url: "")
        ]
        
        let result = service.calculatePriceEstimate(from: items)
        
        XCTAssertEqual(result.average, 150.0, accuracy: 0.01)
        XCTAssertEqual(result.min, 100.0)
        XCTAssertEqual(result.max, 200.0)
    }
    
    func testAuthenticityDetection() async throws {
        let image = UIImage(named: "test_antique")!
        let result = await service.determineAuthenticity(image: image, similarItems: [])
        
        XCTAssertTrue(result.confidence >= 0.0 && result.confidence <= 1.0)
    }
}
```

## Performance Optimization / Optimización de Rendimiento

### Image Optimization / Optimización de Imágenes

```swift
extension UIImage {
    func optimizedForAssessment() -> UIImage? {
        let maxDimension: CGFloat = 1024
        let scale = min(maxDimension / size.width, maxDimension / size.height, 1.0)
        let newSize = CGSize(width: size.width * scale, height: size.height * scale)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        draw(in: CGRect(origin: .zero, size: newSize))
        let optimized = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return optimized
    }
}
```

### Async/Await Best Practices / Mejores Prácticas de Async/Await

```swift
func assessAntique(image: UIImage) async throws -> AntiqueItem {
    // Run independent tasks concurrently
    async let imageAnalysis = analyzeImage(image)
    async let similarItems = searchSimilarItems(description: "antique")
    
    // Wait for both to complete
    let analysis = try await imageAnalysis
    let items = try await similarItems
    
    // Continue with dependent tasks
    let priceEstimate = calculatePriceEstimate(from: items)
    
    async let authenticity = determineAuthenticity(image: image, similarItems: items)
    async let period = determinePeriod(image: image, description: analysis.description)
    
    let auth = await authenticity
    let per = await period
    
    return AntiqueItem(/* ... */)
}
```

## Security Considerations / Consideraciones de Seguridad

### API Key Storage / Almacenamiento de Clave API

```swift
import Security

class KeychainManager {
    static func save(apiKey: String) {
        let data = apiKey.data(using: .utf8)!
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "TodoColeccionAPIKey",
            kSecValueData as String: data
        ]
        
        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }
    
    static func load() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "TodoColeccionAPIKey",
            kSecReturnData as String: true
        ]
        
        var result: AnyObject?
        SecItemCopyMatching(query as CFDictionary, &result)
        
        guard let data = result as? Data else { return nil }
        return String(data: data, encoding: .utf8)
    }
}
```

---

For more information, see the main [README.md](README.md) and [IMPLEMENTATION.md](IMPLEMENTATION.md).
