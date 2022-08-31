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
import SwiftUI

struct GameView: View {
    @Binding var showSheet: Bool
    @Binding var mute: Bool
    var username: String
    var difficulty: String

    private let card_types = ["clubs", "hearts", "spades", "diamonds"]
    private let card_ranks = ["2", "3", "4", "5", "6", "7", "8","9","10", "jack", "queen", "king", "ace"]
    private let funcs = Common()
    
    @Environment(\.colorScheme) var colorScheme
    
    @State private var allCards = [Card]()
    @State private var playerCards = [Card]()
    @State private var dealerCards = [Card]()
    @State private var showDealerCards = [Card]()
    @State private var showCards = [Card]()
    
    //SHow if it is plyer turn
    @State private var playerTurn = false
    
    //Bet money
    @State private var bet = 10
    
    @State private var player = Player(username: "")
    @State private var playerPoint = 0
    @State private var dealerPoint = 0
    @State private var playerBusted = false
    @State private var win = 0
    
    
    @State private var showChooseValueOp = false
    @State private var currentAce = 0
    
    //Variable to show winner
    @State private var imageName = String()
    @State private var showPopup = false
    
    //Variable to check game ends
    @State private var plays = 0
    @State private var endGame = false
    
    @State private var showAddCoin = false
    @State private var showWarning = false
    @State private var showBlackjack = false
    @State private var showConsecutiveWins = false
    @State private var showHighscore = false
    
    
    //MARK: - Reset game
    func resetGame() {
        allCards = [Card]()
        playerCards = [Card]()
        dealerCards = [Card]()
        showDealerCards = [Card]()
        showCards = [Card]()

        playerBusted = false
        //reset bet value
        if bet > 50 {bet = 50}
        
        currentAce = 0
        
        endGame = false
    }
    
    //MARK: control sound icon
    func checkSound() -> String {
        if mute {
            return "speaker.slash.fill"
        }
        return "speaker.3.fill"
    }
    
    //MARK: - Control game sound
    func soundControl(sound: SoundOption) {
        if !mute {
            SoundManager.instance.playSound(sound: sound, fileType: .mp3)
        }
    }
    
    //MARK: - Initialize game
    func initilizeGame() {
        //Play new backgound sound
//        SoundManager.instance.pauseBackgroundSound()
        if(!mute) {
            SoundManager.instance.playBackgroundSound(sound: .BattleTheme, fileType: .mp3)
        }
        
        //get player by username from user defaults
        if(plays == 0) {
            player = funcs.findPlayer(username: username)
        }
        
        if bet > player.coin {
            //SHow warning
            showWarning = true
            endGame = true
        } else {
            // initilize a standard 52 card deck
            for type in card_types {
                for rank in card_ranks {
                    allCards.append(Card(type: type, rank: rank))
                }
            }
            // shuffle the deck
            allCards.shuffle()
            // draw 2 card for both player and dealer
            for _ in 0...2-1 {
                playerCards.append(self.drawCard())
                dealerCards.append(self.drawCard())
            }
            
            //default: show player cards
            showCards = playerCards
            
            // add dealer cards to another array to show to UI
            showDealerCards.append(dealerCards[0])
            showDealerCards.append(Card(type: "face", rank: "down"))
            
            //Player turn
            playerTurn = true
            
            //Check blackjack
            self.checkBlackjack()
        }
    }
    
    // MARK: - Draw card
    func drawCard() -> Card  {
        let randomCard = allCards[Int.random(in: 0...allCards.count - 1)] //get a random card from all_cards
        let index = allCards.firstIndex(where: {$0.id == randomCard.id})! //Get the index of that card
        allCards.remove(at: index) // remove the card from all_cards
        soundControl(sound: .card_flip)

        return randomCard
    }
    
    //MARK: - calculate total point
    func calculateCardValue(cards: [Card]) -> Int {
        var total = 0
        for card in cards {
            total = total + card.value
        }
        
        return total
    }
    
    //MARK: - Player options
    func hit() {
        playerCards.append(self.drawCard())
        self.updateShowCards()
        self.checkPlayerBusted()
    }
    
