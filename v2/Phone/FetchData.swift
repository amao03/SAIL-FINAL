//
//  FetchData.swift
//  v2
//
//  Created by Alice Mao on 2/16/24.
//

import Foundation

class FetchData: ObservableObject {
    private var concept2monitor:PerformanceMonitor? = nil
    private var strokeRateDisposable:Disposable? = nil
    private var distanceDisposable:Disposable? = nil
    private var strokePowerDisposable:Disposable? = nil
    @Published var strokePower: C2Power? = nil
    @Published var distance: C2Distance? = nil
    @Published var strokeRate: C2StrokeRate? = nil

    init(concept2monitor: PerformanceMonitor? = nil) {
        if(concept2monitor != nil) {
            self.concept2monitor = concept2monitor
            attachObservers()
        }
    }
    
    public func setPerformanceMonitor(_ pm: PerformanceMonitor) {
        concept2monitor = pm
        attachObservers()
    }
    
    private func attachObservers() {
        detachObservers()
        

        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            print("power timer: \(String(describing: self.concept2monitor?.strokePower.value))")
        }

        strokeRateDisposable = concept2monitor?.strokeRate.attach(observer: {
            [weak self] (strokeRate:C2StrokeRate) -> Void in
            if let weakSelf = self {
                DispatchQueue.global(qos: .background).async {
                    DispatchQueue.main.async {
                        print("Stroke Rate: \(strokeRate)")
                        weakSelf.strokeRate = strokeRate
                    }
                }
            }
        })
        
        distanceDisposable = concept2monitor?.distance.attach(observer: {
            [weak self] (distance:C2Distance) -> Void in
            if let weakSelf = self {
                DispatchQueue.global(qos: .background).async {
                    DispatchQueue.main.async {
                        print("Distance: \(distance)")
                        weakSelf.distance = distance
                    }
                }
            }
        })
        
        strokePowerDisposable = concept2monitor?.strokePower.attach(observer: {
            [weak self] (strokePower:C2Power) -> Void in
            if let weakSelf = self {
                DispatchQueue.global(qos: .background).async {
                    DispatchQueue.main.async {
                        print("Power: \(strokePower)")
                        weakSelf.strokePower = strokePower
                    }
                }
            }
        })
    }
    
    private func detachObservers() {
        strokeRateDisposable?.dispose()
        distanceDisposable?.dispose()
        strokePowerDisposable?.dispose()

    }
}
