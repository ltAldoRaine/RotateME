//
//  MainViewController.swift
//  RotateME
//
//  Created by Beka Gelashvili on 5/1/20.
//  Copyright © 2020 Aisitec. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var coverImageView: UIImageView!

    private var lastZoomScale: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func onPickMeButtonTapped() {
        showPickerController(fromSourceType: .photoLibrary)
    }

    @IBAction func onRotationHandler(_ sender: UIRotationGestureRecognizer) {
        coverImageView.transform = coverImageView.transform.rotated(by: sender.rotation)
        sender.rotation = 0
    }

    @IBAction func onZoomHandler(_ sender: UIPinchGestureRecognizer) {
        if sender.state == .began {
            lastZoomScale = sender.scale
        }
        if let value = coverImageView.layer.value(forKeyPath: "transform.scale"),
            let currentScale = value as? CGFloat,
            sender.state == .began || sender.state == .changed {
            let kMaxScale: CGFloat = 2.0
            let kMinScale: CGFloat = 1.0
            var newScale = 1 - (lastZoomScale - sender.scale)
            newScale = min(newScale, kMaxScale / currentScale)
            newScale = max(newScale, kMinScale / currentScale)
            lastZoomScale = sender.scale
            coverImageView.transform = coverImageView.transform.scaledBy(x: newScale, y: newScale)
        }
    }

    private func showPickerController(fromSourceType sourceType: UIImagePickerController.SourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(sourceType) else {
            return
        }
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = sourceType
        present(imagePickerController, animated: true)
    }

}

extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            return
        }
        picker.dismiss(animated: true)
        lastZoomScale = 0
        coverImageView.transform = .identity
        coverImageView.image = image
    }

}
