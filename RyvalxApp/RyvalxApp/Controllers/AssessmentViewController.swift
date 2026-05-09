//
//  AssessmentViewController.swift
//  RyvalxApp
//
//  Created by Abishek on 08/05/26.
//

import UIKit

struct AssessmentQuestion {
    let code: String
    let text: String
    var selectedRating: Int?
}

let ratingEmojis = ["😑", "😐", "🙂", "😊", "😄"]
let ratingLabels = ["Needs Work", "Fair", "Good", "Very Good", "Excellent"]

class AssessmentViewController: UIViewController {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var subtitleLbl: UILabel!
    @IBOutlet weak var skipBtn: UIButton!
    
    @IBOutlet weak var techLbl: UILabel!
    @IBOutlet weak var tacLbl: UILabel!
    @IBOutlet weak var phyLbl: UILabel!
    @IBOutlet weak var menLbl: UILabel!
    
    @IBOutlet weak var techDot: UIView!
    @IBOutlet weak var tacDot: UIView!
    @IBOutlet weak var phyDot: UIView!
    @IBOutlet weak var menDot: UIView!
    
    @IBOutlet weak var battingBtn: UIButton!
    @IBOutlet weak var bowlingBtn: UIButton!
    @IBOutlet weak var fieldingBtn: UIButton!
    
    @IBOutlet weak var questionsTV: UITableView!
    @IBOutlet weak var nextBtn: UIButton!
    
    @IBOutlet weak var pillarStack: UIStackView!
    
    var questions: [AssessmentQuestion] = [
        AssessmentQuestion(code: "BAT-T1", text: "Against quality bowling, how reliable is your batting technique in terms of balance, timing, and control?", selectedRating: nil),
        AssessmentQuestion(code: "BAT-T2", text: "How consistently are you able to execute correct batting technique against both pace and spin?", selectedRating: nil),
        AssessmentQuestion(code: "BAT-T3", text: "How well can you control the ball when playing attacking shots, independent of match situation?", selectedRating: nil)
    ]
    
    var selectedTabIndex = 0
    var currentPillarIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        fixPillarStackLayout()
        updateStepperUI()
        updateTabSelection()
        
