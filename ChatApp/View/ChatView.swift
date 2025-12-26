import SwiftUI

struct ChatView: View {
    @StateObject private var viewModel = ChatViewModel()
    @State private var inputText = ""
    
    var body: some View {
        header
        chatMessages
        inputBar
    }
}

private extension ChatView {
    var header: some View {
        HStack {
            Text("Mini Chat App 🤖")
                .font(.headline)
            Spacer()
            Button {
                viewModel.clearChat()
            } label: {
                Text("Clear chat")
            }
            
        }
        .padding()
        .background(Color.white)
        .shadow(radius: 1)
    }
}

private extension ChatView {
    var chatMessages: some View {
        ScrollViewReader { proxy in
            ScrollView {
                if viewModel.messages.isEmpty {
                    VStack {
                        Text("Start a conversation")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                    }
                } else {
                    LazyVStack(spacing: 10) {
                        ForEach(viewModel.messages) { message in
                            MessageBubbleView(message: message) {
                                viewModel.retry(message: message)
                            }
                            .id(message.id)
                        }
                        
                        if viewModel.isTyping {
                            TypingIndicatorBubble()
                                .id("typing")
                        }
                    }
                    .padding()
                }
            }
            .onAppear {
                scrollToBottom(proxy)
            }
            .onChange(of: viewModel.messages.count) {
                scrollToBottom(proxy)
            }
            .onChange(of: viewModel.isTyping) {
                if viewModel.isTyping {
                    proxy.scrollTo("typing", anchor: .bottom)
                }
            }
        }
    }
}

private extension ChatView {
    var inputBar: some View {
        HStack {
            //            TextEditor(text: $inputText)
            //                .scrollContentBackground(.hidden)
            //                .frame(minHeight: 24, maxHeight: 120)
            //                .padding(8)
            //                .overlay(
            //                    RoundedRectangle(cornerRadius: 12)
            //                        .stroke(Color.gray, lineWidth: 1)
            //                )
            GrowingTextEditor(text: $inputText)
            
            Button {
                viewModel.sendMessage(text: inputText)
                inputText = ""
            } label: {
                Image(systemName: "paperplane.fill")
                    .font(.title3)
                    .foregroundColor(.blue)
            }
            .disabled(inputText.isEmpty)
        }
        .padding([.leading, .trailing, .bottom, .top], 8)
    }
}

private extension ChatView {
    private func scrollToBottom(_ proxy: ScrollViewProxy) {
        guard let lastId = viewModel.messages.last?.id else { return }
        DispatchQueue.main.async {
            proxy.scrollTo(lastId, anchor: .bottom)
        }
    }
}

#Preview {
    ChatView()
}
