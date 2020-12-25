//
//  SentMemsViewController.swift
//  Meme Me
//
//  Created by user on 25/12/2020.
//

import UIKit

class SentMemsViewController: UIViewController {
    
    var meme:Meme?

    @IBOutlet weak var memeImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let meme = meme {
            memeImageView.image = meme.memedImage
        }
    }
}
