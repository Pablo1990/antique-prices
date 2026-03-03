import Foundation
import Translation

/// Provides automatic English-to-Spanish translation using the native
/// Translation framework (requires iOS 17.4+).
/// On older OS versions the caller receives the original text unchanged.
@available(iOS 17.4, *)
enum TranslationService {

    @available(iOS 18.0, *)
    private static let configuration = TranslationSession.Configuration(
        source: Locale.Language(identifier: "en"),
        target: Locale.Language(identifier: "es")
    )

    /// Translate an array of English strings to Spanish.
    /// Returns the original strings unchanged if translation is unavailable.
    static func translateToSpanish(_ words: [String]) async -> [String] {
        guard !words.isEmpty else { return words }
        let session = TranslationSession(configuration: configuration)
        do {
            let requests = words.map { TranslationSession.Request(sourceText: <#String#>, sourceString: $0) }
            let responses = try await session.translations(from: requests)
            return responses.map { $0.targetText }
        } catch {
            print("TranslationService: failed to translate \(words.count) word(s): \(error.localizedDescription)")
            return words
        }
    }
}
