# FastViT Model Placeholder

## Required File: FastViTT8F16.mlpackage

This placeholder indicates where the FastViT model file should be placed.

### Instructions:

1. **Obtain the Model**:
   - Download or export `FastViTT8F16.mlpackage` from your model training environment
   - This is a Vision Transformer model with T8 architecture and Float16 precision

2. **Place the Model**:
   - Copy `FastViTT8F16.mlpackage` to this directory (`AntiqueAssessor/AntiqueAssessor/MLModels/`)
   - The complete path should be: `AntiqueAssessor/AntiqueAssessor/MLModels/FastViTT8F16.mlpackage`

3. **Add to Xcode**:
   - Open `AntiqueAssessor.xcodeproj` in Xcode
   - Drag `FastViTT8F16.mlpackage` into the MLModels group in the Project Navigator
   - Ensure "Copy items if needed" is checked
   - Ensure the target "AntiqueAssessor" is selected
   - Xcode will automatically compile the model to `.mlmodelc` format during build

4. **Verify Integration**:
   - Build the project (Cmd+B)
   - Run the app on a simulator or device
   - Check the console logs - you should see "✓ FastViT model loaded successfully"
   - If the model is not found, you'll see a warning and the app will fallback to Vision framework

### Model Specifications:

- **Input**: 224x224x3 RGB image
- **Output**: Class predictions with confidence scores
- **Architecture**: FastViT-T8 (Tiny, 8M parameters)
- **Precision**: Float16 (F16) for mobile efficiency
- **Format**: Core ML `.mlpackage` (iOS 15.0+)

### Why this placeholder?

Large binary files (like ML models) are typically not committed to git repositories. Instead:
- The model should be downloaded separately or stored in a model registry
- Developers add the model locally to their workspace
- CI/CD pipelines fetch the model from a secure location

### Fallback Behavior:

If the model file is not present, the app will automatically fall back to Apple's Vision framework with `VNClassifyImageRequest`, which provides good general-purpose object classification but may be less accurate for antique-specific items.

### Need Help?

See the main README.md in the MLModels directory for more details on model integration.
