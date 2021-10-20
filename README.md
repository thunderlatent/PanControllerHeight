![panControllerHeight](https://user-images.githubusercontent.com/40600827/138028119-6b0b0e0f-7624-4916-93d4-31bb60e4ed61.png)

# PanControllerHeight

PanControllerHeight is designed to present a sheet ViewController easily and control ViewController height with pangesture.

If you want to present SheetVC from MainVC, you can using this library like code example
## Step:
### Step1: You have to call configurePanSetting(viewController:defaultHeight:) to init setting default height and max height at MainController

### Step2: Call presentContainerViewWithAnimation() at viewDidAppear(_:) to show sheet view.

## Requirements
- iOS 10.0+

## Installation
### Swift Package Manager
```swift
dependencies: [
    .package(url: "https://github.com/thunderlatent/PanControllerHeight", .upToNextMajor(from: "1.0.0"))
]
```


## Code Example :
```swift
MainViewController: UIViewController{
    func yourCusomtFuncToPresentSheetVC()
    {
        let sheetVC = SheetViewController()
        sheetVC.configurePanSetting(viewController: sheetVC, defaultHeight: 300, maxHeight: 600)
        presentPanViewController(viewController: sheetVC)
    }
}

SheetViewController: UIViewController{
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presentContainerViewWithAnimation()
    }
}
```
# Recommend to use in programmatically UI i.e , it is not suitable for storyboard

# Notice: If you want to add any UI on sheet view, you have to add UI on `containerView`.

## Code Example
```swift
SheetViewController: UIViewController{

    func configureSomeView()
    {
        let someView = UIView()
        self.containerView.addSubview(someView)
    }

}
```

