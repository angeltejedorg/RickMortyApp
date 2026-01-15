//
//  Logger.swift
//  RickyMortyApp
//
//  Created by Angel Tejedor on 14/01/26.
//

import Foundation

protocol Logger {
    func debug(_ message: String)
    func info(_ message: String)
    func warning(_ message: String)
    func error(_ message: String, error: Error?, context: [String: Any]?)
}

final class ConsoleLogger: Logger {
    
    static let shared = ConsoleLogger()
    
    private init() {}
    
    func debug(_ message: String) {
        #if DEBUG
        print("[DEBUG] \(message)")
        #endif
    }
    
    func info(_ message: String) {
        print("[INFO] \(message)")
    }
    
    func warning(_ message: String) {
        print("[WARNING] \(message)")
    }
    
    func error(_ message: String, error: Error?, context: [String : Any]?) {
        var output = "[ERROR] \(message)"
        if let error { output += " | Error: \(error)"}
        if let context { output += " | Context: \(context)"}
        print(output)
    }
    
    
}
