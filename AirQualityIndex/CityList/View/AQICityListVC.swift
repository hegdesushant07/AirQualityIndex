//
//  AQICityListVC.swift
//  AirQualityIndex
//
//  Created by Sushant Hegde on 19/08/21.
//

import UIKit

class AQICityListVC: BaseVC {
    
    @IBOutlet weak var cityAqiTblVw: UITableView!
    private let urlStr = WebSocketUrlConstants.cityAqiList
    var aqiCityListVwModel : AqiCityListViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "City AQI List"

        // Do any additional setup after loading the view.
        self.viewModelSetup()
        self.tblVwSetup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.socketConnection()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.disconnectsocket()
    }

}

extension AQICityListVC{
    
    func viewModelSetup(){
        self.aqiCityListVwModel = AqiCityListViewModel()
        self.aqiCityListVwModel?.aqiCityListVC = self
        self.aqiCityListVwModel?.completionHandler = {
            self.reloadTableViewAsync(tableVw: self.cityAqiTblVw)
        }
    }
    
    func tblVwSetup(){
        self.cityAqiTblVw.delegate = self.aqiCityListVwModel
        self.cityAqiTblVw.dataSource = self.aqiCityListVwModel
        self.cityAqiTblVw.removeFooterViewLine()
    }
}

//MARK:- Socket Connction
extension AQICityListVC{
    
    func socketConnection(){
        self.connectToSocket(urlStr: self.urlStr,timeInterval: 0.0)
        self.webSocketConnection.delegate = aqiCityListVwModel
    }
    
    func disconnectsocket(){
        self.webSocketConnection.disconnect()
        self.webSocketConnection = nil
    }
    
}

extension AQICityListVC:AqiCityListDelegate{
    func update() {
        
    }
}





