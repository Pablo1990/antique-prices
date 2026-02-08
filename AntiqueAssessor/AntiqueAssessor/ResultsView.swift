import SwiftUI

struct ResultsView: View {
    let antiqueItem: AntiqueItem
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Title
                    Text(antiqueItem.name)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    // Description
                    Text(antiqueItem.description)
                        .font(.body)
                        .foregroundColor(.secondary)
                    
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
                        }
                        
                        HStack {
                            Text("price_range")
                            Spacer()
                            Text(String(format: "%.2f € - %.2f €", 
                                      antiqueItem.priceRange.min, 
                                      antiqueItem.priceRange.max))
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    
                    // Authenticity Assessment
                    VStack(alignment: .leading, spacing: 10) {
                        Text("authenticity_check")
                            .font(.headline)
                        
                        HStack {
                            Image(systemName: antiqueItem.isAuthentic ? "checkmark.circle.fill" : "xmark.circle.fill")
                                .foregroundColor(antiqueItem.isAuthentic ? .green : .red)
                            
                            Text(antiqueItem.isAuthentic ? "likely_authentic" : "possibly_fake")
                                .fontWeight(.semibold)
                            
                            Spacer()
                            
                            Text(String(format: "%.0f%%", antiqueItem.authenticityConfidence * 100))
                                .fontWeight(.bold)
                        }
                        
                        ProgressView(value: antiqueItem.authenticityConfidence)
                            .progressViewStyle(LinearProgressViewStyle(tint: antiqueItem.isAuthentic ? .green : .red))
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    
                    // Period Assessment
                    VStack(alignment: .leading, spacing: 10) {
                        Text("period_assessment")
                            .font(.headline)
                        
                        HStack {
                            Image(systemName: "clock.fill")
                                .foregroundColor(.blue)
                            
                            Text(antiqueItem.period)
                                .fontWeight(.semibold)
                            
                            Spacer()
                            
                            Text(String(format: "%.0f%%", antiqueItem.periodConfidence * 100))
                                .fontWeight(.bold)
                        }
                        
                        ProgressView(value: antiqueItem.periodConfidence)
                            .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    
                    // Similar Items
                    if !antiqueItem.similarItems.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("similar_items")
                                .font(.headline)
                            
                            ForEach(antiqueItem.similarItems) { item in
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(item.name)
                                            .font(.subheadline)
                                        Text(item.url)
                                            .font(.caption)
                                            .foregroundColor(.blue)
                                    }
                                    
                                    Spacer()
                                    
                                    Text(String(format: "%.2f €", item.price))
                                        .fontWeight(.semibold)
                                }
                                .padding(.vertical, 5)
                            }
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                    }
                    
                    // Source
                    Text("source_info \(antiqueItem.source)")
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
}

struct ResultsView_Previews: PreviewProvider {
    static var previews: some View {
        ResultsView(antiqueItem: AntiqueItem(
            name: "Reloj Antiguo",
            description: "Un hermoso reloj de bolsillo del siglo XIX",
            estimatedPrice: 150.0,
            priceRange: AntiqueItem.PriceRange(min: 125.0, max: 200.0),
            isAuthentic: true,
            authenticityConfidence: 0.85,
            period: "Siglo XIX (1800-1900)",
            periodConfidence: 0.78,
            source: "https://www.todocoleccion.net",
            similarItems: [
                AntiqueItem.SimilarItem(name: "Similar 1", price: 125.0, url: "https://example.com/1"),
                AntiqueItem.SimilarItem(name: "Similar 2", price: 180.0, url: "https://example.com/2")
            ]
        ))
    }
}
