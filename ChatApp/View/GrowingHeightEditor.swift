import SwiftUI

struct GrowingTextEditor: View {
    @Binding var text: String
    @State private var height: CGFloat = 36
    
    let minHeight: CGFloat = 36
    let maxHeight: CGFloat = 120
    
    var body: some View {
        ZStack(alignment: .leading) {
            
            // Placeholder
            if text.isEmpty {
                Text("Type a message...")
                    .foregroundColor(.gray)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
            }
            
            // Hidden Text for height calculation
            Text(text.isEmpty ? " " : text)
                .font(.system(size: 16))
                .lineLimit(nil)
                .padding(.horizontal, 8)
                .background(
                    GeometryReader { geo in
                        Color.clear
                            .onAppear { updateHeight(geo.size.height) }
                            .onChange(of: text) { _ ,_ in
                                updateHeight(geo.size.height)
                            }
                    }
                )
                .hidden()
            
            // actual editor
            TextEditor(text: $text)
                .scrollContentBackground(.hidden)
                .frame(height: height)
                .padding(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray, lineWidth: 1)
                )
        }
        .animation(.easeInOut(duration: 0.15), value: height)
    }
    
    private func updateHeight(_ newHeight: CGFloat) {
        let clamped = min(max(newHeight, minHeight), maxHeight)
        if height != clamped {
            height = clamped
        }
    }
}
