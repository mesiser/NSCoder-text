//
//  ViewController.swift
//  NSCoder text
//
//  Created by Vadim Shalugin on 06/09/2019.
//  Copyright © 2019 Vadim Shalugin. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, messageSentBack, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var text: UILabel!
    @IBOutlet var textField: UITextField!
    @IBOutlet var oldMessagesTableView: UITableView!
    var oldMessagesSent = [String]()//Массив старых сообщений для второго VC. Необходимо хранить здесь, т.к. при каждом segue второй VC создается заново и ничего в нем хранить нельзя.
    var oldMessagesReceived = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        oldMessagesTableView.delegate = self
        oldMessagesTableView.dataSource = self
        
    }
    @IBAction func sendButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "sendMessage", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! SecondViewController
        destinationVC.messageReceived = textField.text!
        oldMessagesSent.append(textField.text!)
        destinationVC.oldMessages = oldMessagesSent
        textField.text = ""
        textField.endEditing(true)
        destinationVC.delegate = self
    }
    
    func message(textSentBack: String) {
        text.text = textSentBack
        oldMessagesReceived.append(textSentBack)
        oldMessagesTableView.reloadData()
    }
    
    // Табличка
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return oldMessagesReceived.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellOne", for: indexPath)
        cell.textLabel?.text = oldMessagesReceived[indexPath.row]
        return cell
    }
    
    
    
    //        self.defaults.set(self.itemArray, forKey: "TodoListArray")//Сохраняет объект в базе данных. self.itemArray - объект, в данном случае массив. Forkey - имя, под которым объект сохраняется в базе данных. NB! В user defaults нельзя сохранять объекты из созданного вручную класса. Только объекты по-умолчанию (String, Int etc). Поэтому нужно использовать метод ниже.
    
    //        let encoder = PropertyListEncoder()//Переменная, которая кодирует пользовательские данные.
    
    //        do {// Do catch необходим, т.к. метод может выдавать ошибки.
    ////            let data = try encoder.encode(todoItemArray)
    ////            try data.write(to: dataFilePath!)
    //            try context.save()
    //
    //        } catch {
    //            print("Error saving context \(error)")
    //        }
    
    //    func loadThings() {
    //        if let data = try? Data(contentsOf: dataFilePath!) {// Переменная, которая принимает значение данных по указанному url. try? превращает переменную за ним в optional, ! - форсированно ее развертывает, а if нужен для optional binding. Все вместе заменяет do catch блок, но в отличие от него не уточняет, какая именно была ошибка, если она была.
    //
    //            let decoder = PropertyListDecoder()
    //
    //            do {
    //                todoItemArray = try decoder.decode([Item].self, from: data)//Т.к. Item является массивом, то после класса декодируемых данных, который является массивом [Item], нужно указать self, чтобы Xcode понимал, что речь о массиве целиком.
    //            } catch {
    //                print("Error decoding item array \(error)")
    //            }
    //
    //        }
    //    }
    
}


