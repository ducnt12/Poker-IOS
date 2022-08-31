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

struct Common {
    func getAllPlayers() -> [Player] {
        if let players = UserDefaults.standard.object(forKey: "players") as? Data {
            let decoder = JSONDecoder()
            if let all_players = try? decoder.decode([Player].self, from: players) {
                return all_players
            }
        }
        return []
    }
    
    // check if player existed
    func checkPlayerExisted(username: String) -> Bool {
        let players = getAllPlayers()

        let player = players.filter{i in
            i.username.lowercased() == username.lowercased()
        }

        if (player.count == 0) {
            return false
        }
        return true
    }
    
    func findPlayer(username: String) -> Player {
        let allPlayers = getAllPlayers()

        let player = allPlayers.filter{i in
            i.username.lowercased() == username.lowercased()
        }
        
        if player.count > 0 {
            return player[0]
        }
        return Player(username: "nil")
    }
    
    // add user
    func login(username: String) {
        if (checkPlayerExisted(username: username) == false) {
            var players = getAllPlayers()
            players.append(Player(username: username))

            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(players) {
                UserDefaults.standard.set(encoded, forKey: "players")
            }
        }
    }
    
    func savePlayer(player: Player) {
        var allPlayers = getAllPlayers()
        let index = allPlayers.firstIndex(where: {$0.id == player.id})!
        
        allPlayers[index] = player
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(allPlayers) {
            UserDefaults.standard.set(encoded, forKey: "players")
        }
    }
}
