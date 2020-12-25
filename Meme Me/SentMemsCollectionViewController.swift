//
//  SentMemsCollectionCollectionViewController.swift
//  Meme Me
//
//  Created by user on 23/12/2020.
//

import UIKit

class SentMemsCollectionViewController: UICollectionViewController, NewMemDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var flowLayout:UICollectionViewFlowLayout!
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        collectionView.reloadData()
    }
    
    @objc func startOver(){
        
        let memeEditorViewController = storyboard?.instantiateViewController(identifier: "MemeEditorViewController")as! MemeEditorViewController
        
        memeEditorViewController.newMemDelegate = self
        
        present(memeEditorViewController, animated: true, completion: nil)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sentMemsCollectionViewCell", for: indexPath) as! SentMemesCollectionViewCell
        
        let meme = self.memes[indexPath.row]
    
        cell.memeImageView.image = meme.memedImage
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let numberOfCellsPerRow: CGFloat = 3
        
        let horizontalSpacing = flowLayout.scrollDirection == .vertical ? flowLayout.minimumInteritemSpacing : flowLayout.minimumLineSpacing
        
        
        let cellWidth = (view.frame.width - max(0, numberOfCellsPerRow - 1)*horizontalSpacing)/numberOfCellsPerRow
        
        
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "collectionViewDetail", sender: memes[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "collectionViewDetail" {
            let sentMemsViewController = segue.destination as! SentMemsViewController
            sentMemsViewController.meme = sender as? Meme
        }
    }
    
    func newMemAdded() {
        collectionView.reloadData()
    }
}
