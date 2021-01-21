//
//  Storyboard.swift
//  MovieSearchApp
//
//  Created by Szymon Świętek on 18/01/2021.
//

import UIKit

protocol Presentable {
    func toPresent() -> UIViewController?
}

extension UIViewController: Presentable {
    
    func toPresent() -> UIViewController? {
        return self
    }
}
