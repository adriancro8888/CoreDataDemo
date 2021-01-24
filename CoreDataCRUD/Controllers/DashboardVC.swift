//
//  DashboardVC.swift
//  CoreDataCRUD
//
//  Created by Thomas Woodfin on 1/8/21.
//  Copyright © 2021 Thomas Woodfin. All rights reserved.
//

import UIKit

class DashboardVC: UIViewController {
    
    @IBOutlet weak private var tblView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
    }
    
    private func getData(){
        CoreDataManager.sharedManager.retrieveData { [weak self](success) in
            if success{
                self?.tblView.reloadData()
            }
        }
    }
    
    @IBAction func addBtnAction(_ sender: Any) {
        openAddUser()
    }
}

extension DashboardVC: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CoreDataManager.sharedManager.userList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DashboardCell.identifire, for: indexPath) as! DashboardCell
        cell.selectionStyle = .none
        let data = CoreDataManager.sharedManager.userList[indexPath.row]
        cell.configureCell(data: data)
        cell.deleteUser = {
            let data = CoreDataManager.sharedManager.userList[indexPath.row]
            self.removeDialog(name: data.name ?? "")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = CoreDataManager.sharedManager.userList[indexPath.row]
        openUpdateUser(oldName: data.name ?? "")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    private func openAddUser(){
        let alert = UIAlertController(title: "User Add", message: "Please input user name", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addTextField {(textField) in
            textField.placeholder = "Enter user name"
        }
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { _ in
            let nameFld = alert.textFields![0] as UITextField
            guard let txt = nameFld.text else {return}
            if txt.isEmpty{
                self.showDialog(msg: "Please insert user name")
                return
            }
            CoreDataManager.sharedManager.createData(name: txt) { [weak self] (success) in
                self?.getData()
            }
            
        }))
        self.present(alert, animated:true, completion: nil)
    }
    
    private func showDialog(msg: String){
        let alertControl = UIAlertController(title: "Alert", message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertControl.addAction(okAction)
        self.present(alertControl, animated:true, completion: nil)
    }
    
    private func removeDialog(name: String){
        let alertControl = UIAlertController(title: "Alert", message: "Are you want to remove ?", preferredStyle: .alert)
        alertControl.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            CoreDataManager.sharedManager.deleteData(name: name) { [weak self] (success) in
                if success{
                    self?.getData()
                }
            }
        }))
        alertControl.addAction(UIAlertAction(title: "No", style: .default, handler: { _ in
            
        }))
        self.present(alertControl, animated:true, completion: nil)
    }
    
    private func openUpdateUser(oldName: String){
        let alert = UIAlertController(title: "User Update", message: "Please input user updated name", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addTextField {(textField) in
            textField.placeholder = "Enter new user name"
        }
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { _ in

            let nameFld = alert.textFields![0] as UITextField
            guard let txt = nameFld.text else {return}
            if txt.isEmpty{
                self.showDialog(msg: "Please insert new user name")
                return
            }
            
            CoreDataManager.sharedManager.updateData(oldName: oldName, newName: txt) { [weak self] (success) in
                if success{
                    self?.getData()
                }
            }
            
        }))
        self.present(alert, animated:true, completion: nil)
    }
    
}

