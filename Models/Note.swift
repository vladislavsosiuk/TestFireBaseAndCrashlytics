//
//  Note.swift
//  TestFireBaseAndCrashlytics
//
//  Created by air on 04.11.17.
//  Copyright © 2017 VladOS. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct Note{
    
    var key:String?
    var title:String
    var content:String
    let databaseRef:DatabaseReference?
    
    init(snapshot: DataSnapshot){
        key = snapshot.key
        let value = snapshot.value as! [String:AnyObject]
        title = value["title"] as! String
        content = value["content"] as! String
        self.databaseRef = snapshot.ref
    }
    init(title: String, content:String){
        self.title = title
        self.content = content
        self.databaseRef = nil
    }
    
    func toAnyObject()->Any{
        return ["title":self.title, "content":self.content]
    }
}
