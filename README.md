# Tasador de Antigüedades / Antique Assessor

Una aplicación iOS completamente gratuita y de código abierto para evaluar fielmente antigüedades que se pueden encontrar en los mercados españoles.

A completely free, open-source iOS app to faithfully assess antiques that can be found in Spanish markets.

## 🌟 Features / Características

### Español
- 📸 **Captura de Fotos**: Toma fotos de antigüedades directamente desde la aplicación
- 💰 **Valoración de Precios**: Estima precios basándose en datos reales de todocoleccion.net mediante web scraping
- 🔍 **Detección de Falsificaciones**: Determina si un artículo es auténtico o falso con porcentaje de precisión
- 🕰️ **Identificación de Época**: Identifica el período histórico del artículo con porcentaje de confianza
- 🤖 **Reconocimiento de Imágenes**: Usa Vision framework de Apple para clasificar automáticamente antigüedades
- 🔗 **Artículos Similares**: Encuentra artículos similares reales en todocoleccion.net con precios actuales
- 🌐 **Bilingüe**: Soporte completo en Español e Inglés
- 🆓 **100% Gratuito**: Sin compras dentro de la aplicación, sin suscripciones
- 🔓 **Código Abierto**: Todo el código es abierto y auditable

### English
- 📸 **Photo Capture**: Take photos of antiques directly from the app
- 💰 **Price Valuation**: Estimates prices based on real data from todocoleccion.net via web scraping
- 🔍 **Fake Detection**: Determines if an item is authentic or fake with accuracy percentage
- 🕰️ **Period Identification**: Identifies the historical period of the item with confidence percentage
- 🤖 **Image Recognition**: Uses Apple's Vision framework to automatically classify antiques
- 🔗 **Similar Items**: Find real similar items on todocoleccion.net with current prices
- 🌐 **Bilingual**: Full support in Spanish and English
- 🆓 **100% Free**: No in-app purchases, no subscriptions
- 🔓 **Open Source**: All code is open and auditable

## 🔗 Trusted Sources / Fuentes Confiables

- [TodoColección.net](https://www.todocoleccion.net/) - Principal fuente de datos de precios de mercado español / Main source for Spanish market price data

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
2. **Evalúa**: Presiona el botón "Evaluar Antigüedad" para iniciar el análisis
3. **Revisa Resultados**: Obtén información detallada sobre:
   - Precio estimado y rango de precios
   - Autenticidad con porcentaje de confianza
   - Período histórico con porcentaje de precisión
   - Artículos similares en todocoleccion.net

### English
1. **Take a Photo**: Use the built-in camera to capture an image of your antique
2. **Assess**: Press the "Assess Antique" button to start the analysis
3. **Review Results**: Get detailed information about:
   - Estimated price and price range
   - Authenticity with confidence percentage
   - Historical period with accuracy percentage
   - Similar items on todocoleccion.net

## 🏗️ Architecture / Arquitectura

The app is built using:
- **SwiftUI**: Modern declarative UI framework
- **Vision Framework**: For image recognition and classification (VNClassifyImageRequest)
- **CoreML**: For machine learning models (authenticity and period detection)
- **URLSession**: For web scraping todocoleccion.net (native HTTP requests)
- **Pure Swift**: No external dependencies, only native iOS frameworks

### Project Structure / Estructura del Proyecto

```
AntiqueAssessor/
├── AntiqueAssessor/
│   ├── AntiqueAssessorApp.swift          # App entry point
│   ├── ContentView.swift                 # Main view
│   ├── CameraView.swift                  # Camera interface
│   ├── ResultsView.swift                 # Results display
│   ├── Models/
│   │   └── AntiqueItem.swift            # Data models
│   ├── Services/
│   │   ├── AssessmentService.swift      # Core assessment logic
│   │   └── TodoColeccionScraper.swift   # Web scraping service
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
- [x] Real web scraping of todocoleccion.net
- [x] Vision framework image classification
- [x] Price estimation from real market data
- [x] Similar items with actual URLs and prices
- [x] Authenticity detection with ML
- [x] Period identification
- [x] Bilingual support (Spanish/English)
- [ ] Custom trained CoreML models for antiques
- [ ] Improved accuracy for authenticity detection
- [ ] Offline mode with cached data
- [ ] User history and favorites
- [ ] Export assessment reports
- [ ] Additional market sources integration

## 📄 License / Licencia

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

Este proyecto está licenciado bajo la Licencia MIT - consulta el archivo [LICENSE](LICENSE) para más detalles.

## 🙏 Acknowledgments / Agradecimientos

- [TodoColección.net](https://www.todocoleccion.net/) for being a trusted source of Spanish antiques market data
- The iOS development community for excellent tools and frameworks

## 📚 Technical Documentation / Documentación Técnica

For detailed technical information, see:
- [IMPLEMENTATION.md](IMPLEMENTATION.md) - Implementation status and technical details
- [SCRAPING_IMPLEMENTATION.md](SCRAPING_IMPLEMENTATION.md) - Web scraping implementation guide
- [BUILD.md](BUILD.md) - Build and setup instructions
- [API_INTEGRATION.md](API_INTEGRATION.md) - Integration examples and patterns
- [CONTRIBUTING.md](CONTRIBUTING.md) - Contribution guidelines

## 📧 Contact / Contacto

Project Link: [https://github.com/Pablo1990/antique-prices](https://github.com/Pablo1990/antique-prices)

---

Made with ❤️ for antique enthusiasts / Hecho con ❤️ para entusiastas de las antigüedades