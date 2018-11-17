//
//  LocalTableViewController.swift
//  PayloadDemo
//
//  Created by Parveen Khatkar on 26/10/18.
//  Copyright © 2018 Codetrix Studio. All rights reserved.
//

import UIKit
import Payload

class LocalTableViewController: PayloadTableViewController<TitleTableViewCell>, PayloadCollectionDataSource {
    let overwatchHeroes = ["Ana", "Ashe", "Bastion", "Brigitte", "D.Va", "Doomfist", "Genji", "Hanzo", "Junkrat", "Lúcio", "McCree", "Mei", "Mercy", "Moira", "Orisa", "Pharah", "Reaper", "Reinhardt", "Roadhog", "Soldier: 76", "Sombra", "Symmetra", "Torbjörn", "Tracer", "Widowmaker", "Winston", "Wrecking Ball", "Zarya", "Zenyatta"];
    
    override func viewDidLoad() {
        if collection.dataSource == nil {
            collection.dataSource = self;
        }
        
        super.viewDidLoad();
    }
    
    func getPayloads<T>(of modelType: T.Type, completionHandler: @escaping (Optional<T>) -> ()) -> PayloadTask? where T : Collection, T : Decodable, T : Encodable {
        completionHandler(overwatchHeroes as? T);
        return nil;
    }
}
