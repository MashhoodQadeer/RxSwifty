//  ListItemTableViewCell.swift
//  MemoryOptimizer
//  Created by Mashhood Qadeer on 29/10/2022.

import UIKit

class ListItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelView: UILabel!
    var model : ToDoModel!
    var callback : ( (ToDoModel) -> Void )?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configLayout( model : ToDoModel ){
        self.model = model
        self.labelView.text = self.model.name
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        self.callback?(self.model)
    }
    
}

class ListItemModel {
    
    var name : String!;
    var icon : String!;
    
    init(){
        
    }
    
    init( name: String, icon : String ) {
        self.name = name
        self.icon = icon
    }
    
}
