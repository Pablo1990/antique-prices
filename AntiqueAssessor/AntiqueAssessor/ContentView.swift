import SwiftUI

struct ContentView: View {
    @State private var showCamera = false
    @State private var selectedImage: UIImage?
    @State private var currentStep: AssessmentStep = .initial
    @State private var isProcessing = false
    
    // Assessment data
    @State private var imageAnalysis: ImageAnalysisResult?
    @State private var userProvidedPrices: UserProvidedPrices?
    @State private var conditionAssessment: ConditionAssessment?
    @State private var finalResult: AntiqueItem?
    
    // UI state
    @State private var showSafari = false
    @State private var showPriceInput = false
    @State private var showConditionScoring = false
    @State private var showResults = false
    @State private var errorMessage: String?
    @State private var showError = false
    
    @StateObject private var assessmentService = AssessmentService()
    
    enum AssessmentStep {
        case initial
        case imageAnalysis
        case browsing
        case priceEntry
        case conditionScoring
        case complete
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    VStack(spacing: 12) {
                        Text("app_title")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                        
                        Text("app_description_new")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .padding(.top)
                    
                    // Selected image preview
                    if let image = selectedImage {
                        VStack(spacing: 10) {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 250)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                            
                            if currentStep != .initial {
                                Button(action: resetAssessment) {
                                    HStack {
                                        Image(systemName: "arrow.clockwise")
                                        Text("start_over")
                                    }
                                    .font(.caption)
                                    .foregroundColor(.blue)
                                }
                            }
                        }
                        .padding()
                    }
                    
