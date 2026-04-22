import SwiftUI

struct AboutView: View {
    var body: some View {
        VStack(spacing: 20) {
            // App Icon placeholder
            Image(systemName: "keyboard")
                .font(.system(size: 64))
                .foregroundColor(.accentColor)
            
            // App name and version
            Text("Tiny Home/End")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Version 1.0.0")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Divider()
                .padding(.horizontal, 40)
            
            // Description
            VStack(spacing: 8) {
                Text("Windows-like Home/End key behavior for macOS")
                    .font(.body)
                    .multilineTextAlignment(.center)
                
                Text("Makes Home/End keys behave like they do on Windows")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            Divider()
                .padding(.horizontal, 40)
            
            // Links
            VStack(spacing: 12) {
                Link(destination: URL(string: "https://github.com/adenearnshaw/tiny-mac-home-end-bindings")!) {
                    HStack {
                        Image(systemName: "link")
                        Text("View on GitHub")
                    }
                }
                
                // Placeholder for Buy Me a Coffee (future)
                /*
                Link(destination: URL(string: "https://buymeacoffee.com/...")!) {
                    HStack {
                        Image(systemName: "cup.and.saucer")
                        Text("Buy Me a Coffee")
                    }
                }
                */
            }
            
            Spacer()
            
            // License
            VStack(spacing: 4) {
                Text("Licensed under MIT License")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                
                Text("© 2026 Aden Earnshaw")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .frame(width: 400, height: 350)
    }
}

#Preview {
    AboutView()
}
