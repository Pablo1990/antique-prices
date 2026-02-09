# Contributing to Antique Assessor / Contribuir al Tasador de Antigüedades

Thank you for your interest in contributing to this open-source project!

¡Gracias por tu interés en contribuir a este proyecto de código abierto!

## Ways to Contribute / Formas de Contribuir

### English
- **Report bugs**: Open an issue describing the problem
- **Suggest features**: Share your ideas for improvements
- **Improve documentation**: Help make the docs clearer
- **Fix issues**: Submit pull requests for existing issues
- **Add translations**: Help localize to more languages
- **Improve ML models**: Contribute better detection algorithms

### Español
- **Reportar errores**: Abre un issue describiendo el problema
- **Sugerir características**: Comparte tus ideas de mejora
- **Mejorar documentación**: Ayuda a hacer los docs más claros
- **Resolver issues**: Envía pull requests para issues existentes
- **Agregar traducciones**: Ayuda a localizar a más idiomas
- **Mejorar modelos ML**: Contribuye mejores algoritmos de detección

## Development Setup / Configuración de Desarrollo

1. Fork the repository / Haz fork del repositorio
2. Clone your fork / Clona tu fork:
   ```bash
   git clone https://github.com/YOUR_USERNAME/antique-prices.git
   ```
3. Create a branch / Crea una rama:
   ```bash
   git checkout -b feature/your-feature-name
   ```
4. Open in Xcode / Abre en Xcode:
   ```bash
   open AntiqueAssessor/AntiqueAssessor.xcodeproj
   ```

## Coding Standards / Estándares de Código

### Swift Style Guide
- Use Swift naming conventions
- Follow Apple's API Design Guidelines
- Add comments for complex logic
- Keep functions small and focused
- Use meaningful variable names

### SwiftUI Best Practices
- Keep views small and composable
- Use `@State`, `@Binding`, `@StateObject` appropriately
- Extract reusable components
- Maintain proper view hierarchy

### Localization
- All user-facing strings must be localized
- Use `NSLocalizedString` or SwiftUI's `Text("key")`
- Update both Spanish and English `.strings` files
- Test in both languages

## Commit Guidelines / Guías de Commit

### English
- Use clear, descriptive commit messages
- Start with a verb (Add, Fix, Update, Remove, etc.)
- Reference issue numbers when applicable
- Keep commits focused on single changes

Example:
```
Add period detection for Art Deco items

- Implement Art Deco style recognition
- Add training data for 1920-1939 period
- Update confidence calculation algorithm
Closes #123
```

### Español
- Usa mensajes de commit claros y descriptivos
- Comienza con un verbo (Agregar, Corregir, Actualizar, Eliminar, etc.)
- Referencia números de issue cuando aplique
- Mantén commits enfocados en cambios únicos

Ejemplo:
```
Agregar detección de periodo para artículos Art Deco

- Implementar reconocimiento de estilo Art Deco
- Agregar datos de entrenamiento para periodo 1920-1939
- Actualizar algoritmo de cálculo de confianza
Cierra #123
```

## Pull Request Process / Proceso de Pull Request

1. **Update Documentation** / **Actualiza Documentación**
   - Update README.md if needed
   - Update IMPLEMENTATION.md with technical details
   - Add comments to complex code

2. **Test Your Changes** / **Prueba tus Cambios**
   - Build and run the app
   - Test on multiple devices/simulators
   - Verify both Spanish and English work
   - Test edge cases

3. **Create Pull Request** / **Crea Pull Request**
   - Use descriptive title
   - Explain what changes were made and why
   - Reference related issues
   - Add screenshots for UI changes

4. **Code Review** / **Revisión de Código**
   - Be open to feedback
   - Make requested changes
   - Discuss disagreements respectfully

## Areas Needing Help / Áreas que Necesitan Ayuda

### High Priority / Alta Prioridad
- 🌐 **API Integration**: Implement todocoleccion.net scraping/API
- 🤖 **ML Models**: Improve authenticity and period detection
- 🧪 **Testing**: Add unit and UI tests
- 📚 **Documentation**: Improve code documentation

### Medium Priority / Prioridad Media
- 🎨 **UI/UX**: Improve design and user experience
- 🌍 **Localization**: Add more languages (French, Italian, Portuguese)
- 📊 **Analytics**: Add privacy-friendly usage tracking
- 💾 **Data Storage**: Implement assessment history

### Good First Issues / Buenos Primeros Issues
- 🐛 Fix UI alignment issues
- 📝 Improve error messages
- 🌐 Add new localizable strings
- 📖 Improve README examples

## Questions? / ¿Preguntas?

- Open a Discussion on GitHub
- Comment on relevant issues
- Review existing documentation

## Code of Conduct / Código de Conducta

### English
- Be respectful and inclusive
- Welcome newcomers
- Focus on constructive feedback
- Help others learn and grow
- No harassment or discrimination

### Español
- Sé respetuoso e inclusivo
- Da la bienvenida a principiantes
- Enfócate en retroalimentación constructiva
- Ayuda a otros a aprender y crecer
- No acoso o discriminación

Thank you for contributing! / ¡Gracias por contribuir!
