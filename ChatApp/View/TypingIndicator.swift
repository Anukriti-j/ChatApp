import SwiftUI

struct TypingIndicatorBubble: View {
    @State private var animate = false
    
    var body: some View {
        HStack {
            HStack(spacing: 6) {
                ForEach(0..<3) { index in
                    Circle()
                        .frame(width: 6, height: 6)
                        .opacity(animate ? 0.2 : 1)
                        .animation(
                            .easeInOut(duration: 0.6)
                            .repeatForever()
                            .delay(Double(index) * 0.2),
                            value: animate
                        )
                }
            }
            .padding(10)
            .background(Color.gray.opacity(0.3))
            .cornerRadius(16)
            
            Spacer()
        }
        .padding(.horizontal)
        .onAppear {
            animate = true
        }
    }
}

#Preview {
    TypingIndicatorBubble()
}
