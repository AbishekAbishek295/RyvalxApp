//
//  DashboardViewController.swift
//  RyvalxApp
//
//  Created by Abishek on 08/05/26.
//

import UIKit

class DashboardViewController: UIViewController {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var welcomeLabel: UILabel!
    
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var beginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        addGradient()
    }
    
    func setupUI() {
        
        backgroundImageView.image = UIImage(named: "Background")
        backgroundImageView.contentMode = .scaleAspectFill
        
        welcomeLabel.textColor = .white
        welcomeLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        
        subtitleLabel.textColor = .white
        subtitleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        
        descLabel.textColor = UIColor.white.withAlphaComponent(0.8)
        descLabel.font = UIFont.systemFont(ofSize: 16)
        
        skipButton.layer.cornerRadius = 10
        skipButton.layer.borderWidth = 1.5
        skipButton.layer.borderColor = UIColor.systemTeal.cgColor
        skipButton.setTitleColor(.white, for: .normal)
        skipButton.backgroundColor = .clear
        
        beginButton.layer.cornerRadius = 10
        beginButton.backgroundColor = UIColor.systemTeal
        beginButton.setTitleColor(.white, for: .normal)
    }
    
    @IBAction func beginButtonAction(_ sender: Any) {
        if let dashboardVC =
            storyboard?.instantiateViewController(
                withIdentifier: "RoleViewController"
            ) as? RoleViewController {
            
            self.navigationController?.pushViewController(
                dashboardVC,
                animated: true
            )
        }
    }
    func addGradient() {
        
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        
        gradient.colors = [
            UIColor.clear.cgColor,
            UIColor.black.withAlphaComponent(0.15).cgColor,
            UIColor.black.withAlphaComponent(0.75).cgColor
        ]
        
        gradient.locations = [0.0, 0.5, 1.0]
        
        overlayView.layer.insertSublayer(gradient, at: 0)
    }
}
