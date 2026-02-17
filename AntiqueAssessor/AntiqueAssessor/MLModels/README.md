# ML Models Directory

This directory contains Core ML models used by the Antique Assessor app.

## FastViT Model

The app uses **FastViT** (Fast Vision Transformer) for accurate object recognition.

### Required Model File

**File:** `FastViTT8F16.mlpackage`

This is a TinyML variant of FastViT optimized for mobile devices with float16 precision.

### Where to Place the Model

1. Download or obtain the `FastViTT8F16.mlpackage` file
2. Place it in this directory: `AntiqueAssessor/AntiqueAssessor/MLModels/`
3. In Xcode, drag the `.mlpackage` file into the project navigator under the MLModels group
4. When prompted, ensure "Copy items if needed" is checked and the target is "AntiqueAssessor"

### Model Info

- **Model Type:** Vision Transformer (ViT)
- **Input:** 224x224x3 RGB image
- **Output:** Object class predictions with confidence scores
- **Precision:** Float16 (F16) for efficiency
- **Use Case:** Object recognition for antique items

### Integration

The model is integrated via the `FastViTService` class in `Services/FastViTService.swift`, which handles:
- Model loading and initialization
- Image preprocessing (resizing to 224x224)
- Inference execution
- Result post-processing

The `AssessmentService` uses FastViT to identify objects in antique photos, which are then used to generate search queries for todocoleccion.net.

## Adding Additional Models

If you need to add other Core ML models:
1. Place the `.mlmodel` or `.mlpackage` file in this directory
2. Add it to the Xcode project
3. Create a corresponding service class in the Services directory
4. Update the documentation here
