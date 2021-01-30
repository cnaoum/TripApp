//
//  ListViewCell.swift
//  Assignment4
//
//  Created by Maria Leticia Leoncio Barbosa
//  Created by Carolina Naoum Junqueira.
//

import UIKit

class ListViewCell: UITableViewCell {
    
    @IBOutlet weak var gasLabel: UILabel!
    @IBOutlet weak var originLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        originLabel.adjustsFontForContentSizeCategory = true
        destinationLabel.adjustsFontForContentSizeCategory = true
        gasLabel.adjustsFontForContentSizeCategory = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateLabels() {
        let bodyFont = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
        originLabel.font = bodyFont
        destinationLabel.font = bodyFont
        let captionFont = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.caption1)
        gasLabel.font = captionFont
    }
}
