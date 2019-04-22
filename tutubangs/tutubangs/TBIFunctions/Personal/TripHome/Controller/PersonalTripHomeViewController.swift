//
//  PersonalTripHomeViewController.swift
//  shanglvjia
//
//  Created by manman on 2018/7/17.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class PersonalTripHomeViewController: PersonalBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let label = UILabel()
        label.text = "行程"
        label.textColor = UIColor.red
        label.frame = CGRect.init(x: 100, y: 100, width: 200, height: 30)
        self.view.addSubview(label)
        self.view.backgroundColor = UIColor.green
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
