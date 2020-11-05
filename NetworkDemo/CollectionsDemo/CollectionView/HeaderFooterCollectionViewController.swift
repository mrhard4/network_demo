//
//  CollectionViewController.swift
//  CollectionsDemo
//
//  Created by a.dirsha on 19.10.2020.
//

import UIKit

final class HeaderFooterCollectionViewController: BaseCollectionViewController, UICollectionViewDelegateFlowLayout {
    private final class Cell: UICollectionViewCell {
        let label = UILabel()
        let colorView = UIView()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            self.colorView.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview(self.colorView)
            self.colorView.horizontal()
            self.colorView.top()
            self.colorView.heightAnchor.constraint(equalTo: self.colorView.widthAnchor, multiplier: 1.0).isActive = true
            
            
            self.label.numberOfLines = 0
            self.label.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview(self.label)
            self.label.horizontal(16.0, trailing: -16.0)
            self.label.bottom(-8.0)
            self.label.topAnchor.constraint(equalTo: self.colorView.bottomAnchor, constant: 8.0).isActive = true
            self.label.font = UIFont.systemFont(ofSize: 15.0, weight: .light)
            
            self.layer.cornerRadius = 8.0
            self.clipsToBounds = true
            
            self.backgroundView = UIView()
            self.backgroundView?.backgroundColor = .systemBackground
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    private final class HeaderFooterView: UICollectionReusableView {
        let label = UILabel()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            self.label.numberOfLines = 0
            self.label.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(self.label)
            self.label.pins(UIEdgeInsets(top: 8.0, left: 8.0, bottom: -8.0, right: -8.0))
            self.label.font = UIFont.systemFont(ofSize: 15.0, weight: .bold)
            self.label.textAlignment = .center
            
            self.clipsToBounds = true
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    private let colors: [UIColor] = [.black, .blue, .brown, .cyan, .darkGray, .green, .orange, .purple, .red, .yellow]
    
    private let layout = UICollectionViewFlowLayout()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.register(Cell.self, forCellWithReuseIdentifier: "cell")
        self.collectionView.register(HeaderFooterView.self,
                                     forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                     withReuseIdentifier: "headerfooter"
        )
        self.collectionView.register(HeaderFooterView.self,
                                     forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                     withReuseIdentifier: "headerfooter"
        )
        
        let switchView = UISwitch()
        switchView.addTarget(self, action: #selector(onSwitch(_:)), for: .valueChanged)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: switchView)
    }
    
    @objc
    private func onSwitch(_ view: UISwitch) {
        UIView.animate(withDuration: 0.3) {
            self.layout.scrollDirection = view.isOn ? .horizontal : .vertical
            self.updateHeaderFooterSizes()
        }
    }
    
    override func makeLayout() -> UICollectionViewLayout {
        self.layout.scrollDirection = .vertical
        self.layout.sectionInset = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
        return self.layout
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let width = (self.collectionView.frame.width - 48.0) / 2.0
        self.layout.itemSize = CGSize(width: width, height: width + 30.0)
        
        self.updateHeaderFooterSizes()
    }
    
    private func updateHeaderFooterSizes() {
        switch self.layout.scrollDirection {
        case .vertical:
            self.layout.headerReferenceSize = CGSize(width: self.collectionView.frame.width, height: 100.0)
        case .horizontal:
            self.layout.headerReferenceSize = CGSize(width: 200.0, height: self.collectionView.frame.height)
        @unknown default:
            assertionFailure()
        }
        self.layout.footerReferenceSize = self.layout.headerReferenceSize
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        colors.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? Cell else {
            fatalError()
        }
        
        cell.label.text = "Item: \(indexPath.item), section: \(indexPath.section)"
        cell.colorView.backgroundColor = self.colors[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerfooter", for: indexPath) as? HeaderFooterView else {
            fatalError()
        }
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            view.label.text = "Section Header"
            view.backgroundColor = .red
        case UICollectionView.elementKindSectionFooter:
            view.label.text = "Section Footer"
            view.backgroundColor = .blue
        default:
            assertionFailure()
        }
        
        return view
    }
}
