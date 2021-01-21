//
//  Storyboard.swift
//  MovieSearchApp
//
//  Created by Szymon Świętek on 18/01/2021.
//

import Foundation

typealias CoordinatorOutput = (_ coordinator: Coordinator?) -> Void

class Coordinator {
    var childCoordinators: [Coordinator] = []
    var finishFlow: (CoordinatorOutput)?
    
    func start() {}
    func refresh() {}
}

extension Coordinator {
    func addCoordinator(_ coordinator: Coordinator) {
        for coord in childCoordinators where coord === coordinator { return }
        childCoordinators.append(coordinator)
    }
    
    func removeCoordinator(_ coordiantor: Coordinator?) {
        guard let coordiantor = coordiantor,
            childCoordinators.isEmpty == false
            else { return }
        
        for (index, coord) in childCoordinators.enumerated() where coord === coordiantor {
            childCoordinators.remove(at: index)
        }
    }
}
