//
//  ContentViewController.swift
//  ARStories
//
//  Created by Antony Raphel on 05/10/17.
//

import UIKit

var ContentViewControllerVC = ContentViewController()

class ContentViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
   // var viewModel = StoryVM()
    var pageViewController : UIPageViewController?
  //  var pages: [UserDetails] = []
    var pages = [StoryDetailsModel]()
    var currentIndex : Int = 0
    var activityIndicator = UIActivityIndicatorView(style: .large)

    let userId = SignUpModel(dict: AppPrefsManager.shared.getUserData() as? [String : Any] ?? [String:Any]())
    override func viewDidLoad() {
        super.viewDidLoad()
        
    //   getStoryApiCall(userid: viewModel.userStoryDetails[viewModel.indexUser.row].userId)
       
        ScrollPageControllerAtSeclection()
    }

    /*
func getStoryApiCall(userid:String) {
    
    viewModel.viewUserID = userid
   
    viewModel.getStoryDetails { [self] (isSuccess) in
       // myGroup.leave()
        if isSuccess {
            
            //viewModel.userStoryDetails[viewModel.indexUser.row].userId != userId.userId ? setData() : nil
            
            ScrollPageControllerAtSeclection()
        }
    }
}*/
    override func viewWillAppear(_ animated: Bool) {
        ShowLoader()
    }
    func ScrollPageControllerAtSeclection()
    {
      
        
        // Do any additional setup after loading the view.
        ContentViewControllerVC = self
        pageViewController = storyboard?.instantiateViewController(withIdentifier: "PageViewController") as? UIPageViewController
        pageViewController!.dataSource = self
        pageViewController!.delegate = self
        
        let startingViewController: PreViewController = viewControllerAtIndex(index: currentIndex)!
        let viewControllers = [startingViewController]
        pageViewController!.setViewControllers(viewControllers , direction: .forward, animated: false, completion: nil)
       // pageViewController?.setViewControllers(viewControllers, direction: .reverse, animated: false)
        pageViewController!.view.frame = view.bounds
        
        addChild(pageViewController!)
        view.addSubview(pageViewController!.view)
        view.sendSubviewToBack(pageViewController!.view)
        pageViewController!.didMove(toParent: self)
        
        
        
    }
    
    
//    func setData() {
//
//        imgProfile.sd_setImage(with: URL(string: viewModel.userStoryDetails[viewModel.indexUser.row].profile), placeholderImage: UIImage(named: "home_1"), options: .retryFailed)
//        lblStoryTitle.text =  viewModel.userStoryDetails[viewModel.indexUser.row].name
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - UIPageViewControllerDataSource
    //1
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController?
    {
        var index = (viewController as! PreViewController).pageIndex
        if (index == 0) || (index == NSNotFound){
            return nil
        }
        index -= 1
        return viewControllerAtIndex(index: index)
    }
    
    //2
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! PreViewController).pageIndex
        if index == NSNotFound{
            return nil
        }
        index += 1
        if (index == pages.count) {
            return nil
        }
        return viewControllerAtIndex(index: index)
    }
    
    //3
    func viewControllerAtIndex(index: Int) -> PreViewController? {
        if pages.count == 0 || index >= pages.count  {
            return nil
        }
       
        // Create a new view controller and pass suitable data.
       let vc = storyboard?.instantiateViewController(withIdentifier: "PreView") as! PreViewController
          vc.pageIndex = index
     //   vc.viewModel = viewModel
       //  vc.item = pages[index]
         vc.items = pages
        currentIndex = index
        
        
        
        vc.view.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
        return vc
    }
    
    // Navigate to next page
    func goNextPage(fowardTo position: Int) {
        
        let startingViewController: PreViewController = viewControllerAtIndex(index: position)!
        let viewControllers = [startingViewController]
        pageViewController!.setViewControllers(viewControllers , direction: .forward, animated: true, completion: nil)
    }
    
    func ShowLoader() {
        print("ShowLoader")
        activityIndicator.center = self.view.center
        activityIndicator.color = .orange
        if let topVC = UIApplication.getTopViewController() {
           topVC.view.addSubview(activityIndicator)
        }
        self.view.bringSubviewToFront(activityIndicator)
      // self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
   }
    
    
    
    
    func HideLoader()
    {
        print("HideLoader")
        activityIndicator.isHidden = true
       // ContentViewControllerVC.activityIndicator.stopAnimating()
        activityIndicator.stopAnimating()
    }
    // MARK: - Button Actions
    @IBAction func closeAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
