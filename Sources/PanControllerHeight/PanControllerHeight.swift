//
//  Protocol+PanViewControllerAble.swift
//  CustomViewControllerHeight
//
//  Created by Jimmy on 2021/10/18.
//

import UIKit

public protocol PanViewControllerAble where Self: UIViewController{
    
    func presentPanViewController(viewController vc: UIViewController)
    func configurePanSetting(viewController vc: UIViewController, defaultHeight: CGFloat, maxHeight: CGFloat)
}


extension UIViewController: PanViewControllerAble{
    
    fileprivate struct Holder
    {
        static var dimmedView:UIView = UIView()
        static var dragIndicatorView = UIView()
        
        static var containerView: UIView = {
            let view = UIView()
            view.backgroundColor = .white
            view.layer.cornerRadius = 16
            view.clipsToBounds = true
            return view
        }()
        
        
        ///高度變數
        static fileprivate var defaultHeight: CGFloat = 300
        
        ///可解除
        static fileprivate var dismissibleHeight: CGFloat = ((defaultHeight - 100) <= 0) ? 50 : defaultHeight - 100
        static fileprivate var maximumContainerHeight: CGFloat = UIScreen.main.bounds.height - 64
        
        static fileprivate var currentContainerHeight: CGFloat = defaultHeight
        
        //MARK: - 動態調整高度
        static fileprivate var containerViewHeightConstraint: NSLayoutConstraint?
        static fileprivate var containerViewBottomConstraint: NSLayoutConstraint?
    }
    
    //MARK: - 重置狀態
    fileprivate func resetHolder()
    {
        dimmedView = UIView()
        dragIndicatorView = UIView()
        containerView = {
            let view = UIView()
            view.backgroundColor = .white
            view.layer.cornerRadius = 16
            view.clipsToBounds = true
            return view
        }()
        
        currentContainerHeight = defaultHeight
        containerViewHeightConstraint = nil
        containerViewBottomConstraint = nil
    }
    
    //MARK: - 平滑手勢處理邏輯
    @objc fileprivate func handlePanGesture(gesture: UIPanGestureRecognizer) {
        //MARK: - 手指滑動的位移
        let translation = gesture.translation(in: view)
        
        //MARK: - 判斷是否下拉
        let isDraggingDown = translation.y > 0
        
        //MARK: - 新的高度
        let newHeight = currentContainerHeight + (-translation.y)
        
        //MARK: - 根據手勢狀態判斷目前要變高還是變低
        switch gesture.state {
        case .changed:
            if newHeight < maximumContainerHeight {
                containerViewHeightConstraint?.constant = newHeight
                view.layoutIfNeeded()
            }
        case .ended:
            //MARK: - 小於最低高度則解除VC
            if newHeight < dismissibleHeight {
                self.dismissViewAnimation()
            }
            //MARK: - 小於預設高度則回覆至預設高度
            else if newHeight < defaultHeight {
                setContainerViewHeightAnimation(defaultHeight)
            }
            //MARK: - 小於最大高度並且是下拉姿態，則回復到預設高度
            else if newHeight < maximumContainerHeight && isDraggingDown {
                setContainerViewHeightAnimation(defaultHeight)
            }
            //MARK: - 大於預設高度並且是上拉姿態，回復到最大高度
            else if newHeight > defaultHeight && !isDraggingDown {
                setContainerViewHeightAnimation(maximumContainerHeight)
            }
            
        default:
            break
        }
    }
    
    //MARK: - 解除VC動畫
    @objc fileprivate func dismissViewAnimation() {
        
        dimmedView.alpha = dimmedMaxAlpha
        let dismissDimmedViewAnimate = UIViewPropertyAnimator(duration: 0.4, curve: .easeIn) {
            self.dimmedView.alpha = 0
        }
        
        dismissDimmedViewAnimate.addCompletion { position in
            if position == .end
            {
                self.dismiss(animated: false, completion:{
                    self.resetHolder()
                })
            }
        }
        dismissDimmedViewAnimate.startAnimation()
        
        
        
        UIViewPropertyAnimator(duration: 0.3, curve: .easeIn) {
            self.containerViewBottomConstraint?.constant = self.currentContainerHeight
            
            self.view.layoutIfNeeded()
        }.startAnimation()
        
    }
}
extension PanViewControllerAble where Self: UIViewController
{
    
    
    fileprivate var dimmedView: UIView{
        get{
            return Holder.dimmedView
        }set{
            Holder.dimmedView = newValue
        }
    }
    
    
    
    fileprivate var dragIndicatorView: UIView
    {
        get
        {
            return Holder.dragIndicatorView
        }set{
            Holder.dragIndicatorView = newValue
        }
    }
    
    public var containerView: UIView{
        get{
            return Holder.containerView
        }set{
            Holder.containerView = newValue
        }
    }
    
    fileprivate var defaultHeight: CGFloat
    {
        get{
            return Holder.defaultHeight
        }set{
            Holder.defaultHeight = newValue
        }
    }
    
    fileprivate var dismissibleHeight: CGFloat
    {
        get{
            ((defaultHeight - 100) <= 0) ? 50 : defaultHeight - 100
        }set{
            Holder.dismissibleHeight = newValue
        }
    }
    fileprivate var maximumContainerHeight: CGFloat{
        get{
            Holder.maximumContainerHeight
        }set{
            Holder.maximumContainerHeight = newValue
        }
    }
    
