# Build and Setup Guide / Guía de Compilación y Configuración

## Prerequisites / Requisitos Previos

### Required / Requerido
- macOS 13.0 (Ventura) or later
- Xcode 15.0 or later
- iOS 15.0+ device or simulator
- Apple Developer account (for device testing)

### Recommended / Recomendado
- Git for version control
- Command Line Tools for Xcode
- Familiarity with Swift and SwiftUI

## Installation Steps / Pasos de Instalación

### 1. Install Xcode / Instalar Xcode

**English:**
1. Open Mac App Store
2. Search for "Xcode"
3. Click "Get" or "Install"
4. Wait for download and installation (this may take a while, ~10GB)

**Español:**
1. Abre Mac App Store
2. Busca "Xcode"
3. Haz clic en "Obtener" o "Instalar"
4. Espera la descarga e instalación (puede tardar, ~10GB)

### 2. Install Command Line Tools / Instalar Herramientas de Línea de Comandos

```bash
xcode-select --install
```

### 3. Clone the Repository / Clonar el Repositorio

```bash
# Using HTTPS
git clone https://github.com/Pablo1990/antique-prices.git
cd antique-prices

# Using SSH
git clone git@github.com:Pablo1990/antique-prices.git
cd antique-prices
```

### 4. Open Project / Abrir Proyecto

```bash
open AntiqueAssessor/AntiqueAssessor.xcodeproj
```

Or / O:
- Double-click `AntiqueAssessor.xcodeproj` in Finder
- Open Xcode and select "Open a project or file"

## Building the App / Compilando la Aplicación

### Using Xcode GUI / Usando la Interfaz de Xcode

**English:**
1. Select target device from the top toolbar:
   - Choose a simulator (e.g., "iPhone 14 Pro")
   - Or connect a physical device
2. Click the "Run" button (▶️) or press `Cmd + R`
3. Wait for build to complete
4. App will launch on selected device/simulator

**Español:**
1. Selecciona el dispositivo objetivo desde la barra superior:
   - Elige un simulador (ej. "iPhone 14 Pro")
   - O conecta un dispositivo físico
2. Haz clic en el botón "Run" (▶️) o presiona `Cmd + R`
3. Espera a que se complete la compilación
4. La app se abrirá en el dispositivo/simulador seleccionado

### Using Command Line / Usando Línea de Comandos

```bash
# Build for simulator
xcodebuild -project AntiqueAssessor/AntiqueAssessor.xcodeproj \
           -scheme AntiqueAssessor \
           -destination 'platform=iOS Simulator,name=iPhone 14 Pro' \
           build

# Run on simulator
xcodebuild -project AntiqueAssessor/AntiqueAssessor.xcodeproj \
           -scheme AntiqueAssessor \
           -destination 'platform=iOS Simulator,name=iPhone 14 Pro' \
           test
```

## Testing on Physical Device / Probar en Dispositivo Físico

### Configure Code Signing / Configurar Firma de Código

**English:**
1. In Xcode, select the project in the navigator
2. Select "AntiqueAssessor" target
3. Go to "Signing & Capabilities" tab
4. Check "Automatically manage signing"
5. Select your Team from dropdown
6. Xcode will automatically create provisioning profile

**Español:**
1. En Xcode, selecciona el proyecto en el navegador
2. Selecciona el target "AntiqueAssessor"
3. Ve a la pestaña "Signing & Capabilities"
4. Marca "Automatically manage signing"
5. Selecciona tu Team del menú desplegable
6. Xcode creará automáticamente el perfil de aprovisionamiento

### Trust Developer Certificate / Confiar en Certificado de Desarrollador

**English:**
After installing on your device:
1. Go to Settings > General > VPN & Device Management
2. Find your developer profile
3. Tap "Trust [Your Name]"
4. Confirm trust

**Español:**
Después de instalar en tu dispositivo:
1. Ve a Ajustes > General > VPN y gestión de dispositivos
2. Encuentra tu perfil de desarrollador
3. Toca "Confiar en [Tu Nombre]"
4. Confirma la confianza

## Common Issues / Problemas Comunes

### Issue: "No Development Team Selected" / "No se Seleccionó Equipo de Desarrollo"

**Solution / Solución:**
1. Sign in to Xcode with Apple ID:
   - Xcode > Settings > Accounts > Add (+)
2. Create a free development team
3. Select team in project settings

