//
//  MusicVC.swift
//  PlugSpace
//
//  Created by MAC on 03/12/21.
//

import UIKit

class MusicVC: BaseVC {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var tblMusic:UITableView!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var viewSearch: UIView!
    
    // MARK: - Properties
    
    private var viewModel = MusicVM()
    private var FavouriteSongViewXIB = UIView.getView(viewT: FavouriteSongView.self)
    
    // MARK: - VC Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
//      hideKeyboardWhenTappedAround()
        tblMusic.register(UINib(nibName: "MusicTVCell", bundle: nil), forCellReuseIdentifier: "MusicTVCell")
        tblMusic.delegate = self
        tblMusic.dataSource = self
        callMusicListAPi()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setupUI()
        AudioPlayer.shared.pauseMp4Audio()
    }
    
    // MARK: - SetupUI
    
    private func setupUI() {
        
    }

//    private func hideKeyboardWhenTappedAround() {
//        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
//        tap.cancelsTouchesInView = false
//        view.addGestureRecognizer(tap)
//    }
    
    func OpenPopUpSongs() {
        FavouriteSongViewXIB = UIView.getView(viewT: FavouriteSongView.self)
        FavouriteSongViewXIB.btnOk.addTarget(self, action:  #selector(clickbtnOk(_:)), for: .touchUpInside)
        openXIB(XIB: FavouriteSongViewXIB)
    }
    
    private func NoMusicData(isSearch:Bool) {
        
        if isSearch {
            removeNewNoDataViewFrom(containerView: tblMusic)
            if viewModel.MusicSearchListArr.count == 0 {
                setNoDataFoundView(containerView: tblMusic, text:"No Music Found!")
            }
        } else {
            removeNewNoDataViewFrom(containerView: tblMusic)
            if viewModel.MusicListArr.count == 0 {
                setNoDataFoundView(containerView: tblMusic, text:"No Music Found!")
            }
        }
    }
    
    private func applySearch() {
        if !viewModel.searchText.isEmptyOrWhiteSpace {
            viewModel.MusicSearchListArr = viewModel.MusicListArr.filter { $0.subtitle.range(of: viewModel.searchText, options: .caseInsensitive) != nil }
            NoMusicData(isSearch:true)
            tblMusic.reloadData()
        }
    }
    
    func setData() {
        
        if viewModel.searchText.count > 0 {
            let obj = viewModel.MusicSearchListArr[viewModel.indexPath.row]
            obj.isFavorite = obj.isFavorite == "0" ? "1" : "0"
            
            if let cell = self.tblMusic.cellForRow(at: viewModel.indexPath) as? MusicTVCell {
                cell.imgHeart.image = obj.isFavorite == "0" ? UIImage(named: "ic_Heart") : UIImage(named: "ic_like_filed")
            }
            
        } else {
            
            let obj = viewModel.MusicListArr[viewModel.indexPath.row]
            obj.isFavorite = obj.isFavorite == "0" ? "1" : "0"
    
            if let cell = self.tblMusic.cellForRow(at: viewModel.indexPath) as? MusicTVCell {
                cell.imgHeart.image = obj.isFavorite == "0" ? UIImage(named: "ic_Heart") : UIImage(named: "ic_like_filed")
            }
        }
    }
    
    //MARK:- Api Calling
    
    func callMusicListAPi() {
        
        viewModel.getMusicList { [self] (isSuccess) in
            NoMusicData(isSearch:false)
            isSuccess ? tblMusic.reloadData() : alertWith(message: viewModel.errorMessage)
        }
    }
    
    func callLikeDisLikeAPi() {
        
        if viewModel.searchText.count > 0 {
            viewModel.musicId = viewModel.MusicSearchListArr[viewModel.indexPath.row].musicId
        } else {
            viewModel.musicId = viewModel.MusicListArr[viewModel.indexPath.row].musicId
        }
        
        FavouriteSongViewXIB.getSongsType(type: { (Musictype) in
            viewModel.musicType = viewModel.musicTypeArr[Musictype]
        })
        
        guard viewModel.validation() else {
            alertWith(message: viewModel.errorMessage)
            return
        }
        
        viewModel.musicLikeDislike { [self] (isSuccess) in
            
            isSuccess ?  setData() : alertWith(message: viewModel.errorMessage)
        }
    }
    
    // MARK: - IBAction
    @IBAction private func onBtnBack(_ sender: UIButton) {
        backVC()
    }
    
    @IBAction private func onBtnClose(_ sender: UIButton) {
        
        if !viewModel.searchText.isEmptyOrWhiteSpace {
            txtSearch.text = ""
            viewModel.searchText = ""
        } else {
            view.endEditing(true)
            btnSearch.isHidden = false
            txtSearch.isHidden = true
            viewSearch.isHidden = true
        }
        NoMusicData(isSearch:false)
        tblMusic.reloadData()
    }
    
    @IBAction func clickBtnSearch(_ sender: UIButton) {
      
        btnSearch.isHidden = true
        viewSearch.isHidden = false
        txtSearch.delegate = self
        
        txtSearch.transform.scaledBy(x: 1, y: 1)
        
        UIView.animate(withDuration: 0.4, delay: 0.1, options: .allowAnimatedContent) { [self] in
            txtSearch.backgroundColor = AppColor.Orange.withAlphaComponent(0.10)
            txtSearch.setCornerRadius(10)
            txtSearch.setBlankView(10, .Left)
            txtSearch.placeholder = "Search"
            txtSearch.isHidden = false
        }
    }
}

