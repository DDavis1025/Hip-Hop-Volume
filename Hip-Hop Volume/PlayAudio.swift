//
//  PlayAudio.swift
//  Test
//
//  Created by Dillon Davis on 3/26/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//

import Foundation
import AVFoundation

var audioPlayer: AVAudioPlayer?


func playSound(sound: String, type: String) {
    if let path = Bundle.main.path(forResource: sound, ofType: type){
    do {
        audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
        audioPlayer?.play()
    } catch {
        print("Could not play audio file")
    }
    }
}

