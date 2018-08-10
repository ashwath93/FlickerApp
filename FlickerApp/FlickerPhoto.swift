//
//  FlickerPhotoModel.swift
//  FlickerApp
//
//  Created by Ashwath R on 07/08/18.
//  Copyright © 2018 Ashwath R. All rights reserved.
//

import UIKit

class Photos: Decodable {
    let photo: Photo
    enum CodingKeys: String, CodingKey {
        case photos = "photos"
    }
    required init(from decoder: Decoder) throws {
        photo = try decoder.container(keyedBy: CodingKeys.self).decode(Photo.self, forKey: .photos)
    }
}

class Photo: Decodable {
    let photos: [FlickerPhoto]
    enum CodingKeys: String, CodingKey {
        case photo = "photo"
    }
    required init(from decoder: Decoder) throws {
        photos = try decoder.container(keyedBy: CodingKeys.self).decode([FlickerPhoto].self, forKey: .photo)
    }
}

class FlickerPhoto: Decodable {
    
    //Making imageUrl NSString for NSCache support
    let imageUrl: String
    let photoId: String?
    let title: String
    
    enum CodingKeys: String, CodingKey {
        case imageUrl, title, photoId = "id", secret, farm, server
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        photoId = try container.decode(String.self, forKey: .photoId)
        if let pid = photoId, let secret = try container.decodeIfPresent(String.self, forKey: .secret),
           let server = try container.decodeIfPresent(String.self, forKey: .server) {
            let farm = try container.decodeIfPresent(Int.self, forKey: .farm)?.description ?? container.decodeIfPresent(String.self, forKey: .farm) ?? ""
            imageUrl = "http://farm\(farm).static.flickr.com/\(server)/\(pid)_\(secret).jpg"
        } else {
            imageUrl = ""
            debugPrint("Image parameter is missing")
        }
    }
    
    init(_ params: [String:Any]) {
        
        photoId = params["id"] as? String
        if let pid = params["id"] as? String, let psec = params["secret"] as? String,
           let pserver = params["server"] as? String {
            let pfram = params["farm"] as? String ?? (params["farm"] as? Int)?.description ?? ""
            imageUrl = "http://farm\(pfram).static.flickr.com/\(pserver)/\(pid)_\(psec).jpg"
        } else {
            imageUrl = ""
            debugPrint("Image parameter is missing")
        }
        title = params["title"] as? String ?? ""
    }
}
