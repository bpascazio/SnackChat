//
//  ViewController.swift
//  SnackChat
//
//  Created by Bob Pascazio on 12/10/15.
//  Copyright © 2015 Pace. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {

    @IBOutlet weak var imagePreview: UIImageView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func takeAPic(sender: AnyObject) {
        
        let image = UIImage(named: "Photo")
        let png = UIImageJPEGRepresentation(image!, 0.1)
        imagePreview.image = image
        
        // Send pic up to parse.
        let pics = PFObject(className: "Pics")
        pics.setObject("Bob", forKey: "Name")
        pics.setObject(png!, forKey: "ImageData")
        pics.saveInBackgroundWithBlock { (succeeded, error) -> Void in
            if succeeded {
                print("Object Uploaded")
            } else {
                print("Error: \(error)")
            }
        }
    }

}

