//
//  MoreTableViewCell.swift
//  MistAir
//
//  Created by Michelle Zhu on 19/10/18.
//  Copyright © 2018 Salamender Li. All rights reserved.
//

import UIKit

//tableview programatically: https://www.youtube.com/watch?v=lXpRJXCJ9uA

class MoreTableViewCell: UITableViewCell {

    //cell view
    let cellView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.darkPurple
        return view
    }()
        
    //image
    let iconView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    //label
    let labelView : UILabel = {
        let lbView = UILabel()
        lbView.text = ""
        lbView.textColor = UIColor.white
        lbView.font = UIFont.systemFont(ofSize: 16)
        return lbView
    }()

    //switch
    let modeSwitch: UISwitch = {
        let sw = UISwitch()
        sw.isOn = false
        sw.tag = 0
        return sw
    }()
    

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    
    
    //set up the more cell
    func setupCell(){
        //set up cellview
        addSubview(cellView)
        cellView.translatesAutoresizingMaskIntoConstraints = false
        self.cellView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        self.cellView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        self.cellView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        self.cellView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        
        //set up image view
        cellView.addSubview(iconView)
        iconView.translatesAutoresizingMaskIntoConstraints = false
        self.iconView.leftAnchor.constraint(equalTo: self.cellView.leftAnchor, constant: 16).isActive = true
        self.iconView.centerYAnchor.constraint(equalTo: self.cellView.centerYAnchor, constant: 0).isActive = true
        self.iconView.frame.size.width = 30
        self.iconView.frame.size.height = 30
        
        //set up label view
        cellView.addSubview(labelView)
        labelView.translatesAutoresizingMaskIntoConstraints = false
        self.labelView.leftAnchor.constraint(equalTo: self.iconView.rightAnchor, constant: 16).isActive = true
        self.labelView.centerYAnchor.constraint(equalTo: self.iconView.centerYAnchor).isActive = true
        
        //set up switch
        cellView.addSubview(modeSwitch)
        modeSwitch.translatesAutoresizingMaskIntoConstraints = false
        self.modeSwitch.rightAnchor.constraint(equalTo: self.cellView.rightAnchor, constant: -16).isActive = true
        self.modeSwitch.centerYAnchor.constraint(equalTo: self.cellView.centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
