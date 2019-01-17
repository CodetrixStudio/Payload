//
//  LocalTableViewController.swift
//  PayloadDemo
//
//  Created by Parveen Khatkar on 26/10/18.
//  Copyright © 2018 Codetrix Studio. All rights reserved.
//

import UIKit
import Payload

class LocalTableViewController: PayloadTableViewController<TitleTableViewCell> {
    
    let overwatchHeroes = ["Ana", "Ashe", "Bastion", "Brigitte", "D.Va", "Doomfist", "Genji", "Hanzo", "Junkrat", "Lúcio", "McCree", "Mei", "Mercy", "Moira", "Orisa", "Pharah", "Reaper", "Reinhardt", "Roadhog", "Soldier: 76", "Sombra", "Symmetra", "Torbjörn", "Tracer", "Widowmaker", "Winston", "Wrecking Ball", "Zarya", "Zenyatta"];
    
    override func viewDidLoad() {
        collection.courier = getPayloads;
        
        super.viewDidLoad();
    }
    
    func getPayloads(completionHandler: @escaping ([String]?) -> Void) -> PayloadTask? {
        completionHandler(overwatchHeroes);
        return nil;
    }
}
