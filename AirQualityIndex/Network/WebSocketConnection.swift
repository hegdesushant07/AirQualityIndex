//
//  NetworkLayer.swift
//  AirQualityIndex
//
//  Created by Sushant Hegde on 19/08/21.
//

import Foundation

//MARK:- Protocol for Socket connection
protocol WebSocketConnection {
    func send(text: String)
    func connect()
    func disconnect()
    var delegate: WebSocketConnectionDelegate? { get set }
}

//MARK:- Protocol To get the Socket Update Details
protocol WebSocketConnectionDelegate {
    func onConnected(connection: WebSocketConnection)
    func onDisconnected(connection: WebSocketConnection, error: Error?)
    func onError(connection: WebSocketConnection, error: Error)
    func onMessage(connection: WebSocketConnection, text: String)
    func onMessage(connection: WebSocketConnection, data: Data)
}

//MARK:- Socket Connection Class for reciveing data
class WebSocketTaskConnection: NSObject, WebSocketConnection{
    
    var webSocketTask: URLSessionWebSocketTask!
    var delegate: WebSocketConnectionDelegate?
    var urlSession: URLSession!
    var timeInterval : Double = 1.0
    
    init(url: URL,timeInterval: Double) {
        super.init()
        urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        webSocketTask = urlSession.webSocketTask(with: url)
        self.timeInterval = timeInterval
    }
    
}

//MARK:- Socket Data Updtes functions
extension WebSocketTaskConnection{
    
    func listen(){
        webSocketTask.receive { result in
            switch result{
            case .failure(let error):
                self.delegate?.onError(connection: self, error: error)
            case .success(let message):
                switch message {
                case .string(let text):
                    self.delegate?.onMessage(connection: self, text: text)
                case .data(let data):
                    self.delegate?.onMessage(connection: self, data: data)
                @unknown default:
                    //fatalError()
                    debugPrint("Web socket Msg failed case : \(message)")
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + self.timeInterval) {
                self.listen()
            }
        }
    }
    
    func send(text: String) {
        webSocketTask.send(URLSessionWebSocketTask.Message.string(text)) { (error) in
            if let error = error{
                self.delegate?.onError(connection: self, error: error)
            }
        }
    }
    
}


//MARK:- Connecting and Disconnecting the Socket
extension WebSocketTaskConnection{
    
    func connect() {
        webSocketTask.resume()
        self.listen()
    }
    
    func disconnect() {
        webSocketTask.cancel(with: .goingAway, reason: nil)
    }
    
}


//MARK:- Delegate functions of URLSessionWebSocketDelegate
extension WebSocketTaskConnection: URLSessionWebSocketDelegate{
    
    //
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        self.delegate?.onConnected(connection: self)
    }
    
    //
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        self.delegate?.onDisconnected(connection: self, error: nil)
    }
        
}
