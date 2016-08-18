//
//  PrizeMathTabBarController.swift
//  Prize Math
//
//  Created by Mark Eaton on 2/1/16.
//  Copyright © 2016 Eaton Productions. All rights reserved.
//

import UIKit

class PrizeMathTabBarController: UITabBarController, UITabBarControllerDelegate{

    let userDefaults = NSUserDefaults.standardUserDefaults()
    let colors = Colors()
    var selectedTheme = Theme()
    var tabProgressBar: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        
        //Add Progress Bar
        
        //Progress Bar
        
        tabProgressBar = UIProgressView(frame: CGRect.zero)
        tabProgressBar.frame = CGRect(x: 0.0, y: self.tabBar.bounds.minY - 2.0, width: self.tabBar.bounds.width, height: 2.0)
        tabProgressBar!.trackTintColor = UIColor.clearColor()
        tabProgressBar!.progressTintColor = colors.primaryColor[0]
        
        self.tabBar.addSubview(tabProgressBar!)
        
        getUserDefaults()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(false)
        
        self.tabBar.barStyle = .Black
        //self.tabBar.translucent = false
        //self.tabBar.barTintColor = UIColor.clearColor()
        //self.tabBar.backgroundImage = UIImage()
        self.tabBar.tintColor = UIColor.whiteColor()
            
            
//            self.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
//            self.navigationBar.shadowImage = UIImage()
//            self.navigationBar.backgroundColor = UIColor.clearColor()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    func getUserDefaults(){
        

    }
}
