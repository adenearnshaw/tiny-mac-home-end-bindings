import SwiftUI
import KeyBindingCore

struct SettingsView: View {
    let service: KeyBindingService
    
    @State private var homeAction: KeyAction = .moveToBeginningOfLine
    @State private var endAction: KeyAction = .moveToEndOfLine
    @State private var useCommandModifier = false
    @State private var showBackups = false
    @State private var backups: [URL] = []
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Header
            Text("Key Binding Configuration")
                .font(.title2)
                .fontWeight(.bold)
            
            Divider()
            
            // Basic Home/End behavior
            VStack(alignment: .leading, spacing: 12) {
                Text("Basic Behavior")
                    .font(.headline)
                
                Picker("Home key:", selection: $homeAction) {
                    Text("Beginning of Line (Windows-like)").tag(KeyAction.moveToBeginningOfLine)
                    Text("Beginning of Paragraph (macOS)").tag(KeyAction.moveToBeginningOfParagraph)
                }
                .pickerStyle(.radioGroup)
                
                Picker("End key:", selection: $endAction) {
                    Text("End of Line (Windows-like)").tag(KeyAction.moveToEndOfLine)
                    Text("End of Paragraph (macOS)").tag(KeyAction.moveToEndOfParagraph)
                }
                .pickerStyle(.radioGroup)
            }
            
            Divider()
            
            // Modifier preference
            VStack(alignment: .leading, spacing: 8) {
                Text("Document Navigation Modifier")
                    .font(.headline)
                
                Toggle("Use ⌘ (Command) instead of ⌃ (Control)", isOn: $useCommandModifier)
                    .help("Some apps work better with Command key for document navigation")
            }
            
            Divider()
            
            // Backups section
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Backups")
                        .font(.headline)
                    Spacer()
                    Button("View Backups") {
                        loadBackups()
                        showBackups.toggle()
                    }
                }
                
                if showBackups && !backups.isEmpty {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 4) {
                            ForEach(backups, id: \.self) { backup in
                                HStack {
                                    Text(backup.lastPathComponent)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    Spacer()
                                    Button("Restore") {
                                        restoreBackup(backup)
                                    }
                                    .buttonStyle(.link)
                                }
                            }
                        }
                    }
                    .frame(height: 100)
                }
            }
            
            Spacer()
            
            // Apply button
            HStack {
                Spacer()
                Button("Apply Changes") {
                    applyConfiguration()
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
        .frame(width: 500, height: 400)
        .alert("Settings", isPresented: $showAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
    }
    
    private func loadBackups() {
        backups = (try? service.listBackups()) ?? []
    }
    
    private func applyConfiguration() {
        let config = KeyBindingConfiguration(
            homeAction: homeAction,
            endAction: endAction,
            shiftHomeAction: homeAction == .moveToBeginningOfLine 
                ? .moveToBeginningOfLineAndModifySelection 
                : .moveToBeginningOfParagraphAndModifySelection,
            shiftEndAction: endAction == .moveToEndOfLine 
                ? .moveToEndOfLineAndModifySelection 
                : .moveToEndOfParagraphAndModifySelection,
            ctrlHomeAction: .moveToBeginningOfDocument,
            ctrlEndAction: .moveToEndOfDocument,
            ctrlShiftHomeAction: .moveToBeginningOfDocumentAndModifySelection,
            ctrlShiftEndAction: .moveToEndOfDocumentAndModifySelection,
            useCommandModifier: useCommandModifier
        )
        
        do {
            try service.applyConfiguration(config, merge: true)
            alertMessage = "Configuration applied successfully!\n\nRestart your applications to see the changes."
            showAlert = true
        } catch {
            alertMessage = "Error applying configuration: \(error.localizedDescription)"
            showAlert = true
        }
    }
    
    private func restoreBackup(_ backup: URL) {
        do {
            try service.restoreFromBackup(backup)
            alertMessage = "Backup restored successfully!"
            showAlert = true
        } catch {
            alertMessage = "Error restoring backup: \(error.localizedDescription)"
            showAlert = true
        }
    }
}

#Preview {
    SettingsView(service: KeyBindingService())
}
