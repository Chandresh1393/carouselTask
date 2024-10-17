//
//  ViewController.swift
//  AtlysCarouselTask
//
//  Created by chandresh patel on 17/10/24.
//
import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {

    // MARK: - Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    // MARK: - Properties
    private var viewModel: CarouselViewModel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize the view model with sample data
        let sampleImages = [
            CarouselImage(imageName: "image1"),
            CarouselImage(imageName: "image2"),
            CarouselImage(imageName: "image3"),
            CarouselImage(imageName: "image1")
        ]
        viewModel = CarouselViewModel(images: sampleImages)
        
        setupBindings()
        setupScrollView()
        setupImages()
        setupPageControl()
        setupStackViewConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setInitialOffset()
        scrollViewDidScroll(scrollView)
    }
    
    // MARK: - Setup Methods
    private func setupBindings() {
        viewModel.onPageUpdate = { [weak self] page in
            self?.pageControl.currentPage = page
        }
    }

    private func setupScrollView() {
        scrollView.isPagingEnabled = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
    }

    private func setupImages() {
        for index in 0..<viewModel.numberOfPages {
            let imageView = UIImageView()
            imageView.image = viewModel.image(for: index)
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 20
            imageView.layer.masksToBounds = true
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.backgroundColor = .cyan
            stackView.addArrangedSubview(imageView)
            
            NSLayoutConstraint.activate([
                imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.8),
                imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
            ])
        }
    }

    private func setupPageControl() {
        pageControl.numberOfPages = viewModel.numberOfPages
        pageControl.currentPage = 0
    }

    private func setupStackViewConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: CGFloat(viewModel.numberOfPages) * 0.8 + CGFloat(viewModel.numberOfPages - 1) * 0.1).isActive = true
        stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
        stackView.spacing = -scrollView.frame.width * 0.1
    }

    private func setInitialOffset() {
        let middleIndex = viewModel.numberOfPages > 1 ? viewModel.numberOfPages / 2 : 0
        let initialOffset = (scrollView.frame.size.width * CGFloat(middleIndex)) * 0.8
        let maxOffsetX = scrollView.contentSize.width - scrollView.frame.size.width
        let offset = max(0, min(initialOffset, maxOffsetX))
        scrollView.setContentOffset(CGPoint(x: offset, y: 0), animated: false)
    }
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let centerX = scrollView.contentOffset.x + scrollView.frame.size.width / 2
        
        for view in stackView.arrangedSubviews {
            guard let imageView = view as? UIImageView else { continue }
            let offset = centerX - imageView.center.x
            let maxScale: CGFloat = 1.0
            let minScale: CGFloat = 0.8
            let scale = max(maxScale - abs(offset) / (scrollView.frame.size.width), minScale)
            imageView.transform = CGAffineTransform(scaleX: scale, y: scale)
            imageView.layer.zPosition = -abs(offset)
        }
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let targetX = targetContentOffset.pointee.x + scrollView.frame.size.width / 2
        var closestImageView: UIImageView?
        var minDistance = CGFloat.greatestFiniteMagnitude

        for imageView in stackView.arrangedSubviews {
            guard let imageView = imageView as? UIImageView else { continue }
            let distance = abs(imageView.center.x - targetX)
            if distance < minDistance {
                minDistance = distance
                closestImageView = imageView
            }
        }

        if let closestImageView = closestImageView {
            let centeredOffsetX = closestImageView.center.x - scrollView.frame.size.width / 2
            let maxOffsetX = scrollView.contentSize.width - scrollView.frame.size.width
            targetContentOffset.pointee.x = max(0, min(centeredOffsetX, maxOffsetX))
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        viewModel.updateCurrentPage(with: scrollView, stackView: stackView)
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        viewModel.updateCurrentPage(with: scrollView, stackView: stackView)
    }
}
