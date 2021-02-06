//
//  UIViewController+Helpers.swift
//  Advanced - Coredata - Practice
//
//  Created by Elbek Shaykulov on 2/5/21.
//

import UIKit

extension UIViewController {
    
    func setupPlusButtonInNavBar(selector:Selector) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: selector)
    }
    
    func setupCancelButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancelModal))
    }
    
    @objc func handleCancelModal() {
        dismiss(animated: true, completion: nil)
    }
    
    func setupLightBlueBackgroundView(height:CGFloat) -> UIView {
        
        let lightBackgroundView: UIView = {
            let view = UIView()
            view.backgroundColor = UIColor.lightBlue
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        view.addSubview(lightBackgroundView)
        lightBackgroundView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        lightBackgroundView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        lightBackgroundView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        lightBackgroundView.heightAnchor.constraint(equalToConstant: height).isActive = true        
        return lightBackgroundView
    }
    
}
