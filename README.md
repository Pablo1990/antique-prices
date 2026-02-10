# Tasador de Antigüedades / Antique Assessor

Una aplicación iOS completamente gratuita y de código abierto para evaluar fielmente antigüedades que se pueden encontrar en los mercados españoles mediante investigación de mercado asistida por el usuario.

A completely free, open-source iOS app to faithfully assess antiques that can be found in Spanish markets using user-assisted market research.

## 🌟 Features / Características

### Español
- 📸 **Captura de Fotos**: Toma fotos de antigüedades directamente desde la aplicación
- 🧠 **Análisis con IA**: Usa Vision framework y Core ML de Apple para identificar categorías y sugerir palabras clave
- 🌐 **Navegación Asistida**: Abre Safari con búsquedas sugeridas en todocoleccion.net para que explores manualmente
- 💰 **Entrada Manual de Precios**: Tú ingresas los precios que observas después de investigar el mercado
- ⭐ **Evaluación de Condición**: Evalúa la condición, restauración, autenticidad y rareza de tu artículo
- 📊 **Cálculo Transparente**: Fórmula clara: precio_estimado = precio_mediano × factor_condición × factor_rareza
- 🌐 **Bilingüe**: Soporte completo en Español e Inglés
- ✅ **100% Legal**: Sin scraping, sin automatización, respeta robots.txt y políticas de sitios web
- 🆓 **100% Gratuito**: Sin compras dentro de la aplicación, sin suscripciones
- 🔓 **Código Abierto**: Todo el código es abierto y auditable

### English
- 📸 **Photo Capture**: Take photos of antiques directly from the app
- 🧠 **AI Analysis**: Uses Apple's Vision framework and Core ML to identify categories and suggest keywords
- 🌐 **Assisted Browsing**: Opens Safari with suggested searches on todocoleccion.net for you to browse manually
- 💰 **Manual Price Entry**: You enter the prices you observe after researching the market
- ⭐ **Condition Assessment**: Rate the condition, restoration, authenticity, and rarity of your item
- 📊 **Transparent Calculation**: Clear formula: estimated_price = median_price × condition_factor × rarity_factor
- 🌐 **Bilingual**: Full support in Spanish and English
- ✅ **100% Legal**: No scraping, no automation, respects robots.txt and website policies
- 🆓 **100% Free**: No in-app purchases, no subscriptions
- 🔓 **Open Source**: All code is open and auditable

## 🔗 Reference Sources / Fuentes de Referencia

