### ETradeDemo Project Scaffold

```
     A production-ready iOS trading demo showcasing:
     1. Best design practices & usability patterns
     2. UIKit & SwiftUI
     3. Structured concurrency & GCD
     4. Combine
     5. MVVM
     6. RESTful API consumption
     7. Real-time streaming via Socket.IO
```
### Project Structure
```
     ETradeDemo/
     ├── ETradeDemo.xcodeproj
     ├── Sources/
     │   ├── Models/
     │   │   └── Trade.swift
     │   ├── Networking/
     │   │   ├── APIClient.swift
     │   │   └── ETradeService.swift
     │   ├── Streaming/
     │   │   └── SocketService.swift
     │   ├── ViewModels/
     │   │   ├── MarketViewModel.swift
     │   │   └── TradeViewModel.swift
     │   ├── Views/
     │   │   ├── UIKit/
     │   │   │   └── TradeListViewController.swift
     │   │   └── SwiftUI/
     │   │       └── MarketView.swift
     │   └── Utilities/
     │       └── Logger.swift
     └── Resources/
         └── Assets.xcassets
```
