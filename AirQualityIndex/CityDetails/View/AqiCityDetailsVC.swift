//
//  AqiCityDetailsVC.swift
//  AirQualityIndex
//
//  Created by Sushant Hegde on 19/08/21.
//

import UIKit
import DSFSparkline

class AqiCityDetailsVC: BaseVC {
    
    @IBOutlet weak var aqiLbl: UILabel!
    @IBOutlet var sparkLineGraph: DSFSparklineLineGraphView!
    @IBOutlet weak var attributedStringSupportLabel: UILabel!
    
    private let urlStr = WebSocketUrlConstants.cityAqiList
    private var aqiCityVwModel : AqiCityListViewModel?
    var selectedCity : AQICity!
    var selectedCityDetails : CityAQIDetails!
    
    // Graph
    var sparkDS = DSFSparkline.DataSource(windowSize: 25, range: 0 ... 500)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = selectedCityDetails?.city.name
        
        self.viewModelSetup()
        self.graphSetup()
        self.configureAttributedString()
        self.updateAqi()
        
        // Do any additional setup after loading the view.
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

extension AqiCityDetailsVC{
    
    func viewModelSetup(){
        self.aqiCityVwModel = AqiCityListViewModel()
        self.aqiCityVwModel?.completionHandler = {
            if let aqiObj = self.aqiCityVwModel?.getCityAqiDetails(city: self.selectedCity){
                self.selectedCityDetails = aqiObj
                self.updateAqi()
            }
        }
    }
    
    func updateAqi(){
        DispatchQueue.main.async {
            self.aqiLbl.text = "\(self.selectedCityDetails.aqiUpto2Decimal)"
            self.view.backgroundColor = self.aqiCityVwModel?.returnTextColor(aqi: self.selectedCityDetails.aqiUpto2Decimal)
            self.addNewValue2(newValue: CGFloat(self.selectedCityDetails.aqiUpto2Decimal))
        }
    }
}

//MARK:- Socket Connction
extension AqiCityDetailsVC{
    
    func socketConnection(){
        self.connectToSocket(urlStr: self.urlStr,timeInterval: 0.0)
        self.webSocketConnection.connect()
        self.webSocketConnection.delegate = aqiCityVwModel
        //webSocketConnection.send(text: "ping")
    }
    
    func disconnectsocket(){
        self.webSocketConnection.disconnect()
        self.webSocketConnection = nil
    }
    
}

extension AqiCityDetailsVC{
    
    func graphSetup(){
        self.sparkLineGraph.backgroundColor = .clear
        self.sparkLineGraph.dataSource = sparkDS
        self.sparkDS.zeroLineValue = 0
    }
    
    func addNewValue2(newValue: CGFloat) {
        DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
            guard let `self` = self else {
                return
            }
            self.sparkDS.push(value: newValue)
        }
    }
    
    
}


extension AqiCityDetailsVC{
    
    func configureAttributedString() {
        let source = DSFSparkline.DataSource(values: [4, 1, 8, 7, 5, 9, 3], range: 0 ... 10)

        let baseColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [0.033,  0.277, 0.650, 1.000])!
        let primaryStroke = baseColor // (gray: 0.0, alpha: 0.3))
        let primaryFill = DSFSparkline.Fill.Color(baseColor.copy(alpha: 0.3)!)

        let bitmap = DSFSparklineSurface.Bitmap()   // Create a bitmap surface
        let line = DSFSparklineOverlay.Line()       // Create a line overlay
        line.strokeWidth = 1
        line.primaryStrokeColor = primaryStroke
        line.primaryFill = primaryFill
        line.dataSource = source                    // Assign the datasource to the overlay
        bitmap.addOverlay(line)                     // And add the overlay to the surface.

        let attr = bitmap.attributedString(size: CGSize(width: 40, height: 18), scale: 2)!
        let message = NSMutableAttributedString(string: "Inlined ")
        message.append(attr)
        message.append(NSAttributedString(string: " line graph"))

        self.attributedStringSupportLabel.attributedText = message
    }
    
}
