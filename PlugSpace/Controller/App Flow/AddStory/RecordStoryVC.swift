
import UIKit

class RecordStoryVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()  } }
//MARK:- Old class
//
//  AddStoryVC.swift
//  PlugSpace
//
//  Created by Kaushal on 03/05/22.
//
/*
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
    
    @IBOutlet weak var lblquestion: UILabel!
    var noNeedToRecord = false
   // var recordButton : RecordButton!
    var progressTimer : Timer?
    var progress : CGFloat! = 0
    var AnimatonTimer : Timer?
   // var AnimationProgress : CGFloat! = 0
    
    var FinalRecordingVideoArr = [RecordingInfo]()
    var RecordingitemArr = [URL](){
        didSet{
            getVideoAndThanmnailFromUrl()
        }
    }
    @IBOutlet weak var btnStory: UIButton!
    var RandomArr = ["fdfd","fvevev","reerv","gtb","rtgt","tg5tgtt","rve","erqv","ev","evfev"]
    var isRecoderOn = Bool()
    @IBOutlet weak var previewView: CKFPreviewView! {
        didSet {
            let session = CKFVideoSession()
            session.delegate = self
            
           // self.previewView.autorotate = true
            self.previewView.session = session
            self.previewView.previewLayer?.videoGravity = .resizeAspectFill
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
       
       // SetupRecordBtn()
        
        if let randomElement = RandomArr.randomElement() {
            self.lblquestion.text = randomElement
        }
        buttonRecord.addTarget(self, action: #selector(self.againRecord), for: .touchDown)
        buttonRecord.addTarget(self, action: #selector(self.stop), for: UIControl.Event.touchUpInside)
    }
    
    @IBAction func BtnBackAct(_ sender: UIButton) {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
    
  /*  func SetupRecordBtn(){
        // set up recorder button
        recordButton = RecordButton(frame: CGRect(x: 0,y: self.view.frame.height - 110,width: 100,height: 100))
        recordButton.progressColor = .red
        recordButton.closeWhenFinished = false
        recordButton.addTarget(self, action: #selector(self.record), for: .touchDown)
        recordButton.addTarget(self, action: #selector(self.stop), for: UIControl.Event.touchUpInside)
        recordButton.center.x = self.view.center.x
        view.addSubview(recordButton)
    }*/
    

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
        self.stopTimers()
    }
    
    @objc func record() {
        print(RecordingitemArr.count)
        guard RecordingitemArr.count < 3 else{return}
        self.startProgress()
        againRecord()
    }
    
    @objc func againRecord(){
        print(RecordingitemArr.count)
        guard !noNeedToRecord else{return}
        self.startProgress()
        self.viewCircleCentre.backgroundColor = UIColor.red
        print("RecordingitemArr.count",RecordingitemArr.count)
        if RecordingitemArr.count > 4{
            print("if")
            stop()
        }else{
            print("else")
        StopRecording()
        isRecoderOn = true
        progress = 0
        //AnimationProgress = 0
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            self.StartVideoRecording()
            
      
           self.AnimatonTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.AnimationButton), userInfo: nil, repeats: true)
            self.progressTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateProgress), userInfo: nil, repeats: true)
        }
      }
    }

    @objc func startProgress(){
        print("-------START_PROGRESS------")
        AnimationProgress.animate(fromAngle: 0, toAngle: 360, duration: 5) { completed in
            if completed {
                print("animation stopped, completed")
            } else {
                print("animation stopped, was interrupted")
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
    
    @objc func AnimationButton() {
        
      /*  AnimationProgress.animate(fromAngle: 0, toAngle: 360, duration: 5) { completed in
            if completed {
              // self.progress.angle = Double(0)
             //   self.progress.set(colors: UIColor.white,UIColor.white)

                print("animation stopped, completed")
            } else {
                print("animation stopped, was interrupted")
            }
        }*/
        
       /*
        let maxDuration = CGFloat(5) // Max duration of the recordButton
        
        self.AnimationProgress = self.AnimationProgress + (CGFloat(0.05) / maxDuration)
        
        recordButton.setProgress(AnimationProgress)
        if AnimationProgress >= 1 {
            AnimatonTimer?.invalidate()
            AnimatonTimer = nil
            
        }*/
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
        stopTimers()
        
            guard let videourl = FinalRecordingVideoArr.first?.videoUrl else {
                return
            }
            selectImage = UIView.getView(viewT: SelectImageVC.self)
         //   print("File size before compression: \(Double(data.count / 1048576)) mb")
        FileManager.default.clearTmpDirectory()
                  let compressedURL = NSURL.fileURL(withPath: NSTemporaryDirectory() + UUID().uuidString + ".mp4")
                  compressVideo(inputURL: videourl,
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
                          print("File size after compression: \(Double(compressedData.count / 1048576)) mb")
                          DispatchQueue.main.async {
                              
                          
                          self.selectImage.viewModel.storyVideo = compressedData
                          openXIB(XIB: self.selectImage)
                          }
                      case .failed:
                          break
                      case .cancelled:
                          break
                      @unknown default:
                          print("default")
                      }
                  
            
            
            
       /*
        selectImage.videoURL  = FinalRecordingVideoArr.first?.videoUrl
       // selectImage.setupVideoPlayer()
        
        do {
            let videoData = try Data(contentsOf: selectImage.videoURL)
            selectImage.viewModel.storyVideo = videoData
        
            } catch let error {
                    print("*** Error : \(error.localizedDescription)")
            }*/
        
        
        }
        
    }
    
    @objc func updateProgress() {
        
      
      //  print("progress:",progress)
        if progress == 5{
            self.progressTimer?.invalidate()
            self.progressTimer = nil
            
            if isRecoderOn
            {
                
                againRecord()
            }
            if RecordingitemArr.count == 3{
                self.stop()
            }
        }
        else if RecordingitemArr.count >= 4{
           
            stopTimers()
            
            
        }
        else
        {
           print("end time",progress)
        }
         progress += 1
        
        }
    
    
    
    func stopTimers()
    {
        isRecoderOn = false
        self.progressTimer?.invalidate()
        self.progressTimer = nil
        self.AnimatonTimer?.invalidate()
        self.AnimatonTimer = nil
        
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
                }) { (_) in
                }
            }
        
    }
    
    
    @objc func stop() {
        noNeedToRecord = true
        isRecoderOn = false
       // recordButton.progressColor = .clear
       // self.AnimationProgress = 0
        self.progress = 0
        self.progressTimer?.invalidate()
        self.progressTimer = nil
        
        btnStopProgress()
        StopRecording()
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
//            let player = AVPlayerViewController()
//            player.player = AVPlayer(url: url)
//           // player.view.frame = self.view.bounds
//
//            //self.view.addSubview(player.view)
//            self.addChild(player)
//
//            player.player?.play()
        
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
*/
