//
//  HelpWelcomeVCSeven.swift
//  HydroPal
//
//  Created by Cheuk Lun Ko on 8/12/2016.
//  Copyright © 2016 HydroPal. All rights reserved.
//

import UIKit

class HelpWelcomeVCSeven: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
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
    override var prefersStatusBarHidden : Bool {
        return true
    }
}
