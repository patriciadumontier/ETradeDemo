import SwiftUI

struct ChatView: View {
    @StateObject var viewModel = ChatVM()

    var body: some View {
        VStack {
            List(viewModel.messages) { message in
                HStack {
                    Text(message.text)
                        .padding()
                        .background(Color.secondary.opacity(0.1))
                        .cornerRadius(8)
                    Spacer()
                    Text(message.timestamp, style: .time)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            HStack {
                TextField("Enter message", text: $viewModel.currentText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: viewModel.sendMessage) {
                    Text("Send")
                }
                .disabled(viewModel.currentText.isEmpty || !viewModel.isConnected)
            }
            .padding()
        }
        .navigationTitle("Chat Room")
        .onAppear {
            viewModel.connect()
        }
        .onDisappear {
            viewModel.disconnect()
        }
    }
}
