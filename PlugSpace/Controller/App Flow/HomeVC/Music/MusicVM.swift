//
//  MusicVM.swift
//  PlugSpace
//
//  Created by MAC on 01/02/22.
//

import Foundation
import UIKit

class MusicVM: BaseVM {

    //MARK:- Properties
    var indexPath : IndexPath!
    var MusicListArr = [MusicModel]()
    var PlayIndexPath :IndexPath!
    var searchText = ""
    let userId = SignUpModel(dict: AppPrefsManager.shared.getUserData() as? [String : Any] ?? [String:Any]())
    var musicId = ""
    var musicType = ""
    var MusicSearchListArr = [MusicModel]()
    var musicTypeArr = ["exercise","relax","cars","wedding","regions"]
    var selectedStateIndexPath : IndexPath?
    
    //MARK:- Method
    
    func getMusicList(completion : @escaping (_ isSuccess: Bool) -> Void) {
        
        let parameterRequest = ParameterRequest()
        
            parameterRequest.addParameter(key: ParameterRequest.searchText, value: searchText)
            parameterRequest.addParameter(key: ParameterRequest.userId, value: userId.userId)
        
        apiClient.getMusicList(parameter: parameterRequest.parameters) { (resp, respMsg, respCode, err) in
            guard err == nil else {
                self.errorMessage = err!
                completion(false)
                return
            }
            
            if respCode == ResponseStatus.success {
                if let respDict = resp as? [String:Any] {
                    self.MusicListArr = MusicModel.getMusicList(data: respDict["data"] as? [Any] ?? [Any]())
                }
                self.errorMessage = respMsg!
                completion(true)
            }else {
                
                self.errorMessage = respMsg!
                completion(false)
            }
        }
    }
   
    func getMusicListData(indexPath:IndexPath) -> MusicModel {
        
        return MusicListArr[indexPath.row]
        
    }
    
    func getMusicSearchListData(indexPath:IndexPath) -> MusicModel {
        
        return MusicSearchListArr[indexPath.row]
        
    }
    
    func validation() -> Bool {
        if musicType.isEmptyOrWhiteSpace {
            errorMessage = StringConstant.musicType
        } else {
            return true
        }
        return false
    }
    
    func musicLikeDislike(completion : @escaping (_ isSuccess: Bool) -> Void) {
        
        let parameterRequest = ParameterRequest()
        
            parameterRequest.addParameter(key: ParameterRequest.userId, value: userId.userId)
            parameterRequest.addParameter(key: ParameterRequest.musicId, value: musicId)
            parameterRequest.addParameter(key: ParameterRequest.musicType, value: musicType)
        
        apiClient.musicLikeDislike(parameter: parameterRequest.parameters) { (resp, respMsg, respCode, err) in
            guard err == nil else {
                self.errorMessage = err!
                completion(false)
                return
            }
            
            if respCode == ResponseStatus.success {
                self.errorMessage = respMsg!
                completion(true)
            }else {
                
                self.errorMessage = respMsg!
                completion(false)
            }
        }
    }
    
}

