//
//  SketchViewController.swift
//  JackieWWDC
//
//  Created by Mark Eaton on 11/26/15.
//  Copyright © 2015 Eaton Productions. All rights reserved.
//

import UIKit

class SketchViewController: UIViewController {

    @IBOutlet weak var drawView: DrawView!
    @IBAction func Clear(){
        
        drawView.lines = []
        drawView.setNeedsDisplay()
    }
    
    let colors = Colors()
    var colorSelection: Int?
    var nightMode: Bool = false
    
    var selectedTheme = Theme()
    var selectedThemeIndex = 0{
        didSet{
            switch selectedThemeIndex{
            case 0:
                selectedTheme = Ocean()
            case 1:
                selectedTheme = Space()
            default:
                break
            }
            selectedTheme.superview = view
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        
        userDefaults.setObject("0", forKey: UserDefaults.key.colorSelection.rawValue)
        getUserDefaults()
        updateUI()
    }
    
    func updateUI() {
        
        //Navigation Bar
        
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: colors.secondaryColor[colorSelection!]! ]
    
        //applyImageViewToBackgroundView()
    }
    
    func applyImageViewToBackgroundView(){
        
        //Set Background Image w/ blur effect
        view = UIImageView(image: UIImage(named: selectedTheme.backgroundImageName!))
        selectedTheme.superview = view
        
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: selectedTheme.backgroundImageBlurEffect))
        blurView.frame = view.bounds

        view.insertSubview(blurView, atIndex: 0)
    }
    
    //MARK: User Defaults
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    let keyColorSelection: String = "keyColorSelection"
    
    func getUserDefaults(){
        
        if let value = userDefaults.stringForKey(UserDefaults.key.colorSelection.rawValue){
            colorSelection = Int(value)!
            print(value)
        }
        
        //Selected Theme
        
        //Selected Theme Index
        selectedThemeIndex = userDefaults.integerForKey(UserDefaults.key.selectedTheme.rawValue)
    }
}


