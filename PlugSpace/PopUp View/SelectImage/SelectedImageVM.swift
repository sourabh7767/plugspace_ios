//
//  SelectedImageVM.swift
//  PlugSpace
//
//  Created by MAC on 22/12/21.
//

import Foundation
import UIKit

class SelectedImageVM: BaseVM {
    
    //MARK:- Properties
    
    var storyImage : Data!
    var storyVideo : Data!
    var description = ""
    let userId = SignUpModel(dict: AppPrefsManager.shared.getUserData() as? [String : Any] ?? [String:Any]())
    
    //MARK:- Method
    
    func validation() -> Bool {
        
        if storyImage == nil {
            self.errorMessage = StringConstant.imageFeed
        }
        else {
            return true
        }
        return false
    }
    
    func createStory(completion : @escaping (_ isSuccess: Bool) -> Void) {
        
        let parameterRequest = ParameterRequest()
        
        parameterRequest.addParameter(key: ParameterRequest.userId, value: userId.userId)
        storyImage != nil ? parameterRequest.addParameter(key: ParameterRequest.Multimedia, value: storyImage) : parameterRequest.addParameter(key: ParameterRequest.Multimedia, value: storyVideo)
        
        var files : [[Data]] = [[]]
        var fileNames : [[String]] = [[]]
        var fileKeys : [String] = [""]
        
        if storyImage != nil {
            files.append([storyImage])
            fileNames.append(["image.jpg"])
            fileKeys.append(ParameterRequest.Multimedia)
        } else if storyVideo != nil {
            files.append([storyVideo])
            fileNames.append(["Video.mp4"])
            fileKeys.append(ParameterRequest.Multimedia)
        }
        
        apiClient.createStory(parameters: parameterRequest.parameters, files: files, fileNames: fileNames, fileKeys: fileKeys) { [self] (resp, respMsg, respCode, err) in
            guard err == nil else {
                self.errorMessage = err!
                completion(false)
                return
            }
            
            if respCode ==  ResponseStatus.success {
                self.errorMessage = respMsg!
                completion(true)
            }else {
                self.errorMessage = respMsg!
                completion(false)
            }
        }
    }
    
    func validationFeed() -> Bool {
        
        if description.isEmptyOrWhiteSpace {
            self.errorMessage = StringConstant.FeedDescription
        }
        else {
            return true
        }
        return false
    }
    
    func createFeed(completion : @escaping (_ isSuccess: Bool) -> Void) {
        
        let parameterRequest = ParameterRequest()
        
        parameterRequest.addParameter(key: ParameterRequest.userId, value: userId.userId)
        storyImage != nil ? parameterRequest.addParameter(key: ParameterRequest.feedImage, value: storyImage) : parameterRequest.addParameter(key: ParameterRequest.feedImage, value: storyVideo)
        parameterRequest.addParameter(key: ParameterRequest.description, value: description)
        
        var files : [[Data]] = [[]]
        var fileNames : [[String]] = [[]]
        var fileKeys : [String] = [""]
        
        if storyImage != nil {
            files.append([storyImage])
            fileNames.append(["image.jpg"])
            fileKeys.append(ParameterRequest.feedImage)
        } else if storyVideo != nil {
            files.append([storyVideo])
            fileNames.append(["Video.mp4"])
            fileKeys.append(ParameterRequest.feedImage)
        }
        
        apiClient.createFeed(parameters: parameterRequest.parameters, files: files, fileNames: fileNames, fileKeys: fileKeys) { [self] (resp, respMsg, respCode, err) in
            guard err == nil else {
                self.errorMessage = err!
                completion(false)
                return
            }
            
            if respCode ==  ResponseStatus.success {
                self.errorMessage = respMsg!
                completion(true)
            } else {
                self.errorMessage = respMsg!
                completion(false)
            }
        }
    }
}