- [TodoColección.net](https://www.todocoleccion.net/) - Fuente de referencia para investigación de mercado español (navegación manual del usuario) / Reference source for Spanish market research (user manual browsing)

**Importante / Important**: Esta aplicación NO hace scraping ni automatización de todocoleccion.net. Toda navegación es manual por el usuario a través de Safari. / This app does NOT scrape or automate todocoleccion.net. All browsing is manual by the user through Safari.

## 🚀 Getting Started / Primeros Pasos

### Requirements / Requisitos

- Xcode 15.0 or later
- iOS 15.0 or later
- Swift 5.0 or later

### Installation / Instalación

1. Clone the repository / Clona el repositorio:
```bash
git clone https://github.com/Pablo1990/antique-prices.git
cd antique-prices
```

2. Open the Xcode project / Abre el proyecto de Xcode:
```bash
open AntiqueAssessor/AntiqueAssessor.xcodeproj
```

3. Build and run the app / Compila y ejecuta la aplicación:
   - Select your target device or simulator
   - Press `Cmd + R` to build and run

### Camera Permissions / Permisos de Cámara

The app requires camera access to take photos of antiques. The permission request is included in the Info.plist with bilingual descriptions.

La aplicación requiere acceso a la cámara para tomar fotos de antigüedades. La solicitud de permiso está incluida en Info.plist con descripciones bilingües.

## 📱 How It Works / Cómo Funciona

### Español
1. **Toma una Foto**: Usa la cámara integrada para capturar una imagen de tu antigüedad
2. **Analiza con IA**: La app usa Vision y Core ML para sugerir categorías y palabras clave de búsqueda
3. **Explora el Mercado**: Safari se abre con una búsqueda sugerida en todocoleccion.net - tú navegas manualmente
4. **Ingresa Precios**: Después de investigar, ingresa los precios mínimo, mediano y máximo que observaste
5. **Evalúa Condición**: Responde preguntas sobre condición, restauración, autenticidad y rareza
6. **Revisa Resultados**: Obtén una estimación calculada con:
   - Precio estimado basado en tu investigación
   - Desglose del cálculo (precio × condición × rareza)
   - Tus observaciones de mercado
   - Tu evaluación de condición
   - Avisos legales claros

### English
1. **Take a Photo**: Use the built-in camera to capture an image of your antique
2. **AI Analysis**: The app uses Vision and Core ML to suggest categories and search keywords
3. **Browse Market**: Safari opens with a suggested search on todocoleccion.net - you browse manually
4. **Enter Prices**: After researching, enter the minimum, median, and maximum prices you observed
5. **Rate Condition**: Answer questions about condition, restoration, authenticity, and rarity
6. **Review Results**: Get a calculated estimate with:
   - Estimated price based on your research
   - Calculation breakdown (price × condition × rarity)
   - Your market observations
   - Your condition assessment
   - Clear legal disclaimers
   - Estimated price and price range
   - Authenticity with confidence percentage
   - Historical period with accuracy percentage
   - Similar items on todocoleccion.net

## 🏗️ Architecture / Arquitectura

The app is built using:
- **SwiftUI**: Modern declarative UI framework
- **Vision Framework**: For on-device image recognition and classification (VNClassifyImageRequest)
- **CoreML**: For machine learning models (category and keyword suggestion)
- **SafariServices**: For legal browsing of todocoleccion.net (SFSafariViewController)
- **Pure Swift**: No external dependencies, only native iOS frameworks
- **Human-in-the-Loop**: User provides all market data manually

### Project Structure / Estructura del Proyecto

```
AntiqueAssessor/
├── AntiqueAssessor/
│   ├── AntiqueAssessorApp.swift          # App entry point
│   ├── ContentView.swift                 # Main view with 6-step workflow
│   ├── CameraView.swift                  # Camera interface
│   ├── SafariView.swift                  # Safari browser wrapper
│   ├── PriceInputView.swift              # Manual price entry
│   ├── ConditionScoringView.swift        # Condition assessment
│   ├── ResultsView.swift                 # Results with disclaimers
│   ├── Models/
│   │   ├── AntiqueItem.swift            # Assessment result model
│   │   ├── UserProvidedData.swift       # User input models
│   │   └── ImageAnalysisResult.swift    # Vision analysis result
│   ├── Services/
│   │   └── AssessmentService.swift      # Image analysis & calculation
│   ├── Localization/
│   │   ├── es.lproj/                    # Spanish translations
│   │   └── en.lproj/                    # English translations
│   └── Assets.xcassets/                 # App assets
└── AntiqueAssessor.xcodeproj/           # Xcode project
```

## 🤝 Contributing / Contribuir

Contributions are welcome! / ¡Las contribuciones son bienvenidas!

### Español
1. Haz un fork del proyecto
2. Crea tu rama de característica (`git checkout -b feature/AmazingFeature`)
3. Haz commit de tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

### English
1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📋 Roadmap / Hoja de Ruta

- [x] Basic camera functionality
- [x] Vision framework image classification
- [x] Safari integration for manual browsing
- [x] User manual price entry
- [x] Condition and rarity assessment
- [x] Price estimation formula
- [x] Legal compliance (no scraping)
- [x] Bilingual support (Spanish/English)
- [x] Legal disclaimers and attribution
- [ ] Custom trained CoreML models for antiques
- [ ] Save assessment history locally
- [ ] Export assessment reports as PDF
- [ ] Multiple photos per item
- [ ] Category-specific condition questions
- [ ] Comparison mode for multiple items
- [ ] Enhanced image quality preprocessing

## 📄 License / Licencia

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

Este proyecto está licenciado bajo la Licencia MIT - consulta el archivo [LICENSE](LICENSE) para más detalles.

## 🙏 Acknowledgments / Agradecimientos

- [TodoColección.net](https://www.todocoleccion.net/) as a reference source for Spanish antiques market (user-browsed only)
- The iOS development community for excellent tools and frameworks
- Apple for Vision, CoreML, and SafariServices frameworks

**Important Legal Note**: This app does not scrape, automate, or extract data from todocoleccion.net. All browsing is done manually by the user through Safari. The app fully respects robots.txt and website policies.

**Nota Legal Importante**: Esta app no hace scraping, automatización ni extracción de datos de todocoleccion.net. Toda navegación es hecha manualmente por el usuario a través de Safari. La app respeta completamente robots.txt y las políticas del sitio web.

## 📚 Technical Documentation / Documentación Técnica

For detailed technical information, see:
- [LEGAL_COMPLIANCE.md](LEGAL_COMPLIANCE.md) - **IMPORTANT**: Legal architecture and compliance details
- [IMPLEMENTATION.md](IMPLEMENTATION.md) - Implementation status and technical details
- [BUILD.md](BUILD.md) - Build and setup instructions
- [API_INTEGRATION.md](API_INTEGRATION.md) - Integration examples and patterns
- [CONTRIBUTING.md](CONTRIBUTING.md) - Contribution guidelines

**Note**: The scraping implementation has been removed for legal compliance. See LEGAL_COMPLIANCE.md for the new human-in-the-loop architecture.

## 📧 Contact / Contacto

Project Link: [https://github.com/Pablo1990/antique-prices](https://github.com/Pablo1990/antique-prices)

---

Made with ❤️ for antique enthusiasts / Hecho con ❤️ para entusiastas de las antigüedades