    func doubleDown() {
        bet *= 2
        playerCards.append(self.drawCard())
        self.updateShowCards()
        self.checkPlayerBusted()
        if (!playerBusted) {
            self.stand()
        }
        //Dealer turn
        // self.dealer_turn()
    }
    
    func stand() {
        //Change player turn to dealer turn
        playerTurn = false
        self.checkWinner()
        //Dealer turn
        // self.dealer_turn()
    }
    
    func surrender() {
        playerTurn = false
        self.showResult(imageName: "surrender")
    }
    
    func updateShowCards() {
        var arr = [Card]()
        for i in 0...playerCards.count-2 {
            arr.append(playerCards[i])
        }
        if (showCards == arr) {
            showCards.append(playerCards[playerCards.count-1])
        }
    }
    
    //MARK: - Dealer logic
    
    func dealerTurn() {
        dealerPoint = calculateCardValue(cards: dealerCards)
  
        while(dealerPoint <= 16 || dealerPoint > 21) {
            
            //Draw 1 more card when dealer point is smaller than 16 and recalculate total
            if (dealerPoint <= 16) {
                dealerCards.append(self.drawCard())
                dealerPoint = calculateCardValue(cards: dealerCards)
            }
            
            //Change ace value to 1 when dealer point is greater than 21
            if (dealerPoint > 21) {
                let breakLoop = self.changeAceValue() //Change the first ace value to 1
                dealerPoint = calculateCardValue(cards: dealerCards)
                if (breakLoop) { //break loop when there is no ace with value of 11
                    break
                }
            }
        }
    }
    
    func easyAI() {
        while(dealerPoint <= 16) {
            
            //Draw 1 more card when dealer point is smaller than 16 and recalculate total
            if (dealerPoint <= 16) {
                dealerCards.append(self.drawCard())
                dealerPoint = calculateCardValue(cards: dealerCards)
            }
        }
    }
    
    func changeAceValue() -> Bool {

        // Check for aces with value of 11
        let aces = dealerCards.filter{card in
          card.rank == "ace" && card.value == 11
        }
        if (aces.count > 0) {
          //Find index of the first ace with value of 11
          let index = dealerCards.firstIndex(where: {$0.rank == "ace" && $0.value == 11})!
          //Change the value to 1
          dealerCards[index].value = 1
          //find total
          dealerPoint = self.calculateCardValue(cards: dealerCards)
          return false
        }
        return true
    }
    
    func checkPlayerMoney() {
        if player.coin < 0 {
            player.coin = 0
        }
    }

    //MARK: Check player achievements
    func checkConsecutiveWins() {
        win += 1
        if win >= 2 && player.consecutiveWin < win {
            player.consecutiveWin = win
            showHighscore = true
            soundControl(sound: .highscore)
            funcs.savePlayer(player: player)
        }
        
        if (player.consecutiveWin == 2 && !player.achievements[0].gained) {
            player.achievements[0].gained = true
            showConsecutiveWins = true
            soundControl(sound: .highscore)
            funcs.savePlayer(player: player)
        }
    }
    
    func checkBlackjackAchievement() {
        player.blackjack += 1
        if (player.blackjack == 3 && !player.achievements[1].gained) {
            player.achievements[1].gained = true
            showBlackjack = true
            soundControl(sound: .highscore)
            funcs.savePlayer(player: player)
        }
    }
    
    //MARK: Show result
    func showResult(imageName: String) {
        if (imageName == "busted" || imageName == "you lose") {
            SoundManager.instance.pauseBackgroundSound()
            soundControl(sound: .DefeatTheme)
            player.coin -= bet
            checkPlayerMoney()
            win = 0
        } else if (imageName == "you win") {
            SoundManager.instance.pauseBackgroundSound()
            soundControl(sound: .VictoryTheme)
            player.coin += bet
            checkConsecutiveWins()
        } else if (imageName == "surrender") {
            SoundManager.instance.pauseBackgroundSound()
            soundControl(sound: .DefeatTheme)
            player.coin -= (bet/2)
            checkPlayerMoney()
            win = 0
        } else if (imageName == "draw") {
            SoundManager.instance.pauseBackgroundSound()
            soundControl(sound: .DefeatTheme)
            win = 0
        }
        
        
        self.imageName = imageName
        //show result
        showPopup = true
        playerTurn = false
        endGame = true
        
        plays += 1
    }
    
