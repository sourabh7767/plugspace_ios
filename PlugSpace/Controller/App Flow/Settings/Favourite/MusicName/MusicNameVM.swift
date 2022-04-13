//
//  MusicNameVM.swift
//  PlugSpace
//
//  Created by MAC on 03/12/21.
//

import Foundation

class MusicNameVM:BaseVM {
    
    //MARK:- Properties
    
    var searchText = ""
    var otherUserId = ""
    var musicId = ""
    var musicType = ""
    var musicTypeListArr = [MusicModel]()
    var musicTypeSearchArr = [MusicModel]()
    var indexPath : IndexPath!
    var selectedStateIndexPath : IndexPath?

    let currentUser = SignUpModel.init(dict: AppPrefsManager.shared.getUserData() as? [String : Any] ?? [String:Any]())
    
    func getFavoriteMusic(completion : @escaping (_ isSuccess: Bool) -> Void) {
        
        otherUserId = otherUserId != "" ? otherUserId : currentUser.userId
        
        let parameterRequest = ParameterRequest()
        
            parameterRequest.addParameter(key: ParameterRequest.userId, value: otherUserId)
            parameterRequest.addParameter(key: ParameterRequest.musicType, value: musicType)
        
        apiClient.getFavoriteMusic(parameter: parameterRequest.parameters) { (resp, respMsg, respCode, err) in
            guard err == nil else {
                self.errorMessage = err!
                completion(false)
                return
            }
            
            if respCode == ResponseStatus.success {
                if let respDict = resp as? [String:Any] {
                    self.musicTypeListArr = MusicModel.getMusicList(data: respDict["data"] as? [Any] ?? [Any]())
                }
                self.errorMessage = respMsg!
                completion(true)
            }else {
                
                self.errorMessage = respMsg!
                completion(false)
            }
        }
    }
    
    func getMusicTypeListData(indexPath:IndexPath) -> MusicModel {
        
        return musicTypeListArr[indexPath.row]
    }
    
    func getMusicTypeSearchListData(indexPath:IndexPath) -> MusicModel {
        
        return musicTypeSearchArr[indexPath.row]
    }
}
