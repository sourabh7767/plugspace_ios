//
//  AddStoryVC.swift
//  PlugSpace
//
//  Created by Kaushal on 03/05/22.
//

import UIKit
//import RecordButton
import AVKit
import KDCircularProgress
struct RecordingInfo {
    var videoThumb : UIImage
    var videoUrl :URL
}
class AddStoryVC: UIViewController,CKFSessionDelegate {
    func didChangeValue(session: CKFSession, value: Any, key: String) {
        
    }
    @IBOutlet weak var AnimationProgress: KDCircularProgress!
    @IBOutlet weak var viewCircleCentre: UIView!
  
    @IBOutlet weak var buttonRecord: UIButton!
    
   // @IBOutlet weak var lblquestion: UILabel!
    var noNeedToRecord = false
    var progressTimer : Timer?
    var progress : CGFloat! = 0
    var AnimatonTimer : Timer?
    
    var FinalRecordingVideoArr = [RecordingInfo]()
    var RecordingitemArr = [URL](){
        didSet{
            getVideoAndThanmnailFromUrl()
        }
    }
    @IBOutlet weak var btnStory: UIButton!
   // var RandomArr = ["When did you feel safest?","What is your earliest memory?","What is your Harry Potter house?","What item do you collect?","What word do you use most often?","What is the most uncomfortable sensation?"]
    var isRecoderOn = Bool()
    var isBackCamera = true
    @IBOutlet weak var previewView: CKFPreviewView! {
        didSet {
            let session = CKFVideoSession()
            session.delegate = self
            self.previewView.session = session
            self.previewView.previewLayer?.videoGravity = .resizeAspectFill
            session.cameraPosition = .front
        }
    }
    @IBOutlet weak var clcvideoPreview: UICollectionView!
    {
        didSet
        {
        self.clcvideoPreview.delegate = self
        self.clcvideoPreview.dataSource = self
        }
        }
    
