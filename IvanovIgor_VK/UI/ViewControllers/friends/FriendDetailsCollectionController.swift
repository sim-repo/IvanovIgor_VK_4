//
//  FriendDetailCollectionVC.swift
//  IvanovIgor_VK
//
//  Created by MAC on 25.09.2018.
//  Copyright © 2018 com.home. All rights reserved.
//

import UIKit



class FriendDetailsCollectionController: UICollectionViewController {

    
    var friend: MyFriend?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendDetailsCollectionCell", for: indexPath) as! FriendDetailsCollectionCell
            if let friend = friend {
                cell.friendPhotoImageView.image = friend.image200
                cell.firstNameLabel.text = friend.firstName
                cell.lastNameLabel.text = friend.lastName
            }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as! FriendPhotosCollectionController
        dest.friend = friend
    }
    

//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendDetailsCollectionCell", for: indexPath) as? FriendDetailsCollectionCell{
//            
//            if let friend = friend {
//                cell.friendPhotoLabel.text = friend.profilePicture
//            }
//        }
//        return UICollectionViewCell()
//    }

}


extension FriendDetailsCollectionController: FriendDetailsDelegate {
    func prepareForRun(with friend: MyFriend) {
        self.friend = friend
    }
}
