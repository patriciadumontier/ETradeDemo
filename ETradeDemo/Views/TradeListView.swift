import SwiftUI

public struct TradeListView: View {
    @StateObject private var vm = MarketViewModel()

    public var body: some View {
        NavigationView {
            List {
                ForEach(vm.trades) { trade in
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
            }
            .navigationTitle("Trades")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if vm.isLoading {
                        ProgressView()
                    } else {
                        Button(action: vm.loadTrades) {
                            Image(systemName: "arrow.clockwise")
                        }
                    }
                }
            }
            .onAppear { vm.loadTrades() }
            .alert(isPresented: Binding<Bool>(
                get: { vm.errorMessage != nil },
                set: { if !$0 { vm.errorMessage = nil } }
            )) {
                Alert(
                    title: Text("Error"),
                    message: Text(vm.errorMessage ?? ""),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}

