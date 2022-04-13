//
//  MusicNameVC.swift
//  PlugSpace
//
//  Created by MAC on 03/12/21.
//

import UIKit

class MusicNameVC: BaseVC {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var tblMusicName:UITableView!
    @IBOutlet weak var lblSongTitle:UILabel!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var viewSearch: UIView!
    
    // MARK: - Properties
    
    var viewModel = MusicNameVM()
    private var viewMusicModel = MusicVM()

    var songTitle = ""
    private var FavouriteSongViewXIB = UIView.getView(viewT: FavouriteSongView.self)
    
    // MARK: - VC Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblMusicName.register(UINib(nibName: "MusicNameTVCell", bundle: nil), forCellReuseIdentifier: "MusicNameTVCell")
        tblMusicName.delegate = self
        tblMusicName.dataSource = self
        setupUI()
        callGetFavoriteMusicAPi()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AudioPlayer.shared.pauseMp4Audio()
    }
    
    // MARK: - SetupUI
    private func setupUI() {
        
        lblSongTitle.text =  songTitle
        
    }

    //MARK:- Api Calling
    
    func callGetFavoriteMusicAPi() {
        
        viewModel.getFavoriteMusic { [self] (isSuccess) in
            NoMusicData(isSearch: false)
            isSuccess ? tblMusicName.reloadData() : alertWith(message: viewModel.errorMessage)
        }
    }
    
    func callLikeDisLikeAPi() {
        
        if viewModel.searchText.count > 0 {
            viewMusicModel.musicId = viewModel.musicTypeSearchArr[viewModel.indexPath.row].musicId
        } else {
            viewMusicModel.musicId = viewModel.musicTypeListArr[viewModel.indexPath.row].musicId
        }
        viewMusicModel.musicType = viewModel.musicType
        guard viewMusicModel.validation() else {
            alertWith(message: viewMusicModel.errorMessage)
            return
        }
        
        viewMusicModel.musicLikeDislike { [self] (isSuccess) in

            if  isSuccess {
                setData()
//                    alertWith(message: viewMusicModel.errorMessage)
               
            } else {
                alertWith(message: viewMusicModel.errorMessage)
            }
            
        }
    }
    
    func setData() {
        
        if viewModel.searchText.count > 0 {
            let obj = viewModel.musicTypeSearchArr[viewModel.indexPath.row]
            obj.isFavorite = obj.isFavorite == "0" ? "1" : "0"
    
            if let cell = self.tblMusicName.cellForRow(at: viewModel.indexPath) as? MusicNameTVCell {
                cell.imgHeart.image = obj.isFavorite == "0" ? UIImage(named: "ic_Heart") : UIImage(named: "ic_like_filed")
            }
            
        } else {
            
            let obj = viewModel.musicTypeListArr[viewModel.indexPath.row]
            obj.isFavorite = obj.isFavorite == "0" ? "1" : "0"
    
            if let cell = self.tblMusicName.cellForRow(at: viewModel.indexPath) as? MusicNameTVCell {
                cell.imgHeart.image = obj.isFavorite == "0" ? UIImage(named: "ic_Heart") : UIImage(named: "ic_like_filed")
            }
        }
    }
    
    func OpenPopUpSongs()  {
        FavouriteSongViewXIB = UIView.getView(viewT: FavouriteSongView.self)
        FavouriteSongViewXIB.btnOk.addTarget(self, action:  #selector(clickbtnOk(_:)), for: .touchUpInside)
        openXIB(XIB: FavouriteSongViewXIB)
    }
    
    private func NoMusicData(isSearch:Bool) {
        
        if isSearch {
            removeNewNoDataViewFrom(containerView: tblMusicName)
            if viewModel.musicTypeSearchArr.count == 0 {
                setNoDataFoundView(containerView: tblMusicName, text:"No \(songTitle) Found!")
            }
        } else {
            removeNewNoDataViewFrom(containerView: tblMusicName)
            if viewModel.musicTypeListArr.count == 0 {
                setNoDataFoundView(containerView: tblMusicName, text:"No \(songTitle) Found!")
            }
        }
    }
    
    private func applySearch() {
        if !viewModel.searchText.isEmptyOrWhiteSpace {
            viewModel.musicTypeSearchArr = viewModel.musicTypeListArr.filter { $0.subtitle.range(of: viewModel.searchText, options: .caseInsensitive) != nil }
            NoMusicData(isSearch:true)
            tblMusicName.reloadData()
        }
    }
  
    
    private func tapOnSearch() {
        btnSearch.tag = 1
        viewSearch.isHidden = false
        txtSearch.delegate = self
        btnSearch.setImage(UIImage(named: "ic_Close"), for: .normal)
        
        txtSearch.transform.scaledBy(x: 1, y: 1)
        UIView.animate(withDuration: 0.4, delay: 0.1, options: .allowAnimatedContent) { [self] in
            txtSearch.backgroundColor = AppColor.Orange.withAlphaComponent(0.10)
            txtSearch.setCornerRadius(10)
            txtSearch.setBlankView(10, .Left)
            txtSearch.placeholder = "Search"
            txtSearch.isHidden = false
        }
    }
    
    private func tapOnClose() {
        if !viewModel.searchText.isEmptyOrWhiteSpace {
            txtSearch.text = ""
            viewModel.searchText = ""
            btnSearch.tag = 1
        } else {
            btnSearch.tag = 0
            btnSearch.setImage(UIImage(named: "ic_search_Squre"), for: .normal)
            view.endEditing(true)
            btnSearch.isHidden = false
            txtSearch.isHidden = true
            viewSearch.isHidden = true
        }
        NoMusicData(isSearch:false)
        tblMusicName.reloadData()
    }
    
    // MARK: - IBAction
    @IBAction private func onBtnBack(_ sender: UIButton) {
     
        backVC()
    }
    
    @IBAction private func onBtnSearch(_ sender: UIButton) {
        btnSearch.tag == 0 ? tapOnSearch() : tapOnClose()
        
    }
}

