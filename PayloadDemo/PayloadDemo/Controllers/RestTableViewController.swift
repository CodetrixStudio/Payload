//
//  RestTableViewController.swift
//  PayloadDemo
//
//  Created by Parveen Khatkar on 17/11/18.
//  Copyright © 2018 Codetrix Studio. All rights reserved.
//

import UIKit
import Payload

class RestTableViewController: PayloadTableViewController<TitleTableViewCell> {
    
    override func viewDidLoad() {
        collection.courier = getPayloads;
        
        super.viewDidLoad();
    }

    func getPayloads(completionHandler: @escaping ([String]?) -> Void) -> PayloadTask? {
        let urlString = String(format: "https://overwatch-api.net/api/v1/ability?page=%d&limit=%d", (collection.count / collection.bufferSize) + 1, collection.bufferSize);
        let url = URL(string: urlString)!
        let request = URLRequest(url: url);

        let task = URLSession.shared.dataTask(with: request, completionHandler: { (responseData: Data?, response: URLResponse?, error: Error?) in

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                DispatchQueue.main.sync {
                    completionHandler(nil);
                }
                return;
            }

            let jsonDecoder = JSONDecoder();

            let page = try! jsonDecoder.decode(Page<Ability>.self, from: responseData!);
            let modelCollection = page.data?.map({$0.name ?? "N/A"});
            DispatchQueue.main.sync {
                completionHandler(modelCollection);
            }
        })

        task.resume();
        return task;
    }
}