    fileprivate var currentContainerHeight: CGFloat
    {
        get{
            return Holder.currentContainerHeight
        }set{
            Holder.currentContainerHeight = newValue
        }
    }
    
    //MARK: - 動態調整高度
    fileprivate var containerViewHeightConstraint: NSLayoutConstraint?
    {
        get{
            return Holder.containerViewHeightConstraint
        }set
        {
            Holder.containerViewHeightConstraint = newValue
        }
    }
    fileprivate var containerViewBottomConstraint: NSLayoutConstraint?
    {
        get{
            return Holder.containerViewBottomConstraint
        }set
        {
            Holder.containerViewBottomConstraint = newValue
        }
    }
    
    
    fileprivate var dimmedMaxAlpha: CGFloat {
        get{
            0.6
        }
    }
    
    
    /// 推送出新的UIViewController
    /// - Parameter vc: 要被推送出的UIViewController
    public func presentPanViewController(viewController vc: UIViewController)
    {
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        
        //MARK: - 設置dimmedView
        self.present(vc, animated: false, completion: nil)
    }
    
    ///初始化手勢滑動設定
    /// - Parameters:
    ///   - vc: 被推送出的視圖控制器
    ///   - defaultHeight: 設定預設高度
    ///   - maxHeight: 設定最大高度
    public func configurePanSetting(viewController vc: UIViewController, defaultHeight: CGFloat, maxHeight: CGFloat)
    {
        setDefauleHeight(height: defaultHeight)
        setMaxHeight(height: maxHeight)
        resetHolder()
        configureDimmedView(viewController: vc)
        configureContainerView(viewController: vc)
        configureDragIndicatorView(viewController: vc)
        configurePanGesture(viewController: vc)
    }
    
    ///推送出ContainerView，必須要在ViewDidAppear內被呼叫
    public func presentContainerViewWithAnimation() {
        showDimmedViewAnimation()
        UIViewPropertyAnimator(duration: 0.3, curve: .easeIn) {
            self.containerViewBottomConstraint?.constant = 0
            self.view.layoutIfNeeded()
        }.startAnimation()
    }
    
    
    //MARK: - 配置暗色backgroundView
    private func configureDimmedView(viewController vc: UIViewController)
    {
        self.dimmedView.alpha = dimmedMaxAlpha
        self.dimmedView.backgroundColor = .black
        vc.view.addSubview(dimmedView)
        dimmedView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dimmedView.topAnchor.constraint(equalTo: vc.view.topAnchor),
            dimmedView.bottomAnchor.constraint(equalTo: vc.view.bottomAnchor),
            dimmedView.leadingAnchor.constraint(equalTo: vc.view.leadingAnchor),
            dimmedView.trailingAnchor.constraint(equalTo: vc.view.trailingAnchor),
        ])
        
        //MARK: - 為DimmedView添加手勢用以移除VC
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissViewAnimation))
        dimmedView.addGestureRecognizer(tapGesture)
    }
    
    //MARK: - 配置存放內容的ContainerView
    private func configureContainerView(viewController vc: UIViewController)
    {
        vc.view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        containerViewHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: defaultHeight)
        containerViewBottomConstraint = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: defaultHeight)
        if containerViewHeightConstraint?.isActive == false{
            containerViewHeightConstraint?.isActive = true
        }
        if containerViewBottomConstraint?.isActive == false
        {
            containerViewBottomConstraint?.isActive = true
        }
    }
    
    //MARK: - 配置ContainerView頂部指示器
    private func configureDragIndicatorView(viewController vc: UIViewController)
    {
        vc.view.addSubview(dragIndicatorView)
        self.dragIndicatorView.backgroundColor = #colorLiteral(red: 0.6039215686, green: 0.6039215686, blue: 0.6039215686, alpha: 1)
        self.dragIndicatorView.layer.masksToBounds = true
        self.dragIndicatorView.layer.cornerRadius = 10
        dragIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        dragIndicatorView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 6).isActive = true
        dragIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        dragIndicatorView.widthAnchor.constraint(equalToConstant: self.view.frame.width / 8).isActive = true
        dragIndicatorView.heightAnchor.constraint(equalToConstant: 6).isActive = true
    }
    
    
    //MARK: - 添加平滑手勢
    private func configurePanGesture(viewController vc: UIViewController) {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(gesture:)))
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
        vc.view.addGestureRecognizer(panGesture)
    }
    
    
    
    //MARK: - 調整內容視圖高度動畫
    fileprivate func setContainerViewHeightAnimation(_ height: CGFloat) {
        
        UIViewPropertyAnimator(duration: 0.4, curve: .easeIn) {
            self.containerViewHeightConstraint?.constant = height
            self.view.layoutIfNeeded()
        }.startAnimation()
        currentContainerHeight = height
    }
    
    
    
    
    //MARK: - 顯示背景暗色過度動畫
    private func showDimmedViewAnimation() {
        dimmedView.alpha = 0
        UIViewPropertyAnimator(duration: 0.4, curve: .easeIn) {
            self.dimmedView.alpha = self.dimmedMaxAlpha
        }.startAnimation()
        
    }
    
    
    /// 設置預設高度
    /// - Parameter height: 指定預設高度
    fileprivate func setDefauleHeight(height: CGFloat) {
        defaultHeight = height
    }
    
    /// 設置最大高度
    /// - Parameter height: 指定最大高度
    fileprivate func setMaxHeight(height: CGFloat)
    {
        maximumContainerHeight = height
    }
}

