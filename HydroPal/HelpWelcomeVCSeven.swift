//
//  HelpWelcomeVCSeven.swift
//  Hydropal
//
//  Created by Cheuk Lun Ko on 8/12/2016.
//  Copyright © 2016 HydroPal. All rights reserved.
//

import UIKit

class HelpWelcomeVCSeven: UIViewController {
    
    var shouldHide = false

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        shouldHide = true
        UIView.animate(withDuration: 0.3) { () -> Void in
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func backSleepTime(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func backHome(_ sender: Any) {
        defaults.set(true, forKey: "launchedBefore")
        
        let homeView = storyboard?.instantiateViewController(withIdentifier: "homeView") as! HomeViewController
        self.view.window!.rootViewController? = homeView
        self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
        //FIXME: Animation failing
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .fade
    }
    
    override var prefersStatusBarHidden : Bool {
        return shouldHide
    }
}