        techLbl.text = "Technical"
        tacLbl.text = "Tactical"
        phyLbl.text = "Physical"
        menLbl.text = "Mental"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        questionsTV.layoutIfNeeded()
    }
    
    func setupUI() {
        view.backgroundColor = UIColor(red: 0.95, green: 0.96, blue: 0.97, alpha: 1.0)
        
        titleLbl.text = "Assessment"
        titleLbl.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        
        subtitleLbl.text = "Drill-down of questions based on selected pillar and user ratings"
        subtitleLbl.font = UIFont.systemFont(ofSize: 13)
        subtitleLbl.textColor = UIColor(red: 0.62, green: 0.67, blue: 0.74, alpha: 1.0)
        subtitleLbl.numberOfLines = 2
        
        skipBtn.setTitle("Skip", for: .normal)
        skipBtn.setTitleColor(UIColor(red: 0.13, green: 0.53, blue: 0.87, alpha: 1.0), for: .normal)
        skipBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        skipBtn.layer.borderWidth = 1.5
        skipBtn.layer.borderColor = UIColor(red: 0.13, green: 0.53, blue: 0.87, alpha: 1.0).cgColor
        skipBtn.layer.cornerRadius = 6
        skipBtn.contentEdgeInsets = UIEdgeInsets(top: 6, left: 16, bottom: 6, right: 16)
        
        if var config = nextBtn.configuration {
            config.baseBackgroundColor = UIColor(red: 0.13, green: 0.73, blue: 0.87, alpha: 1.0)
            config.cornerStyle = .medium
            config.title = "Next"
            config.baseForegroundColor = .white
            nextBtn.configuration = config
        } else {
            nextBtn.setTitle("Next", for: .normal)
            nextBtn.backgroundColor = UIColor(red: 0.13, green: 0.73, blue: 0.87, alpha: 1.0)
            nextBtn.layer.cornerRadius = 14
            nextBtn.setTitleColor(.white, for: .normal)
        }
        
        techLbl.text = "Technical"
        tacLbl.text = "Tactical"
        phyLbl.text = "Physical"
        menLbl.text = "Mental"
        
        let pillarLabels = [techLbl, tacLbl, phyLbl, menLbl]
        pillarLabels.forEach { label in
            label?.numberOfLines = 2
            label?.adjustsFontSizeToFitWidth = true
            label?.minimumScaleFactor = 0.6
            label?.textAlignment = .center
            label?.lineBreakMode = .byWordWrapping
            label?.setContentCompressionResistancePriority(.required, for: .horizontal)
            label?.setContentHuggingPriority(.required, for: .horizontal)
        }
        
        [techDot, tacDot, phyDot, menDot].forEach { dot in
            dot?.layer.cornerRadius = 5
            dot?.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)
        }
        techDot.backgroundColor = UIColor(red: 0.13, green: 0.53, blue: 0.87, alpha: 1.0)
        techLbl.font = UIFont.systemFont(ofSize: 11, weight: .bold)
        techLbl.textColor = UIColor(red: 0.13, green: 0.53, blue: 0.87, alpha: 1.0)
    }
    
    func fixPillarStackLayout() {
        guard let stack = pillarStack else { return }
        stack.distribution = .fillProportionally
        stack.alignment = .fill
        stack.spacing = 8
        
        if let heightConstraint = stack.constraints.first(where: { $0.firstAttribute == .height && $0.relation == .equal }) {
            heightConstraint.isActive = false
        }
        
        let labels = [techLbl, tacLbl, phyLbl, menLbl]
        for label in labels {
            label?.setContentCompressionResistancePriority(.required, for: .horizontal)
            label?.setContentHuggingPriority(.required, for: .horizontal)
            label?.numberOfLines = 2
            label?.adjustsFontSizeToFitWidth = true
            label?.minimumScaleFactor = 0.7
        }
        
        stack.layoutIfNeeded()
    }
    
    func setupTableView() {
        questionsTV.delegate = self
        questionsTV.dataSource = self
        questionsTV.separatorStyle = .none
        questionsTV.backgroundColor = .clear
        questionsTV.showsVerticalScrollIndicator = true
        questionsTV.register(QuestionTableViewCell.self, forCellReuseIdentifier: "QuestionCell")
        questionsTV.rowHeight = UITableView.automaticDimension
        questionsTV.estimatedRowHeight = 200
        questionsTV.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
    }
    
    func updateStepperUI() {
        let pillars: [(UILabel?, UIView?)] = [
            (techLbl, techDot),
            (tacLbl, tacDot),
            (phyLbl, phyDot),
            (menLbl, menDot)
        ]
        
        for (index, (label, dot)) in pillars.enumerated() {
            let isSelected = (index == currentPillarIndex)
            
            label?.textColor = isSelected ? UIColor(red: 0.13, green: 0.53, blue: 0.87, alpha: 1.0) : UIColor(red: 0.62, green: 0.67, blue: 0.74, alpha: 1.0)
            label?.font = UIFont.systemFont(ofSize: 11, weight: isSelected ? .bold : .regular)
            
            if isSelected {
                let attributedString = NSMutableAttributedString(string: label?.text ?? "")
                attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributedString.length))
                attributedString.addAttribute(.underlineColor, value: UIColor(red: 0.13, green: 0.53, blue: 0.87, alpha: 1.0), range: NSRange(location: 0, length: attributedString.length))
                label?.attributedText = attributedString
            } else {
                label?.attributedText = nil
            }
            
            dot?.backgroundColor = isSelected ? UIColor(red: 0.13, green: 0.53, blue: 0.87, alpha: 1.0) : UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)
        }
    }
    
    func updateTabSelection() {
        let tabs = [(battingBtn, "Batting", "sportscourt.fill"),
                    (bowlingBtn, "Bowling", "baseball.fill"),
                    (fieldingBtn, "Fielding", "globe")]
        let selectedColor = UIColor(red: 0.13, green: 0.73, blue: 0.87, alpha: 1.0)
        let normalColor = UIColor(red: 0.62, green: 0.67, blue: 0.74, alpha: 1.0)
        
        for (index, (button, title, iconName)) in tabs.enumerated() {
            let isSelected = (index == selectedTabIndex)
            var config = UIButton.Configuration.plain()
            config.image = UIImage(systemName: iconName, withConfiguration: UIImage.SymbolConfiguration(pointSize: 16, weight: .medium))
            config.imagePlacement = .leading
            config.imagePadding = 8
            config.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 8, bottom: 6, trailing: 8)
            var titleAttr = AttributedString(title)
            titleAttr.font = UIFont.systemFont(ofSize: 15, weight: isSelected ? .semibold : .regular)
            config.attributedTitle = titleAttr
            config.baseForegroundColor = isSelected ? selectedColor : normalColor
            button?.configuration = config
        }
    }
    
    @IBAction func skipButtonTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func battingTabTapped(_ sender: UIButton) {
        selectedTabIndex = 0
        updateTabSelection()
        loadQuestions(for: "batting")
    }
    
    @IBAction func bowlingTabTapped(_ sender: UIButton) {
        selectedTabIndex = 1
        updateTabSelection()
        loadQuestions(for: "bowling")
    }
    
    @IBAction func fieldingTabTapped(_ sender: UIButton) {
        selectedTabIndex = 2
        updateTabSelection()
        loadQuestions(for: "fielding")
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        let unanswered = questions.filter { $0.selectedRating == nil }
        if !unanswered.isEmpty {
            showAlert(title: "Incomplete", message: "Please rate all questions before continuing.")
            return
        }
        
        if currentPillarIndex < 3 {
            currentPillarIndex += 1
            updateStepperUI()
            resetQuestions()
            questionsTV.reloadData()
        } else {
            showAlert(title: "Complete", message: "Assessment completed successfully!")
        }
    }
    
    func loadQuestions(for category: String) {
        switch category {
        case "batting":
            questions = [
                AssessmentQuestion(code: "BATT-1", text: "Against quality bowling, how reliable is your batting technique in terms of balance, timing, and control?", selectedRating: nil),
                AssessmentQuestion(code: "BATT-2", text: "How consistently are you able to execute correct batting technique against both pace and spin?", selectedRating: nil),
                AssessmentQuestion(code: "BATT-3", text: "How well can you control the ball when playing attacking shots, independent of match situation?", selectedRating: nil)
            ]
        case "bowling":
            questions = [
                AssessmentQuestion(code: "BOWL-1", text: "How accurate is your line and length under match pressure?", selectedRating: nil),
                AssessmentQuestion(code: "BOWL-2", text: "How effectively can you execute different types of deliveries?", selectedRating: nil),
                AssessmentQuestion(code: "BOWL-3", text: "How well do you maintain consistency in your bowling action?", selectedRating: nil)
            ]
        case "fielding":
            questions = [
                AssessmentQuestion(code: "FIELD-1", text: "How reliable are your catching skills in high-pressure situations?", selectedRating: nil),
                AssessmentQuestion(code: "FIELD-2", text: "How quickly and accurately can you throw the ball to the wicket?", selectedRating: nil),
                AssessmentQuestion(code: "FIELD-3", text: "How effective is your ground fielding technique?", selectedRating: nil)
            ]
        default: break
        }
        DispatchQueue.main.async {
            self.questionsTV.reloadData()
        }
    }
    
    func resetQuestions() {
        for i in questions.indices {
            questions[i].selectedRating = nil
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension AssessmentViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionCell", for: indexPath) as? QuestionTableViewCell else {
            return UITableViewCell()
        }
        let question = questions[indexPath.row]
        cell.configure(with: question, selectedRating: question.selectedRating)
        cell.onRatingSelected = { [weak self] ratingIndex in
            self?.questions[indexPath.row].selectedRating = ratingIndex
            DispatchQueue.main.async {
                self?.questionsTV.reloadRows(at: [indexPath], with: .none)
            }
        }
        return cell
    }
}