    //MARK: - check winner
    func checkWinner() {
        if difficulty == "Pros" {
            self.dealerTurn()
        } else {
            self.easyAI()
        }
        showDealerCards = dealerCards
        
        //Calculate point of both player and dealer
        dealerPoint = self.calculateCardValue(cards: dealerCards)
        playerPoint = self.calculateCardValue(cards: playerCards)
        
        if (playerPoint > dealerPoint || dealerPoint > 21) {
            self.showResult(imageName: "you win")
        } else if (playerPoint < dealerPoint) {
            self.showResult(imageName: "you lose")
        } else if (playerPoint == dealerPoint) {
            self.showResult(imageName: "draw")
        }
    }
    
    func checkCards(card: [Card]) -> Bool {
        if (card[0].rank == "A" && card[1].rank == "10") ||
            (card[0].rank == "10" && card[1].rank == "A") {
            return true
        }
        return false
    }
    
    func checkBlackjack() {
        let dealerBlackjack = self.checkCards(card: dealerCards)
        let playerBlackjack = self.checkCards(card: playerCards)
        
        if (playerBlackjack && dealerBlackjack) {
            self.showResult(imageName: "draw")
        } else if (playerBlackjack) {
            self.showResult(imageName: "you win")
            checkBlackjackAchievement()
        } else if (dealerBlackjack) {
            self.showResult(imageName: "you lose")
        }
    }
    
