//
//  CreateCompanyController.swift
//  Advanced - Coredata - Practice
//
//  Created by Elbek Shaykulov on 1/25/21.
//

import UIKit
import CoreData
 
protocol CreateCompanyControllerDelegate {
    func didAddCompany(company:Company)
    func didEditCompany(company: Company)
}

class CreateCompanyController: UIViewController, UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    var delegate: CompaniesViewController?
    var company: Company? {
        didSet{
            if let imageData = company?.imageData {
                imageView.image = UIImage(data: imageData)
            }
            nameTextField.text = company?.name
            if let founded = company?.founded {
                datePicker.date = founded
            }
        }
    }
    
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
    let lightBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightBlue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.datePickerMode = .date
        return picker
    }()
    lazy var imageView: UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "select_photo_empty"))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectPhoto)))
        //ROUNDing the imageView
        image.layer.cornerRadius = image.frame.width / 2
        image.clipsToBounds = true
        image.layer.borderColor = UIColor.darkBlue.cgColor
        image.layer.borderWidth = 2
        
        return image
    }()
    @objc fileprivate func handleSelectPhoto() {
        let imagePicker = UIImagePickerController()
        imagePicker.view.backgroundColor = .lightRed
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        imagePicker.modalPresentationStyle = .fullScreen
        present(imagePicker, animated: true, completion: nil)
    }
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        dismiss(animated: true, completion: nil)
//    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let edited = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            imageView.image = edited
        }else if let original = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = original
        }
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)        
        navigationItem.title = company == nil ? "Create Companies":"Edit Company"
    }
    
    fileprivate func setupUI() {
        view.backgroundColor = UIColor.darkBlue
        navigationController?.view.backgroundColor = .lightRed
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
        
        view.addSubview(lightBackgroundView)
        lightBackgroundView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        lightBackgroundView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        lightBackgroundView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        lightBackgroundView.heightAnchor.constraint(equalToConstant: 210).isActive = true
        
        view.addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        view.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: view.leftAnchor,constant: 15).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(nameTextField)
        nameTextField.topAnchor.constraint(equalTo: nameLabel.topAnchor).isActive = true
        nameTextField.leftAnchor.constraint(equalTo: nameLabel.rightAnchor).isActive = true
        nameTextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        nameTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(datePicker)
        datePicker.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        datePicker.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        datePicker.leftAnchor.constraint(equalTo: view.leftAnchor,constant: 110).isActive = true
        datePicker.bottomAnchor.constraint(equalTo: lightBackgroundView.bottomAnchor).isActive = true
        
    }
    
    @objc fileprivate func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func handleSave() {
        if company == nil{
            createCompany()
        }else{
            editCompany()
        }
    }
    
    fileprivate func createCompany() {
        let context = CoreDataManager.shared.persistentData.viewContext
        let company = NSEntityDescription.insertNewObject(forEntityName: "Company", into: context)
        
        if nameTextField.text?.count == 0 {
            nameTextField.text = "NO NAME"
        }
        company.setValue(nameTextField.text, forKey: "name")
        company.setValue(datePicker.date, forKey: "founded")
        
        if let companyImage = imageView.image {
            let imageData = companyImage.jpegData(compressionQuality: 0.8)
            company.setValue(imageData, forKey: "imageData")
        }
        
        do {
            try context.save()
            dismiss(animated: true) {
                self.delegate?.didAddCompany(company: company as! Company)
            }
        } catch let err {
            print("ERROR \(err)")
        }
    }
    
    fileprivate func editCompany() {
        let context = CoreDataManager.shared.persistentData.viewContext
        
        if nameTextField.text?.count == 0 {
            nameTextField.text = "NO NAME"
        }
        company?.name = nameTextField.text
        company?.founded = datePicker.date
        
        if let companyImage = imageView.image {
            let imageData = companyImage.jpegData(compressionQuality: 0.8)
            company?.imageData = imageData
        }
        
        do{
            try context.save()
            dismiss(animated: true) {
                self.delegate?.didEditCompany(company: self.company!)
            }
        }catch let err{
            print(err)
        }
    }
    
}

 

 
