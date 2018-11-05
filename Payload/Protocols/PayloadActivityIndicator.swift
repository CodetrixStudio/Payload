//
//  File.swift
//  Payload
//
//  Created by Parveen Khatkar on 02/11/18.
//  Copyright © 2018 Codetrix Studio. All rights reserved.
//

import Foundation

public protocol PayloadActivityIndicator {
    func startAnimating();
    func stopAnimating();
}

extension UIActivityIndicatorView: PayloadActivityIndicator {}
