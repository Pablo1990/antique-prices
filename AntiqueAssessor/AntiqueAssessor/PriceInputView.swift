import SwiftUI

struct PriceInputView: View {
    @Binding var prices: UserProvidedPrices?
    @Environment(\.presentationMode) var presentationMode
    
    @State private var minimumPrice: String = ""
    @State private var medianPrice: String = ""
    @State private var maximumPrice: String = ""
    @State private var listingURLsText: String = ""
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("price_input_header")) {
                    Text("price_input_instructions")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                
                Section(header: Text("price_input_section")) {
                    HStack {
                        Text("minimum_price")
                        Spacer()
                        TextField("0.00", text: $minimumPrice)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                        Text("€")
                    }
                    
                    HStack {
                        Text("median_price")
                        Spacer()
                        TextField("0.00", text: $medianPrice)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                        Text("€")
                    }
                    
                    HStack {
                        Text("maximum_price")
                        Spacer()
                        TextField("0.00", text: $maximumPrice)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                        Text("€")
                    }
                }
                
                Section(header: Text("listing_urls_section"), 
                       footer: Text("listing_urls_footer")) {
                    TextEditor(text: $listingURLsText)
                        .frame(minHeight: 100)
                        .font(.caption)
                }
            }
            .navigationTitle("enter_prices")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("continue") {
                        validateAndSave()
                    }
                }
            }
            .alert("error", isPresented: $showError) {
                Button("ok", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    private func validateAndSave() {
        // Parse prices
        guard let min = Double(minimumPrice.replacingOccurrences(of: ",", with: ".")),
              let median = Double(medianPrice.replacingOccurrences(of: ",", with: ".")),
              let max = Double(maximumPrice.replacingOccurrences(of: ",", with: ".")) else {
            errorMessage = NSLocalizedString("invalid_price_format", comment: "")
            showError = true
            return
        }
        
        // Validate price logic
        guard min > 0 && median > 0 && max > 0 else {
            errorMessage = NSLocalizedString("prices_must_be_positive", comment: "")
            showError = true
            return
        }
        
        guard min <= median && median <= max else {
            errorMessage = NSLocalizedString("invalid_price_order", comment: "")
            showError = true
            return
        }
        
        // Parse URLs (optional)
        let urls = listingURLsText
            .components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        
        // Create prices object
        prices = UserProvidedPrices(
            minimumPrice: min,
            medianPrice: median,
            maximumPrice: max,
            listingURLs: urls
        )
        
        presentationMode.wrappedValue.dismiss()
    }
}

struct PriceInputView_Previews: PreviewProvider {
    static var previews: some View {
        PriceInputView(prices: .constant(nil))
    }
}
