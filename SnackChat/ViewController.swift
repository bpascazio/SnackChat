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
    var timer:NSTimer?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(animated: Bool) {
        self.timer = NSTimer(timeInterval: 1.0, target: self, selector: "updateImageTask:", userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(self.timer!, forMode: NSDefaultRunLoopMode)
    }
    
    override func viewWillDisappear(animated: Bool) {
        if let timer_ = self.timer {
            timer_.invalidate()
        }
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func takeAPic(sender: AnyObject) {
        
        let image = UIImage(named: "Photo")
        let png = UIImageJPEGRepresentation(image!, 0.5)
        imagePreview.image = image
        
        // Send pic up to parse.
        let query = PFQuery(className: "Pics")
        var pics:PFObject?
        do {
            pics = try query.getFirstObject()
        } catch _ {
            print("Error getting first object")
        }
        if let pics_ = pics {
            pics_.setObject("Bob", forKey: "Name")
            pics_.setObject(png!, forKey: "ImageData")
            pics_.saveInBackgroundWithBlock { (succeeded, error) -> Void in
                if succeeded {
                    print("Object Uploaded")
                } else {
                    print("Error: \(error)")
                }
            }
        } else {
            print("No object")
        }
    }
    
    @objc func updateImageTask(timer:NSTimer) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), { () -> Void in
            
            // Fetch from parse.
            let query = PFQuery(className: "Pics")
            var pics:PFObject?
            do {
                pics = try query.getFirstObject()
            } catch _ {
                print("Error getting first object")
            }

            // Update as necessary.
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if let pics_ = pics {
                    if pics_.objectForKey("Name") as! String != "Bob" {
                        let jpg = pics_.objectForKey("ImageData") as! NSData
                        let image = UIImage(data: jpg)
                        self.imagePreview.image = image
                    } else {
                        print("No changes")
                    }
                } else {
                    print("No object")
                }
            })
        })
    }

}

