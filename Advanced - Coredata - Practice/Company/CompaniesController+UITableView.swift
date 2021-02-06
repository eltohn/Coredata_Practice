//
//  CompaniesController+UITableView.swift
//  Advanced - Coredata - Practice
//
//  Created by Elbek Shaykulov on 2/2/21.
//

import UIKit

extension CompaniesViewController {
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let company = companies[indexPath.row]
        let createEmployee = EmployeeController()
        createEmployee.company = company
        navigationController?.pushViewController(createEmployee, animated: true)
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .lightBlue
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "No companies added"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return companies.count == 0 ? 150 : 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as! CompanyCell
        
        let company = companies[indexPath.row]
        cell.company = company
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let company = companies[indexPath.row]
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (_, _, _) in
          
            self.companies.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            let context = CoreDataManager.shared.persistentData.viewContext
            context.delete(company)
            do {
               try context.save()
            }catch let err {
               print(err)
            }
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (_, _, _) in
            let editCompanyController = CreateCompanyController()
            editCompanyController.delegate = self
            editCompanyController.company = self.companies[indexPath.row]
            let navController = CustomNavigationController(rootViewController: editCompanyController)
            navController.modalPresentationStyle = .fullScreen
            self.present(navController, animated: true, completion: nil)
            tableView.reloadData()
        }
        
        deleteAction.backgroundColor = .lightRed
        editAction.backgroundColor = .darkBlue
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction,editAction])
        return swipeActions
    }
}
