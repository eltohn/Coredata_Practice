//
//  CompaniesController+CreateCompany.swift
//  Advanced - Coredata - Practice
//
//  Created by Elbek Shaykulov on 2/2/21.
//

import UIKit

extension CompaniesViewController:CreateCompanyControllerDelegate  {
    
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
