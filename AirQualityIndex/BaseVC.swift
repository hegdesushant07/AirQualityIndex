//
//  BaseVC.swift
//  AirQualityIndex
//
//  Created by Sushant Hegde on 19/08/21.
//

import UIKit

class BaseVC: UIViewController {

    var webSocketConnection: WebSocketConnection!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    //MARK:- Function to connect to Socket with url provided
    func connectToSocket(urlStr: String,timeInterval: Double){
        webSocketConnection = WebSocketTaskConnection(url: URL(string: urlStr)!,timeInterval: timeInterval)
        webSocketConnection.connect()
    }
    
    

}
