//
//  LoadingTableViewCell.swift
//  News
//
//  Created by Baidetskyi Jurii on 06.02.2023.
//

import UIKit

class LoadingTableViewCell: UITableViewCell {
    
    var loadMoreClouser: (() -> ())?
    
    @IBOutlet weak var loadMoreButtonOutlet: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    
    @IBAction func loadMoreButtonPressed(_ sender: Any) {
        loadMoreClouser?()
    }
    
}
