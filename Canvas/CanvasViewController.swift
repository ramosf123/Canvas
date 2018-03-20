//
//  CanvasViewController.swift
//  Canvas
//
//  Created by Farid Ramos on 2/26/18.
//  Copyright © 2018 Farid Ramos. All rights reserved.
//

import UIKit

class CanvasViewController: UIViewController {

    @IBOutlet weak var trayView: UIView!
    var trayOriginalCenter: CGPoint!
    var trayDownOffset: CGFloat!
    var trayUp: CGPoint!
    var trayDown: CGPoint!
    var newlyCreatedFace: UIImageView!
    var newlyCreatedFaceOriginalCenter: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trayDownOffset = 180
        trayUp = trayView.center // The initial position of the tray
        trayDown = CGPoint(x: trayView.center.x ,y: trayView.center.y + trayDownOffset) // The position of the tray transposed down
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didPanTray(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        let velocity = sender.velocity(in: view)

        if sender.state == .began {
            trayOriginalCenter = trayView.center
        } else if sender.state == .changed {
            trayView.center = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y + translation.y)
        } else if sender.state == .ended {
            if velocity.y > 0{
                UIView.animate(withDuration:0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options:[] ,
                               animations: { () -> Void in
                                self.trayView.center = self.trayDown
                }, completion: nil)
            }
            else{
                UIView.animate(withDuration:0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options:[] ,
                               animations: { () -> Void in
                                self.trayView.center = self.trayUp
                }, completion: nil)
            }
        }
    }

    @IBAction func didPanFace(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)

        if sender.state == .began {
            let imageView = sender.view as! UIImageView
            newlyCreatedFace = UIImageView(image: imageView.image)
            view.addSubview(newlyCreatedFace)
            newlyCreatedFace.center = imageView.center
            newlyCreatedFace.center.y += trayView.frame.origin.y
            newlyCreatedFaceOriginalCenter = newlyCreatedFace.center
            
            UIView.animate(withDuration: 0.3, animations: {
                self.newlyCreatedFace.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            })
        } else if sender.state == .changed {
            newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)
        } else if sender.state == .ended {
            UIView.animate(withDuration: 0.4, animations: {
                self.newlyCreatedFace.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
            newlyCreatedFace.isUserInteractionEnabled = true
            let addGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(moveCanvas(sender:)))
            newlyCreatedFace.addGestureRecognizer(addGestureRecognizer)
        }
        
    }
    
    @objc func moveCanvas(sender: UIPanGestureRecognizer){
        let translation = sender.translation(in: view)
        if sender.state == .began {
            newlyCreatedFace = sender.view as! UIImageView
            newlyCreatedFaceOriginalCenter = newlyCreatedFace.center
            UIView.animate(withDuration: 0.3, animations: {
                self.newlyCreatedFace.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            })
        }
            
        else if sender.state == .changed {
            newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)
        }
            
        else if sender.state == .ended {
            UIView.animate(withDuration: 0.4, animations: {
                self.newlyCreatedFace.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }
    }
    

}
