//
//  MissionViewController.swift
//  NetworkDemo
//
//  Created by a.dirsha on 01.11.2020.
//

import UIKit

final class MissionViewController: CollectionViewController {
    private let rover: Rover
    private let apiClient = APIClient()
    
    private var photos = [Manifest.Photo]()
    
    init(rover: Rover) {
        self.rover = rover
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = self.rover.rawValue
        
        self.apiClient.dataTask("manifests/\(self.rover)") { [weak self] (result: Result<ManifestResponse, Error>) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let data):
                self?.photos = data.photoManifest.photos
                self?.collectionView.reloadData()
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photos.count
    }
    
    override func configureCell(_ cell: Cell, at indexPath: IndexPath) {
        let photo = self.photos[indexPath.item]
        cell.label.text = "Sol: \(photo.sol), cameras: \(photo.cameras.map({ $0.rawValue }).joined(separator: ", "))"
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
