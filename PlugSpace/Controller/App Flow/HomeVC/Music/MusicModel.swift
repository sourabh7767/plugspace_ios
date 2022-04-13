//
//  MusicModel.swift
//  PlugSpace
//
//  Created by MAC on 01/02/22.
//

import Foundation

class MusicModel {
    
    var musicId = ""
    var musicOtherOd = ""
    var title = ""
    var imageUrl = ""
    var mediaUrl = ""
    var artistsName = ""
    var language = ""
    var isFavorite = ""
    var isPlay = false
    var subtitle = ""
    var headerDesc = ""
    
    init(dict:[String:Any]) {
        
        musicId = dict["music_id"] as? String ?? ""
        musicOtherOd = dict["music_other_id"] as? String ?? ""
        title = dict["title"] as? String ?? ""
        imageUrl = dict["image_url"] as? String ?? ""
        mediaUrl = dict["media_url"] as? String ?? ""
        artistsName = dict["artists_name"] as? String ?? ""
        language = dict["language"] as? String ?? ""
        isFavorite = dict["is_favorite"] as? String ?? ""
        subtitle = dict["subtitle"] as? String ?? ""
        headerDesc = dict["header_desc"] as? String ?? ""
    }
    
    class func getMusicList(data:[Any]) -> [MusicModel] {
        var temp = [MusicModel]()
        for dict in data {
            temp.append(MusicModel.init(dict: dict as? [String:Any] ?? [String:Any]()))
        }
        return temp
    }
}
