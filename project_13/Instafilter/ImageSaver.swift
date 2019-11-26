//
//  ImageSaver.swift
//  Instafilter
//
//  Created by Nikolay Volosatov on 11/26/19.
//  Copyright © 2019 BX23. All rights reserved.
//

import Foundation
import UIKit

class ImageSaver: NSObject {
    typealias Callback = (Error?) -> Void

    static var shared = ImageSaver()

    private var callbacks: [String:Callback] = [:]
    private func nextId() -> String { UUID().uuidString }
    private static let idBytesCount = 36

    func saveImageToAlbum(_ image: UIImage, callback: @escaping Callback) {
        let id = nextId()
        callbacks[id] = callback

        let data = id.data(using: .utf8)!
        let context = UnsafeMutablePointer<UInt8>.allocate(capacity: data.count)
        data.copyBytes(to: context, count: data.count)
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveError), context)
    }

    @objc private func saveError(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        defer {
            contextInfo.deallocate()
        }

        let data = Data(bytes: contextInfo, count: Self.idBytesCount)
        guard let id = String(data: data, encoding: .utf8) else {
            return
        }
        guard let callback = callbacks[id] else {
            return
        }
        callbacks[id] = nil
        callback(error)
    }
}