                    // Step-by-step workflow
                    VStack(spacing: 15) {
                        // Step 1: Take Photo
                        assessmentStepView(
                            stepNumber: 1,
                            title: "take_photo",
                            icon: "camera.fill",
                            isComplete: selectedImage != nil,
                            isActive: currentStep == .initial
                        ) {
                            showCamera = true
                        }
                        
                        // Step 2: Analyze Image
                        if selectedImage != nil {
                            assessmentStepView(
                                stepNumber: 2,
                                title: "analyze_image",
                                icon: "brain",
                                isComplete: imageAnalysis != nil,
                                isActive: currentStep == .imageAnalysis,
                                isProcessing: isProcessing && currentStep == .imageAnalysis
                            ) {
                                performImageAnalysis()
                            }
                        }
                        
                        // Step 3: Browse Market
                        if imageAnalysis != nil {
                            VStack(alignment: .leading, spacing: 8) {
                                assessmentStepView(
                                    stepNumber: 3,
                                    title: "browse_market",
                                    icon: "safari",
                                    isComplete: userProvidedPrices != nil,
                                    isActive: currentStep == .browsing
                                ) {
                                    openSafari()
                                }
                                
                                if let analysis = imageAnalysis {
                                    Text("suggested_search_keywords")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                        .padding(.leading, 50)
                                    Text(analysis.searchQuery)
                                        .font(.caption)
                                        .fontWeight(.medium)
                                        .foregroundColor(.blue)
                                        .padding(.leading, 50)
                                }
                            }
                        }
                        
                        // Step 4: Enter Prices
                        if imageAnalysis != nil && currentStep != .initial && currentStep != .imageAnalysis {
                            assessmentStepView(
                                stepNumber: 4,
                                title: "enter_prices",
                                icon: "eurosign.circle",
                                isComplete: userProvidedPrices != nil,
                                isActive: currentStep == .priceEntry
                            ) {
                                showPriceInput = true
                            }
                        }
                        
                        // Step 5: Rate Condition
                        if userProvidedPrices != nil {
                            assessmentStepView(
                                stepNumber: 5,
                                title: "rate_condition",
                                icon: "star.circle",
                                isComplete: conditionAssessment != nil,
                                isActive: currentStep == .conditionScoring
                            ) {
                                showConditionScoring = true
                            }
                        }
                        
                        // Step 6: View Results
                        if conditionAssessment != nil {
                            assessmentStepView(
                                stepNumber: 6,
                                title: "view_results",
                                icon: "doc.text",
                                isComplete: finalResult != nil,
                                isActive: currentStep == .complete,
                                isProcessing: isProcessing && currentStep == .complete
                            ) {
                                generateFinalEstimate()
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    // Legal disclaimer
                    VStack(spacing: 8) {
                        Text("legal_disclaimer")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                        
                        Text("no_scraping_notice")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showCamera) {
                CameraView(selectedImage: $selectedImage)
                    .onDisappear {
                        if selectedImage != nil && imageAnalysis == nil {
                            currentStep = .imageAnalysis
                        }
                    }
            }
            .sheet(isPresented: $showSafari) {
                if let analysis = imageAnalysis, let url = analysis.generateSearchURL() {
                    SafariView(url: url)
                        .onDisappear {
                            currentStep = .priceEntry
                        }
                }
            }
            .sheet(isPresented: $showPriceInput) {
                PriceInputView(prices: $userProvidedPrices)
                    .onDisappear {
                        if userProvidedPrices != nil {
                            currentStep = .conditionScoring
                        }
                    }
            }
            .sheet(isPresented: $showConditionScoring) {
                ConditionScoringView(conditionAssessment: $conditionAssessment)
                    .onDisappear {
                        if conditionAssessment != nil {
                            currentStep = .complete
                        }
                    }
            }
            .sheet(isPresented: $showResults) {
                if let result = finalResult {
                    ResultsView(antiqueItem: result)
                }
            }
            .alert("error", isPresented: $showError) {
                Button("ok", role: .cancel) { }
            } message: {
                Text(errorMessage ?? "")
            }
        }
    }
    
    private func assessmentStepView(
        stepNumber: Int,
        title: String,
        icon: String,
        isComplete: Bool,
        isActive: Bool,
        isProcessing: Bool = false,
        action: @escaping () -> Void = {}
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 15) {
                // Step number / checkmark
                ZStack {
                    Circle()
                        .fill(isComplete ? Color.green : (isActive ? Color.blue : Color.gray.opacity(0.3)))
                        .frame(width: 35, height: 35)
                    
                    if isComplete {
                        Image(systemName: "checkmark")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                    } else {
                        Text("\(stepNumber)")
                            .foregroundColor(isActive ? .white : .gray)
                            .fontWeight(.semibold)
                    }
                }
                
                // Icon and title
                HStack {
                    Image(systemName: icon)
                        .font(.title3)
                    Text(NSLocalizedString(title, comment: ""))
                        .fontWeight(.medium)
                }
                .foregroundColor(isActive ? .primary : .secondary)
                
                Spacer()
                
                // Processing indicator or arrow
                if isProcessing {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                } else if isActive && !isComplete {
                    Image(systemName: "arrow.right.circle.fill")
                        .foregroundColor(.blue)
                        .font(.title2)
                }
            }
            .padding()
            .background(isActive ? Color.blue.opacity(0.1) : Color.clear)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isActive ? Color.blue : Color.clear, lineWidth: 2)
            )
        }
        .disabled(!isActive || isProcessing)
    }
    
    private func performImageAnalysis() {
        guard let image = selectedImage else { return }
        isProcessing = true
        
        Task {
            do {
                let analysis = try await assessmentService.analyzeImage(image)
                await MainActor.run {
                    self.imageAnalysis = analysis
                    self.isProcessing = false
                    self.currentStep = .browsing
                }
            } catch {
                await MainActor.run {
                    self.isProcessing = false
                    self.errorMessage = error.localizedDescription
                    self.showError = true
                }
            }
        }
    }
    
    private func openSafari() {
        showSafari = true
    }
    
    private func generateFinalEstimate() {
        guard let analysis = imageAnalysis,
              let prices = userProvidedPrices,
              let condition = conditionAssessment else {
            return
        }
        
        isProcessing = true
        
        Task {
            await MainActor.run {
                let result = assessmentService.createFinalAssessment(
                    imageAnalysis: analysis,
                    userPrices: prices,
                    condition: condition
                )
                self.finalResult = result
                self.isProcessing = false
                self.showResults = true
            }
        }
    }
    
    private func resetAssessment() {
        selectedImage = nil
        imageAnalysis = nil
        userProvidedPrices = nil
        conditionAssessment = nil
        finalResult = nil
        currentStep = .initial
        isProcessing = false
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
