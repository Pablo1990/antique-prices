import Foundation
import Translation

/// Provides automatic English-to-Spanish translation using the native
/// Translation framework (requires iOS 17.4+).
/// On older OS versions the caller receives the original text unchanged.
@available(iOS 17.4, *)
enum TranslationService {

    /// Translate an array of English strings to Spanish.
    /// Returns the original strings unchanged if translation is unavailable.
    @available(iOS 18.0, *)
    static func translateToSpanish(_ words: [String]) async -> [String] {
        guard !words.isEmpty else { return words }
        let session = TranslationSession(
            installedSource: Locale.Language(identifier: "en"),
            target: Locale.Language(identifier: "es")
        )
        do {
            let requests = words.map { TranslationSession.Request(sourceText: $0) }
            let responses = try await session.translations(from: requests)
            return responses.map { $0.targetText }
        } catch {
            print("TranslationService: failed to translate \(words.count) word(s): \(error.localizedDescription)")
            return words
        }
    }
}
