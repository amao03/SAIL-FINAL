//
//  File.swift
//  sail-v1
//
//  Created by Alice Mao on 12/7/23.
//

import Foundation
import UIKit
import WatchConnectivity
import Combine

final class ConnectToWatch: NSObject, ObservableObject {
    
    static let connect = ConnectToWatch()
    public let session = WCSession.default
    
    @Published var pattern:Pattern = Pattern()
    @Published var receivedInitial:Bool = false
    @Published var power:Int = 0
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
    
    func activateSession(){
        if WCSession.isSupported() {
            session.delegate = self
            session.activate()
            print("Supported and activated watch session")
        } else{
            print("watch not supported")
        }
    }
    
    // Convert Pattern to Data to send to watch
    public func sendDataToWatch(sendObject: Pattern){
        do {
            let data:[String:Any] = ["pattern":sendObject]
            let _ = try session.updateApplicationContext(data)
            print("sent pattern")
        } catch {
            print("failed to send haptics because it is not reachable")
        }
    }
    
    public func sendPower(sendObject: Int){
            do {
                let data:[String:Any] = ["power":sendObject]
                let _ = try session.updateApplicationContext(data)
                print("sent alt")
            } catch {
                print("Not Reachable")
            }
    }
    
    // Convert Data from phone to a Pattern object to be set in TimerControls
    public func dataReceivedFromPhone(_ info:[String:Any]) {
        if !session.isReachable{
            Swift.print("couldn't retrieve data from phone")
            return
        }
        
        DispatchQueue.main.async {
            if let data = info["pattern"] as? Data {
                let decodedPattern = Pattern.decoder(data)
                self.pattern = decodedPattern
                self.receivedInitial = true
                self.updating = true
                print("received pattern: \(self.pattern)")
            }
            
            if let power = info["power"] as? Int {
                self.power = power
                print("received power: \(self.power)")
            }
        }
    }
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
//        print("did receive")
        dataReceivedFromPhone(info)
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]){
        print("didReceiveApplicationContext")
        
        if let data = applicationContext["pattern"] as? Data {
            let decodedPattern = Pattern.decoder(data)
            self.pattern = decodedPattern
            self.receivedInitial = true
            self.updating = true
            print("received pattern: \(self.pattern)")
        }
        
        if let power = applicationContext["power"] as? Int {
            self.power = power
            print("received alt: \(self.power)")
        }
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

