//
//  CacheManager.swift
//  WMovie
//
//  Created by Алексей Павленко on 29.09.2022.
//

import UIKit

class CacheManager {
    static let shared = CacheManager()
    private init() {}
    
    private let cache = NSCache<NSString, UIImage>()
    
    public func getImage(for path: String?) -> UIImage? {
        guard let path = path else { return nil }
        if let image = cache.object(forKey: NSString(string: path)) {
            return image
        }
        return nil
    }
    
    public func cache(image: UIImage?, for path: String?) {
        guard let image = image, let path = path else { return }
        cache.setObject(image, forKey: NSString(string: path))
    }
    
    public func restoreCache() {
        cache.removeAllObjects()
    }
}
