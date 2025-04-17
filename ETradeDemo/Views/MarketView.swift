import SwiftUI

public struct MarketView: View {
    @StateObject private var viewModel = MarketViewModel()

    public var body: some View {
        NavigationView {
            List(viewModel.trades) { trade in
                VStack(alignment: .leading) {
                    Text(trade.symbol)
                        .font(.headline)
                    Text(String(format: "Price: %.2f", trade.price))
                        .font(.subheadline)
                    Text("Qty: \(trade.quantity)")
                        .font(.caption)
                }
                .padding(.vertical, 4)
            }
            .navigationTitle("Market Trades")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if viewModel.isLoading {
                        ProgressView()
                    } else {
                        Button(action: viewModel.loadTrades) {
                            Image(systemName: "arrow.clockwise")
                        }
                    }
                }
            }
            .onAppear { viewModel.loadTrades() }
            .alert(isPresented: Binding(
                get: { viewModel.errorMessage != nil },
                set: { if !$0 { viewModel.errorMessage = nil } }
            )) {
                Alert(
                    title: Text("Error"),
                    message: Text(viewModel.errorMessage ?? ""),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}