class QuestionTableViewCell: UITableViewCell {
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.06
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let codeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.textColor = UIColor(red: 0.13, green: 0.53, blue: 0.87, alpha: 1.0)
        label.backgroundColor = UIColor(red: 0.88, green: 0.95, blue: 1.0, alpha: 1.0)
        label.layer.cornerRadius = 6
        label.layer.masksToBounds = true
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let questionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .black
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let ratingStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    var onRatingSelected: ((Int) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        containerView.addSubview(codeLabel)
        containerView.addSubview(questionLabel)
        containerView.addSubview(ratingStackView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            codeLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            codeLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            codeLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 60),
            codeLabel.heightAnchor.constraint(equalToConstant: 24),
            
            questionLabel.topAnchor.constraint(equalTo: codeLabel.bottomAnchor, constant: 8),
            questionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            questionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            
            ratingStackView.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 16),
            ratingStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            ratingStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            ratingStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
            ratingStackView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    func configure(with question: AssessmentQuestion, selectedRating: Int?) {
        codeLabel.text = question.code
        questionLabel.text = question.text
        
        ratingStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for index in 0..<ratingLabels.count {
            let isSelected = (index == selectedRating)
            let button = createRatingButton(emoji: ratingEmojis[index],
                                            title: ratingLabels[index],
                                            tag: index,
                                            isSelected: isSelected)
            button.addTarget(self, action: #selector(ratingButtonTapped(_:)), for: .touchUpInside)
            ratingStackView.addArrangedSubview(button)
        }
    }
    
    func createRatingButton(emoji: String, title: String, tag: Int, isSelected: Bool) -> UIButton {
        let button = UIButton(type: .custom)
        button.tag = tag
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 4
        stackView.isUserInteractionEnabled = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let emojiLabel = UILabel()
        emojiLabel.text = emoji
        emojiLabel.font = UIFont.systemFont(ofSize: 28)
        emojiLabel.textAlignment = .center
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 10, weight: isSelected ? .semibold : .regular)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        titleLabel.textColor = isSelected ? UIColor(red: 0.13, green: 0.73, blue: 0.87, alpha: 1.0) : UIColor(red: 0.62, green: 0.67, blue: 0.74, alpha: 1.0)
        
        stackView.addArrangedSubview(emojiLabel)
        stackView.addArrangedSubview(titleLabel)
        button.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: button.topAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: -8),
            stackView.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 4),
            stackView.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -4)
        ])
        
        button.backgroundColor = isSelected ? UIColor(red: 0.13, green: 0.73, blue: 0.87, alpha: 0.1) : UIColor(red: 0.95, green: 0.96, blue: 0.97, alpha: 1.0)
        button.layer.cornerRadius = 8
        button.layer.borderWidth = isSelected ? 1 : 0
        button.layer.borderColor = isSelected ? UIColor(red: 0.13, green: 0.73, blue: 0.87, alpha: 1.0).cgColor : UIColor.clear.cgColor
        
        return button
    }
    
    @objc private func ratingButtonTapped(_ sender: UIButton) {
        onRatingSelected?(sender.tag)
    }
}
