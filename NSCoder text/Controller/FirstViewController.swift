//
//  ViewController.swift
//  NSCoder text
//
//  Created by Vadim Shalugin on 06/09/2019.
//  Copyright © 2019 Vadim Shalugin. All rights reserved.
//

import UIKit

//NSCoder позволяет сохранять данные из кастомизированных классов.

class FirstViewController: UIViewController, messageSentBack, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var text: UILabel!
    @IBOutlet var textField: UITextField!
    @IBOutlet var oldMessagesTableView: UITableView!
    var oldMessagesSent = [OldMessagesSent]()//Массив старых сообщений для второго VC. Необходимо хранить здесь, т.к. при каждом segue второй VC создается заново и ничего в нем хранить нельзя.
    var oldMessagesReceived = [OldMessagesReceived]()
    let dataFilePathForSentMessages = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("OldMessagesSent.plist")//Указывает путь до папки, где будут хранится данные пользователя.
    let dataFilePathForReceivedMessages = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("OldMessagesReceived.plist")//В принципе все можно сохранять в один plist. Т.к. во время декодирования данных указывается их тип (OldMessagesSent или OldMessagesReceived), то замешательства не будет.
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(dataFilePathForSentMessages)
        oldMessagesTableView.delegate = self
        oldMessagesTableView.dataSource = self
        loadSentMessages()
        loadReceivedMessages()
    }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "sendMessage", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! SecondViewController
        destinationVC.messageReceived = textField.text!
        
        //Сохранение отправленных сообщений в plist файл при помощи NSCoder
        
        let newMessage = OldMessagesSent()
        newMessage.text = textField.text!
        oldMessagesSent.append(newMessage)
        let encoder = PropertyListEncoder()//Фикисированная функция, котоаря позволяет сохранять данные в plist.
        do {
            let data = try encoder.encode(oldMessagesSent)//Кодираует данные.
            try data.write(to: dataFilePathForReceivedMessages!)//Сохраняет данные по указанному пути.
        } catch {
            print("Error saving data \(error)")
        }
        
        destinationVC.oldMessages = oldMessagesSent
        textField.text = ""
        textField.endEditing(true)
        destinationVC.delegate = self
    }
    
    func message(textSentBack: String) {
        text.text = textSentBack
        
        //Сохранение полученных сообщений.
        
        let newMessage = OldMessagesReceived()
        newMessage.text = textSentBack
        oldMessagesReceived.append(newMessage)
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(oldMessagesReceived)
            try data.write(to: dataFilePathForReceivedMessages!)
        } catch {
            print("Error saving data \(error)")
        }
        
        oldMessagesTableView.reloadData()
    }
    
    // Табличка
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return oldMessagesReceived.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellOne", for: indexPath)
        cell.textLabel?.text = oldMessagesReceived[indexPath.row].text
        return cell
    }
    
    //Загрузка сообщений.
    
    func loadSentMessages() {
        if let data = try? Data(contentsOf: dataFilePathForSentMessages!) {// Переменная, которая принимает значение данных по указанному url. try? превращает переменную за ним в optional, а if нужен для optional binding. Все вместе заменяет do catch блок, но в отличие от него не уточняет, какая именно была ошибка, если она была.
    
            let decoder = PropertyListDecoder()
    
            do {
                oldMessagesSent = try decoder.decode([OldMessagesSent].self, from: data)//После decode в () на первом месте указывается тип декодируемых данных - в данном случае массив старых отправленных сообщений -  а на втором сами данные. Т.к. OldMessagesSent является массивом, нужно указать self, чтобы Xcode понимал, что речь о массиве целиком.
            } catch {
                print("Error decoding data \(error)")
            }
    
        }
    }
    
    func loadReceivedMessages() {
        if let data = try? Data(contentsOf: dataFilePathForReceivedMessages!) {
            let decoder = PropertyListDecoder()
            do {
                oldMessagesReceived = try decoder.decode([OldMessagesReceived].self, from: data)
            } catch {
                print("Error decoding data \(error)")
            }
        }
    }
    
    
    
}


