//
//  ExplanationTableViewCell.swift
//  MistAir
//
//  Created by Michelle Zhu on 2/11/18.
//  Copyright © 2018 Salamender Li. All rights reserved.
//

import UIKit

class ExplanationTableViewCell: UITableViewCell {

    //cell view
    let cellView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.darkPurple
        return view
    }()
    
    //label
    let labelView : UILabel = {
        let lbView = UILabel()
        lbView.text = ""
        lbView.textColor = UIColor.customGrey
        lbView.font = UIFont.systemFont(ofSize: 12)
        lbView.lineBreakMode = .byWordWrapping
        lbView.numberOfLines = 0
        return lbView
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //set up the cell
    func setup(){
        //set up cellview
        addSubview(cellView)
        cellView.translatesAutoresizingMaskIntoConstraints = false
        self.cellView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        self.cellView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        self.cellView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        self.cellView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true

        //set up label view
        cellView.addSubview(labelView)
        labelView.translatesAutoresizingMaskIntoConstraints = false
        self.labelView.leftAnchor.constraint(equalTo: self.cellView.leftAnchor, constant: 16).isActive = true
        self.labelView.rightAnchor.constraint(equalTo: self.cellView.rightAnchor, constant: -16).isActive = true
        self.labelView.centerYAnchor.constraint(equalTo: self.cellView.centerYAnchor).isActive = true
    }
    
}
