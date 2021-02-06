//
//  ViewController.swift
//  Advanced - Coredata - Practice
//
//  Created by Elbek Shaykulov on 1/24/21.
//

import UIKit
import CoreData

class CompaniesViewController: UITableViewController  {

    
    var companies = [Company]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVC()

        companies = CoreDataManager.shared.fetchData()
        tableView.register(CompanyCell.self, forCellReuseIdentifier: "cellID")
        tableView.backgroundColor = .darkBlue
        tableView.separatorColor = .black
        tableView.separatorStyle = .singleLine
    }
    
    fileprivate func setupVC() {        
        setupPlusButtonInNavBar(selector: #selector(handleAdd))
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
        let context = CoreDataManager.shared.persistentData.viewContext
        
//        companies.forEach { (company) in
//            context.delete(company)
//        }
//        do {
//            try context.execute(batchDeleteRequest)
//            companies.removeAll()
//            tableView.reloadData()
//        } catch let delErr {
//            print("Failed to delete objects from Core Data:", delErr)
//        }
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: Company.fetchRequest())
        
        do {
            try context.execute(batchDeleteRequest)

            var indexPathsToRemove = [IndexPath]()

            for (index, _) in companies.enumerated() {
                let indexPath = IndexPath(row: index, section: 0)
                indexPathsToRemove.append(indexPath)
            }
            companies.removeAll()
            tableView.deleteRows(at: indexPathsToRemove, with: .left)
        } catch let delErr {
            print("Failed to delete objects from Core Data:", delErr)
        }
    }
    
}

