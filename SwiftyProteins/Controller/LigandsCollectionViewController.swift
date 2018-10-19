//
//  LigandsCollectionViewController.swift
//  SwiftyProteins
//
//  Created by Danil Vdovenko on 3/27/18.
//  Copyright © 2018 Danil Vdovenko. All rights reserved.
//

import UIKit
import SVProgressHUD

private let reuseIdentifier = "Cell"

class LigandsCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    var ligands = [String]()
    let ligand = Ligand()
    var filteredLigands = [String]()
    let request = Request(withKey: "", andSecret: "")
    
    let searchController: UISearchController = {
        
        let searchController = UISearchController(searchResultsController: nil)
        
        searchController.obscuresBackgroundDuringPresentation = false
        
        searchController.searchBar.placeholder = "Search Ligands"
        searchController.searchBar.searchBarStyle = .prominent
        searchController.searchBar.tintColor = .white
        searchController.searchBar.barTintColor = UIColor.rgb(red: 33, green: 33, blue: 33, alpha: 1)
        searchController.searchBar.barStyle = .default
        searchController.searchBar.sizeToFit()
        
        return searchController
        
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        navigationItem.title = "Ligands list"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.white]
        
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = NSAttributedString(string: "Search Ligands", attributes: [NSAttributedStringKey.foregroundColor: UIColor.init(white: 0.95, alpha: 1)])
        
        collectionView?.backgroundColor = UIColor(white: 0.95, alpha: 1)
        collectionView?.dataSource = self
        collectionView?.delegate = self
        searchController.searchResultsUpdater = self
        definesPresentationContext = true

        filteredLigands = ligands
        
        collectionView?.register(LigandsCell.self, forCellWithReuseIdentifier: reuseIdentifier)

    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        
        filteredLigands = searchText.isEmpty ? ligands : ligands.filter({( item : String ) -> Bool in
            return item.lowercased().contains(searchText.lowercased())
        })
        
        collectionView?.reloadData()
    }

    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        
        super.traitCollectionDidChange(previousTraitCollection)
        
        guard
            let previousTraitCollection = previousTraitCollection,
            self.traitCollection.verticalSizeClass != previousTraitCollection.verticalSizeClass ||
                self.traitCollection.horizontalSizeClass != previousTraitCollection.horizontalSizeClass
            else {
                return
        }
        
        self.collectionView?.collectionViewLayout.invalidateLayout()
        self.collectionView?.reloadData()
        
    }
    
    func goToScene() {
        
        let sceneVC = SceneViewController()
        sceneVC.ligandInfo = self.ligand
        navigationController?.pushViewController(sceneVC, animated: true)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        ligand.name = filteredLigands[indexPath.item]
        
        if ligand.name != nil {
         
            SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.dark)
            SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
            SVProgressHUD.show()
            
            request.downloadLigandPDB(withName: filteredLigands[indexPath.item]) { [unowned self] (data, error) in
                
                if error {
                    
                    SVProgressHUD.dismiss()
                    self.displayError()
                    
                } else {
                    
                    self.ligand.info = data
                    
                    DispatchQueue.main.async { [unowned self] () in
                        
                        SVProgressHUD.dismiss()
                        self.ligand.atoms.removeAll()
                        self.ligand.connections.removeAll()
                        self.ligand.parseAtomAndConnections()
                        self.goToScene()
                        
                    }
                }
                
            }
            
        }
        
    }
    
    func displayError() {
        let alert = UIAlertController(title: "Can't download Ligand \(ligand.name ?? "001")", message: "Error occured, check your internet connection", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
        
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if isFiltering() {
            return filteredLigands.count
        }
        
        return ligands.count
        
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! LigandsCell
        
        if isFiltering() {
            cell.text = filteredLigands[indexPath.row]
        } else {
            cell.text = ligands[indexPath.row]
        }
    
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: 50)
        
    }
}

extension LigandsCollectionViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
}
