//
//  AQITblVCell.swift
//  AirQualityIndex
//
//  Created by Sushant Hegde on 19/08/21.
//

import UIKit

class AQITblVCell: UITableViewCell {
    
    @IBOutlet weak var cityNameLbl: UILabel!
    @IBOutlet weak var aqiLbl: UILabel!
    @IBOutlet weak var timeupdateLbl: UILabel!
    
    var parentVC : AQICityListVC?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.setupUIElements()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}

extension AQITblVCell{
    
    func setupUIElements(){
        self.separatorInset = .zero
        self.selectionStyle = .none
        self.timeupdateLbl.text = ""
    }
    
    func updateData(cityDetails: CityAQIDetails){
        self.cityNameLbl.text = cityDetails.city.name
        self.aqiLbl.text = "\(cityDetails.aqiUpto2Decimal)"
        self.aqiLbl.textColor = self.parentVC?.aqiCityListVwModel?.returnTextColor(aqi: cityDetails.aqiUpto2Decimal)
        
    }
}
