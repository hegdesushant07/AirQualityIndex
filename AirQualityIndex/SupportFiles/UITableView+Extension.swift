//
//  UITableView+Extension.swift
//  AirQualityIndex
//
//  Created by Sushant Hegde on 19/08/21.
//

import Foundation
import UIKit

extension UITableView{
    
    func removeSeperatorLines(){
        self.separatorStyle = .none
    }
    
    func removeFooterViewLine(){
        self.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    func cellAutomaticDimension() -> CGFloat{
        return UITableView.automaticDimension
    }
    
    func removescrollIndicators(){
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
    }
    
}

extension UIViewController{
    
    func reloadTableViewAsync(tableVw: UITableView){
        DispatchQueue.main.async {
            tableVw.reloadData()
        }
    }
    
    func reloadTableViewAsyncAfter(tableVw: UITableView, time: TimeInterval){
        DispatchQueue.main.asyncAfter(deadline: .now() + time) {
            tableVw.reloadData()
        }
    }
    
}
