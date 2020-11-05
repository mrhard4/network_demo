//
//  MissionSelectViewController.swift
//  NetworkDemo
//
//  Created by a.dirsha on 01.11.2020.
//

import UIKit

final class MissionSelectViewController: CollectionViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Mission Select"
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        Rover.allCases.count
    }
    
    override func configureCell(_ cell: Cell, at indexPath: IndexPath) {
        cell.label.text = Rover.allCases[indexPath.item].rawValue
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(MissionViewController(rover: Rover.allCases[indexPath.item]), animated: true)
    }
}
