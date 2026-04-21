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
            HStack {
                Image(systemName: "keyboard.fill")
                    .font(.title)
                    .foregroundColor(.accentColor)
                Text("Key Binding Configuration")
                    .font(.title2)
                    .fontWeight(.bold)
            }
            
            Divider()
            
            // Basic Home/End behavior
            GroupBox(label: Label("Basic Behavior", systemImage: "arrow.left.arrow.right")) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Choose how Home and End keys behave:")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Picker("Home key:", selection: $homeAction) {
                        Text("Beginning of Line (Windows-like) ⌘").tag(KeyAction.moveToBeginningOfLine)
                        Text("Beginning of Paragraph (macOS)").tag(KeyAction.moveToBeginningOfParagraph)
                    }
                    .pickerStyle(.radioGroup)
                    
                    Picker("End key:", selection: $endAction) {
                        Text("End of Line (Windows-like) ⌘").tag(KeyAction.moveToEndOfLine)
                        Text("End of Paragraph (macOS)").tag(KeyAction.moveToEndOfParagraph)
                    }
                    .pickerStyle(.radioGroup)
                }
                .padding(8)
            }
            
            // Modifier preference
            GroupBox(label: Label("Document Navigation", systemImage: "doc.text")) {
                VStack(alignment: .leading, spacing: 8) {
                    Toggle("Use ⌘ Command instead of ⌃ Control", isOn: $useCommandModifier)
                        .help("Some apps work better with Command key for document navigation (Ctrl+Home/End)")
                    
                    Text("For Ctrl+Home and Ctrl+End to jump to document start/end")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(8)
            }
            
            // Backups section
            GroupBox(label: Label("Backups", systemImage: "clock.arrow.circlepath")) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Your original keybindings are safely backed up")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Spacer()
                        Button(showBackups ? "Hide" : "View") {
                            if !showBackups {
                                loadBackups()
                            }
                            showBackups.toggle()
                        }
                        .buttonStyle(.borderless)
                    }
                    
                    if showBackups {
                        if backups.isEmpty {
                            Text("No backups yet")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .padding(.vertical, 4)
                        } else {
                            ScrollView {
                                VStack(alignment: .leading, spacing: 6) {
                                    ForEach(backups, id: \.self) { backup in
                                        HStack {
                                            Image(systemName: "doc.badge.clock")
                                                .foregroundColor(.secondary)
                                            Text(formatBackupName(backup))
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                            Spacer()
                                            Button("Restore") {
                                                restoreBackup(backup)
                                            }
                                            .buttonStyle(.link)
                                            .font(.caption)
                                        }
                                        .padding(.vertical, 2)
                                    }
                                }
                            }
                            .frame(height: 80)
                        }
                    }
                }
                .padding(8)
            }
            
            Spacer()
            
            // Apply button
            HStack {
                Text("⚠️ Restart applications after applying changes")
                    .font(.caption)
                    .foregroundColor(.orange)
                Spacer()
                Button("Apply Changes") {
                    applyConfiguration()
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
            }
        }
        .padding()
        .frame(width: 550, height: 500)
        .alert("Settings", isPresented: $showAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
    }
    
    private func formatBackupName(_ url: URL) -> String {
        let name = url.lastPathComponent
        // Extract timestamp from filename
        if let range = name.range(of: #"(\d{4}-\d{2}-\d{2}T\d{2}-\d{2}-\d{2})"#, options: .regularExpression) {
            let timestamp = String(name[range])
            let formatted = timestamp.replacingOccurrences(of: "T", with: " at ")
                .replacingOccurrences(of: "-", with: ":")
            return formatted
        }
        return name
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
