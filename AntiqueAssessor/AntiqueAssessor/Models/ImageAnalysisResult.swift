import Foundation

/// Result from Vision/CoreML image analysis
struct ImageAnalysisResult {
    let suggestedCategory: String
    let suggestedKeywords: [String]
    let eraStyleKeywords: [String]
    let confidence: Double
    let suggestedCondition: ConditionAssessment.ConditionLevel
    let suggestedRarity: ConditionAssessment.RarityLevel

    /// Generate search query with automatic translated to Spanish if the current locale is Spanish
    var searchQuery: String {
        var terms: [String] = []

        if Locale.current.languageCode == "es" {
            // Add other keywords (limit to top 2, translate to Spanish)
            let suggestedKeywords_es = suggestedKeywords.prefix(2).map { translateToSpanish(word: $0) }
            terms.append(contentsOf: suggestedKeywords_es)

            return terms.joined(separator: " ")
        } else {
            // Add other keywords (limit to top 2)
            terms.append(contentsOf: suggestedKeywords.prefix(2))

            return terms.joined(separator: " ")
        }
    }
    
    /// Generate todocoleccion.net search URL
    func generateSearchURL() -> URL? {
        var baseURL = "https://en.todocoleccion.net/orientaprecios/-1/g/reciente/0/1?autocompletado="
        /// If language is Spanish, use Spanish base URL, otherwise use English
        if Locale.current.languageCode == "es" {
            baseURL = "https://www.todocoleccion.net/orientaprecios/-1/g/reciente/0/1?autocompletado="
        }
        
        let query = searchQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        return URL(string: "\(baseURL)\(query)")
    }
    
    /// English-to-Spanish lookup table covering common Vision framework ML labels
    /// and antique-related terms. Defined once as a static constant for performance.
    private static let spanishTranslations: [String: String] = [
            // Common Vision framework object labels
            "chair": "silla",
            "table": "mesa",
            "desk": "escritorio",
            "cabinet": "armario",
            "drawer": "cajón",
            "shelf": "estante",
            "bed": "cama",
            "sofa": "sofá",
            "couch": "sofá",
            "bench": "banco",
            "stool": "taburete",
            "lamp": "lámpara",
            "mirror": "espejo",
            "clock": "reloj",
            "watch": "reloj de pulsera",
            "vase": "jarrón",
            "bottle": "botella",
            "glass": "cristal",
            "cup": "taza",
            "mug": "taza grande",
            "plate": "plato",
            "bowl": "cuenco",
            "pot": "maceta",
            "jug": "jarra",
            "pitcher": "jarra",
            "candle": "vela",
            "candlestick": "candelabro",
            "figurine": "figurilla",
            "statue": "estatua",
            "sculpture": "escultura",
            "bust": "busto",
            "painting": "pintura",
            "portrait": "retrato",
            "landscape": "paisaje",
            "print": "grabado",
            "poster": "póster",
            "frame": "marco",
            "canvas": "lienzo",
            "tapestry": "tapiz",
            "rug": "alfombra",
            "carpet": "tapete",
            "curtain": "cortina",
            "blanket": "manta",
            "quilt": "colcha",
            "pillow": "almohada",
            "book": "libro",
            "map": "mapa",
            "document": "documento",
            "letter": "carta",
            "newspaper": "periódico",
            "magazine": "revista",
            "photograph": "fotografía",
            "photo": "foto",
            "album": "álbum",
            "coin": "moneda",
            "medal": "medalla",
            "badge": "insignia",
            "stamp": "sello",
            "ticket": "billete",
            "banknote": "billete de banco",
            "jewelry": "joyería",
            "ring": "anillo",
            "necklace": "collar",
            "bracelet": "pulsera",
            "earring": "pendiente",
            "brooch": "broche",
            "pendant": "colgante",
            "gold": "oro",
            "silver": "plata",
            "bronze": "bronce",
            "copper": "cobre",
            "iron": "hierro",
            "tin": "estaño",
            "ceramic": "cerámica",
            "porcelain": "porcelana",
            "pottery": "alfarería",
            "terracotta": "terracota",
            "crystal": "cristal",
            "wood": "madera",
            "stone": "piedra",
            "marble": "mármol",
            "ivory": "marfil",
            "bone": "hueso",
            "leather": "cuero",
            "fabric": "tela",
            "lace": "encaje",
            "silk": "seda",
            "wool": "lana",
            "cotton": "algodón",
            "toy": "juguete",
            "doll": "muñeca",
            "puppet": "marioneta",
            "soldier": "soldado",
            "train": "tren",
            "car": "coche",
            "boat": "barco",
            "ship": "barco",
            "airplane": "avión",
            "tool": "herramienta",
            "knife": "cuchillo",
            "sword": "espada",
            "gun": "pistola",
            "pistol": "pistola",
            "rifle": "rifle",
            "compass": "brújula",
            "telescope": "telescopio",
            "microscope": "microscopio",
            "barometer": "barómetro",
            "thermometer": "termómetro",
            "sewing machine": "máquina de coser",
            "typewriter": "máquina de escribir",
            "radio": "radio",
            "gramophone": "gramófono",
            "camera": "cámara",
            "projector": "proyector",
            "telephone": "teléfono",
            "instrument": "instrumento",
            "violin": "violín",
            "guitar": "guitarra",
            "piano": "piano",
            "trumpet": "trompeta",
            "flute": "flauta",
            "drum": "tambor",
            "object": "objeto",
            "item": "artículo",
            "artifact": "artefacto",
            "antique": "antigüedad",
            "vintage": "vintage",
            "piece": "pieza",
            "collection": "colección",
            "art": "arte",
            "furniture": "mueble",
            "decoration": "decoración",
            "ornament": "adorno",
            "accessory": "accesorio",
            "container": "recipiente",
            "box": "caja",
            "chest": "baúl",
            "trunk": "baúl",
            "basket": "cesta",
            "bag": "bolsa",
            "purse": "bolso",
            "fan": "abanico",
            "umbrella": "paraguas",
            "cane": "bastón",
            "hat": "sombrero",
            "helmet": "casco",
            "mask": "máscara",
            "glove": "guante",
            "shoe": "zapato",
            "boot": "bota",
            "button": "botón",
            "buckle": "hebilla",
            "clasp": "broche",
            "key": "llave",
            "lock": "cerradura",
            "handle": "mango",
        ]

    /// Translate from English to Spanish automatically using a built-in dictionary
    /// of common Vision framework ML labels and antique-related terms.
    func translateToSpanish(word: String) -> String {
        let translations = ImageAnalysisResult.spanishTranslations
        let lowercased = word.lowercased()
        if let translation = translations[lowercased] {
            return translation
        }
        // For compound words or phrases, try translating each component
        let parts = lowercased.split(separator: " ").map { String($0) }
        if parts.count > 1 {
            let translatedParts = parts.map { translations[$0] ?? $0 }
            let result = translatedParts.joined(separator: " ")
            if result != lowercased {
                return result
            }
        }
        // Return the original word if no translation is found
        return word
    }
}
