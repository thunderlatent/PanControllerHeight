# PanControllerHeight

This library is designed to present a sheet ViewController easily and control ViewController height with pangesture.

if you want to present SheetVC from MainVC, you can using this library like code example

step1: you have to call configurePanSetting(viewController:defaultHeight:) to init setting default height and max height at MainController

step2: call presentContainerViewWithAnimation() at viewDidAppear(_:) to show sheet view.


//MARK: - Code Example :
```
MainViewController: UIViewController{
    func presentSheetVC()
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
`Notice:` If you want to add any UI on sheet view, you have to add UI on `containerView`.
//MARK: - Code Example
```
SheetViewController: UIViewController{

    func configureSomeView()
    {
        let someView = UIView()
        self.containerView.addSubview(someView)
    }

}
```