//MARK:- UITableView

extension MusicNameVC:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.searchText.count > 0 {
            return viewModel.musicTypeSearchArr.count
        }
        return viewModel.musicTypeListArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeCell(MusicNameTVCell.self, indexPath: indexPath)
        
        if viewModel.searchText.count > 0 {
            cell.setData(data: viewModel.getMusicTypeSearchListData(indexPath: indexPath))
            let obj = viewModel.musicTypeSearchArr[indexPath.row]
            if let ipath = viewModel.selectedStateIndexPath {
                
                ipath == indexPath ? cell.setPlayOrPuase(isPlay: obj.isPlay) : cell.setPlayOrPuase(isPlay: false)
            }
        } else {
            cell.setData(data: viewModel.getMusicTypeListData(indexPath: indexPath))
            if let ipath = viewModel.selectedStateIndexPath {
                
                ipath == indexPath ? cell.setPlayOrPuase(isPlay: true) : cell.setPlayOrPuase(isPlay: false)
            }
        }
        
        cell.btnHeart.addTarget(self, action: #selector(clickbtn(_:)), for: .touchUpInside)
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = self.tblMusicName.cellForRow(at: indexPath) as? MusicNameTVCell {

            if viewModel.searchText.count > 0 {
                let obj = viewModel.musicTypeSearchArr[indexPath.row]
                obj.isPlay = obj.isPlay ? false : true
                obj.isPlay ? AudioPlayer.shared.playMp4Audio(videoURL: URL(string:obj.mediaUrl)!) : AudioPlayer.shared.pauseMp4Audio()
                cell.setPlayOrPuase(isPlay: obj.isPlay)
               
            } else {
                let obj = viewModel.musicTypeListArr[indexPath.row]
                obj.isPlay = obj.isPlay ? false : true
                obj.isPlay ? AudioPlayer.shared.playMp4Audio(videoURL: URL(string:obj.mediaUrl)!) : AudioPlayer.shared.pauseMp4Audio()
                cell.setPlayOrPuase(isPlay: obj.isPlay)
                
            }
        }
        guard viewModel.selectedStateIndexPath != indexPath else {
            return
        }
        
        viewModel.selectedStateIndexPath = indexPath
        tblMusicName.reloadData()
    }
    
    @objc  func clickbtn(_ sender:UIButton) {
        
        guard viewModel.otherUserId == viewModel.currentUser.userId else {
            return
        }
        let buttonPosition = sender.convert(CGPoint.zero, to: self.tblMusicName)
        viewModel.indexPath = self.tblMusicName.indexPathForRow(at:buttonPosition)
    
        var favorite = ""
        
        if viewModel.searchText.count > 0 {
            favorite = viewModel.musicTypeSearchArr[viewModel.indexPath.row].isFavorite
        } else {
            favorite = viewModel.musicTypeListArr[viewModel.indexPath.row].isFavorite
        }
        
        favorite == "0" ? OpenPopUpSongs() : callLikeDisLikeAPi()
    }
    
    @objc  func clickbtnOk(_ sender:UIButton) {
    
        callLikeDisLikeAPi()
    }
}

//MARK: -   UITextFieldDelegate

extension MusicNameVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "\n" {
            return false
        }
        
        viewModel.musicTypeSearchArr.removeAll()
        
        let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        viewModel.searchText = text
        applySearch()
        
        return true
    }
}