### Issue: "Code Signing Error" / "Error de Firma de Código"

**Solution / Solución:**
1. Change bundle identifier to unique name:
   - Project settings > General > Bundle Identifier
   - Change `com.antiqueassessor.app` to `com.yourname.antiqueassessor`
2. Clean build folder: `Cmd + Shift + K`
3. Rebuild

### Issue: "Camera Not Working in Simulator" / "Cámara No Funciona en Simulador"

**Solution / Solución:**
- Camera doesn't work in iOS Simulator
- Use physical device for camera testing
- Or use photo library option (when implemented)

### Issue: Build Takes Too Long / La Compilación Tarda Mucho

**Solution / Solución:**
1. Quit and restart Xcode
2. Clean build folder: `Cmd + Shift + K`
3. Delete DerivedData:
   ```bash
   rm -rf ~/Library/Developer/Xcode/DerivedData
   ```
4. Restart computer if issues persist

## Project Structure / Estructura del Proyecto

```
antique-prices/
├── AntiqueAssessor/                    # Main project folder
│   ├── AntiqueAssessor.xcodeproj/      # Xcode project file
│   └── AntiqueAssessor/                # Source code
│       ├── AntiqueAssessorApp.swift    # App entry point
│       ├── ContentView.swift           # Main view
│       ├── CameraView.swift            # Camera interface
│       ├── ResultsView.swift           # Results display
│       ├── Models/                     # Data models
│       │   └── AntiqueItem.swift
│       ├── Services/                   # Business logic
│       │   └── AssessmentService.swift
│       ├── Localization/               # Translations
│       │   ├── es.lproj/              # Spanish
│       │   └── en.lproj/              # English
│       ├── Assets.xcassets/           # Images, colors
│       └── Info.plist                 # App configuration
├── README.md                           # Project overview
├── IMPLEMENTATION.md                   # Technical details
├── CONTRIBUTING.md                     # Contribution guide
├── BUILD.md                           # This file
└── LICENSE                            # MIT License
```

## Running Tests / Ejecutar Pruebas

```bash
# Run all tests
xcodebuild test -project AntiqueAssessor/AntiqueAssessor.xcodeproj \
                -scheme AntiqueAssessor \
                -destination 'platform=iOS Simulator,name=iPhone 14 Pro'
```

Note: Test suite needs to be implemented / Nota: Suite de pruebas necesita implementarse

## Building for Release / Compilar para Lanzamiento

### Archive Build / Compilación de Archivo

**English:**
1. In Xcode: Product > Archive
2. Wait for archive to complete
3. Click "Distribute App"
4. Choose distribution method:
   - App Store Connect
   - Ad Hoc
   - Development
   - Enterprise

**Español:**
1. En Xcode: Producto > Archivar
2. Espera a que se complete el archivo
3. Haz clic en "Distribuir App"
4. Elige método de distribución:
   - App Store Connect
   - Ad Hoc
   - Desarrollo
   - Empresa

## Debugging / Depuración

### Enable Debug Logging / Habilitar Registro de Depuración

Add breakpoints:
1. Click line number in Xcode
2. Blue arrow appears
3. Run app and execution will pause

### View Console Output / Ver Salida de Consola

- In Xcode: View > Debug Area > Activate Console
- Or press: `Cmd + Shift + C`

## Performance Optimization / Optimización de Rendimiento

### Build Settings / Configuración de Compilación

For faster builds during development:
1. Build Settings > Compilation Mode > "Incremental"
2. Build Settings > Optimization Level > "-Onone" (Debug)

For release builds:
1. Build Settings > Optimization Level > "-O" (Release)
2. Build Settings > Swift Compilation Mode > "Whole Module"

## Need Help? / ¿Necesitas Ayuda?

- Check [IMPLEMENTATION.md](IMPLEMENTATION.md) for technical details
- Read [CONTRIBUTING.md](../CONTRIBUTING.md) for contribution guidelines
- Open an issue on GitHub
- Join discussions on GitHub

## Resources / Recursos

- [Apple Developer Documentation](https://developer.apple.com/documentation/)
- [Swift.org](https://swift.org/documentation/)
- [SwiftUI Tutorials](https://developer.apple.com/tutorials/swiftui)
- [iOS App Dev Tutorials](https://developer.apple.com/tutorials/app-dev-training)

---

Happy Building! / ¡Feliz Construcción! 🎉
