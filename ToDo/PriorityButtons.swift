//
//  PriorityStackView.swift
//  ToDo
//
//  Created by Faraday Faraday on 11/04/2018.
//  Copyright © 2018 Faraday Faraday. All rights reserved.
//

import UIKit

extension UIButton {
    func setBackgroundColor(priority: Priority) {
        backgroundColor = priority.color
    }
}

class PriorityButtons: UIStackView {
    
    //MARK: - Properties
    
    var buttons = [UIButton]()
    let priorities: [Priority] = [.no, .low, .medium, .high]
    
    /*
     Communication with NewTaskViewController signaling that the prioryty of a task was changed
     There is definately the better way to do it, I'm figuring it out
    */
    var priority: Priority = .no {
        didSet {
            NotificationCenter.default.post(name: Notification.Name("PriorityChanged"), object: nil)
        }
    }
    
    //MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    
    //MARK: - Actions
    
    @IBAction func press(_ sender: UIButton) {
        switch sender {
        case buttons[0]: priority = .no
        case buttons[1]: priority = .low
        case buttons[2]: priority = .medium
        case buttons[3]: priority = .high
        default:
            print("Error with buttons for setting priority")
        }
    }

    //MARK: - Private methods
    
    private func setupButtons() {
        for priority in priorities {
            let button = UIButton()
            button.setBackgroundColor(priority: priority)
            buttons.append(button)
            button.addTarget(self, action: #selector(PriorityButtons.press(_:)), for: .touchUpInside)
            addArrangedSubview(button)
        }
        
    }
    
}
