import UIKit


class FriendPhotosCollectionController: UICollectionViewController {

    var friend: MyFriend?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return friend?.photos.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendPhotosCell", for: indexPath) as! FriendPhotosCollectionCell
        cell.photoLabel.text = friend?.photos[indexPath.row] ?? ""
        cell.photoView.layer.cornerRadius = cell.photoView.frame.width / 2
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowFriendPhotoSegue", sender: indexPath)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as! FriendPhotoController
        if let indexPath = sender as? IndexPath {
            dest.photoTxt = friend?.photos[indexPath.row] ?? " "
            return
        }
        dest.photoTxt = friend?.photos[0] ?? " "
        
    }
}
