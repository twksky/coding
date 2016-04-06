//
//  BaseTableViewCell.swift
//  cxd4iphone
//
//  Created by hexy on 12/1/15.
//  Copyright © 2015 hexy. All rights reserved.
//

import UIKit

class BaseTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var viewModel: BaseCellViewModel? {
        
        didSet {
            
            guard let vm = viewModel else { return }
            updateUI(vm)
        }
    }
    
    func updateUI(viewModel: BaseCellViewModel) {
        
        
        imageView?.image = viewModel.viewModel.icon
        textLabel?.text = viewModel.viewModel.title
        detailTextLabel?.text = viewModel.viewModel.detail
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Value1, reuseIdentifier: reuseIdentifier)
        
        self.accessoryType = .DisclosureIndicator
        
        makeUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeUI() {
        
    }
}
