# Atlys Carousel Task (MVVM Implementation)

This project implements a carousel view similar to the Atlys app's sign-up screen using Swift and UIKit. The code is structured following the MVVM (Model-View-ViewModel) pattern to ensure modularity, readability, and maintainability.

### Features
- Carousel slider with images that scale and center as they come into focus.
- Pagination control to indicate the current position in the carousel.
- Image views that appear in the foreground when centered, with depth effects for side images.
- Initial centering of the carousel when the view first appears.

### Project Structure
The project is organized into the following components:


### Components Overview

1. **Model (`CarouselImage.swift`)**:
   - Represents each image in the carousel.
   - Simple data structure that holds the name of the image.

2. **ViewModel (`CarouselViewModel.swift`)**:
   - Manages the list of carousel images and the logic for updating the page control based on user interaction.
   - Uses a closure (`onPageUpdate`) to notify the view (controller) when the page changes.

3. **View (`ViewController.swift`)**:
   - Displays the carousel using a `UIScrollView` and `UIStackView`.
   - Binds to the view model to update the UI when the data changes.
   - Manages the setup of images and the scroll behavior.

### MVVM Implementation Details

- **Model**: `CarouselImage` contains a single property, `imageName`, to represent the image data.
- **ViewModel**: `CarouselViewModel` handles the business logic, such as retrieving images and updating the current page when the user scrolls. It also exposes a closure (`onPageUpdate`) for the view to update the `UIPageControl`.
- **View (Controller)**: The `ViewController` sets up the UI components, binds to the view model, and updates the UI based on user interaction (scrolling).

### Setup Instructions

1. Clone the repository or download the zip file.
2. Open the project in Xcode.
3. Ensure the images (`image1`, `image2`, etc.) are added in the `Assets.xcassets` folder.
4. Run the project on an iOS simulator or device.

### Usage

1. **Initial Launch**: The carousel will center the middle image if there are multiple images; otherwise, it will center the first image.
2. **Scrolling**: As you scroll, the images will scale and adjust their positions to create a depth effect. The image in the center will be larger, and side images will appear behind it.
3. **Pagination Control**: The `UIPageControl` updates as you scroll to reflect the current image in focus.

### Customization

- To customize the images displayed in the carousel, add your images in `Assets.xcassets` and update the `sampleImages` array in `CarouselViewController`.
- You can modify the scale and depth effect by adjusting the parameters in the `scrollViewDidScroll` method within `CarouselViewController`.

### Dependencies

- This project uses **UIKit** for the UI components and animations. No third-party libraries are included.

### Known Issues

- Ensure that the scroll view’s width and height constraints are set properly to match the device’s dimensions for the best visual effect.
- If images do not appear as expected, verify that they are correctly added to the `Assets.xcassets` folder and named appropriately.

### Future Improvements

- Implementing unit tests for the view model to validate page update logic.
- Adding support for remote image loading using a library like **SDWebImage** for real-world use cases.
- Enhancing the view model to handle dynamic image updates and improve scalability.

### License

This project is open-source and available for modification. Feel free to use and adapt the code according to your needs.
