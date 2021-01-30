//
//  MyNavigationController.swift
//  Assignment4
//
//  Created by Maria Leticia Leoncio Barbosa
//  Created by Carolina Naoum Junqueira.
//

import Foundation
import UIKit

public class MyNavigationController: UINavigationController, UINavigationBarDelegate {
    public func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool {
        var result : Bool = true
        
        if let theController = self.topViewController as? DetailViewController {
            result = theController.validateData()
        }
        
        return result
    }
}
