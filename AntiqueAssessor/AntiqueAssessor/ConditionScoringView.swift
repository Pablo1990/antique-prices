import SwiftUI

struct ConditionScoringView: View {
    @Binding var conditionAssessment: ConditionAssessment?
    @Environment(\.presentationMode) var presentationMode
    
    @State private var overallCondition: ConditionAssessment.ConditionLevel = .good
    @State private var hasRestoration = false
    @State private var restorationQuality: ConditionAssessment.RestorationQuality = .none
    @State private var believedAuthenticity: ConditionAssessment.AuthenticityBelief = .probablyAuthentic
    @State private var completeness: ConditionAssessment.CompletenessLevel = .complete
    @State private var rarity: ConditionAssessment.RarityLevel = .uncommon
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("condition_scoring_header")) {
                    Text("condition_scoring_instructions")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                
                Section(header: Text("overall_condition")) {
                    Picker("overall_condition", selection: $overallCondition) {
                        ForEach(ConditionAssessment.ConditionLevel.allCases, id: \.self) { level in
                            Text(level.localizedKey).tag(level)
                        }
                    }
                    .pickerStyle(.menu)
                    
                    Text("condition_description_\(overallCondition.rawValue)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Section(header: Text("restoration_section")) {
                    Toggle("has_restoration", isOn: $hasRestoration)
                    
                    if hasRestoration {
                        Picker("restoration_quality", selection: $restorationQuality) {
                            ForEach([ConditionAssessment.RestorationQuality.professional, 
                                   ConditionAssessment.RestorationQuality.amateur], id: \.self) { quality in
                                Text(quality.localizedKey).tag(quality)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                }
                
                Section(header: Text("authenticity_belief_section")) {
                    Picker("authenticity_belief", selection: $believedAuthenticity) {
                        ForEach(ConditionAssessment.AuthenticityBelief.allCases, id: \.self) { belief in
                            Text(belief.localizedKey).tag(belief)
                        }
                    }
                    .pickerStyle(.menu)
                    
                    Text("authenticity_disclaimer")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Section(header: Text("completeness_section")) {
                    Picker("completeness", selection: $completeness) {
                        ForEach(ConditionAssessment.CompletenessLevel.allCases, id: \.self) { level in
                            Text(level.localizedKey).tag(level)
                        }
                    }
                    .pickerStyle(.menu)
                }
                
                Section(header: Text("rarity_section")) {
                    Picker("rarity", selection: $rarity) {
                        ForEach(ConditionAssessment.RarityLevel.allCases, id: \.self) { level in
                            Text(level.localizedKey).tag(level)
                        }
                    }
                    .pickerStyle(.menu)
                    
                    Text("rarity_description")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("condition_scoring")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("continue") {
                        saveAssessment()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }
    
    private func saveAssessment() {
        conditionAssessment = ConditionAssessment(
            overallCondition: overallCondition,
            hasRestoration: hasRestoration,
            restorationQuality: hasRestoration ? restorationQuality : nil,
            believedAuthenticity: believedAuthenticity,
            completeness: completeness,
            rarity: rarity
        )
        
        presentationMode.wrappedValue.dismiss()
    }
}

struct ConditionScoringView_Previews: PreviewProvider {
    static var previews: some View {
        ConditionScoringView(conditionAssessment: .constant(nil))
    }
}
