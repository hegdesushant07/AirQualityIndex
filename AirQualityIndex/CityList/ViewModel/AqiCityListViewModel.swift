//
//  AqiCityViewModel.swift
//  AirQualityIndex
//
//  Created by Sushant Hegde on 19/08/21.
//

import Foundation
import UIKit

protocol AqiCityListDelegate : class{
    func update()
}

class AqiCityListViewModel: NSObject {
    
    var citylist = [AQICity](){
        didSet{
            debugPrint("cityList updated")
            completionHandler()
        }
    }
    
    var aqiDetails = [AQICity:CityAQIDetails]()
    var completionHandler = { () -> () in }
    weak var aqiCityListVC: AQICityListVC?
    weak var delegate : AqiCityListDelegate?
    private var isConnected : Bool = false

}

//MARK:-  WebSocketConnectionDelegate Delegate Functions
extension AqiCityListViewModel: WebSocketConnectionDelegate{
    
    func onConnected(connection: WebSocketConnection) {
        self.isConnected = true
        debugPrint("connected")
    }
    
    func onDisconnected(connection: WebSocketConnection, error: Error?) {
        self.isConnected = false
        if let error = error {
            debugPrint("Disconnected with error:\(error)")
        } else {
            debugPrint("Disconnected normally")
        }
    }
    
    func onError(connection: WebSocketConnection, error: Error) {
        debugPrint("Connection error:\(error)")
    }
    
    func onMessage(connection: WebSocketConnection, text: String) {
        debugPrint("Text message received")
        self.getParsedData(text: text)
        DispatchQueue.main.asyncAfter(deadline: .now() + 30) {
            self.delegate?.update()
        }
    }
    
    func onMessage(connection: WebSocketConnection, data: Data) {
        debugPrint("Data message: \(data)")
    }
}

extension AqiCityListViewModel{
    
    //MARK:- Parse received websocket data
    func getParsedData(text: String){
        let arr = text.parseData
        guard let cityArr = arr else {
            debugPrint("cityarr is empty")
            return
        }
        debugPrint(cityArr)
        self.updateCityList(cityArr: cityArr)
    }
    
    //MARK:- Update City And its AQI data
    func updateCityList(cityArr: [StringAnyDict]){
        debugPrint("updateCityList func called")
        for cityDict in cityArr{
            if let cityName = cityDict["city"] as? String{
                let aqiCityObj = AQICity(name: cityName)
                if !(self.citylist.contains(aqiCityObj)){
                    self.citylist.append(aqiCityObj)
                }
                if let aqi = cityDict["aqi"] as? Double{
                    let aqiDetailsObj = CityAQIDetails(city: aqiCityObj, aqi: aqi)
                    self.aqiDetails[aqiCityObj] = aqiDetailsObj
                }
            }
        }
        self.citylist.sort(by: { $0.name < $1.name })
    }
    
}

//MARK:- Tableview delegate functions
extension AqiCityListViewModel: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.citylist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AQITblVCell
        cell.parentVC = self.aqiCityListVC
        if let aqiObj = getCityAqiDetails(city: getCityObj(indexpath: indexPath)){
            cell.updateData(cityDetails: aqiObj)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let aqiDetailVc = UIStoryboard.init(name: StoryBoardConstants.AqiCityDetails, bundle: nil).instantiateViewController(withIdentifier: VCName.AqiCityDetailsVC) as! AqiCityDetailsVC
        aqiDetailVc.selectedCity = getCityObj(indexpath: indexPath)
        if let aqiObj = getCityAqiDetails(city: aqiDetailVc.selectedCity){
            aqiDetailVc.selectedCityDetails = aqiObj
        }
        self.aqiCityListVC?.navigationController?.pushViewController(aqiDetailVc, animated: true)
    }
}

extension AqiCityListViewModel{
    
    func getCityObj(indexpath: IndexPath) -> AQICity{
        if let city = self.citylist[indexpath.row] as AQICity?{
            return city
        }
    }
    func getCityAqiDetails(city: AQICity) -> CityAQIDetails?{
        return self.aqiDetails[city]
    }
    
    func returnTextColor(aqi: Double) -> UIColor{
        switch aqi {
            case let aqi where aqi >= 0 && aqi <= 50: return UIColor.aqiGoodColor
            case let aqi where aqi > 50 && aqi <= 100: return UIColor.aqiSatisfactoryColor
            case let aqi where aqi > 100 && aqi <= 200: return UIColor.aqiModerateColor
            case let aqi where aqi > 200 && aqi <= 300: return UIColor.aqiPoorColor
            case let aqi where aqi > 300 && aqi <= 400: return UIColor.aqiVpoorColor
            case let aqi where aqi > 400 && aqi <= 500: return UIColor.aqiSevereColor
            default: return UIColor.black
        }
    }
    
}
    
