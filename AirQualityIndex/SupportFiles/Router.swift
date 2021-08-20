//
//  Utilities.swift
//  AirQualityIndex
//
//  Created by Sushant Hegde on 19/08/21.
//

import Foundation
import UIKit

// MARK:- Router

struct Router{
    
    static func setAqiController(){
        let aqiListVc = UIStoryboard.init(name: StoryBoardConstants.AQICityList, bundle: nil).instantiateViewController(withIdentifier: VCName.AQICityListVC) as! AQICityListVC
        let nav = UINavigationController(rootViewController: aqiListVc)
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate
        nav.navigationBar.isHidden = false
        sceneDelegate.window?.rootViewController = nav
        sceneDelegate.window?.makeKeyAndVisible()
    }
    
}
