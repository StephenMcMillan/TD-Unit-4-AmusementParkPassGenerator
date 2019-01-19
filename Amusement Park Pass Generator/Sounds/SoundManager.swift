//
//  SoundManager.swift
//  Amusement Park Pass Generator
//
//  Created by Stephen McMillan on 18/01/2019.
//  Copyright © 2019 Stephen McMillan. All rights reserved.
//

import Foundation
import AudioToolbox

class SoundManager {
    
    var successSoundID: SystemSoundID = 0
    var failSoundID: SystemSoundID = 1
    
    init() {
        
        let successSoundPath = Bundle.main.path(forResource: "AccessGranted", ofType: "wav")!
        let failSoundPath = Bundle.main.path(forResource: "AccessDenied", ofType: "wav")!
        
        let successURL = URL(fileURLWithPath: successSoundPath)
        let failURL = URL(fileURLWithPath: failSoundPath)
        
        AudioServicesCreateSystemSoundID(successURL as CFURL, &successSoundID)
        AudioServicesCreateSystemSoundID(failURL as CFURL, &failSoundID)
    }
    
    enum SoundType {
        case success
        case failure
    }
    
    func play(_ type: SoundType) {
        switch type {
        case .success:
            AudioServicesPlayAlertSound(successSoundID)
        case .failure:
            AudioServicesPlayAlertSound(failSoundID)
        }
    }
}
