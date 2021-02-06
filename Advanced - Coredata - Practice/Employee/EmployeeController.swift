//
//  EmployeeController.swift
//  Advanced - Coredata - Practice
//
//  Created by Elbek Shaykulov on 2/5/21.
//

import UIKit

class EmployeeController: UITableViewController ,CreateEmployeeDelegate{
    
    func didAddEmployee(employee: Employee) {
        employees.append(employee)
        tableView.reloadData()
    }
    
    var employees = [Employee]()
    
    var company: Company?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = company?.name
        tableView.backgroundColor = .darkBlue
        setupPlusButtonInNavBar(selector: #selector(handleAdd))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        
        fetchEmployees()
    }
    
    fileprivate func fetchEmployees() {
        guard let companyEmployees = company?.employee?.allObjects as? [Employee] else {
            return
        }
        employees = companyEmployees
            //CoreDataManager.shared.fetchEmployeeData()        
    }
    
    @objc private func handleAdd() {
        let createEmployee = CreateEmployeeController()
        createEmployee.company = company
        let navigationController = CustomNavigationController(rootViewController: createEmployee)
        navigationController.modalPresentationStyle = .fullScreen
        createEmployee.delegate = self
        present(navigationController, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employees.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
         
        let employee = employees[indexPath.row]
        cell.textLabel?.text =  employee.name
        if let taxID = employee.employeeInformation?.taxId {
            cell.textLabel?.text = "\(employee.name ?? "v") \(taxID)"
        }
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        cell.backgroundColor = .tealColor
        
        return cell
    }
}
