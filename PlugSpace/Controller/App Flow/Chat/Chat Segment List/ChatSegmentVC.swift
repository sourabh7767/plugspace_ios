//
//  ChatVC.swift
//  PlugSpace
//
//  Created by MAC on 18/11/21.
//

import UIKit
import MXSegmentedPager

class ChatSegmentVC: BaseVC {

    //MARK:- Outlet
    
    @IBOutlet weak var segmentedPager: MXSegmentedPager!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var viewSearch: UIView!

    //MARK:- Properties
    
    private var vcArray = [UIViewController]()
    private var MatchAndChat: MatchAndChatVC!
    private var View: ViewVC!
    private var Like: LikeVC!
    let viewModel = ChatSegmentVM()
    var searchText = ""
    
    //MARK:- Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPagerView()
        callChatApi()
    }

    
    //MARK:- Function
    private func setupPagerView() {
     
        btnSearch.isHidden = false
        txtSearch.isHidden = true
        
        segmentedPager.bounces = false
        
        segmentedPager.segmentedControl.backgroundColor = .clear
        segmentedPager.backgroundColor = .white
        segmentedPager.segmentedControl.font = UIFont(name: AppFont.bold, size: setCustomFont(16))!
        segmentedPager.segmentedControl.indicator.linePosition = .bottom
        segmentedPager.segmentedControl.textColor = AppColor.FontBlack// AppColor.THEME_COLOR
        segmentedPager.segmentedControl.selectedTextColor = AppColor.Orange //AppColor.THEME_COLOR
        segmentedPager.segmentedControl.indicator.lineView.backgroundColor = AppColor.Orange
        segmentedPager.delegate = self
        segmentedPager.dataSource = self
    
        segmentedPager.segmentedControl.removeAll()
        vcArray.removeAll()
        
        Like = UIStoryboard.instantiateVC(LikeVC.self, .Home)
        Like.title = viewModel.likeArr.count != 0 ? "\(viewModel.likeArr.count) Liked" : "Liked"
        Like.viewModel.superVc = self
        
        View = UIStoryboard.instantiateVC(ViewVC.self, .Home)
        View.viewModel.superVc = self
        View.title = viewModel.viewProfileArr.count != 0 ? "\(viewModel.viewProfileArr.count) Views" : "Views"
        
        MatchAndChat = UIStoryboard.instantiateVC(MatchAndChatVC.self, .Home)
        MatchAndChat.viewModel.superVc = self
        MatchAndChat.title = MatchAndChat.viewModel.userChatArr.count != 0 ? "\(MatchAndChat.viewModel.userChatArr.count) Match & Chat" : "Match & Chat"
        
        vcArray.append(Like)
        vcArray.append(View)
        vcArray.append(MatchAndChat)
        segmentedPager.reloadData()
    }
    
    func callChatApi() {
        
        viewModel.getChatList { [self] (isSuccess) in
            
            if isSuccess {
                
                setupPagerView()
                
                Like.viewModel.likeUserArr = viewModel.likeArr
                Like.tableView.reloadData()
                Like.noLikeData(isSearch: false)
                
                View.viewModel.viewProfileArr = viewModel.viewProfileArr
                View.tableView.reloadData()
                View.NoViewData(isSearch: false)
                
            } else {
                alertWith(message: viewModel.errorMessage)
            }
        }
    }
    
    //MARk:- IBAction
    
    @IBAction private func onBtnClose(_ sender: UIButton) {
        
        if !searchText.isEmptyOrWhiteSpace {
            txtSearch.text = ""
           searchText = ""
        } else {
            view.endEditing(true)
            btnSearch.isHidden = false
            viewSearch.isHidden = true
        }
    }
    
    @IBAction func clickBtnSearch(_ sender: UIButton) {
      
        btnSearch.isHidden = true
        
        txtSearch.transform.scaledBy(x: 1, y: 1)
        UIView.animate(withDuration: 0.4, delay: 0.1, options: .allowAnimatedContent) { [self] in
            txtSearch.backgroundColor = AppColor.Orange.withAlphaComponent(0.10)
            txtSearch.setCornerRadius(10)
            txtSearch.setBlankView(10, .Left)
            txtSearch.placeholder = "Search"
            txtSearch.isHidden = false
            viewSearch.isHidden = false
        }
    }
}

//********************************************
//MARK:- MXSegmentedPagerDelegate, MXSegmentedPagerDataSource
//********************************************

extension ChatSegmentVC: MXSegmentedPagerDelegate, MXSegmentedPagerDataSource {
    
    func numberOfPages(in segmentedPager: MXSegmentedPager) -> Int {
        return vcArray.count
    }
    
    func segmentedPager(_ segmentedPager: MXSegmentedPager, titleForSectionAt index: Int) -> String {
        return vcArray[index].title ?? ""
    }
    
    func segmentedPager(_ segmentedPager: MXSegmentedPager, viewForPageAt index: Int) -> UIView {
        return vcArray[index].view
    }
    
    func segmentedPager(_ segmentedPager: MXSegmentedPager, viewControllerForPageAtIndex index: Int) -> UIViewController {
        return vcArray[index]
    }
}
