import SwiftUI

struct ContentView: View {
    @State private var showCamera = false
    @State private var selectedImage: UIImage?
    @State private var showResults = false
    @State private var assessmentResult: AntiqueItem?
    @State private var isAssessing = false
    @StateObject private var assessmentService = AssessmentService()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("app_title")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding()
                
                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 300)
                        .cornerRadius(10)
                        .padding()
                }
                
                VStack(spacing: 15) {
                    Button(action: {
                        showCamera = true
                    }) {
                        HStack {
                            Image(systemName: "camera.fill")
                            Text("take_photo")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    
                    if selectedImage != nil {
                        Button(action: {
                            assessAntique()
                        }) {
                            HStack {
                                if isAssessing {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                } else {
                                    Image(systemName: "magnifyingglass")
                                    Text("assess_antique")
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(isAssessing ? Color.gray : Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                        .disabled(isAssessing)
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                Text("app_description")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showCamera) {
                CameraView(selectedImage: $selectedImage)
            }
            .sheet(isPresented: $showResults) {
                if let result = assessmentResult {
                    ResultsView(antiqueItem: result)
                }
            }
        }
    }
    
    private func assessAntique() {
        guard let image = selectedImage else { return }
        isAssessing = true
        
        Task {
            do {
                let result = try await assessmentService.assessAntique(image: image)
                await MainActor.run {
                    self.assessmentResult = result
                    self.isAssessing = false
                    self.showResults = true
                }
            } catch {
                await MainActor.run {
                    self.isAssessing = false
                    print("Assessment error: \(error)")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
