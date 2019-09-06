//
//  SecondViewController.swift
//  NSCoder text
//
//  Created by Vadim Shalugin on 06/09/2019.
//  Copyright © 2019 Vadim Shalugin. All rights reserved.
//

import UIKit

protocol messageSentBack {
    func message(textSentBack: String)
}

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var text: UILabel!
    @IBOutlet var textField: UITextField!
    @IBOutlet var oldMessagesTableView: UITableView!
    var messageReceived = ""//Эту переменную необходимо изпользовать, чтобы передавать послания из первого VC во второй. Если передавать их напрямую в text.text, то Xcode считает при отправке, что text.text еще не существует (не видит его) и говорит: unexpectidly found nil.
    var oldMessages = [OldMessagesSent]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        oldMessagesTableView.delegate = self
        oldMessagesTableView.dataSource = self
        text.text = messageReceived
    }
    var delegate: messageSentBack?
    
    //Табличка.
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return oldMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellTwo", for: indexPath)
        cell.textLabel?.text = oldMessages[indexPath.row].text
        return cell
    }

    @IBAction func sendButtonPressed(_ sender: Any) {
        delegate?.message(textSentBack: textField.text!)
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    
}
