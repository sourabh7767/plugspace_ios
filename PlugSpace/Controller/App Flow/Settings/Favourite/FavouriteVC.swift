//
//  FavouriteVC.swift
//  PlugSpace
//
//  Created by MAC on 03/12/21.
//

import UIKit

class FavouriteVC: BaseVC {

    //MARK:- Outlets
        
    @IBOutlet weak var clvFavourite:UICollectionView!
    
    //MARK:- Properties
    
    var viewModel = FavouriteVM()
    
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    //AMRK:- Method

    func setUpUI() {
        
        clvFavourite.contentInset.top = 10
        clvFavourite.register(UINib(nibName: "FavouriteCVCell", bundle: nil), forCellWithReuseIdentifier: "FavouriteCVCell")
        clvFavourite.delegate = self
        clvFavourite.dataSource = self
        viewModel.indexpath = IndexPath(row: 0, section: 0)
        clvFavourite.reloadData()
    }
    
    //MARK:- IBAction
    
    @IBAction func btnback(_ sender:UIButton) {
        backVC()
    }
}

//MARK:- CollectionView

extension FavouriteVC: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.musicArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeCell(FavouriteCVCell.self, indexPath: indexPath)
        cell.setData(musicName: viewModel.musicArr[indexPath.row])
        
        if let ipath = viewModel.indexpath {
            
            ipath == indexPath ? cell.setOrangeShadow(image: viewModel.musicArrSelectedimg[indexPath.row]) : cell.setBlackShadow(image: viewModel.musicArrDeselectedimg[indexPath.row])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (collectionView.frame.size.width - 10) / 2
        return CGSize(width: width, height: width - 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        viewModel.indexpath = indexPath
        clvFavourite.reloadData()
        let vc = UIStoryboard.instantiateVC(MusicNameVC.self, .Home)
        vc.songTitle = viewModel.musicArr[indexPath.row]
        vc.viewModel.musicType = viewModel.musicTypeArr[indexPath.row]
        vc.viewModel.otherUserId = viewModel.userID
        navigationController?.pushViewController(vc, animated: true)
    }
}
