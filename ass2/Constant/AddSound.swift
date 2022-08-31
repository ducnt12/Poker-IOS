/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2022B
  Assessment: Assignment 2
  Author: Nguyen Trung Duc
  ID: s3695504
  Created  date: 22/8/2022
  Last modified: 29/8/2022
  Acknowledgement: Lecture slides
*/

import Foundation
import AVFoundation
import SwiftUI

enum SoundOption: String {
    case drum_music, LocationsHappyVillage, card_flip, DefeatTheme, VictoryTheme, bet_chip, highscore, BattleTheme
}

enum SoundType: String {
    case mp3 = ".mp3", wav = ".wav"
}
//
class SoundManager {
    static let instance = SoundManager()

    private var player: AVAudioPlayer?
    private var backgroundPlayer: AVAudioPlayer?

    func playSound(sound: SoundOption, fileType: SoundType) {
        guard let url = Bundle.main.url(forResource: sound.rawValue, withExtension: fileType.rawValue) else { return }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch _ {
            print("Error playing sound")
        }
    }

    func stopSound() {
        player?.pause()
    }
    
    func playBackgroundSound(sound: SoundOption, fileType: SoundType) {
        guard let url = Bundle.main.url(forResource: sound.rawValue, withExtension: fileType.rawValue) else { return }
        do {
            backgroundPlayer = try AVAudioPlayer(contentsOf: url)
            backgroundPlayer?.numberOfLoops = -1
            backgroundPlayer?.play()
        } catch _ {
            print("Error playing sound")
        }
    }
    
    func pauseBackgroundSound() {
        backgroundPlayer?.pause()
    }
    
    func stopBackgroundSound() {
        backgroundPlayer?.stop()
    }
}
