//
//  ViewController.swift
//  Advanced - Coredata - Practice
//
//  Created by Elbek Shaykulov on 1/24/21.
//

import UIKit
import CoreData

class CompaniesViewController: UITableViewController, CreateCompanyControllerDelegate {

    var companies = [Company]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVC()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
        tableView.backgroundColor = .darkBlue
        
        fetchData()
    }
    
    fileprivate func fetchData() {
        let context = CoreDataManager.shared.persistentData.viewContext
        let fetchRequest = NSFetchRequest<Company>(entityName: "Company")
        do {
            let companies = try context.fetch(fetchRequest)
            self.companies = companies
            self.tableView.reloadData()
        }catch let err {
            print(err)
        }
    }
    
    fileprivate func setupVC() {        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleAdd))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(handleReset))        
        navigationController?.navigationBar.tintColor = .white
        navigationItem.title = "Companies"
        navigationController?.view.backgroundColor = .lightRed
    }
    
    @objc fileprivate func handleAdd() {
        let addController = CreateCompanyController()
        let navController = CustomNavigationController(rootViewController: addController)
        addController.delegate = self
        navController.modalPresentationStyle = .overCurrentContext
        present(navController, animated: true, completion: nil)
    }
    
    @objc fileprivate func handleReset() {
        
    }
    
    //MARK: - tableView
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .lightBlue
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        cell.backgroundColor = .tealColor
        
        let company = companies[indexPath.row]
        
        if let name = company.name  , let founded = company.founded {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd , yyyy"
            let foundedString = dateFormatter.string(from: founded)
                
            cell.textLabel?.text = "\(name) - Founded: \(foundedString)"
        }else{
            cell.textLabel?.text = company.name
        }
        cell.imageView?.image = #imageLiteral(resourceName: "select_photo_empty")
        if let imageData = company.imageData {
            cell.imageView?.image = UIImage(data: imageData)
        }
         
        return cell
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
    
    func didAddCompany(company: Company) {
       companies.append(company)
       let indexPath = IndexPath(row: companies.count - 1, section: 0)
       tableView.insertRows(at: [indexPath], with: .automatic)
   }
    func didEditCompany(company: Company) {
        let row = companies.firstIndex(of: company)
        let reloadIndexPath = IndexPath(row: row!, section: 0)
        tableView.reloadRows(at: [reloadIndexPath], with: .right)
    }
}

