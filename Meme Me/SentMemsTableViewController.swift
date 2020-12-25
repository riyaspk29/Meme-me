//
//  SentMemsTableViewController.swift
//  Meme Me
//
//  Created by user on 22/12/2020.
//

import UIKit

class SentMemsTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NewMemDelegate {
    
    @IBOutlet weak var memesTableView: UITableView!
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Sent Memes"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(startOver))

    }
    
    override func viewWillAppear(_ animated: Bool) {
        memesTableView.reloadData()
    }
    
    @objc func startOver(){
        
        let memeEditorViewController = storyboard?.instantiateViewController(identifier: "MemeEditorViewController")as! MemeEditorViewController
        
        memeEditorViewController.newMemDelegate = self
        
        present(memeEditorViewController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sentMemsTableViewCell", for: indexPath)as! SentMemesTableViewCell
        
        let meme = self.memes[indexPath.row]
        
        cell.memeImageView.image = meme.memedImage
        cell.memeLabel.text = meme.topText
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "tableViewDetail", sender: memes[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tableViewDetail" {
            let sentMemsViewController = segue.destination as! SentMemsViewController
            sentMemsViewController.meme = sender as? Meme
        }
    }

    func newMemAdded() {
        memesTableView.reloadData()
    }
}
