//
//  BaseView.swift
//  SimpleChat
//
//  Created by NguyenCuong on 1/18/19.
//  Copyright © 2019 NguyenCuong. All rights reserved.
//

import UIKit
extension UIBarButtonItem
{
    func toggleMenu(screen:UIViewController)
    {
        self.target = screen.revealViewController()
        self.action = #selector(SWRevealViewController.revealToggle(_:))
        screen.view.addGestureRecognizer(screen.revealViewController().panGestureRecognizer())
    }
}

extension UIView
{
    func Login() {
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.yellow.cgColor
    }
}

extension UIButton
{
    func skin(b:Bool)
    {
        self.titleLabel?.numberOfLines = 1;
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        self.titleLabel?.lineBreakMode = NSLineBreakMode.byClipping
        self.layer.cornerRadius = 10
        if(b)
        {
            self.layer.borderColor = UIColor.red.cgColor
            self.layer.borderWidth = 1
            self.tintColor = UIColor.red
            self.backgroundColor = UIColor.white
        }
        
    }
}

let imageCache = NSCache<NSString, UIImage>()
extension UIImageView
{
    func RoundImage() {
        //self.layer.cornerRadius = 20
        //self.clipsToBounds = true
        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = self.frame.height/2
        self.clipsToBounds = true
    }
   
    func LoadAvatar(urlString: String){
        let queue: DispatchQueue = DispatchQueue(label: "LoadImage", qos: .default, attributes: .concurrent, autoreleaseFrequency: .never, target: nil)
        let activity: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        activity.frame = CGRect(x: self.frame.size.width/2, y: self.frame.size.height/2, width: 0, height: 0)
        activity.color = UIColor.red
        self.addSubview(activity)
        activity.startAnimating()
        
        queue.async {
            let url: URL = URL(string: urlString)!
            do{
                let data: Data = try Data(contentsOf: url)
                DispatchQueue.main.async(execute: {
                    activity.stopAnimating()
                    self.image = UIImage(data: data)
                })
              
            }
            catch{
               
                activity.stopAnimating()
                print("Loi!!!1!!!!!!!!!!!!!!")
            }
            
        }
    }
}


extension Error {
    var code: Int { return (self as NSError).code }
    var domain: String { return (self as NSError).domain }
}

