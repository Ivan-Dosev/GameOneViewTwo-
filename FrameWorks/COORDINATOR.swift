//
//  COORDINATOR2.swift
//  CustomNotificationTrial
//
//  Created by Ivan Dosev Dimitrov on 6.10.20.
//  Copyright © 2020 Ivan Dosev Dimitrov. All rights reserved.
//

import UIKit
import GoogleMobileAds
import SwiftUI


final class Rewarded: NSObject, GADRewardedAdDelegate{
    
    var rewardedAd:GADRewardedAd = GADRewardedAd(adUnitID: "ca-app-pub-3940256099942544/1712485313")
    
   
    
    override init() {
        super.init()
//        LoadRewarded()
    }
    
    func LoadRewarded(){
        let req = GADRequest()
        self.rewardedAd.load(req)
    }
    
    func showAd(){
        if self.rewardedAd.isReady{
            let root = UIApplication.shared.windows.first?.rootViewController
            self.rewardedAd.present(fromRootViewController: root!, delegate: self)

        }
       else{
           print("Not Ready")
       }
    }
    
    func rewardedAd(_ rewardedAd: GADRewardedAd, userDidEarn reward: GADAdReward) {

    }
    
    func rewardedAdDidDismiss(_ rewardedAd: GADRewardedAd) {
        self.rewardedAd = GADRewardedAd(adUnitID: "ca-app-pub-3940256099942544/1712485313")
        print("Closed...!!!")
        LoadRewarded()
    }
}

final class PouseRewarded: NSObject, GADRewardedAdDelegate{
    
    var rewardedAd:GADRewardedAd = GADRewardedAd(adUnitID: "ca-app-pub-3940256099942544/1712485313")
    
   
    
    override init() {
        super.init()
                     LoadRewarded()
    }
    
    func LoadRewarded(){
        let req = GADRequest()
        self.rewardedAd.load(req)
    }
    
    func showAd(){
        if self.rewardedAd.isReady{
            let root = UIApplication.shared.windows.first?.rootViewController
            self.rewardedAd.present(fromRootViewController: root!, delegate: self)

        }
       else{
           print("Not Ready")
       }
    }
    
    func rewardedAd(_ rewardedAd: GADRewardedAd, userDidEarn reward: GADAdReward) {

    }
    
    func rewardedAdDidDismiss(_ rewardedAd: GADRewardedAd) {
        self.rewardedAd = GADRewardedAd(adUnitID: "ca-app-pub-3940256099942544/1712485313")
        print("Closed...!!!")
        LoadRewarded()
    }
}