    func checkPlayerBusted(){
        playerPoint = self.calculateCardValue(cards: playerCards)
        if (playerPoint > 21) {
            self.showResult(imageName: "busted")
            playerBusted = true
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack() {
                    //MARK: Header
                    HStack {
                        Image(systemName: "chevron.left.2").onTapGesture {
                            showSheet = false
                            funcs.savePlayer(player: player)
                        }.frame(maxWidth: .infinity, alignment: .topLeading)
                            .foregroundColor(.black)
                        Image(systemName: "plus.square.fill").onTapGesture {
                            showAddCoin = true
                        }.foregroundColor(.black)
                        Image(systemName: "arrow.clockwise.circle.fill").onTapGesture {
                            self.resetGame()
                            self.initilizeGame()
                        }.disabled(!endGame)
                        Image(systemName: checkSound()).onTapGesture {
                            mute.toggle()
                        }
                    }.padding()
                        .background(darkYellow)
                    
                    
                    VStack {
                        //MARK: Dealer cards
                        Text("Dealer \(difficulty)").padding().background(lightBlue).foregroundColor(.white).cornerRadius(15)
                        HStack{
                            ForEach(showDealerCards, id: \.id) { card in
//                                Image(card.image_name).resizable()
//                                    .frame(width: 50, height: 100, alignment: .center)
                                CardView(faceUpName: card.imageName, width: 65, height: 100)
                            }.onTapGesture {
                                showCards = showDealerCards
                            }
                        }.frame(maxWidth: geometry.size.width, maxHeight:geometry.size.height*0.15)
                        //MARK: Player cards
                        Text("\(player.username): \(player.coin)").padding().background(lightBlue).foregroundColor(.white).cornerRadius(15)
                        // Player card list
                        ScrollView(.horizontal) {
                            HStack(){
                                ForEach(playerCards, id: \.id) { card in
                                    CardView(faceUpName: card.imageName, width: 65, height: 100)
                                }.onTapGesture {
                                    showCards = playerCards
                                }
                            }.frame(width: geometry.size.width, height: geometry.size.height*0.15)
                        }
                    }
                    
                    VStack{
                        //MARK: SHow hand (player, dealer)
                        ScrollView(.horizontal) {
                            HStack() {
                                ForEach(showCards, id: \.id) { card in
                                    CardView(faceUpName: card.imageName, width: 100, height: 200)
                                        .onTapGesture {
                                            if (showCards == playerCards && card.rank == "ace") {
                                                showChooseValueOp = true
                                                currentAce = playerCards.firstIndex(where: {card.id == $0.id})!
                                            }
                                        }
                                }.actionSheet(isPresented: $showChooseValueOp, content: {
                                    ActionSheet(
                                        title: Text("Choose value for your \(playerCards[currentAce].imageName)"),
                                        buttons: [
                                            .default(Text("1")) {
                                                playerCards[currentAce].value = 1
                                                showCards[currentAce].value = 1
                                                playerPoint = self.calculateCardValue(cards: playerCards)
                                                self.checkPlayerBusted()
                                            },
                                            .default(Text("11")) {
                                                playerCards[currentAce].value = 11
                                                showCards[currentAce].value = 11
                                                playerPoint = self.calculateCardValue(cards: playerCards)
                                                self.checkPlayerBusted()
                                            },
                                            .destructive(Text("Cancel"))
                                        ]
                                    )
                                })
                            }.frame(width: geometry.size.width)
                        }
                        
                        //MARK: SHow player options
                        HStack {
                            PlayerOptionView(playerTurn: $playerTurn, width: geometry.size.width*0.3, height: geometry.size.height*0.07, name: "Hit")
                                .onTapGesture {
                                    if(playerTurn){self.hit()}
                                }
                                
                            
                            PlayerOptionView(playerTurn: $playerTurn, width: geometry.size.width*0.3, height: geometry.size.height*0.07, name: "Double down")
                                .onTapGesture {
                                    if(playerTurn){self.doubleDown()}
                                }
                        }
                        HStack{
                            PlayerOptionView(playerTurn: $playerTurn, width: geometry.size.width*0.3, height: geometry.size.height*0.07, name: "Stand").onTapGesture {
                                    if(playerTurn){self.stand()}
                                }
                            PlayerOptionView(playerTurn: $playerTurn, width: geometry.size.width*0.3, height: geometry.size.height*0.07, name: "Surrender").onTapGesture {
                                    if(playerTurn){self.surrender()}
                                }
                        }
                    
                        HStack{
                            Image("coin").resizable().frame(width: geometry.size.width*0.1, height: geometry.size.width*0.1).background(darkGreen)
                            Text("\(bet)").onTapGesture {
                                if bet >= 50 {
                                    bet = 10
                                } else {
                                    bet += 10
                                }
                                if bet > player.coin {
                                    showWarning = true
                                    bet = 10
                                }
                                soundControl(sound: .bet_chip)
                            }.foregroundColor(darkYellow).font(bodyFont)
                                .frame(maxWidth:.infinity, alignment: .leading)
                        }
                    }.frame(maxHeight:.infinity, alignment: .bottom)
                }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                
                //MARK: Result popupimageNamedealerCardsplayerCards
                PopUp(showPopup: $showPopup, imageName: imageName, dealerCards: dealerCards, playerCards: playerCards, playerPoint: playerPoint, dealerPoint: dealerPoint, height: geometry.size.width*0.9)
                
                //MARK: Add coin
                AddCoinView(showAddCoin: $showAddCoin, player: $player, height: geometry.size.height*0.09, width: geometry.size.width*0.2)
                
                //MARK: Warning
                WarningView(showWarning: $showWarning)
                
                //MARK: Achievement badge
                BadgeView(showBadge: $showConsecutiveWins, imageName: player.achievements[0].image_name, achievemnetName: player.achievements[0].name, achievementContent: player.achievements[0].content)
                
                BadgeView(showBadge: $showBlackjack, imageName: player.achievements[1].image_name, achievemnetName: player.achievements[1].name, achievementContent: player.achievements[1].content)
                
                //MARK: Highscore view
                HighscoreView(showHighscore: $showHighscore, consecutiveWin: player.consecutiveWin)
                
            }
            .onAppear{self.initilizeGame()} //Initilize game on appear
            .background(colorScheme == .light ? AnyView(Image("background_image").resizable().edgesIgnoringSafeArea(.all)) :
                AnyView(Image("dark_background").resizable().edgesIgnoringSafeArea(.all)))
            	
        }
    }
}

//struct GameView_Preview: PreviewProvider {
//    static var previews: some View {
//        GameView(showSheet: .constant(true), mute: .constant(true), username: "Duc", difficulty: "Beginner")
//    }
//}
