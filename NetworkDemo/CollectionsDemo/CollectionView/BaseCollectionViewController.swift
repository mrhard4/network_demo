//
//  BaseCollectionViewController.swift
//  CollectionsDemo
//
//  Created by a.dirsha on 19.10.2020.
//

import UIKit

class BaseCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    private(set) lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.makeLayout())
    
    func makeLayout() -> UICollectionViewLayout {
        fatalError()
    }
    
    override func loadView() {
        self.view = UIView()
        
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.collectionView)
        self.collectionView.pins()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.alwaysBounceVertical = true
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.backgroundColor = .secondarySystemBackground
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        fatalError()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        fatalError()
    }
}
