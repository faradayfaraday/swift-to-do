//
//  TableViewCell.swift
//  ToDo
//
//  Created by Faraday Faraday on 10/04/2018.
//  Copyright © 2018 Faraday Faraday. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    
    
    var task: Task?
    
    @IBOutlet weak var taskTextLabel: UILabel!
    @IBOutlet weak var priorityBar: UIView!
    
    init(task: Task) {
        self.task = task
        super.init(style: .default, reuseIdentifier: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
