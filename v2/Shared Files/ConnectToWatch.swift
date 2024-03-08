//
//  File.swift
//  sail-v1
//
//  Created by Alice Mao on 12/7/23.
//

import Foundation
import UIKit
import WatchConnectivity

class ConnectToWatch: NSObject, ObservableObject {
    
    static let connect = ConnectToWatch()
    public let session = WCSession.default
    
    @Published var pattern:MadePattern = MadePattern()
    @Published var receivedInitial:Bool = false
    @Published var updating:Bool = false
    
    private override init(){
        super.init()
        if WCSession.isSupported() {
            session.delegate = self
            session.activate()
            print("Supported and activated watch session")
        } else{
            Swift.print("watch not supported")
        }
    }
    
    func activateSession() -> Bool{
        if WCSession.isSupported() {
            session.delegate = self
            session.activate()
            print("Supported and activated watch session")
            return true
        } else{
            Swift.print("watch not supported")
            return false
        }
    }
    
    // Convert Pattern to Data to send to watch
    public func sendDataToWatch(sendObject: Pattern){
        Swift.print("send method")
        if activateSession(){
            if (session.isReachable){
                Swift.print("reached")
                let data:[String:Any] = ["data":sendObject.encoder()]
                Swift.print("sending data: \(data)")
                session.sendMessage(data, replyHandler: nil)
            }
            else{
                print("failed to send haptics because it is not reachable")
            }
        }
        else {
            print("not activated")
        }
    }
    
    public func sendDataToWatch(sendObject: MadePattern){
        Swift.print("send method")
        if activateSession(){
            if (session.isReachable){
                Swift.print("reached")
                let data:[String:Any] = ["data":sendObject.encoder()]
                Swift.print("sending data: \(data)")
                session.sendMessage(data, replyHandler: nil)
            }
            else{
                print("failed to send haptics because watch is not reachable")
            }
        }
        else {
            print("not activated")
        }
    }
    
    
    // Convert Data from phone to a Pattern object to be set in TimerControls
    public func dataReceivedFromPhone(_ info:[String:Any]) {
        if !session.isReachable{
            Swift.print("couldn't retrieve data from phone")
            return
        }
        print("dataReceivedFromPhone")
        if !receivedInitial{
            self.receivedInitial = true
        } else{
            self.updating = true
        }
        
        let data:Data = info["data"] as! Data
        let decodedPattern = MadePattern.decoder(data)
        Swift.print("Receiving..")
        DispatchQueue.main.async {
            Swift.print("pattern received: \(decodedPattern)")
            self.pattern = decodedPattern
//            self.updatePattern(pattern: self.pattern)
        }
    }
    
//    func updatePattern(pattern: Pattern){
//        Pattern.init(underPattern: pattern.underPattern, atPattern: pattern.atPattern, abovePattern: pattern.abovePattern, underTime: pattern.underTime, atTime: pattern.atTime, aboveTime: pattern.aboveTime, timeOverall: pattern.timeOverall, type: pattern.type, target: pattern.target)
//    }
    
}


//  Other functions needed for WCSession
extension ConnectToWatch: WCSessionDelegate{
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error{
            Swift.print("Error starting WC Session \(error.localizedDescription)")
            return
        }
        
        if WCSession.default.isReachable{
            Swift.print("connected to watch")
        }
        else{
            Swift.print("failed to connect to watch")
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage info: [String : Any]) {
        dataReceivedFromPhone(info)
    }
    
    
    
#if os(iOS)
    public func sessionDidBecomeInactive(_ session: WCSession) {
        session.activate()
    }
    
    public func sessionDidDeactivate(_ session: WCSession) {
        session.activate()
    }
#endif
}


