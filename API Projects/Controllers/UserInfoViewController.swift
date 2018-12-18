//
//  UserInfoViewController.swift
//  API Projects
//
//  Created by Gabriel Blaine Palmer on 12/18/18.
//  Copyright © 2018 Gabriel Blaine Palmer. All rights reserved.
//

import UIKit

class UserInfoViewController: UIViewController {
    
    @IBOutlet weak var pictureView: UIImageView!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    var user: RandomUser?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = user {
            navigationItem.title = user.firstName + " " + user.lastName
            
            genderLabel.text = "Gender: \(user.gender)"
            ageLabel.text = "Age: \(user.age)"
            addressLabel.text = user.address
            loadPicture()
            
        }
    }
    
    fileprivate func loadPicture() {
        guard let user = user else { return }
        
        URLSession.shared.dataTask(with: URL(string: user.pictureURL)!) { (data, response, error) in
            if let data = data, let image = UIImage(data: data) {
                
                DispatchQueue.main.async {
                    self.pictureView.image = image
                }
                
            } else {
                print("Failed to retrieve image")
                print("ERROR: \(error!)")
            }
            }.resume()
    }

}
