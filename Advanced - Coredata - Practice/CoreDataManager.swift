//
//  CoreDataManager.swift
//  Advanced - Coredata - Practice
//
//  Created by Elbek Shaykulov on 1/31/21.
//

import CoreData

struct CoreDataManager {
    
    static let shared = CoreDataManager()
    
    let persistentData: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Advanced___Coredata___Practice")
        container.loadPersistentStores { (storeDescription, err) in
            if let err = err {
                fatalError("Loading of store failed: \(err)")
            }
        }
        return container
    }()
    
        func fetchData() -> [Company] {
        let context = persistentData.viewContext
        let fetchRequest = NSFetchRequest<Company>(entityName: "Company")
        do {
            let companies = try context.fetch(fetchRequest)
            return companies
        }catch let err {
            print(err)
            return []
        }
    }
    
        func fetchEmployeeData() -> [Employee] {
        let context = persistentData.viewContext
        let fetchRequest = NSFetchRequest<Employee>(entityName: "Employee")
        do{
            let employees = try context.fetch(fetchRequest)
            return employees
        }catch let err{
            print("ERROR",err)
            return []
        }
    }
    
    func createEmployee(employeeName: String, company:Company) -> (Employee?,Error?) {
        let context = persistentData.viewContext
        let employee = NSEntityDescription.insertNewObject(forEntityName: "Employee", into: context) as! Employee
        
        let employeeInformation = NSEntityDescription.insertNewObject(forEntityName: "EmployeeInformation", into: context) as! EmployeeInformation
        
        employee.company = company
    
        employeeInformation.taxId = "6996"
        
        employee.employeeInformation = employeeInformation
        
        employee.setValue(employeeName, forKey: "name")
        do {
             try context.save()
            return (employee,nil)
        }catch let err {
            print(err)
            return (nil,err)
        }
    }
}
