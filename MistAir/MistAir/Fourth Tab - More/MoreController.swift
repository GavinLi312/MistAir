//
//  MoreController.swift
//  MistAir
//
//  Created by Michelle Zhu on 19/10/18.
//  Copyright © 2018 Salamender Li. All rights reserved.
//

import UIKit

class MoreController: UITableViewController {

    //for header
    let sectionArray = ["HUMIDITY LEVEL", "PRESENCE DETECTION", "SETTING"]
    
    //for mode array -- first row for each section
    let modeArray = [Mode(imageName: "HL mode-40", labelText: "HL Auto Mode"),
                     Mode(imageName: "PD mode-40", labelText: "PD Auto Mode"),
                     Mode(imageName: "notification-40", labelText: "Push Notification")
    ]
    
    //for setting array -- those rows with the right arrow at the right side
    let settingArray = [Mode(imageName: "humidity setting-40", labelText: "Humidity Level Setting"),
                        Mode(imageName: "about-40", labelText: "About"),
                        Mode(imageName: "logout-40", labelText: "Log Out")
    ]
    
    //for explanation array -- third row in first section, second row in second section
    let explanationArray = [Mode(imageName: nil, labelText: "Humidity Level Mode switches your humidifier on/off automatically based on the maximum/minimum level you set."),
                            Mode(imageName: nil, labelText: "Presence Detection Mode detects any presence in your environment. If it is enabled, when no presence is detected in 90 minutes, your humidifier will be switched off; otherwise, as long as it detects movement/sound in your environment, your humidifier will be controlled based on the HL Auto Mode.")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor.darkPurple
        tableView.register(MoreTableViewCell.self, forCellReuseIdentifier: "ModeCell")
        tableView.register(SettingTableViewCell.self, forCellReuseIdentifier: "SettingCell")
        tableView.register(ExplanationTableViewCell.self, forCellReuseIdentifier: "ExplanationCell")
        tableView.register(HeaderTableViewCell.self, forCellReuseIdentifier: "HeaderCell")
    }
    
    // MARK: - Table view data source
    
    //MARK: SECTION
    //define the number of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionArray.count
    }
    
    //define the height
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    //define header view
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let sectionView = view as? UITableViewHeaderFooterView{
            sectionView.backgroundColor = UIColor.white
            //sectionView.isOpaque = false
            sectionView.textLabel?.textColor = UIColor.customGrey
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell") as! HeaderTableViewCell
        headerCell.labelView.text = sectionArray[section]
        headerCell.selectionStyle = .none
        return headerCell
    }
        
    
    //MARK: CELL
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 2 || indexPath.section == 1 && indexPath.row == 1{
            return 120
        }
        return 60
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1{
            return 2
        }
        return 3
    }

    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //set up cell for first row of each section
        if indexPath.row == 0{
            let modeCell = tableView.dequeueReusableCell(withIdentifier: "ModeCell", for: indexPath) as! MoreTableViewCell
            modeCell.selectionStyle = .none
            modeCell.labelView.text = modeArray[indexPath.section].labelText
            modeCell.iconView.image = UIImage(named: modeArray[indexPath.section].imageName!)
            return modeCell
        }
        
        //set up rows for the setting cell (with right arrow at the right)
        if indexPath.section == 0 && indexPath.row == 1 || indexPath.section == 2 && indexPath.row != 0{
            let settingCell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath) as! SettingTableViewCell
            //for the first section, use index 0 of the array to set up the cell
            if indexPath.section == 0{
                settingCell.labelView.text = settingArray[indexPath.section].labelText
                settingCell.iconView.image = UIImage(named: settingArray[indexPath.section].imageName!)
            }
                //for the third section, use index 1 & 2 of the array to set up the cell
            else{
                settingCell.labelView.text = settingArray[indexPath.row].labelText
                settingCell.iconView.image = UIImage(named: settingArray[indexPath.row].imageName!)
            }
            return settingCell
        }
        
        //for those two explanation labels
        let explanationCell = tableView.dequeueReusableCell(withIdentifier: "ExplanationCell", for: indexPath) as! ExplanationTableViewCell
        explanationCell.selectionStyle = .none
        explanationCell.labelView.text = explanationArray[indexPath.section].labelText
        
        return explanationCell
    }
    

    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
