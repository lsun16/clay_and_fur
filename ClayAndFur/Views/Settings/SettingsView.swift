import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            Form {
                Section("About") {
                    HStack {
                        Image(systemName: "hands.sparkles")
                            .foregroundColor(.orange)
                        VStack(alignment: .leading) {
                            Text("Clay and Fur")
                                .font(.headline)
                            Text("Pottery Tracker v1.0")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                Section("iCloud") {
                    HStack {
                        Image(systemName: "icloud")
                            .foregroundColor(.blue)
                        Text("CloudKit Sync")
                        Spacer()
                        Text("Enabled")
                            .font(.caption)
                            .foregroundColor(.green)
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
}
