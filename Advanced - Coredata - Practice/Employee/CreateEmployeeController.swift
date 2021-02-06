//
//  CreateEmployeeController.swift
//  Advanced - Coredata - Practice
//
//  Created by Elbek Shaykulov on 2/5/21.
//

import UIKit

protocol CreateEmployeeDelegate{
    func didAddEmployee(employee:Employee)
}

class CreateEmployeeController: UIViewController {
    
    var delegate: CreateEmployeeDelegate?
    var company: Company?
    
    let nameLabel: UILabel = {
       let label = UILabel()
        label.text = "Name"
        label.translatesAutoresizingMaskIntoConstraints = false
       return label
    }()
    let nameTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Enter name"
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Create Employee"
        navigationController?.view.backgroundColor = .lightRed
        view.backgroundColor = .darkBlue
        
        setupCancelButton()
        _ = setupLightBlueBackgroundView(height: 50)
        
        setupUI()
    }
    
    func setupUI() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
        
        view.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: view.leftAnchor,constant: 15).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(nameTextField)
        nameTextField.topAnchor.constraint(equalTo: nameLabel.topAnchor).isActive = true
        nameTextField.leftAnchor.constraint(equalTo: nameLabel.rightAnchor).isActive = true
        nameTextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        nameTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    @objc func handleSave() {
        guard let employeeName = nameTextField.text else {return}
        guard let company = company else { return }
        
        let tuple = CoreDataManager.shared.createEmployee(employeeName: employeeName, company: company)
        
        if let error = tuple.1 {
            print("ERROR:",error)
        }else{
            dismiss(animated: true) {
                self.delegate?.didAddEmployee(employee: tuple.0!)
            }
        }
    }
 
}
