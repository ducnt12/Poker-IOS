class SoundManager {
    static let instance = SoundManager()

    private var player: AVAudioPlayer?

    func playSound(sound: String) {
        guard let url = Bundle.main.url(forResource: sound, withExtension: ".mp3") else { return }
        do {
            player = try AVAudioPlayer(contentOf: url)
            player?.play()
        } catch let error {
            print("Error playing sound")
        }
    }

    func stopSound() {
        player?.stop()
    }
}

//SoundManager.instance.playSound
