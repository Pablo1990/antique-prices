# iOS App Store Publishing Guide / Guía de Publicación en App Store

## Tabla de Contenidos / Table of Contents

1. [Local Testing / Pruebas Locales](#local-testing--pruebas-locales)
2. [Prepare for Publishing / Preparar para Publicación](#prepare-for-publishing--preparar-para-publicación)
3. [App Store Connect Setup / Configuración de App Store Connect](#app-store-connect-setup--configuración-de-app-store-connect)
4. [Code Signing & Provisioning / Firma de Código y Aprovisionamiento](#code-signing--provisioning--firma-de-código-y-aprovisionamiento)
5. [App Metadata / Metadatos de la App](#app-metadata--metadatos-de-la-app)
6. [Privacy Policy & Terms / Política de Privacidad y Términos](#privacy-policy--terms--política-de-privacidad-y-términos)
7. [TestFlight Beta Testing / Pruebas Beta con TestFlight](#testflight-beta-testing--pruebas-beta-con-testflight)
8. [Final Submission / Envío Final](#final-submission--envío-final)
9. [Review Process / Proceso de Revisión](#review-process--proceso-de-revisión)
10. [Post-Launch / Después del Lanzamiento](#post-launch--después-del-lanzamiento)
11. [Common Rejection Reasons / Razones Comunes de Rechazo](#common-rejection-reasons--razones-comunes-de-rechazo)

---

## Local Testing / Pruebas Locales

### Testing on iOS Simulator / Pruebas en Simulador iOS

**English:**

1. **Open the project in Xcode:**
   ```bash
   cd antique-prices
   open AntiqueAssessor/AntiqueAssessor.xcodeproj
   ```

2. **Select a simulator device:**
   - In Xcode toolbar, click the device dropdown
   - Choose from available simulators:
     - iPhone SE (3rd generation) - Small screen testing
     - iPhone 14 - Standard size
     - iPhone 14 Pro Max - Large screen
     - iPad Pro (12.9-inch) - Tablet layout

3. **Build and run:**
   - Press `Cmd + R` or click the Play button (▶️)
   - Wait for build to complete
   - App will launch in simulator

4. **Test key features:**
   - ✅ App launches without crashes
   - ✅ UI layout looks good on different screen sizes
   - ✅ Language switching (change simulator language in Settings)
   - ✅ All buttons and navigation work
   - ⚠️ Camera will NOT work (simulator limitation)

**Español:**

1. **Abre el proyecto en Xcode:**
   ```bash
   cd antique-prices
   open AntiqueAssessor/AntiqueAssessor.xcodeproj
   ```

2. **Selecciona un dispositivo simulador:**
   - En la barra de herramientas de Xcode, haz clic en el menú desplegable del dispositivo
   - Elige entre los simuladores disponibles:
     - iPhone SE (3ª generación) - Prueba de pantalla pequeña
     - iPhone 14 - Tamaño estándar
     - iPhone 14 Pro Max - Pantalla grande
     - iPad Pro (12.9 pulgadas) - Diseño para tablet

3. **Compila y ejecuta:**
   - Presiona `Cmd + R` o haz clic en el botón Play (▶️)
   - Espera a que se complete la compilación
   - La app se abrirá en el simulador

4. **Prueba funciones clave:**
   - ✅ La app se abre sin fallos
   - ✅ El diseño de UI se ve bien en diferentes tamaños de pantalla
   - ✅ Cambio de idioma (cambia el idioma del simulador en Ajustes)
   - ✅ Todos los botones y navegación funcionan
   - ⚠️ La cámara NO funcionará (limitación del simulador)

### Testing on Physical Device / Pruebas en Dispositivo Físico

**English:**

1. **Connect your iPhone/iPad:**
   - Use USB cable to connect device to Mac
   - Unlock device and trust computer if prompted
   - Device should appear in Xcode's device list

2. **Configure code signing:**
   - In Xcode, select project in navigator
   - Select "AntiqueAssessor" target
   - Go to "Signing & Capabilities" tab
   - Check ✅ "Automatically manage signing"
   - Select your Apple ID team from dropdown
   - Change Bundle Identifier if needed: `com.yourname.antiqueassessor`

3. **Build and install:**
   - Select your physical device from device dropdown
   - Press `Cmd + R` to build and run
   - First time: May need to trust developer certificate on device
     - Go to Settings > General > VPN & Device Management
     - Tap on your developer profile
     - Tap "Trust [Your Name]"
     - Confirm trust

4. **Test all features:**
   - ✅ Camera access permission request appears
   - ✅ Camera captures photos correctly
   - ✅ Image analysis and assessment works
   - ✅ Results display properly
   - ✅ App performs well (no lag or crashes)
   - ✅ Test in both Spanish and English

**Español:**

1. **Conecta tu iPhone/iPad:**
   - Usa un cable USB para conectar el dispositivo a tu Mac
   - Desbloquea el dispositivo y confía en el ordenador si se solicita
   - El dispositivo debería aparecer en la lista de dispositivos de Xcode

2. **Configura la firma de código:**
   - En Xcode, selecciona el proyecto en el navegador
   - Selecciona el target "AntiqueAssessor"
   - Ve a la pestaña "Signing & Capabilities"
   - Marca ✅ "Automatically manage signing"
   - Selecciona tu equipo de Apple ID del menú desplegable
   - Cambia el Bundle Identifier si es necesario: `com.tunombre.antiqueassessor`

3. **Compila e instala:**
   - Selecciona tu dispositivo físico del menú desplegable de dispositivos
   - Presiona `Cmd + R` para compilar y ejecutar
   - Primera vez: Puede que necesites confiar en el certificado de desarrollador en el dispositivo
     - Ve a Ajustes > General > VPN y gestión de dispositivos
     - Toca en tu perfil de desarrollador
     - Toca "Confiar en [Tu Nombre]"
     - Confirma la confianza

4. **Prueba todas las funciones:**
   - ✅ Aparece la solicitud de permiso de acceso a la cámara
   - ✅ La cámara captura fotos correctamente
   - ✅ El análisis y evaluación de imágenes funciona
   - ✅ Los resultados se muestran correctamente
   - ✅ La app funciona bien (sin retrasos ni fallos)
   - ✅ Prueba en español e inglés

### Testing Different iOS Versions / Probar Diferentes Versiones de iOS

**English:**
- Test on iOS 15.0 (minimum supported version)
- Test on latest iOS version
- Test on iOS 16 and iOS 17 if possible
- Use Xcode simulator to test different versions

**Español:**
- Prueba en iOS 15.0 (versión mínima compatible)
- Prueba en la última versión de iOS
- Prueba en iOS 16 e iOS 17 si es posible
- Usa el simulador de Xcode para probar diferentes versiones

---

## Prepare for Publishing / Preparar para Publicación

### Prerequisites / Requisitos Previos

**English:**

Before you can publish to the App Store, you need:

1. ✅ **Apple Developer Account** ($99/year)
   - Sign up at: https://developer.apple.com/programs/
   - Complete enrollment process (may take 1-2 days for approval)
   - Verify payment information

2. ✅ **Valid App Icon** (all required sizes)
   - 1024x1024 pixels (App Store)
   - Various sizes for device (handled by Assets.xcassets)
   - No transparency or rounded corners on master image

3. ✅ **App Screenshots** (required for each device size)
   - iPhone 6.7" display (iPhone 14 Pro Max)
   - iPhone 6.5" display (iPhone 11 Pro Max, XS Max)
   - iPhone 5.5" display (iPhone 8 Plus)
   - iPad Pro (12.9-inch) (if supporting iPad)
   - Minimum 3 screenshots, maximum 10 per device type

4. ✅ **Privacy Policy** (required for apps using camera/data)
   - Must be hosted on publicly accessible URL
   - Must explain data collection and usage
   - Must be in English and Spanish

5. ✅ **App Description** (bilingual)
   - Marketing description (up to 4000 characters)
   - Keywords (up to 100 characters)
   - Promotional text (up to 170 characters)

**Español:**

Antes de poder publicar en el App Store, necesitas:

1. ✅ **Cuenta de Desarrollador de Apple** ($99/año)
   - Regístrate en: https://developer.apple.com/programs/
   - Completa el proceso de inscripción (puede tardar 1-2 días en ser aprobado)
   - Verifica la información de pago

2. ✅ **Icono de App Válido** (todos los tamaños requeridos)
   - 1024x1024 píxeles (App Store)
   - Varios tamaños para dispositivo (manejados por Assets.xcassets)
   - Sin transparencia ni esquinas redondeadas en la imagen maestra

3. ✅ **Capturas de Pantalla de la App** (requeridas para cada tamaño de dispositivo)
   - Pantalla de iPhone 6.7" (iPhone 14 Pro Max)
   - Pantalla de iPhone 6.5" (iPhone 11 Pro Max, XS Max)
   - Pantalla de iPhone 5.5" (iPhone 8 Plus)
   - iPad Pro (12.9 pulgadas) (si soporta iPad)
   - Mínimo 3 capturas de pantalla, máximo 10 por tipo de dispositivo

4. ✅ **Política de Privacidad** (requerida para apps que usan cámara/datos)
   - Debe estar alojada en una URL públicamente accesible
   - Debe explicar la recopilación y uso de datos
   - Debe estar en inglés y español

5. ✅ **Descripción de la App** (bilingüe)
   - Descripción de marketing (hasta 4000 caracteres)
   - Palabras clave (hasta 100 caracteres)
   - Texto promocional (hasta 170 caracteres)

### Update Version and Build Numbers / Actualizar Números de Versión y Build

**English:**

1. Open project in Xcode
2. Select project in navigator
3. Select "AntiqueAssessor" target
4. Go to "General" tab
5. Update version numbers:
   - **Version**: e.g., `1.0.0` (MARKETING_VERSION)
   - **Build**: e.g., `1` (CURRENT_PROJECT_VERSION)

For subsequent releases:
- Increment **Version** for new features: `1.1.0`
- Increment **Build** for bug fixes: same version, build `2`

**Español:**

1. Abre el proyecto en Xcode
2. Selecciona el proyecto en el navegador
3. Selecciona el target "AntiqueAssessor"
4. Ve a la pestaña "General"
5. Actualiza los números de versión:
   - **Version**: ej., `1.0.0` (MARKETING_VERSION)
   - **Build**: ej., `1` (CURRENT_PROJECT_VERSION)

Para lanzamientos posteriores:
- Incrementa **Version** para nuevas funciones: `1.1.0`
- Incrementa **Build** para correcciones de errores: misma versión, build `2`

---

## App Store Connect Setup / Configuración de App Store Connect

**English:**

1. **Log in to App Store Connect:**
   - Go to: https://appstoreconnect.apple.com
   - Sign in with your Apple Developer account

2. **Create a new app:**
   - Click "My Apps"
   - Click the "+" button
   - Select "New App"

3. **Fill in app information:**
   - **Platforms**: iOS
   - **Name**: Tasador de Antigüedades (or your preferred name)
   - **Primary Language**: Spanish (Spain)
   - **Bundle ID**: Select the one you configured in Xcode
     - Should match: `com.yourcompany.antiqueassessor`
   - **SKU**: Unique identifier (e.g., `antiqueassessor001`)
   - **User Access**: Full Access (recommended for first app)

4. **Save and continue**

**Español:**

1. **Inicia sesión en App Store Connect:**
   - Ve a: https://appstoreconnect.apple.com
   - Inicia sesión con tu cuenta de Apple Developer

2. **Crea una nueva app:**
   - Haz clic en "Mis Apps"
   - Haz clic en el botón "+"
   - Selecciona "Nueva App"

3. **Completa la información de la app:**
   - **Plataformas**: iOS
   - **Nombre**: Tasador de Antigüedades (o tu nombre preferido)
   - **Idioma Principal**: Español (España)
   - **Bundle ID**: Selecciona el que configuraste en Xcode
     - Debe coincidir con: `com.tucompañia.antiqueassessor`
   - **SKU**: Identificador único (ej., `antiqueassessor001`)
   - **Acceso de Usuario**: Acceso Completo (recomendado para primera app)

4. **Guarda y continúa**

---

## Code Signing & Provisioning / Firma de Código y Aprovisionamiento

### Automatic Code Signing (Recommended) / Firma Automática de Código (Recomendado)

**English:**

1. **In Xcode project settings:**
   - Select "AntiqueAssessor" target
   - Go to "Signing & Capabilities" tab
   - Check ✅ "Automatically manage signing"
   - Select your Team from dropdown
   - Xcode will automatically:
     - Create App ID
     - Create provisioning profiles
     - Download certificates

2. **Verify signing configuration:**
   - ✅ Status shows: "Team: [Your Name]"
   - ✅ Provisioning Profile: "Xcode Managed Profile"
   - ✅ Signing Certificate: "Apple Development" or "Apple Distribution"

**Español:**

1. **En la configuración del proyecto de Xcode:**
   - Selecciona el target "AntiqueAssessor"
   - Ve a la pestaña "Signing & Capabilities"
   - Marca ✅ "Automatically manage signing"
   - Selecciona tu Team del menú desplegable
   - Xcode automáticamente:
     - Creará el App ID
     - Creará perfiles de aprovisionamiento
     - Descargará certificados

2. **Verifica la configuración de firma:**
   - ✅ El estado muestra: "Team: [Tu Nombre]"
   - ✅ Provisioning Profile: "Xcode Managed Profile"
   - ✅ Signing Certificate: "Apple Development" o "Apple Distribution"

### Manual Code Signing (Advanced) / Firma Manual de Código (Avanzado)

**English:**

If you need manual control:

1. **Create App ID:**
   - Go to: https://developer.apple.com/account/resources/identifiers
   - Click "+" to add new identifier
   - Select "App IDs" > "App"
   - Description: "Antique Assessor"
   - Bundle ID: Explicit - `com.yourcompany.antiqueassessor`
   - Capabilities: Enable "Camera"
   - Save

2. **Create Provisioning Profile:**
   - Go to: https://developer.apple.com/account/resources/profiles
   - Click "+" to add new profile
   - Select "App Store" distribution
   - Select your App ID
   - Select your distribution certificate
   - Name it: "Antique Assessor Distribution"
   - Download and double-click to install

3. **Configure in Xcode:**
   - Uncheck "Automatically manage signing"
   - Import downloaded provisioning profile
   - Select it for Release configuration

**Español:**

Si necesitas control manual:

1. **Crea el App ID:**
   - Ve a: https://developer.apple.com/account/resources/identifiers
   - Haz clic en "+" para añadir un nuevo identificador
   - Selecciona "App IDs" > "App"
   - Descripción: "Antique Assessor"
   - Bundle ID: Explícito - `com.tucompañia.antiqueassessor`
   - Capacidades: Habilita "Camera"
   - Guarda

2. **Crea el Perfil de Aprovisionamiento:**
   - Ve a: https://developer.apple.com/account/resources/profiles
   - Haz clic en "+" para añadir un nuevo perfil
   - Selecciona distribución "App Store"
   - Selecciona tu App ID
   - Selecciona tu certificado de distribución
   - Nómbralo: "Antique Assessor Distribution"
   - Descarga y haz doble clic para instalar

3. **Configura en Xcode:**
   - Desmarca "Automatically manage signing"
   - Importa el perfil de aprovisionamiento descargado
   - Selecciónalo para la configuración Release


---

## App Metadata / Metadatos de la App

### Prepare App Information / Preparar Información de la App

**English:**

In App Store Connect, fill in the following sections:

#### 1. App Information

- **Name**: Tasador de Antigüedades (up to 30 characters)
- **Subtitle**: Evalúa antigüedades con IA (up to 30 characters)
- **Primary Language**: Spanish (Spain)
- **Category**:
  - Primary: Shopping
  - Secondary: Reference
- **Content Rights**: Contains third-party content (todocoleccion.net data)

#### 2. Pricing and Availability

- **Price**: Free
- **Availability**: All countries (or select specific ones)
- **Pre-Order**: No (for first release)

#### 3. App Privacy

**Required privacy information:**

- ✅ **Camera**: Yes (explain usage for capturing antique photos)
- ✅ **Photos**: Yes (explain usage for accessing photo library)
- ❌ **Location**: No
- ❌ **Contacts**: No
- ❌ **User Tracking**: No
- ❌ **Health Data**: No
- ❌ **Financial Data**: No

**Data Collection:**
- Link to your privacy policy URL
- Specify what data is collected (if any)
- Explain how data is used
- State if data is shared with third parties

#### 4. Age Rating

Answer questionnaire honestly:
- Likely rating: 4+ (for general audiences)
- No mature content
- No gambling
- No violence

#### 5. App Review Information

**Contact Information:**
- First Name: [Your Name]
- Last Name: [Your Last Name]
- Phone: [Your Phone]
- Email: [Your Email]

**Review Notes:**
```
This app helps users assess antiques found in Spanish markets using camera and AI analysis.

Testing Instructions:
1. Grant camera permission when prompted
2. Take a photo of any object (antique not required for testing)
3. Tap "Evaluar Antigüedad" button
4. View assessment results

Note: The app currently uses demonstration data for price estimates and authenticity checks.
```

**Demo Account:** Not required (app doesn't need login)

**Español:**

En App Store Connect, completa las siguientes secciones:

#### 1. Información de la App

- **Nombre**: Tasador de Antigüedades (hasta 30 caracteres)
- **Subtítulo**: Evalúa antigüedades con IA (hasta 30 caracteres)
- **Idioma Principal**: Español (España)
- **Categoría**:
  - Principal: Compras
  - Secundaria: Referencia
- **Derechos de Contenido**: Contiene contenido de terceros (datos de todocoleccion.net)

#### 2. Precio y Disponibilidad

- **Precio**: Gratis
- **Disponibilidad**: Todos los países (o selecciona específicos)
- **Pre-pedido**: No (para primer lanzamiento)

#### 3. Privacidad de la App

**Información de privacidad requerida:**

- ✅ **Cámara**: Sí (explica el uso para capturar fotos de antigüedades)
- ✅ **Fotos**: Sí (explica el uso para acceder a la biblioteca de fotos)
- ❌ **Ubicación**: No
- ❌ **Contactos**: No
- ❌ **Seguimiento de Usuario**: No
- ❌ **Datos de Salud**: No
- ❌ **Datos Financieros**: No

**Recopilación de Datos:**
- Enlace a tu URL de política de privacidad
- Especifica qué datos se recopilan (si hay alguno)
- Explica cómo se usan los datos
- Indica si los datos se comparten con terceros

#### 4. Clasificación por Edad

Responde el cuestionario honestamente:
- Clasificación probable: 4+ (para audiencias generales)
- Sin contenido para adultos
- Sin apuestas
- Sin violencia

#### 5. Información de Revisión de la App

**Información de Contacto:**
- Nombre: [Tu Nombre]
- Apellido: [Tu Apellido]
- Teléfono: [Tu Teléfono]
- Email: [Tu Email]

**Notas de Revisión:**
```
Esta app ayuda a los usuarios a evaluar antigüedades encontradas en mercados españoles usando la cámara y análisis con IA.

Instrucciones de Prueba:
1. Concede permiso de cámara cuando se solicite
2. Toma una foto de cualquier objeto (no se requiere antigüedad para pruebas)
3. Toca el botón "Evaluar Antigüedad"
4. Ve los resultados de la evaluación

Nota: La app actualmente usa datos de demostración para estimaciones de precios y verificaciones de autenticidad.
```

**Cuenta de Demostración:** No requerida (la app no necesita inicio de sesión)

### Create Marketing Materials / Crear Materiales de Marketing

**English:**

#### App Description (Spanish)

```
Tasador de Antigüedades - Tu Experto Personal en Antigüedades

¿Encontraste una antigüedad en un mercadillo? ¿Te preguntas cuánto vale o si es auténtica? Tasador de Antigüedades es tu compañero perfecto para evaluar antigüedades españolas.

CARACTERÍSTICAS PRINCIPALES:

📸 Evaluación Instantánea
• Toma una foto de cualquier antigüedad
• Análisis automático con inteligencia artificial
• Resultados en segundos

💰 Valoración de Precios
• Estimación basada en el mercado español
• Datos de todocoleccion.net
• Rango de precios mínimo y máximo

🔍 Detección de Autenticidad
• Determina si es auténtico o falso
• Porcentaje de confianza
• Análisis con aprendizaje automático

🕰️ Identificación de Época
• Identifica el período histórico
• Precisión basada en características visuales
• Referencia a estilos conocidos

🌐 100% Bilingüe
• Interfaz en español e inglés
• Cambia según tu configuración del sistema

🆓 Completamente Gratis
• Sin compras dentro de la app
• Sin suscripciones
• Sin anuncios
• Código abierto

IDEAL PARA:
• Coleccionistas de antigüedades
• Compradores de mercadillos
• Vendedores de artículos vintage
• Entusiastas de la historia
• Cazadores de tesoros

FUENTES CONFIABLES:
Utilizamos datos del reconocido mercado español todocoleccion.net para proporcionarte estimaciones precisas.

PRIVACIDAD:
• No recopilamos datos personales
• No compartimos tus fotos
• Todo el procesamiento es local cuando es posible
• Código abierto y auditable

¡Descarga Tasador de Antigüedades hoy y conviértete en un experto en antigüedades españolas!
```

#### App Description (English)

```
Antique Assessor - Your Personal Antique Expert

Found an antique at a flea market? Wondering how much it's worth or if it's authentic? Antique Assessor is your perfect companion for evaluating Spanish antiques.

KEY FEATURES:

📸 Instant Assessment
• Take a photo of any antique
• Automatic AI analysis
• Results in seconds

💰 Price Valuation
• Estimation based on Spanish market
• Data from todocoleccion.net
• Minimum and maximum price range

🔍 Authenticity Detection
• Determines if authentic or fake
• Confidence percentage
• Machine learning analysis

🕰️ Period Identification
• Identifies historical period
• Accuracy based on visual features
• Reference to known styles

🌐 100% Bilingual
• Interface in Spanish and English
• Changes according to your system settings

🆓 Completely Free
• No in-app purchases
• No subscriptions
• No ads
• Open source

PERFECT FOR:
• Antique collectors
• Flea market shoppers
• Vintage item sellers
• History enthusiasts
• Treasure hunters

TRUSTED SOURCES:
We use data from the renowned Spanish marketplace todocoleccion.net to provide you with accurate estimates.

PRIVACY:
• We don't collect personal data
• We don't share your photos
• All processing is local when possible
• Open source and auditable

Download Antique Assessor today and become an expert in Spanish antiques!
```

#### Keywords (100 characters max)

```
antigüedades,valoración,tasador,mercadillo,coleccionismo,vintage,autenticidad,precio,español
```

English alternative:
```
antiques,valuation,assessor,flea market,collectibles,vintage,authenticity,price,spanish
```

#### Promotional Text (170 characters max)

Spanish:
```
¡Descubre el valor real de tus antigüedades! Toma una foto y obtén valoración instantánea con IA. Gratis y sin anuncios. ¡Perfecto para mercadillos españoles!
```

English:
```
Discover the real value of your antiques! Take a photo and get instant AI valuation. Free and ad-free. Perfect for Spanish flea markets!
```

**Español:**

[See the Spanish descriptions above in the English section]

### Create Screenshots / Crear Capturas de Pantalla

**English:**

You need screenshots for each device size:

1. **Take screenshots in simulator:**
   ```bash
   # Run app on specific simulator
   # For iPhone 14 Pro Max (6.7")
   xcrun simctl boot "iPhone 14 Pro Max"
   # Take screenshot: Cmd + S in Simulator
   ```

2. **Screenshot requirements:**
   - PNG or JPEG format
   - RGB color space
   - No transparency
   - Portrait orientation preferred

3. **Recommended screenshots:**
   - Screenshot 1: Main screen with camera button
   - Screenshot 2: Camera view (or placeholder)
   - Screenshot 3: Assessment results with price
   - Screenshot 4: Authenticity and period info
   - Screenshot 5: Similar items list

4. **Add text overlays (optional but recommended):**
   - Use design tool (Figma, Sketch, Canva)
   - Add descriptive text in Spanish
   - Highlight key features
   - Keep consistent design across all screenshots

**Español:**

Necesitas capturas de pantalla para cada tamaño de dispositivo:

1. **Toma capturas de pantalla en el simulador:**
   ```bash
   # Ejecuta la app en un simulador específico
   # Para iPhone 14 Pro Max (6.7")
   xcrun simctl boot "iPhone 14 Pro Max"
   # Toma captura de pantalla: Cmd + S en el Simulador
   ```

2. **Requisitos de las capturas de pantalla:**
   - Formato PNG o JPEG
   - Espacio de color RGB
   - Sin transparencia
   - Orientación vertical preferida

3. **Capturas de pantalla recomendadas:**
   - Captura 1: Pantalla principal con botón de cámara
   - Captura 2: Vista de cámara (o marcador de posición)
   - Captura 3: Resultados de evaluación con precio
   - Captura 4: Información de autenticidad y época
   - Captura 5: Lista de artículos similares

4. **Añadir superposiciones de texto (opcional pero recomendado):**
   - Usa una herramienta de diseño (Figma, Sketch, Canva)
   - Añade texto descriptivo en español
   - Resalta funciones clave
   - Mantén un diseño consistente en todas las capturas de pantalla


---

## Privacy Policy & Terms / Política de Privacidad y Términos

### Create Privacy Policy / Crear Política de Privacidad

**English:**

Apple requires a privacy policy for apps that access camera or collect data.

**Option 1: Use Privacy Policy Generator**
- https://www.privacypolicygenerator.info/
- https://app-privacy-policy-generator.firebaseapp.com/

**Option 2: Create Manual Privacy Policy**

Here's a template:

```markdown
# Privacy Policy for Tasador de Antigüedades / Antique Assessor

Last updated: [DATE]

## Introduction

Tasador de Antigüedades ("we", "our", or "the app") respects your privacy and is committed to protecting your personal data.

## Data We Collect

### Camera Access
- The app requests camera access to capture photos of antiques
- Photos are processed locally on your device
- Photos are NOT uploaded to our servers
- Photos are NOT stored permanently unless you choose to save them

### Photo Library Access
- The app may request access to your photo library (future feature)
- Only used to select photos for assessment
- We do not access or scan your entire photo library

### Usage Data
- The app does NOT collect analytics or usage data
- We do NOT track your location
- We do NOT collect personal information

## Third-Party Services

### TodoColección.net
- The app references data from todocoleccion.net for price estimates
- When searching for similar items, image data may be sent to their servers
- Please review their privacy policy: [todocoleccion.net privacy policy URL]

## Data Storage

- All processing is done locally on your device when possible
- No personal data is stored on our servers
- No user accounts or login required

## Your Rights

You have the right to:
- Revoke camera permissions at any time (Settings > Privacy > Camera)
- Delete the app and all its data

## Changes to Privacy Policy

We may update this policy occasionally. Check this page for updates.

## Contact

For privacy questions, contact: [YOUR EMAIL]

---

# Política de Privacidad para Tasador de Antigüedades

Última actualización: [FECHA]

## Introducción

Tasador de Antigüedades ("nosotros", "nuestro" o "la app") respeta tu privacidad y se compromete a proteger tus datos personales.

## Datos que Recopilamos

### Acceso a la Cámara
- La app solicita acceso a la cámara para capturar fotos de antigüedades
- Las fotos se procesan localmente en tu dispositivo
- Las fotos NO se suben a nuestros servidores
- Las fotos NO se almacenan permanentemente a menos que elijas guardarlas

### Acceso a la Biblioteca de Fotos
- La app puede solicitar acceso a tu biblioteca de fotos (función futura)
- Solo se usa para seleccionar fotos para evaluación
- No accedemos ni escaneamos toda tu biblioteca de fotos

### Datos de Uso
- La app NO recopila análisis ni datos de uso
- NO rastreamos tu ubicación
- NO recopilamos información personal

## Servicios de Terceros

### TodoColección.net
- La app hace referencia a datos de todocoleccion.net para estimaciones de precios
- Al buscar artículos similares, los datos de imagen pueden enviarse a sus servidores
- Por favor, revisa su política de privacidad: [URL de política de privacidad de todocoleccion.net]

## Almacenamiento de Datos

- Todo el procesamiento se realiza localmente en tu dispositivo cuando es posible
- No se almacenan datos personales en nuestros servidores
- No se requieren cuentas de usuario ni inicio de sesión

## Tus Derechos

Tienes derecho a:
- Revocar permisos de cámara en cualquier momento (Ajustes > Privacidad > Cámara)
- Eliminar la app y todos sus datos

## Cambios en la Política de Privacidad

Podemos actualizar esta política ocasionalmente. Consulta esta página para actualizaciones.

## Contacto

Para preguntas sobre privacidad, contacta: [TU EMAIL]
```

**Where to Host:**
- GitHub Pages (free)
- Personal website
- Google Sites (free)
- Any publicly accessible URL

**Español:**

Apple requiere una política de privacidad para apps que acceden a la cámara o recopilan datos.

[See the English section above for the template and instructions]

### Terms of Service (Optional) / Términos de Servicio (Opcional)

**English:**

While not required by Apple, Terms of Service can protect you legally.

Simple template:

```markdown
# Terms of Service

1. **Acceptance**: By using this app, you agree to these terms
2. **Use**: This app is for personal, non-commercial use
3. **Accuracy**: Price estimates are for reference only, not guarantees
4. **Liability**: We are not responsible for purchasing decisions
5. **Open Source**: This app is open source under MIT License
6. **Changes**: We may update these terms at any time

For questions: [YOUR EMAIL]
```

**Español:**

[Similar structure in Spanish]

---

## TestFlight Beta Testing / Pruebas Beta con TestFlight

**English:**

TestFlight allows you to test your app with real users before public release.

### Step 1: Upload Build to TestFlight

1. **Create archive in Xcode:**
   - Select "Any iOS Device (arm64)" as destination
   - Product > Archive
   - Wait for archive to complete
   - Xcode Organizer window opens

2. **Distribute app:**
   - Click "Distribute App"
   - Select "App Store Connect"
   - Select "Upload"
   - Choose distribution options:
     - ✅ Include bitcode: Yes (if supported)
     - ✅ Upload symbols: Yes (for crash reports)
     - ✅ Manage version and build: Automatically
   - Click "Upload"
   - Wait for upload to complete (may take 10-20 minutes)

3. **Wait for processing:**
   - Go to App Store Connect > TestFlight
   - Your build will show "Processing" status
   - Wait 10-30 minutes for Apple to process
   - You'll receive email when ready for testing

### Step 2: Add Internal Testers

1. **In App Store Connect:**
   - Go to "TestFlight" tab
   - Click on your build
   - Add internal testers (your team members)
   - Up to 100 internal testers allowed

2. **Testers install:**
   - Testers receive email invitation
   - Download TestFlight app from App Store
   - Accept invitation
   - Install your app through TestFlight

### Step 3: Add External Testers (Optional)

1. **Create external test group:**
   - TestFlight > External Testing
   - Create new group: "Beta Testers"
   - Add testers by email

2. **Submit for Beta App Review:**
   - Provide test information
   - Submit for review (1-2 days)
   - Once approved, external testers can install

3. **Collect feedback:**
   - Testers can send feedback through TestFlight
   - Review crash reports in Xcode Organizer

### Step 4: Iterate Based on Feedback

1. Fix bugs found by testers
2. Create new build with incremented build number
3. Upload new build to TestFlight
4. Notify testers of updates

**Español:**

TestFlight te permite probar tu app con usuarios reales antes del lanzamiento público.

### Paso 1: Subir Build a TestFlight

1. **Crea un archivo en Xcode:**
   - Selecciona "Any iOS Device (arm64)" como destino
   - Producto > Archivar
   - Espera a que se complete el archivo
   - Se abre la ventana de Xcode Organizer

2. **Distribuir app:**
   - Haz clic en "Distribuir App"
   - Selecciona "App Store Connect"
   - Selecciona "Subir"
   - Elige opciones de distribución:
     - ✅ Incluir bitcode: Sí (si es compatible)
     - ✅ Subir símbolos: Sí (para informes de fallos)
     - ✅ Gestionar versión y build: Automáticamente
   - Haz clic en "Subir"
   - Espera a que se complete la subida (puede tardar 10-20 minutos)

3. **Espera el procesamiento:**
   - Ve a App Store Connect > TestFlight
   - Tu build mostrará el estado "Procesando"
   - Espera 10-30 minutos a que Apple lo procese
   - Recibirás un email cuando esté listo para pruebas

### Paso 2: Añadir Testers Internos

1. **En App Store Connect:**
   - Ve a la pestaña "TestFlight"
   - Haz clic en tu build
   - Añade testers internos (miembros de tu equipo)
   - Se permiten hasta 100 testers internos

2. **Los testers instalan:**
   - Los testers reciben una invitación por email
   - Descargan la app TestFlight del App Store
   - Aceptan la invitación
   - Instalan tu app a través de TestFlight

### Paso 3: Añadir Testers Externos (Opcional)

1. **Crea un grupo de prueba externo:**
   - TestFlight > Pruebas Externas
   - Crea un nuevo grupo: "Beta Testers"
   - Añade testers por email

2. **Enviar para Revisión de App Beta:**
   - Proporciona información de prueba
   - Envía para revisión (1-2 días)
   - Una vez aprobado, los testers externos pueden instalar

3. **Recopila comentarios:**
   - Los testers pueden enviar comentarios a través de TestFlight
   - Revisa informes de fallos en Xcode Organizer

### Paso 4: Iterar Basándote en Comentarios

1. Corrige errores encontrados por los testers
2. Crea un nuevo build con número de build incrementado
3. Sube el nuevo build a TestFlight
4. Notifica a los testers de las actualizaciones

---

## Final Submission / Envío Final

**English:**

Once testing is complete, submit for App Store review:

### Step 1: Complete All Metadata

In App Store Connect, verify all sections are complete:
- ✅ App Information
- ✅ Pricing and Availability
- ✅ App Privacy
- ✅ Age Rating
- ✅ Version Information
- ✅ Screenshots (all device sizes)
- ✅ Description and keywords
- ✅ Build selected from TestFlight
- ✅ App Review Information

### Step 2: Select Build

1. Go to App Store Connect > Your App > App Store tab
2. Under "Build", click "+" to add a build
3. Select the TestFlight build you want to submit
4. Click "Done"

### Step 3: Submit for Review

1. Review all information one final time
2. Click "Submit for Review"
3. Confirm submission

### Step 4: Track Review Status

Review timeline:
- **In Review**: 24-48 hours typically
- **Pending Developer Release**: Approved! You control when to release
- **Ready for Sale**: Live on App Store
- **Rejected**: See rejection reasons and resubmit

Check status in App Store Connect:
- My Apps > [Your App] > App Store tab
- Look for status banner at top

**Español:**

Una vez completadas las pruebas, envía para revisión del App Store:

### Paso 1: Completa Todos los Metadatos

En App Store Connect, verifica que todas las secciones estén completas:
- ✅ Información de la App
- ✅ Precio y Disponibilidad
- ✅ Privacidad de la App
- ✅ Clasificación por Edad
- ✅ Información de Versión
- ✅ Capturas de Pantalla (todos los tamaños de dispositivo)
- ✅ Descripción y palabras clave
- ✅ Build seleccionado de TestFlight
- ✅ Información de Revisión de la App

### Paso 2: Seleccionar Build

1. Ve a App Store Connect > Tu App > pestaña App Store
2. Bajo "Build", haz clic en "+" para añadir un build
3. Selecciona el build de TestFlight que quieres enviar
4. Haz clic en "Listo"

### Paso 3: Enviar para Revisión

1. Revisa toda la información una última vez
2. Haz clic en "Enviar para Revisión"
3. Confirma el envío

### Paso 4: Seguir el Estado de Revisión

Cronología de revisión:
- **En Revisión**: Típicamente 24-48 horas
- **Pendiente de Lanzamiento por Desarrollador**: ¡Aprobada! Tú controlas cuándo lanzarla
- **Lista para la Venta**: En vivo en el App Store
- **Rechazada**: Ver razones de rechazo y reenviar

Verifica el estado en App Store Connect:
- Mis Apps > [Tu App] > pestaña App Store
- Busca el banner de estado en la parte superior

---

## Review Process / Proceso de Revisión

**English:**

### What Apple Reviews

Apple will check:
1. ✅ **Functionality**: App works as described
2. ✅ **Performance**: No crashes or major bugs
3. ✅ **Design**: Follows iOS Human Interface Guidelines
4. ✅ **Privacy**: Proper permission requests and privacy policy
5. ✅ **Content**: No objectionable content
6. ✅ **Business**: Follows App Store guidelines
7. ✅ **Legal**: Proper rights to all content

### Review Timeline

Typical timeline:
- **Waiting for Review**: 0-24 hours
- **In Review**: 24-48 hours
- **Total**: 1-3 days on average

### If Approved

You'll receive email notification. Two options:
1. **Manual Release**: Keep "Pending Developer Release", release when ready
2. **Automatic Release**: App goes live immediately

To release manually:
- App Store Connect > Your App
- Click "Release This Version"

### If Rejected

Don't panic! Common first-time rejections are normal.

Steps to handle rejection:
1. Read rejection message carefully
2. Check Resolution Center in App Store Connect
3. Fix the issues
4. Respond to reviewer if needed
5. Submit new build (if code changes needed)
6. Or resubmit same build (if metadata changes only)

**Español:**

### Qué Revisa Apple

Apple verificará:
1. ✅ **Funcionalidad**: La app funciona como se describe
2. ✅ **Rendimiento**: Sin fallos ni errores importantes
3. ✅ **Diseño**: Sigue las Directrices de Interfaz Humana de iOS
4. ✅ **Privacidad**: Solicitudes de permisos apropiadas y política de privacidad
5. ✅ **Contenido**: Sin contenido objetable
6. ✅ **Negocio**: Sigue las directrices del App Store
7. ✅ **Legal**: Derechos apropiados sobre todo el contenido

### Cronología de Revisión

Cronología típica:
- **Esperando Revisión**: 0-24 horas
- **En Revisión**: 24-48 horas
- **Total**: 1-3 días en promedio

### Si es Aprobada

Recibirás una notificación por email. Dos opciones:
1. **Lanzamiento Manual**: Mantén "Pendiente de Lanzamiento por Desarrollador", lanza cuando estés listo
2. **Lanzamiento Automático**: La app se publica inmediatamente

Para lanzar manualmente:
- App Store Connect > Tu App
- Haz clic en "Lanzar Esta Versión"

### Si es Rechazada

¡No entres en pánico! Los rechazos comunes la primera vez son normales.

Pasos para manejar el rechazo:
1. Lee el mensaje de rechazo cuidadosamente
2. Revisa el Centro de Resolución en App Store Connect
3. Corrige los problemas
4. Responde al revisor si es necesario
5. Envía un nuevo build (si se necesitan cambios de código)
6. O reenvía el mismo build (si solo hay cambios de metadatos)


---

## Post-Launch / Después del Lanzamiento

**English:**

Congratulations! Your app is live. Now what?

### Monitor Performance

1. **App Analytics:**
   - App Store Connect > Analytics
   - Track: Downloads, sessions, crashes, retention

2. **Crash Reports:**
   - Xcode > Window > Organizer > Crashes
   - Monitor and fix critical crashes

3. **User Reviews:**
   - App Store Connect > Ratings and Reviews
   - Respond to user feedback
   - Address common issues

### Promote Your App

1. **Share on social media**
2. **Create website or landing page**
3. **Submit to app review sites**
4. **Engage with users**
5. **Consider press release** (for significant apps)

### Update Your App

When releasing updates:

1. **Increment version/build numbers:**
   - Bug fixes: same version, increment build (1.0.0 build 2)
   - New features: increment minor version (1.1.0 build 1)
   - Major changes: increment major version (2.0.0 build 1)

2. **Create archive and upload:**
   - Same process as initial submission
   - Add "What's New" text describing changes

3. **Submit for review:**
   - Updates also go through review
   - Usually faster than initial review

### Maintain App Store Presence

- Refresh screenshots periodically
- Update description with new features
- Respond to reviews
- Keep app up-to-date with latest iOS

**Español:**

¡Felicitaciones! Tu app está en vivo. ¿Y ahora qué?

### Monitorear Rendimiento

1. **Análisis de App:**
   - App Store Connect > Análisis
   - Rastrea: Descargas, sesiones, fallos, retención

2. **Informes de Fallos:**
   - Xcode > Ventana > Organizador > Fallos
   - Monitorea y corrige fallos críticos

3. **Reseñas de Usuarios:**
   - App Store Connect > Valoraciones y Reseñas
   - Responde a comentarios de usuarios
   - Aborda problemas comunes

### Promocionar Tu App

1. **Comparte en redes sociales**
2. **Crea sitio web o página de destino**
3. **Envía a sitios de reseñas de apps**
4. **Interactúa con usuarios**
5. **Considera comunicado de prensa** (para apps significativas)

### Actualizar Tu App

Al lanzar actualizaciones:

1. **Incrementa números de versión/build:**
   - Correcciones de errores: misma versión, incrementa build (1.0.0 build 2)
   - Nuevas funciones: incrementa versión menor (1.1.0 build 1)
   - Cambios mayores: incrementa versión mayor (2.0.0 build 1)

2. **Crea archivo y sube:**
   - Mismo proceso que el envío inicial
   - Añade texto "Novedades" describiendo cambios

3. **Enviar para revisión:**
   - Las actualizaciones también pasan por revisión
   - Usualmente más rápido que la revisión inicial

### Mantener Presencia en App Store

- Actualiza capturas de pantalla periódicamente
- Actualiza descripción con nuevas funciones
- Responde a reseñas
- Mantén la app actualizada con el último iOS

---

## Common Rejection Reasons / Razones Comunes de Rechazo

**English:**

Learn from common mistakes to avoid rejection:

### 1. Incomplete Metadata

**Issue:** Missing screenshots, description, or privacy policy
**Fix:** Complete all required fields in App Store Connect before submitting

### 2. App Crashes

**Issue:** App crashes during review
**Fix:** 
- Test thoroughly on multiple devices and iOS versions
- Fix all critical bugs before submission
- Enable crash reporting in TestFlight

### 3. Incomplete App

**Issue:** App has placeholder content or "coming soon" features
**Fix:** 
- Remove or implement all advertised features
- Don't mention features that don't exist yet
- Ensure all buttons and features work

### 4. Privacy Issues

**Issue:** Camera/photo access without clear explanation
**Fix:**
- Ensure NSCameraUsageDescription clearly explains usage
- Provide privacy policy URL
- Be transparent about data collection

### 5. Misleading Functionality

**Issue:** App doesn't work as described
**Fix:**
- Update description to match actual functionality
- If using mock data, mention in review notes
- Don't promise features you can't deliver

### 6. Intellectual Property

**Issue:** Using copyrighted content without permission
**Fix:**
- Ensure you have rights to all content
- Properly attribute third-party content
- Get permission for trademarked names/logos

### 7. Minimum Functionality

**Issue:** App doesn't provide enough functionality
**Fix:**
- Ensure app has substantial functionality beyond a mobile website
- Provide unique value to users
- Implement meaningful features

### 8. Spam

**Issue:** App is duplicate of another app or generic template
**Fix:**
- Ensure your app is unique
- Provide specific value for your target market
- Don't submit multiple similar apps

### 9. Broken Links

**Issue:** Privacy policy or support URL doesn't work
**Fix:**
- Test all URLs before submission
- Ensure links are accessible publicly (not behind login)
- Use HTTPS for all links

### 10. Performance Issues

**Issue:** App is slow, buggy, or unresponsive
**Fix:**
- Optimize image loading and processing
- Use async operations for long tasks
- Test on older devices (iPhone SE, etc.)

### How to Respond to Rejection

1. **Stay professional and polite**
2. **Read rejection carefully**
3. **Ask for clarification if needed:**
   - Use Resolution Center in App Store Connect
   - Be specific with questions
4. **Fix issues thoroughly**
5. **Document fixes in resubmission notes**
6. **Resubmit when ready**

**Español:**

Aprende de errores comunes para evitar el rechazo:

### 1. Metadatos Incompletos

**Problema:** Faltan capturas de pantalla, descripción o política de privacidad
**Solución:** Completa todos los campos requeridos en App Store Connect antes de enviar

### 2. La App Falla

**Problema:** La app falla durante la revisión
**Solución:** 
- Prueba exhaustivamente en múltiples dispositivos y versiones de iOS
- Corrige todos los errores críticos antes del envío
- Habilita informes de fallos en TestFlight

### 3. App Incompleta

**Problema:** La app tiene contenido de marcador de posición o funciones "próximamente"
**Solución:** 
- Elimina o implementa todas las funciones anunciadas
- No menciones funciones que aún no existen
- Asegúrate de que todos los botones y funciones funcionen

### 4. Problemas de Privacidad

**Problema:** Acceso a cámara/fotos sin explicación clara
**Solución:**
- Asegúrate de que NSCameraUsageDescription explique claramente el uso
- Proporciona URL de política de privacidad
- Sé transparente sobre la recopilación de datos

### 5. Funcionalidad Engañosa

**Problema:** La app no funciona como se describe
**Solución:**
- Actualiza la descripción para que coincida con la funcionalidad real
- Si usas datos simulados, menciona en notas de revisión
- No prometas funciones que no puedes entregar

### 6. Propiedad Intelectual

**Problema:** Usar contenido con derechos de autor sin permiso
**Solución:**
- Asegúrate de tener derechos sobre todo el contenido
- Atribuye correctamente el contenido de terceros
- Obtén permiso para nombres/logotipos con marca registrada

### 7. Funcionalidad Mínima

**Problema:** La app no proporciona suficiente funcionalidad
**Solución:**
- Asegúrate de que la app tenga funcionalidad sustancial más allá de un sitio web móvil
- Proporciona valor único a los usuarios
- Implementa funciones significativas

### 8. Spam

**Problema:** La app es duplicada de otra app o plantilla genérica
**Solución:**
- Asegúrate de que tu app sea única
- Proporciona valor específico para tu mercado objetivo
- No envíes múltiples apps similares

### 9. Enlaces Rotos

**Problema:** La política de privacidad o URL de soporte no funciona
**Solución:**
- Prueba todas las URLs antes del envío
- Asegúrate de que los enlaces sean accesibles públicamente (no detrás de inicio de sesión)
- Usa HTTPS para todos los enlaces

### 10. Problemas de Rendimiento

**Problema:** La app es lenta, tiene errores o no responde
**Solución:**
- Optimiza la carga y procesamiento de imágenes
- Usa operaciones asíncronas para tareas largas
- Prueba en dispositivos más antiguos (iPhone SE, etc.)

### Cómo Responder al Rechazo

1. **Mantén la profesionalidad y cortesía**
2. **Lee el rechazo cuidadosamente**
3. **Pide aclaraciones si es necesario:**
   - Usa el Centro de Resolución en App Store Connect
   - Sé específico con las preguntas
4. **Corrige los problemas exhaustivamente**
5. **Documenta las correcciones en notas de reenvío**
6. **Reenvía cuando esté listo**

---

## Quick Reference Checklist / Lista de Verificación Rápida

### Before Submission / Antes del Envío

- [ ] App tested on multiple devices and iOS versions
- [ ] All features working correctly
- [ ] No placeholder or "coming soon" content
- [ ] Camera and photo permissions working
- [ ] Privacy policy URL accessible
- [ ] All URLs tested and working
- [ ] Screenshots for all required device sizes
- [ ] App description in Spanish and English
- [ ] Keywords optimized
- [ ] App icon finalized (1024x1024px)
- [ ] Version and build numbers set correctly
- [ ] Code signing configured
- [ ] TestFlight testing completed
- [ ] All metadata completed in App Store Connect
- [ ] Review notes added for testers
- [ ] Contact information provided

### After Submission / Después del Envío

- [ ] Monitor review status daily
- [ ] Respond to reviewer questions promptly
- [ ] Fix any issues immediately if rejected
- [ ] Prepare promotional materials
- [ ] Plan launch announcement
- [ ] Set up crash reporting monitoring
- [ ] Prepare to respond to user reviews
- [ ] Plan first update

---

## Additional Resources / Recursos Adicionales

### Official Apple Documentation

- [App Store Review Guidelines](https://developer.apple.com/app-store/review/guidelines/)
- [App Store Connect Help](https://help.apple.com/app-store-connect/)
- [iOS Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)
- [TestFlight Beta Testing](https://developer.apple.com/testflight/)
- [App Store Product Page](https://developer.apple.com/app-store/product-page/)

### Helpful Tools

- **Screenshot Tools:**
  - [Fastlane Snapshot](https://docs.fastlane.tools/actions/snapshot/)
  - [App Store Screenshot](https://appstore-screenshot.com/)
  
- **Privacy Policy Generators:**
  - [Privacy Policy Generator](https://www.privacypolicygenerator.info/)
  - [Termly](https://termly.io/)

- **App Store Optimization:**
  - [App Store Connect API](https://developer.apple.com/app-store-connect/api/)
  - [App Annie](https://www.appannie.com/)

### Community Support

- [Apple Developer Forums](https://developer.apple.com/forums/)
- [Stack Overflow - iOS](https://stackoverflow.com/questions/tagged/ios)
- [r/iOSProgramming](https://www.reddit.com/r/iOSProgramming/)

---

## Summary / Resumen

**English:**

Publishing to the App Store involves:
1. ✅ Local testing on simulators and devices
2. ✅ Creating Apple Developer account
3. ✅ Preparing app metadata and screenshots
4. ✅ Setting up code signing
5. ✅ Creating privacy policy
6. ✅ TestFlight beta testing
7. ✅ Final submission and review
8. ✅ Monitoring and updates

**Expected Timeline:**
- Preparation: 1-2 weeks (first time)
- TestFlight: 1 week
- Review: 1-3 days
- **Total: 2-4 weeks for first release**

**Español:**

Publicar en el App Store implica:
1. ✅ Pruebas locales en simuladores y dispositivos
2. ✅ Crear cuenta de Apple Developer
3. ✅ Preparar metadatos de la app y capturas de pantalla
4. ✅ Configurar firma de código
5. ✅ Crear política de privacidad
6. ✅ Pruebas beta con TestFlight
7. ✅ Envío final y revisión
8. ✅ Monitoreo y actualizaciones

**Cronología Esperada:**
- Preparación: 1-2 semanas (primera vez)
- TestFlight: 1 semana
- Revisión: 1-3 días
- **Total: 2-4 semanas para primer lanzamiento**

---

**Good luck with your App Store launch! / ¡Buena suerte con tu lanzamiento en el App Store!** 🎉

For questions or issues, consult the documentation or reach out to the community.

---

*Last updated: February 2026*
