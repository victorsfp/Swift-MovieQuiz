//
//  QuizManager.swift
//  MovieQuiz
//
//  Created by Victor dos Santos Feitosa (P) on 16/11/22.
//

import Foundation

typealias Round = (quiz: Quiz, options:[QuizOption])

class QuizManager {
    var quizes: [Quiz]
    var quizOptions: [QuizOption]
    var round: Round?
    var score: Int
    
    init(){
        self.score = 0
        let quizesURL = Bundle.main.url(forResource: "quizes", withExtension: "json")!
        do {
            let quizesData = try Data(contentsOf: quizesURL)
            self.quizes = try JSONDecoder().decode([Quiz].self, from: quizesData)
            
            let quizOptionsURL = Bundle.main.url(forResource: "options", withExtension: "json")!
            let quizOptionData = try Data(contentsOf: quizOptionsURL)
            self.quizOptions = try JSONDecoder().decode([QuizOption].self, from: quizOptionData)
        } catch {
            print(error.localizedDescription)
            self.quizes = []
            self.quizOptions = []
        }
    }
    
    func generateRandomQuiz() -> Round {
        let quizIndex = Int(arc4random_uniform(UInt32(quizes.count)))
        let quiz = quizes[quizIndex]
        var indexes: Set<Int> = [quizIndex]
        
        while indexes.count < 4 {
            let index = Int(arc4random_uniform(UInt32(quizes.count)))
            indexes.insert(index)
        }
        
        let options = indexes.map({ quizOptions[$0] })
        
        round = (quiz, options)
        return round!
    }
    
    func checkAnswer(_ answer: String){
        guard let round = round else { return }
        if answer == round.quiz.name {
            score += 1
        }
    }
}


struct Quiz: Codable {
    let name: String
    let number: Int
}

struct QuizOption: Codable {
    let name: String
}
