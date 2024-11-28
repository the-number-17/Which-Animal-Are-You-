//
//  ResultViewController.swift
//  AnimalPersonalityQuiz
//
//  Created by Batch - 1 on 06/09/1946 Saka.
//

import UIKit



class ResultViewController: UIViewController {
    
    
    @IBOutlet var resultAnswerLabel: UILabel!
    @IBOutlet var resultDescriptionLabel: UILabel!
    
    var responses : [Answer]
    init?(coder: NSCoder, responses: [Answer]){
        self.responses = responses
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationItem.hidesBackButton = true
calculatePersonalityResult()
        
    }
    
    
    func calculatePersonalityResult(){
        let frequencyOfAnswers = responses.reduce(into: [AnimalType : Int]()) {
            (counts, answer) in
            if let existingCount = counts[answer.type]{
                counts[answer.type] = existingCount + 1
            }
            else{
                counts[answer.type] = 1
            }
        }
        
        let frequentAnswerSorted = frequencyOfAnswers.sorted(by: { (pair1, pair2) in
            return pair1.value > pair2.value
        })
        
        let mostCommonAnswer = frequencyOfAnswers.sorted{ $0.1 > $1.1 }.first!.key
        
        
        resultAnswerLabel.text = "You are a \(mostCommonAnswer.rawValue)!"
        
        resultDescriptionLabel.text = mostCommonAnswer.definition
    }
    
    
    
}
