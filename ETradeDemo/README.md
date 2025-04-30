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
### Chat server
```
## Initialize npm & install Socket.IO
```
npm init -y
npm install socket.io
```
## Run the Chat server
```
npm install -g ngrok
ngrok http 3000
```
## Interpreting the Socket.IO Console Logs
When you enable `.log(true)` in your `SocketManager` config, you’ll see detailed lifecycle and message flows in the console. Here’s what each line means:

```
LOG SocketEngine: Got message: 2
```
- **Engine frame type 2** indicates the Socket.IO engine received an **‘upgrade’** or **‘ping’** packet. It’s part of the heartbeat and transport negotiation.

```
LOG SocketEngine: Writing ws:  has data: false
```
- The engine is writing an outgoing WebSocket frame. The empty payload (`has data: false`) is usually the ping response.

```
LOG SocketIOClient{/}: Handling event: ping with data: []
```
- At the Socket.IO layer, a **ping** event arrived. The client responds automatically with a **pong** under the hood.

```
LOG SocketEngineWebSocket: Sending ws:  as type: 3
```
- A WebSocket **pong** frame (type 3) is sent back to keep the connection alive.

```
LOG SocketIOClient{/}: Emitting: 2["message",{...}], Ack: false
```
- Your app called `socket.emit("message", payload)` before; this log shows the raw packet being sent.
- The leading `2` is the packet type (**MESSAGE**), followed by the JSON array containing the event name and payload.

```
LOG SocketEngineWebSocket: Sending ws: 2["message",{...}] as type: 4
```
- The WebSocket frame (type 4) carries your **MESSAGE** packet to the server.

```
LOG SocketIOClient{/}: Handling event: message with data: [{...}]
```
- The client received a **message** event, with the same data structure you emitted. Your Node server echos it back.

### Packet Types at a Glance
- **2** = MESSAGE (Socket.IO level packet)  
- **3** = PONG (WebSocket level, in response to ping)  
- **4** = MESSAGE (WebSocket frame carrying a Socket.IO message)  

### Why You See Repeats
- **Regular pings** every few seconds keep the connection alive.  
- Your **Echo** server immediately sends back any `message` you emit, so you see the incoming and outgoing logs side‑by‑side.

This granular logging helps you diagnose connection health, transport upgrades, heartbeats, and the exact JSON payloads on each send/receive. You can disable it in production by removing `.log(true)` or setting it to `false`.
