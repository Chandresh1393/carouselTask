//
//  CarouselViewModel.swift
//  AtlysCarouselTask
//
//  Created by chandresh patel on 17/10/24.
//

import UIKit

class CarouselViewModel {

    // MARK: - Properties
    private var images: [CarouselImage]
    var currentPage: Int = 0
    
    var numberOfPages: Int {
        return images.count
    }
    
    // A closure to bind updates to the view
    var onPageUpdate: ((Int) -> Void)?
    
    // MARK: - Initialization
    init(images: [CarouselImage]) {
        self.images = images
    }
    
    // Method to get an image for a given index
    func image(for index: Int) -> UIImage? {
        let imageName = images[index].imageName
        return UIImage(named: imageName)
    }
    
    // Method to update the current page based on the scroll position
    func updateCurrentPage(with scrollView: UIScrollView, stackView: UIStackView) {
        let centerX = scrollView.contentOffset.x + scrollView.frame.size.width / 2
        var closestIndex = 0
        var minDistance = CGFloat.greatestFiniteMagnitude
        
        for (index, view) in stackView.arrangedSubviews.enumerated() {
            guard let imageView = view as? UIImageView else { continue }
            let distance = abs(centerX - imageView.center.x)
            if distance < minDistance {
                minDistance = distance
                closestIndex = index
            }
        }
        
        currentPage = closestIndex
        onPageUpdate?(currentPage)
    }
}

