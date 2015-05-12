//
//  DetailsViewController.swift
//  Details Overlay
//
//  Created by David Ruisinger on 20.04.15.
//  Copyright (c) 2015 flavordaaave. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    var descriptionText: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        descriptionLabel.text = descriptionText
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
