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
    
//    @Published var pattern:Pattern = Pattern()
    @Published var test:Test = Test()
    @Published var receivedInitial:Bool = false
    @Published var altitude:Int = 0
    @Published var direction:Int = 0
    @Published var updating:Bool = false
    @Published var rower:Int = 0
    
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
            let data:[String:Any] = ["data":sendObject.encoder()]
            let _ = try session.updateApplicationContext(data)
            print("sent pattern")
        } catch {
            print("failed to send haptics because it is not reachable")
        }
    }
    
    public func sendDataToWatch(sendObject: Test){
        do {
            let data:[String:Any] = ["test":sendObject.encoder()]
            let _ = try session.updateApplicationContext(data)
            print("sent test")
        } catch {
            print("failed to send haptics because it is not reachable")
        }
    }
    
    public func sendDataToWatch(sendObject: MadePattern){
        do {
            let data:[String:Any] = ["madePattern":sendObject]
            let _ = try session.updateApplicationContext(data)
            print("sent madePattern")
        } catch {
            print("failed to send haptics because it is not reachable")
        }
    }
    
    public func sendDirection(sendObject: Int){
            do {
                let data:[String:Any] = ["direction":sendObject]
                let _ = try session.updateApplicationContext(data)
                print("sent direction \(sendObject)")
            } catch {
                print("Not Reachable")
            }
    }
    
    public func sendAltitude(sendObject: Int){
            do {
                let data:[String:Any] = ["altitude":sendObject]
                let _ = try session.updateApplicationContext(data)
                print("sent altitude \(sendObject)")
            } catch {
                print("Not Reachable")
            }
    }
    
    public func sendRower(sendObject: Int){
            do {
                let data:[String:Any] = ["rower":sendObject]
                let _ = try session.updateApplicationContext(data)
                print("sent rower \(sendObject)")
            } catch {
                print("Not Reachable")
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
//        dataReceivedFromPhone(info)
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]){

//        if let data = applicationContext["data"] as? Data {
//            let decodedPattern = Pattern.decoder(data)
//            self.pattern = decodedPattern
//            self.receivedInitial = true
//            self.updating = true
//            print("received pattern: \(self.pattern)")
//        }
        
        if let data = applicationContext["test"] as? Data {
            let decodedTest = Test.decoder(data)
            self.test = decodedTest
            self.receivedInitial = true
            self.updating = true
            print("received test: \(self.test)")
        }
        
        if let alt = applicationContext["altitude"] as? Int {
            self.altitude = alt
            print("received alt: \(self.altitude)")
        }
        
        if let receivedDirection = applicationContext["direction"] as? Int {
            self.direction = receivedDirection
            print("received direction: \(self.direction)")
        }
        
        if let receivedRower = applicationContext["rower"] as? Int {
            self.rower = receivedRower
            print("received rower: \(self.rower)")
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

