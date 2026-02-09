import SwiftUI

struct ResultsView: View {
    let antiqueItem: AntiqueItem
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Legal Disclaimer
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "info.circle.fill")
                                .foregroundColor(.blue)
                            Text("disclaimer_title")
                                .font(.headline)
                                .foregroundColor(.blue)
                        }
                        
                        Text("price_estimation_disclaimer")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text("todocoleccion_attribution")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(10)
                    
                    // Title
                    Text(antiqueItem.name)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    // Category and Keywords
                    if !antiqueItem.suggestedKeywords.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("suggested_category")
                                .font(.headline)
                            Text(antiqueItem.suggestedCategory)
                                .font(.body)
                                .foregroundColor(.secondary)
                            
                            if !antiqueItem.suggestedKeywords.isEmpty {
                                Text("keywords_used")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Text(antiqueItem.suggestedKeywords.joined(separator: ", "))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    
                    Divider()
                    
                    // Price Estimation
                    VStack(alignment: .leading, spacing: 10) {
                        Text("price_estimation")
                            .font(.headline)
                        
                        HStack {
                            Text("estimated_value")
                            Spacer()
                            Text(String(format: "%.2f €", antiqueItem.estimatedPrice))
                                .fontWeight(.bold)
                                .foregroundColor(.green)
                                .font(.title3)
                        }
                        
                        HStack {
                            Text("adjusted_price_range")
                            Spacer()
                            Text(String(format: "%.2f € - %.2f €", 
                                      antiqueItem.priceRange.min, 
                                      antiqueItem.priceRange.max))
                                .foregroundColor(.secondary)
                        }
                        
                        Divider()
                        
                        Text("calculation_breakdown")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text("user_median_price")
                                    .font(.caption)
                                Spacer()
                                Text(String(format: "%.2f €", antiqueItem.userProvidedPrices.medianPrice))
                                    .font(.caption)
                            }
                            
                            HStack {
                                Text("condition_factor")
                                    .font(.caption)
                                Spacer()
                                Text(String(format: "×%.2f", antiqueItem.conditionFactor))
                                    .font(.caption)
                            }
                            
                            HStack {
                                Text("rarity_factor")
                                    .font(.caption)
                                Spacer()
                                Text(String(format: "×%.2f", antiqueItem.rarityFactor))
                                    .font(.caption)
                            }
                        }
                        .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    
                    // User-Provided Market Data
                    VStack(alignment: .leading, spacing: 10) {
                        Text("user_provided_prices")
                            .font(.headline)
                        
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text("observed_minimum")
                                Spacer()
                                Text(String(format: "%.2f €", antiqueItem.userProvidedPrices.minimumPrice))
                            }
                            
                            HStack {
                                Text("observed_median")
                                Spacer()
                                Text(String(format: "%.2f €", antiqueItem.userProvidedPrices.medianPrice))
                                    .fontWeight(.semibold)
                            }
                            
                            HStack {
                                Text("observed_maximum")
                                Spacer()
                                Text(String(format: "%.2f €", antiqueItem.userProvidedPrices.maximumPrice))
                            }
                        }
                        .font(.subheadline)
                        
                        if !antiqueItem.userProvidedPrices.listingURLs.isEmpty {
                            Divider()
                            Text("reference_listings")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            
                            ForEach(antiqueItem.userProvidedPrices.listingURLs.prefix(5), id: \.self) { url in
                                Text(url)
                                    .font(.caption)
                                    .foregroundColor(.blue)
                                    .lineLimit(1)
                            }
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    
                    // Condition Assessment
                    VStack(alignment: .leading, spacing: 10) {
                        Text("condition_assessment")
                            .font(.headline)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            assessmentRow(
                                title: "overall_condition",
                                value: antiqueItem.conditionAssessment.overallCondition.localizedKey
                            )
                            
                            if antiqueItem.conditionAssessment.hasRestoration {
                                assessmentRow(
                                    title: "restoration_quality",
                                    value: antiqueItem.conditionAssessment.restorationQuality?.localizedKey ?? "none"
                                )
                            }
                            
                            assessmentRow(
                                title: "authenticity_belief",
                                value: antiqueItem.conditionAssessment.believedAuthenticity.localizedKey
                            )
                            
                            assessmentRow(
                                title: "completeness",
                                value: antiqueItem.conditionAssessment.completeness.localizedKey
                            )
                            
                            assessmentRow(
                                title: "rarity",
                                value: antiqueItem.conditionAssessment.rarity.localizedKey
                            )
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    
                    // Assessment Date
                    Text("assessment_date \(antiqueItem.assessmentDate, style: .date)")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.top)
                }
                .padding()
            }
            .navigationTitle("assessment_results")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
    
    private func assessmentRow(title: String, value: String) -> some View {
        HStack {
            Text(NSLocalizedString(title, comment: ""))
                .font(.subheadline)
            Spacer()
            Text(NSLocalizedString(value, comment: ""))
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}

struct ResultsView_Previews: PreviewProvider {
    static var previews: some View {
        ResultsView(antiqueItem: AntiqueItem(
            name: "Moneda Antigua",
            description: "moneda antigua numismática",
            estimatedPrice: 165.0,
            priceRange: AntiqueItem.PriceRange(min: 110.0, max: 220.0),
            userProvidedPrices: UserProvidedPrices(
                minimumPrice: 100.0,
                medianPrice: 150.0,
                maximumPrice: 200.0,
                listingURLs: ["https://www.todocoleccion.net/example1"]
            ),
            conditionAssessment: ConditionAssessment(
                overallCondition: .good,
                hasRestoration: false,
                restorationQuality: nil,
                believedAuthenticity: .probablyAuthentic,
                completeness: .complete,
                rarity: .uncommon
            ),
            conditionFactor: 1.0,
            rarityFactor: 1.1,
            suggestedCategory: "moneda antigua",
            suggestedKeywords: ["numismática", "colección"],
            analysisConfidence: 0.85
        ))
    }
}
