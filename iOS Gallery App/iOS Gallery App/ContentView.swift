//
//  ContentView.swift
//  iOS Gallery App
//
//  Created by Shreyas Babu on 3/23/21.
//

import SwiftUI
import Photos

class ContentView: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate
{

    var myCollectionView: UICollectionView!
    var imageArray=[UIImage]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.title = "My Photos"
        
        let layout = UICollectionViewFlowLayout()
        
        myCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        myCollectionView.delegate=self
        myCollectionView.dataSource=self
        myCollectionView.register(PhotoCell.self, forCellWithReuseIdentifier: "Cell")
        myCollectionView.backgroundColor=UIColor.systemBackground
        self.view.addSubview(myCollectionView)
        
        myCollectionView.autoresizingMask = UIView.AutoresizingMask(rawValue: UIView.AutoresizingMask.RawValue(UInt8(UIView.AutoresizingMask.flexibleWidth.rawValue) | UInt8(UIView.AutoresizingMask.flexibleHeight.rawValue)))
        
        GetPhotos()
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PhotoCell
        cell.img.image=imageArray[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let vc=ImagePreviewVC()
        vc.imgArray = self.imageArray
        vc.passedContentOffset = indexPath
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //set the size of each cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let width = collectionView.frame.width
        if (DeviceInfo.Orientation.isPortrait)
        {
           return CGSize(width: width/2 - 1, height: width/2 - 1)
        }
        else
        {
           return CGSize(width: width/4 - 1, height: width/4 - 1)
        }
    }
    
    override func viewWillLayoutSubviews()
    {
        super.viewWillLayoutSubviews()
        myCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        return 1.0
    }
    

    func GetPhotos()
    {
        imageArray = []
        
        DispatchQueue.global(qos: .background).async {

            let imgManager=PHImageManager.default()
            
            let requestOptions=PHImageRequestOptions()
            requestOptions.isSynchronous=true
            requestOptions.deliveryMode = .highQualityFormat
            
            let fetchOptions=PHFetchOptions()
            fetchOptions.sortDescriptors=[NSSortDescriptor(key:"creationDate", ascending: false)]
            
            let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)

            if (fetchResult.count > 0) {
                for i in 0..<fetchResult.count
                {
                    imgManager.requestImage(for: fetchResult.object(at: i) as PHAsset, targetSize: CGSize(width:500, height: 500),contentMode: .aspectFill, options: requestOptions, resultHandler: { (image, error) in
                        self.imageArray.append(image!)
                    })
                }
            }
            else
            {
                print("No Photos Avaliable")
            }
            print("imageArray count: \(self.imageArray.count)")
            
            DispatchQueue.main.async {

                self.myCollectionView.reloadData()
            }
        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }


}

class PhotoCell: UICollectionViewCell
{
    
    var img = UIImageView()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        img.contentMode = .scaleAspectFill
        img.clipsToBounds=true
        self.addSubview(img)
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        img.frame = self.bounds
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}
struct DeviceInfo
{
    struct Orientation
    {
        //Returns true if in LandScape orientation
        static var isLandscape: Bool
        {
            get {
                return UIDevice.current.orientation.isValidInterfaceOrientation
                    ? UIDevice.current.orientation.isLandscape
                    : UIApplication.shared.statusBarOrientation.isLandscape
            }
        }
        //Retuns true if in Portrait orientation
        static var isPortrait: Bool
        {
            get
            {
                return UIDevice.current.orientation.isValidInterfaceOrientation
                    ? UIDevice.current.orientation.isPortrait
                    : UIApplication.shared.statusBarOrientation.isPortrait
            }
        }
    }
}