//MARK:- UITableView

extension MusicVC:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.searchText.count > 0 {
            return viewModel.MusicSearchListArr.count
        }
        return viewModel.MusicListArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeCell(MusicTVCell.self, indexPath: indexPath)
        if viewModel.searchText.count > 0 {
            cell.setData(data: viewModel.getMusicSearchListData(indexPath: indexPath))
            let obj = viewModel.getMusicSearchListData(indexPath: indexPath)
            if let ipath = viewModel.selectedStateIndexPath {
                
                ipath == indexPath ? cell.setPlayOrPuase(isPlay: obj.isPlay) : cell.setPlayOrPuase(isPlay: false)
            }
        } else {
            cell.setData(data: viewModel.getMusicListData(indexPath: indexPath))
            
            if let ipath = viewModel.selectedStateIndexPath {
                
                ipath == indexPath ? cell.setPlayOrPuase(isPlay: true) : cell.setPlayOrPuase(isPlay: false)
            }
        }
        cell.btnHeart.addTarget(self, action: #selector(clickbtn(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = self.tblMusic.cellForRow(at: indexPath) as? MusicTVCell {
            if viewModel.searchText.count > 0 {
                let obj = viewModel.getMusicSearchListData(indexPath: indexPath)
                obj.isPlay = obj.isPlay ? false : true
                obj.isPlay ? AudioPlayer.shared.playMp4Audio(videoURL: URL(string:obj.mediaUrl)!) : AudioPlayer.shared.pauseMp4Audio()
                cell.setPlayOrPuase(isPlay: obj.isPlay)
                
            } else {
                let obj = viewModel.getMusicListData(indexPath: indexPath)
                obj.isPlay = obj.isPlay ? false : true
                obj.isPlay ? AudioPlayer.shared.playMp4Audio(videoURL: URL(string:obj.mediaUrl)!) : AudioPlayer.shared.pauseMp4Audio()
                cell.setPlayOrPuase(isPlay: obj.isPlay)
            }
        }
        
        guard viewModel.selectedStateIndexPath != indexPath else {
            return
        }
        viewModel.selectedStateIndexPath = indexPath
        tblMusic.reloadData()
    }
    
    @objc  func clickbtn(_ sender:UIButton) {
        let buttonPosition = sender.convert(CGPoint.zero, to: self.tblMusic)
        viewModel.indexPath = self.tblMusic.indexPathForRow(at:buttonPosition)
        
        var favorite = ""
        
        if viewModel.searchText.count > 0 {
            favorite = viewModel.MusicSearchListArr[viewModel.indexPath.row].isFavorite
        } else {
            favorite = viewModel.MusicListArr[viewModel.indexPath.row].isFavorite
        }
        
        favorite == "0" ? OpenPopUpSongs() : callLikeDisLikeAPi()
        
    }
    
    @objc func clickbtnOk(_ sender:UIButton) {
    
        callLikeDisLikeAPi()
    }
}

//MARK: -   UITextFieldDelegate

extension MusicVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string == "\n" {
            return false
        }
        
        viewModel.MusicSearchListArr.removeAll()
        
        let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        viewModel.searchText = text
        applySearch()
        
        return true
    }
}
