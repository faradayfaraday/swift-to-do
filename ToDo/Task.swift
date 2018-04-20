//
//  Task.swift
//  ToDo
//
//  Created by Faraday Faraday on 10/04/2018.
//  Copyright © 2018 Faraday Faraday. All rights reserved.
//
import os.log
import UIKit

enum Priority: Int {
    case low = 1
    case medium = 2
    case high = 3
    case no = 0
    
    var color: UIColor {
        switch self {
        case .low: return UIColor(red: 0.0, green: 205.0/255.0, blue: 102.0/255.0, alpha: 1)
        case .medium: return UIColor(red: 255.0/255.0, green: 213.0/255.0, blue: 107.0/255.0, alpha: 1)
        case .high: return UIColor(red: 255.0/255.0, green: 107.0/255.0, blue: 114.0/255.0, alpha: 1)
        case .no: return UIColor(red: 235.0/255.0, green: 235.0/255.0, blue: 235.0/255.0, alpha: 1)
        }
    }
}

struct PropertyKey {
    static let text = "text"
    static let priority = "priority"
    static let status = "status"
}

class Task: NSObject, NSCoding {
    
    //MARK: - Properties
    
    var text: String
    var done: Bool // + functuanality will be added
    var priority: Priority
    
    //MARK: - Init
    
    init(text: String, priority: Priority, done: Bool) {
        self.text = text
        self.done = false
        self.priority = priority
    }
    
    convenience init(text: String, priority: Priority) {
        self.init(text: text, priority: priority, done: false)
    }
    
    convenience init(text: String) {
        self.init(text: text, priority: .low, done: false)
    }
    
    //MARK: - NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(text, forKey: PropertyKey.text)
        aCoder.encode(priority.rawValue, forKey: PropertyKey.priority)
        aCoder.encode(done, forKey: PropertyKey.status)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let text = aDecoder.decodeObject(forKey: PropertyKey.text) as? String else {
            os_log("Cannot decode text", log: .default, type: .debug)
            return nil
        }
        
        let intPriority = aDecoder.decodeInteger(forKey: PropertyKey.priority)
    
        let priority = Priority.init(rawValue: intPriority) ?? .no
        
        let done = aDecoder.decodeBool(forKey: PropertyKey.status)

        self.init(text: text, priority: priority, done: done)
    }
    
    //MARK: - Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("tasks")
    
}
