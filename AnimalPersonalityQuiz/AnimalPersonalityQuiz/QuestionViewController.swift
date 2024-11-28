
import UIKit

class QuestionViewController: UIViewController {
    
    @IBOutlet var questionLabel: UILabel!
    
    @IBOutlet weak var singleStackView: UIStackView!
    @IBOutlet var singleButton1: UIButton!
    @IBOutlet var singleButton2: UIButton!
    @IBOutlet var singleButton3: UIButton!
    @IBOutlet var singleButton4: UIButton!
    
    @IBOutlet weak var multipleStackView: UIStackView!
    @IBOutlet var multipleLabel1: UILabel!
    @IBOutlet var multipleLabel2: UILabel!
    @IBOutlet var multipleLabel3: UILabel!
    @IBOutlet var multipleLabel4: UILabel!
    
    @IBOutlet var multiSwitch1: UISwitch!
    @IBOutlet var multiSwitch2: UISwitch!
    @IBOutlet var multiSwitch3: UISwitch!
    @IBOutlet var multiSwitch4: UISwitch!
    
    
    @IBOutlet weak var rangedStackView: UIStackView!
    @IBOutlet var rangedLabel1: UILabel!
   
    @IBOutlet var rangedLabel2: UILabel!
    
    @IBOutlet var rangedSlider: UISlider!
    
    @IBOutlet var questionProgressBar: UIProgressView!
    
    var questionIndex = 0
    var answerChosen : [Answer] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
updateUI()
    
    }
    
    
    @IBAction func singleAnswerButtonPressed(_ sender: UIButton) {
        let currentAnswer = questions[questionIndex].answers
        
        switch sender {
        case singleButton1:
            answerChosen.append(currentAnswer[0])
        case singleButton2:
            answerChosen.append(currentAnswer[1])
        case singleButton3:
            answerChosen.append(currentAnswer[2])
        case singleButton4:
            answerChosen.append(currentAnswer[3])
        default:
            break
        }
        nextQuestion()
    }
    
    
    @IBAction func multipleAnswerButtonPressed() {
        let currentAnswer = questions[questionIndex].answers
        print(currentAnswer)

        if multiSwitch1.isOn{
            answerChosen.append(currentAnswer[0])

        }
        if multiSwitch2.isOn{
            answerChosen.append(currentAnswer[1])
        }
        if multiSwitch3.isOn{
            answerChosen.append(currentAnswer[2])
        }
        if multiSwitch4.isOn{
            answerChosen.append(currentAnswer[3])
        }
        nextQuestion()
        
    }
    
    
    @IBAction func rangedAnswerButtonPressed() {

        rangedLabel1.numberOfLines = 0
        rangedLabel1.lineBreakMode = .byWordWrapping
        rangedLabel2.numberOfLines = 0
        rangedLabel2.lineBreakMode = .byWordWrapping
            let currentAnswer = questions[questionIndex].answers
            
            guard !currentAnswer.isEmpty else {
                print("Error: No answers available for the current question")
                return
            }

            let index = max(0, min(currentAnswer.count - 1, Int(round(rangedSlider.value * Float(currentAnswer.count - 1)))))
            answerChosen.append(currentAnswer[index])
            nextQuestion()
        }
    
    
    func nextQuestion(){
        questionIndex += 1
        
        if questionIndex < questions.count {
            updateUI()
        }
        else{
            performSegue(withIdentifier: "Results", sender: nil)
        }
    }
    func updateUI(){
        singleStackView.isHidden = true
        multipleStackView.isHidden = true
        rangedStackView.isHidden = true
        
        let currentQuestion = questions[questionIndex]
        let currentAnswer = currentQuestion.answers
        let totalProgress = Float(questionIndex)/Float(questions.count)
        
        navigationItem.title = "Question: \(questionIndex + 1)"

        questionLabel.text = currentQuestion.text
        questionProgressBar.setProgress(totalProgress, animated: true)
        
        
        
        switch currentQuestion.type {
        case .single:
            updateSingleStackView(using: currentAnswer)
        case .multiple:
            updateMultipleStackView(using: currentAnswer)
        case .ranged:
            updateRangedStackView(using: currentAnswer)
        }
    }
    
    
    func updateSingleStackView(using answers : [Answer]){
        singleStackView.isHidden = false
        singleButton1.setTitle(answers[0].text, for: .normal)
        singleButton2.setTitle(answers[1].text, for: .normal)
        singleButton3.setTitle(answers[2].text, for: .normal)
        singleButton4.setTitle(answers[3].text, for: .normal)
    }
    
    func updateMultipleStackView(using answers : [Answer]){
        multipleStackView.isHidden = false
        multiSwitch1.isOn = false
        multiSwitch2.isOn = false
        multiSwitch3.isOn = false
        multiSwitch4.isOn = false
        multipleLabel1.text = answers[0].text
        multipleLabel2.text = answers[1].text
        multipleLabel3.text = answers[2].text
        multipleLabel4.text = answers[3].text
    }
    
    func updateRangedStackView(using answers : [Answer]){
        rangedStackView.isHidden = false
        rangedSlider.setValue(0.5, animated: false)
        rangedLabel1.text = answers.first?.text
        rangedLabel2.text = answers.last?.text
    }
    var questions: [Question] = [
        Question(
            text:"Which food do you like the most?", type: .single, answers: [
                Answer(text: "Steak", type: .dog),
            Answer(text: "Fish", type: .cat),
            Answer(text: "Carrots", type: .rabbit),
            Answer(text: "Corn", type: .turtle)
        ]),
        Question(text: "which activities do you enjoy?", type: .multiple, answers:  [
            Answer(text: "Swimming", type: .turtle),
            Answer(text: "Sleepin", type: .cat),
            Answer(text: "Cuddling", type: .rabbit),
            Answer(text: "Eating", type: .dog)
        ]),
        Question(text:"how much do you wnjoy car rides?", type: .ranged, answers: [
            Answer(text: "I dislike them", type: .cat),
            Answer(text: "I get a little nervous", type: .rabbit),
            Answer(text: "I barely notice them", type: .turtle),
            Answer(text: "I love them", type: .dog)        ])

    ]
    
    
    
    @IBSegueAction func showResults(_ coder: NSCoder) -> ResultViewController? {
        return ResultViewController(coder: coder,responses: answerChosen)
    }
    
}
