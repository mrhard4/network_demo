//
//  CollectionViewController.swift
//  CollectionsDemo
//
//  Created by a.dirsha on 19.10.2020.
//

import UIKit

final class HeaderFooterAnimatedCollectionViewController: BaseCollectionViewController, UICollectionViewDelegateFlowLayout {
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
    
    struct Item {
        let color: UIColor
        let text: String
    }
    
    private final class Layout: UICollectionViewFlowLayout {
        var lastUpdate = [UICollectionViewUpdateItem]()
        
        override func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
            self.lastUpdate = updateItems
            super.prepare(forCollectionViewUpdates: updateItems)
        }
        
        override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
            let result = super.initialLayoutAttributesForAppearingItem(at: itemIndexPath)?.copy() as? UICollectionViewLayoutAttributes
            if self.lastUpdate.filter({ $0.indexPathAfterUpdate == itemIndexPath }).first?.updateAction == .insert {
                result?.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                result?.alpha = 0.1
            }
            return result
        }
        
        override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
            let result = super.finalLayoutAttributesForDisappearingItem(at: itemIndexPath)?.copy() as? UICollectionViewLayoutAttributes
            if self.lastUpdate.filter({ $0.indexPathBeforeUpdate == itemIndexPath }).first?.updateAction == .delete {
                result?.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
            }
            return result
        }
    }
    
    private let allColors: [UIColor] = [.black, .blue, .brown, .cyan, .darkGray, .green, .orange, .purple, .red, .yellow]
    private var items = [Item]()
    private var updateIndexes = [Int]()
    
    private let layout = Layout()
    
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
        
        self.navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(addColor)),
            UIBarButtonItem(title: "-", style: .plain, target: self, action: #selector(removeColor))
        ]
        
        self.items.append(Item(color: .blue, text: "0"))
    }
    
    @objc
    private func removeColor() {
        if self.updateIndexes.count == 0 {
            return
        }
        
        let index = self.updateIndexes.removeLast()
        self.items.remove(at: index)
        self.collectionView.deleteItems(at: [IndexPath(item: index, section: 0)])
    }
    
    @objc
    private func addColor() {
        guard let color = self.allColors.randomElement() else {
            assertionFailure()
            return
        }
        let index = Int.random(in: 0..<self.items.count)
        self.items.insert(Item(color: color, text: "\(self.items.count)"), at: index)
        self.updateIndexes.append(index)
        self.collectionView.insertItems(at: [IndexPath(item: index, section: 0)])
    }
    
    override func makeLayout() -> UICollectionViewLayout {
        self.layout.sectionInset = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
        return self.layout
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let width = (self.collectionView.frame.width - 48.0) / 2.0
        self.layout.itemSize = CGSize(width: width, height: width + 30.0)
        self.layout.headerReferenceSize = CGSize(width: self.collectionView.frame.width, height: 100.0)
        self.layout.footerReferenceSize = self.layout.headerReferenceSize
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? Cell else {
            fatalError()
        }
        
        cell.label.text = self.items[indexPath.item].text
        cell.colorView.backgroundColor = self.items[indexPath.item].color
        
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
