//
//  DetailViewController.swift
//  Test
//
//  Created by Alan on 2023/11/5.
//

import UIKit

class DetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let label = UILabel()
        label.frame = CGRect(x: 20, y: 16, width: 250, height: 30)
        label.font = UIFont.systemFont(ofSize: 30)
        label.text = "Hello World!"
        view.addSubview(label)
    }
}
