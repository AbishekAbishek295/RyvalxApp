//
//  RoleViewController.swift
//  RyvalxApp
//
//  Created by Abishek on 08/05/26.
//

import UIKit

class RoleViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var battingCard: UIView!
    @IBOutlet weak var battingRadio: UIButton!
    @IBOutlet weak var battingLabel: UILabel!
    @IBOutlet weak var battingIcon: UIImageView!
    
    @IBOutlet weak var bowlingCard: UIView!
    @IBOutlet weak var bowlingRadio: UIButton!
    @IBOutlet weak var bowlingLabel: UILabel!
    @IBOutlet weak var bowlingIcon: UIImageView!
    
    @IBOutlet weak var wicketCard: UIView!
    @IBOutlet weak var wicketRadio: UIButton!
    @IBOutlet weak var wicketLabel: UILabel!
    @IBOutlet weak var wicketIcon: UIImageView!
    
    @IBOutlet weak var allRounderCard: UIView!
    @IBOutlet weak var allRounderRadio: UIButton!
    @IBOutlet weak var allRounderLabel: UILabel!
    @IBOutlet weak var allRounderIcon: UIImageView!
    
    @IBOutlet weak var row1Stack: UIStackView!
    @IBOutlet weak var row2Stack: UIStackView!
    
    @IBOutlet weak var battingStyleLabel: UILabel!
    @IBOutlet weak var battingStyleButton: UIButton!
    
    @IBOutlet weak var bowlingStyleLabel: UILabel!
    @IBOutlet weak var bowlingStyleButton: UIButton!
    
    @IBOutlet weak var nextButton: UIButton!
    
    var selectedRole: String = "All - rounder"
    
    var allCards: [UIView] {
        [battingCard, bowlingCard, wicketCard, allRounderCard]
    }
    
    let cardData: [(title: String, icon: String)] = [
        ("Batting", "Batting"),
        ("Bowling", "Bowling"),
        ("Wicket Keeping", "Wicket"),
        ("All - rounder", "AllRounder")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(
            red: 0.929,
            green: 0.945,
            blue: 0.961,
            alpha: 1
        )
        
        navigationController?.navigationBar.isHidden = true
        
        [battingLabel,
         bowlingLabel,
         wicketLabel,
         allRounderLabel].forEach {
            
            $0?.backgroundColor = .clear
            $0?.layer.backgroundColor = UIColor.clear.cgColor
            $0?.isOpaque = false
        }
        
        setupUI()
        setupRequiredLabels()
        setupCards()
        setupDropdownAppearance()
        setupNextButton()
        
        selectCard(allRounderCard)
    }
    
    
    func setupUI() {
        view.backgroundColor = UIColor(
            red: 0.929,
            green: 0.945,
            blue: 0.961,
            alpha: 1
        )
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textColor = .black
    }
    
    func setupRequiredLabels() {
        battingStyleLabel.attributedText = makeRequiredTitle("Batting Style")
        bowlingStyleLabel.attributedText = makeRequiredTitle("Bowling Style")
        
        battingStyleLabel.backgroundColor = .clear
        bowlingStyleLabel.backgroundColor = .clear
    }
    
    func setupCards() {
        
        let labelViews: [UILabel] = [
            battingLabel,
            bowlingLabel,
            wicketLabel,
            allRounderLabel
        ]
        
        let iconViews: [UIImageView] = [
            battingIcon,
            bowlingIcon,
            wicketIcon,
            allRounderIcon
        ]
        
        let radioViews: [UIButton] = [
            battingRadio,
            bowlingRadio,
            wicketRadio,
            allRounderRadio
        ]
        
        for (i, card) in allCards.enumerated() {
            
            card.tag = i
            
            
            labelViews[i].text = cardData[i].title
            
            labelViews[i].font = UIFont.systemFont(
                ofSize: 13,
                weight: .semibold
            )
            
            labelViews[i].textColor = .black
            labelViews[i].backgroundColor = .clear
            labelViews[i].layer.backgroundColor = UIColor.clear.cgColor
            
            labelViews[i].textAlignment = .left
            labelViews[i].numberOfLines = 1
            labelViews[i].lineBreakMode = .byTruncatingTail
            
            labelViews[i].isOpaque = false
            labelViews[i].clipsToBounds = false
            
            
            iconViews[i].image = UIImage(named: cardData[i].icon)?
                .withRenderingMode(.alwaysOriginal)
            
            iconViews[i].contentMode = .scaleAspectFit
            iconViews[i].clipsToBounds = true
            
            
            card.backgroundColor = .white
            card.layer.cornerRadius = 12
            card.layer.borderWidth = 1.5
            card.layer.borderColor = UIColor.systemGray5.cgColor
            card.layer.masksToBounds = true
            
            
            radioViews[i].tintColor = UIColor(
                red: 0.176,
                green: 0.706,
                blue: 0.843,
                alpha: 1
            )
            
            radioViews[i].isUserInteractionEnabled = false
            
            radioViews[i].setImage(
                UIImage(systemName: "circle"),
                for: .normal
            )
            
            
            let tap = UITapGestureRecognizer(
                target: self,
                action: #selector(cardTapped(_:))
            )
            
            card.addGestureRecognizer(tap)
            card.isUserInteractionEnabled = true
        }
    }
    
    func setupDropdownAppearance() {
        
        let buttons = [battingStyleButton, bowlingStyleButton]
        
        for btn in buttons {
            
            btn?.layer.cornerRadius = 10
            btn?.layer.borderWidth = 1
            btn?.layer.borderColor = UIColor.systemGray4.cgColor
            
            btn?.backgroundColor = .white
            
            btn?.contentEdgeInsets = UIEdgeInsets(
                top: 0,
                left: 14,
                bottom: 0,
                right: 40
            )
            
            btn?.setTitleColor(.black, for: .normal)
            
            btn?.titleLabel?.font = UIFont.systemFont(
                ofSize: 15,
                weight: .regular
            )
        }
    }
    
    func setupNextButton() {
        
        nextButton.layer.cornerRadius = 14
        
        nextButton.backgroundColor = UIColor(
            red: 0.176,
            green: 0.706,
            blue: 0.843,
            alpha: 1
        )
        
        nextButton.setTitleColor(.white, for: .normal)
        
        nextButton.titleLabel?.font = UIFont.boldSystemFont(
            ofSize: 17
        )
    }
    
    
    @objc private func cardTapped(_ gesture: UITapGestureRecognizer) {
        
        guard let card = gesture.view else { return }
        
        selectCard(card)
    }
    
    func selectCard(_ selectedCard: UIView) {
        
        let radioViews: [UIButton] = [
            battingRadio,
            bowlingRadio,
            wicketRadio,
            allRounderRadio
        ]
        
        for (card, radio) in zip(allCards, radioViews) {
            
            card.layer.borderColor = UIColor.systemGray5.cgColor
            card.layer.borderWidth = 1.5
            card.backgroundColor = .white
            
            radio.setImage(
                UIImage(systemName: "circle"),
                for: .normal
            )
        }
        
        selectedCard.layer.borderColor = UIColor(
            red: 0.176,
            green: 0.706,
            blue: 0.843,
            alpha: 1
        ).cgColor
        
        selectedCard.layer.borderWidth = 2
        
        selectedCard.backgroundColor = UIColor(
            red: 0.93,
            green: 0.97,
            blue: 1.0,
            alpha: 1.0
        )
        
        if let index = allCards.firstIndex(of: selectedCard) {
            
            radioViews[index].setImage(
                UIImage(systemName: "record.circle.fill"),
                for: .normal
            )
            
            selectedRole = cardData[index].title
        }
    }
    
    
    @IBAction func cardTappedAction(_ sender: UIButton) {
        
        guard let card = sender.superview else { return }
        
        selectCard(card)
    }
    
    @IBAction func showBattingStylePicker(_ sender: UIButton) {
        
        showPicker(
            title: "Batting Style",
            options: [
                "Right Handed",
                "Left Handed"
            ]
        ) { [weak self] selected in
            
            self?.battingStyleButton.setTitle(
                selected,
                for: .normal
            )
        }
    }
    
    @IBAction func showBowlingStylePicker(_ sender: UIButton) {
        
        showPicker(
            title: "Bowling Style",
            options: [
                "Right Arm Fast",
                "Right Arm Medium",
                "Left Arm Fast",
                "Left Arm Medium",
                "Right Arm Off Break",
                "Left Arm Orthodox",
                "Leg Spin"
            ]
        ) { [weak self] selected in
            
            self?.bowlingStyleButton.setTitle(
                selected,
                for: .normal
            )
        }
    }
    
    @IBAction func nextTapped(_ sender: UIButton) {
        
        print("Selected Role: \(selectedRole)")
        
        if let dashboardVC =
            storyboard?.instantiateViewController(
                withIdentifier: "AssessmentViewController"
            ) as? AssessmentViewController {
            
            self.navigationController?.pushViewController(
                dashboardVC,
                animated: true
            )
        }
        
    }
    
    
    func makeRequiredTitle(_ base: String) -> NSAttributedString {
        
        let text = NSMutableAttributedString(
            string: "\(base) "
        )
        
        text.append(
            NSAttributedString(
                string: "*",
                attributes: [
                    .foregroundColor: UIColor.systemRed
                ]
            )
        )
        
        return text
    }
    
    func showPicker(
        title: String,
        options: [String],
        completion: @escaping (String) -> Void
    ) {
        
        let alert = UIAlertController(
            title: title,
            message: nil,
            preferredStyle: .actionSheet
        )
        
        options.forEach { option in
            
            alert.addAction(
                UIAlertAction(
                    title: option,
                    style: .default
                ) { _ in
                    completion(option)
                }
            )
        }
        
        alert.addAction(
            UIAlertAction(
                title: "Cancel",
                style: .cancel
            )
        )
        
        present(alert, animated: true)
    }
}
