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
    static var shared = ImageSaver()

    func saveImageToAlbum(_ image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveError), nil)
    }

    @objc func saveError(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        print("Saved")
    }
}