    private var selectImage = UIView.getView(viewT: SelectImageVC.self)
   
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        buttonRecord.addTarget(self, action: #selector(self.callProgress), for: .touchDown)
        buttonRecord.addTarget(self, action: #selector(self.btnStopProgress), for: UIControl.Event.touchUpInside)
    }
    
    @IBAction func BtnBackAct(_ sender: UIButton) {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
    
 

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.previewView.session?.start()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.previewView.session?.stop()
        self.btnStopProgress()
    }
    
    @IBAction func handleCamera(sender: UIButton) {
        if let session = self.previewView.session as? CKFVideoSession {
            session.cameraPosition = isBackCamera == false ? .front : .back
        }
        isBackCamera = !isBackCamera
    }
    
    @objc func callProgress(){
        self.startProgress()
      //  DispatchQueue.main.asyncAfter(deadline: .now()+1) {
        self.AnimatonTimer = Timer.scheduledTimer(timeInterval: 5.5, target: self, selector: #selector(self.startProgress), userInfo: nil, repeats: true)
     //  }
        }
           
    @objc func startProgress(){
        print("-------START_PROGRESS------")
        if RecordingitemArr.count >= 4{
            print("if")
           
            btnStopProgress()
           // self.successAlert(AppName, message: "Video Record Sucessfully", button: "OK") {}
        }else{
           self.StartVideoRecording()
        self.viewCircleCentre.backgroundColor = UIColor.red
        AnimationProgress.animate(fromAngle: 0, toAngle: 360, duration: 5) { completed in
            
            
          
            
            
            if completed {
                print("animation stopped, completed before arr count:",self.RecordingitemArr.count)
                self.StopRecording()
                print("animation stopped, completed after arr count:",self.RecordingitemArr.count)
            } else {
                print("animation stopped, was interrupted")
                self.btnStopProgress()
                
            }
            
            
            
            
            
            
        }
        }
    }
    
    @objc func btnStopProgress() {
        print("-----Stop-----")
        AnimatonTimer?.invalidate()
        AnimatonTimer = nil
        self.AnimationProgress.refreshValues()
        self.AnimationProgress.stopAnimation()
        self.viewCircleCentre.backgroundColor = UIColor.white
    }
   
    
    func compressVideo(inputURL: URL,
                           outputURL: URL,
                           handler:@escaping (_ exportSession: AVAssetExportSession?) -> Void) {
            let urlAsset = AVURLAsset(url: inputURL, options: nil)
            guard let exportSession = AVAssetExportSession(asset: urlAsset,
                                                           presetName: AVAssetExportPresetMediumQuality) else {
                handler(nil)

                return
            }

            exportSession.outputURL = outputURL
            exportSession.outputFileType = .mp4
            exportSession.exportAsynchronously {
                handler(exportSession)
            }
        }
 
    @IBAction func BtnSendStory(_ sender: UIButton) {
        btnStopProgress()
        
        guard FinalRecordingVideoArr.count > 0 else {
            return
        }
        
        
        
            selectImage = UIView.getView(viewT: SelectImageVC.self)
        for (_,objRecord) in FinalRecordingVideoArr.enumerated() {

            FileManager.default.clearTmpDirectory()
                  let compressedURL = NSURL.fileURL(withPath: NSTemporaryDirectory() + UUID().uuidString + ".mp4")
            compressVideo(inputURL: objRecord.videoUrl,
                                outputURL: compressedURL) { [self] exportSession in
                      guard let session = exportSession else {
                          return
                      }

                      switch session.status {
                      case .unknown:
                          break
                      case .waiting:
                          break
                      case .exporting:
                          break
                      case .completed:
                          guard let compressedData = try? Data(contentsOf: compressedURL) else {
                              return
                          }
                          print("File size after compression: \(Double(compressedData.count))")
                      
                          DispatchQueue.main.async {
                              
                              self.selectImage.viewModel.storyVideo.append(compressedData)
                     //     self.selectImage.viewModel.storyVideo = compressedData
                          openXIB(XIB: self.selectImage)
                          }
                      case .failed:
                          break
                      case .cancelled:
                          break
                      @unknown default:
                          print("default")
                      }
                  }
            
        }
        
    }
 
    
    func StopRecording()  {
        if let session = self.previewView.session as? CKFVideoSession {
                session.stopRecording()
        }
    }
    
    func getVideoAndThanmnailFromUrl(){
        guard let url = RecordingitemArr.last else {return}
        if let img = self.getThumbnailImage(forUrl: url){
            self.FinalRecordingVideoArr.append(RecordingInfo.init(videoThumb: img, videoUrl: url))
        }
        btnStory.isHidden = false
        self.clcvideoPreview.reloadData()
    }
    
    func StartVideoRecording()  {
        if let session = self.previewView.session as? CKFVideoSession {
                session.record({ (url) in
                  print("url:",url)
                    if self.RecordingitemArr.count < 4
                   {
                    self.RecordingitemArr.append(url)
                }
                    
                    if self.RecordingitemArr.count >= 4{
                        self.successAlert(AppName, message: "Video Record Sucessfully", button: "OK") {}
                    }
                    
                    
                }) { (_) in
                }
            }
        
    }
    

    override var prefersStatusBarHidden: Bool {
        return true
    }

}

extension AddStoryVC: UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.FinalRecordingVideoArr.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recordedCell", for: indexPath as IndexPath) as! recordedCell
        
        cell.imgVideo.image = FinalRecordingVideoArr[indexPath.row].videoThumb
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
        let url = self.FinalRecordingVideoArr[indexPath.row].videoUrl
        let player = AVPlayer(url: url)
        let vc = AVPlayerViewController()
        vc.player = player
        self.present(vc, animated: true) { vc.player?.play() }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellSize = collectionView.frame.size //some width
        
        return CGSize(width: cellSize.width, height: cellSize.height/4.45)
        
       }
    
 func getThumbnailImage(forUrl url: URL) -> UIImage? {
        let asset: AVAsset = AVAsset(url: url)
    
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        do {
            let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60), actualTime: nil)
            return UIImage(cgImage: thumbnailImage)
        } catch let error {
            print(error)
        }

        return nil
    }
    
    
}
class recordedCell: UICollectionViewCell {
    
    @IBOutlet weak var imgVideo: UIImageView!
}
extension FileManager {
    func clearTmpDirectory() {
        do {
            let tmpDirURL = FileManager.default.temporaryDirectory
            let tmpDirectory = try contentsOfDirectory(atPath: tmpDirURL.path)
            try tmpDirectory.forEach { file in
                let fileUrl = tmpDirURL.appendingPathComponent(file)
                try removeItem(atPath: fileUrl.path)
            }
        } catch {
           //catch the error somehow
        }
    }
}
