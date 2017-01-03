// Copyright (c) 2017 evolved.io (http://evolved.io)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit

public extension UIViewController {
    var evo_drawerController: DrawerController? {
        var parentViewController = self.parent
        
        while parentViewController != nil {
            if parentViewController!.isKind(of: DrawerController.self) {
                return parentViewController as? DrawerController
            }
            
            parentViewController = parentViewController!.parent
        }
        
        return nil
    }
    
    var evo_visibleDrawerFrame: CGRect {
        if let drawerController = self.evo_drawerController {
            if drawerController.leftDrawerViewController != nil {
                if self == drawerController.leftDrawerViewController || self.navigationController == drawerController.leftDrawerViewController {
                    var rect = drawerController.view.bounds
                    rect.size.width = drawerController.maximumLeftDrawerWidth
                    return rect
                }
            }
            
            if drawerController.rightDrawerViewController != nil {
                if self == drawerController.rightDrawerViewController || self.navigationController == drawerController.rightDrawerViewController {
                    var rect = drawerController.view.bounds
                    rect.size.width = drawerController.maximumRightDrawerWidth
                    rect.origin.x = drawerController.view.bounds.width - rect.size.width
                    return rect
                }
            }
        }
        
        return CGRect.null
    }
}

private func bounceKeyFrameAnimation(forDistance distance: CGFloat, on view: UIView) -> CAKeyframeAnimation {
    let factors: [CGFloat] = [0, 32, 60, 83, 100, 114, 124, 128, 128, 124, 114, 100, 83, 60, 32, 0, 24, 42, 54, 62, 64, 62, 54, 42, 24, 0, 18, 28, 32, 28, 18, 0]
    
    let values = factors.map { x -> NSNumber in
        // This could be refactored as `NSNumber(value: Float(x / 128 * distance + view.bounds.midX))`
        // but unfortunately that would require 400ms+ more compile time
        var value = x
        value /= 128
        value *= distance
        value += view.bounds.midX

        return NSNumber(value: Float(value))
    }
    
    let animation = CAKeyframeAnimation(keyPath: "position.x")
    animation.repeatCount = 1
    animation.duration = 0.8
    animation.fillMode = kCAFillModeForwards
    animation.values = values
    animation.isRemovedOnCompletion = true
    animation.autoreverses = false
    
    return animation
}

public enum DrawerSide: Int {
    case none
    case left
    case right
}

public struct OpenDrawerGestureMode: OptionSet {
    public let rawValue: UInt
    public init(rawValue: UInt) { self.rawValue = rawValue }
    
    public static let panningNavigationBar = OpenDrawerGestureMode(rawValue: 0b0001)
    public static let panningCenterView = OpenDrawerGestureMode(rawValue: 0b0010)
    public static let bezelPanningCenterView = OpenDrawerGestureMode(rawValue: 0b0100)
    public static let custom = OpenDrawerGestureMode(rawValue: 0b1000)
    public static let all: OpenDrawerGestureMode = [panningNavigationBar, panningCenterView, bezelPanningCenterView, custom]
}

public struct CloseDrawerGestureMode: OptionSet {
    public let rawValue: UInt
    public init(rawValue: UInt) { self.rawValue = rawValue }
    
    public static let panningNavigationBar = CloseDrawerGestureMode(rawValue: 0b0000001)
    public static let panningCenterView = CloseDrawerGestureMode(rawValue: 0b0000010)
    public static let bezelPanningCenterView = CloseDrawerGestureMode(rawValue: 0b0000100)
    public static let tapNavigationBar = CloseDrawerGestureMode(rawValue: 0b0001000)
    public static let tapCenterView = CloseDrawerGestureMode(rawValue: 0b0010000)
    public static let panningDrawerView = CloseDrawerGestureMode(rawValue: 0b0100000)
    public static let custom = CloseDrawerGestureMode(rawValue: 0b1000000)
    public static let all: CloseDrawerGestureMode = [panningNavigationBar, panningCenterView, bezelPanningCenterView, tapNavigationBar, tapCenterView, panningDrawerView, custom]
}

public enum DrawerOpenCenterInteractionMode: Int {
    case none
    case full
    case navigationBarOnly
}

private let DrawerDefaultWidth: CGFloat = 280.0
private let DrawerDefaultAnimationVelocity: CGFloat = 840.0

private let DrawerDefaultFullAnimationDelay: TimeInterval = 0.10

private let DrawerDefaultBounceDistance: CGFloat = 50.0

private let DrawerMinimumAnimationDuration: CGFloat = 0.15
private let DrawerDefaultDampingFactor: CGFloat = 1.0
private let DrawerDefaultShadowRadius: CGFloat = 10.0
private let DrawerDefaultShadowOpacity: Float = 0.8

private let DrawerPanVelocityXAnimationThreshold: CGFloat = 200.0

/** The amount of overshoot that is panned linearly. The remaining percentage nonlinearly asymptotes to the max percentage. */
private let DrawerOvershootLinearRangePercentage: CGFloat = 0.75

/** The percent of the possible overshoot width to use as the actual overshoot percentage. */
private let DrawerOvershootPercentage: CGFloat = 0.1

private let DrawerBezelRange: CGFloat = 20.0

private let DrawerLeftDrawerKey = "DrawerLeftDrawer"
private let DrawerRightDrawerKey = "DrawerRightDrawer"
private let DrawerCenterKey = "DrawerCenter"
private let DrawerOpenSideKey = "DrawerOpenSide"

public typealias DrawerGestureShouldRecognizeTouchBlock = (DrawerController, UIGestureRecognizer, UITouch) -> Bool
public typealias DrawerGestureCompletionBlock = (DrawerController, UIGestureRecognizer) -> Void
public typealias DrawerControllerDrawerVisualStateBlock = (DrawerController, DrawerSide, CGFloat) -> Void

private class DrawerCenterContainerView: UIView {
    fileprivate var openSide: DrawerSide = .none
    var centerInteractionMode: DrawerOpenCenterInteractionMode = .none
    
    fileprivate override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        var hitView = super.hitTest(point, with: event)
        
        if hitView != nil && self.openSide != .none {
            if self.centerInteractionMode == .none {
                hitView = nil
            } else if let navBar = self.navigationBarContained(withinSubviewsOf: self) {
                let navBarFrame = navBar.convert(navBar.bounds, to: self)

                if self.centerInteractionMode == .navigationBarOnly && navBarFrame.contains(point) == false {
                    hitView = nil
                }
            }
        }
        
        return hitView
    }
    
    fileprivate func navigationBarContained(withinSubviewsOf view: UIView) -> UINavigationBar? {
        var navBar: UINavigationBar?
        
        for subview in view.subviews as [UIView] {
            if view.isKind(of: UINavigationBar.self) {
                navBar = view as? UINavigationBar
                break
            } else {
                navBar = self.navigationBarContained(withinSubviewsOf: subview)
                if navBar != nil {
                    break
                }
            }
        }
        
        return navBar
    }
}

open class DrawerController: UIViewController, UIGestureRecognizerDelegate {
    fileprivate var _centerViewController: UIViewController?
    fileprivate var _leftDrawerViewController: UIViewController?
    fileprivate var _rightDrawerViewController: UIViewController?
    fileprivate var _maximumLeftDrawerWidth = DrawerDefaultWidth
    fileprivate var _maximumRightDrawerWidth = DrawerDefaultWidth
    
    /**
    The center view controller.
    
    This can only be set via the init methods, as well as the `setNewCenterViewController:...` methods. The size of this view controller will automatically be set to the size of the drawer container view controller, and it's position is modified from within this class. Do not modify the frame externally.
    */
    open var centerViewController: UIViewController? {
        get {
            return self._centerViewController
        }
        
        set {
            self.setCenter(newValue, animated: false)
        }
    }
    
    /**
    The left drawer view controller.
    
    The size of this view controller is managed within this class, and is automatically set to the appropriate size based on the `maximumLeftDrawerWidth`. Do not modify the frame externally.
    */
    open var leftDrawerViewController: UIViewController? {
        get {
            return self._leftDrawerViewController
        }
        
        set {
            self.setDrawer(newValue, for: .left)
        }
    }
    
    /**
    The right drawer view controller.
    
    The size of this view controller is managed within this class, and is automatically set to the appropriate size based on the `maximumRightDrawerWidth`. Do not modify the frame externally.
    */
    open var rightDrawerViewController: UIViewController? {
        get {
            return self._rightDrawerViewController
        }
        
        set {
            self.setDrawer(newValue, for: .right)
        }
    }
    
    /**
    The maximum width of the `leftDrawerViewController`.
    
    By default, this is set to 280. If the `leftDrawerViewController` is nil, this property will return 0.0;
    */
    open var maximumLeftDrawerWidth: CGFloat {
        get {
            if self.leftDrawerViewController != nil {
                return self._maximumLeftDrawerWidth
            } else {
                return 0.0
            }
        }
        
        set {
            self.setMaximumLeftDrawerWidth(newValue, animated: false, completion: nil)
        }
    }
    
    /**
    The maximum width of the `rightDrawerViewController`.
    
    By default, this is set to 280. If the `rightDrawerViewController` is nil, this property will return 0.0;
    
    */
    open var maximumRightDrawerWidth: CGFloat {
        get {
            if self.rightDrawerViewController != nil {
                return self._maximumRightDrawerWidth
            } else {
                return 0.0
            }
        }
        
        set {
            self.setMaximumRightDrawerWidth(newValue, animated: false, completion: nil)
        }
    }
    
    /**
    The visible width of the `leftDrawerViewController`.
    
    Note this value can be greater than `maximumLeftDrawerWidth` during the full close animation when setting a new center view controller;
    */
    open var visibleLeftDrawerWidth: CGFloat {
        get {
            return max(0.0, self.centerContainerView.frame.minX)
        }
    }
    
    /**
    The visible width of the `rightDrawerViewController`.
    
    Note this value can be greater than `maximumRightDrawerWidth` during the full close animation when setting a new center view controller;
    */
    open var visibleRightDrawerWidth: CGFloat {
        get {
            if self.centerContainerView.frame.minX < 0 {
                return self.childControllerContainerView.bounds.width - self.centerContainerView.frame.maxX
            } else {
                return 0.0
            }
        }
    }
    
    /**
    A boolean that determines whether or not the panning gesture will "hard-stop" at the maximum width for a given drawer side.
    
    By default, this value is set to YES. Enabling `shouldStretchDrawer` will give the pan a gradual asymptotic stopping point much like `UIScrollView` behaves. Note that if this value is set to YES, the `drawerVisualStateBlock` can be passed a `percentVisible` greater than 1.0, so be sure to handle that case appropriately.
    */
    open var shouldStretchDrawer = true
    open var drawerDampingFactor = DrawerDefaultDampingFactor
    open var shadowRadius = DrawerDefaultShadowRadius
    open var shadowOpacity = DrawerDefaultShadowOpacity
    open var bezelRange = DrawerBezelRange
    
    /**
    The flag determining if a shadow should be drawn off of `centerViewController` when a drawer is open.
    
    By default, this is set to YES.
    */
    open var showsShadows: Bool = true {
        didSet {
            self.updateShadowForCenterView()
        }
    }
    
    open var animationVelocity = DrawerDefaultAnimationVelocity
    fileprivate var animatingDrawer: Bool = false {
        didSet {
            self.view.isUserInteractionEnabled = !self.animatingDrawer
        }
    }
    
    fileprivate lazy var childControllerContainerView: UIView = {
        let childContainerViewFrame = self.view.bounds
        let childControllerContainerView = UIView(frame: childContainerViewFrame)
        childControllerContainerView.backgroundColor = UIColor.clear
        childControllerContainerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.view.addSubview(childControllerContainerView)
        
        return childControllerContainerView
        }()
    
    fileprivate lazy var centerContainerView: DrawerCenterContainerView = {
        let centerFrame = self.childControllerContainerView.bounds
        
        let centerContainerView = DrawerCenterContainerView(frame: centerFrame)
        centerContainerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        centerContainerView.backgroundColor = UIColor.clear
        centerContainerView.openSide = self.openSide
        centerContainerView.centerInteractionMode = self.centerHiddenInteractionMode
        self.childControllerContainerView.addSubview(centerContainerView)
        
        return centerContainerView
        }()
    
    /**
    The current open side of the drawer.
    
    Note this value will change as soon as a pan gesture opens a drawer, or when a open/close animation is finished.
    */
    open fileprivate(set) var openSide: DrawerSide = .none {
        didSet {
            self.centerContainerView.openSide = self.openSide
            if self.openSide == .none {
                self.leftDrawerViewController?.view.isHidden = true
                self.rightDrawerViewController?.view.isHidden = true
            }
            
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    fileprivate var startingPanRect: CGRect = CGRect.null
    
    /**
    Sets a callback to be called when a gesture has been completed.
    
    This block is called when a gesture action has been completed. You can query the `openSide` of the `drawerController` to determine what the new state of the drawer is.
    
    - parameter gestureCompletionBlock: A block object to be called that allows the implementer be notified when a gesture action has been completed.
    */
    open var gestureCompletionBlock: DrawerGestureCompletionBlock?
    
    /**
    Sets a callback to be called when a drawer visual state needs to be updated.
    
    This block is responsible for updating the drawer's view state, and the drawer controller will handle animating to that state from the current state. This block will be called when the drawer is opened or closed, as well when the user is panning the drawer. This block is not responsible for doing animations directly, but instead just updating the state of the properies (such as alpha, anchor point, transform, etc). Note that if `shouldStretchDrawer` is set to YES, it is possible for `percentVisible` to be greater than 1.0. If `shouldStretchDrawer` is set to NO, `percentVisible` will never be greater than 1.0.
    
    Note that when the drawer is finished opening or closing, the side drawer controller view will be reset with the following properies:
    
    - alpha: 1.0
    - transform: CATransform3DIdentity
    - anchorPoint: (0.5,0.5)
    
    - parameter drawerVisualStateBlock: A block object to be called that allows the implementer to update visual state properties on the drawer. `percentVisible` represents the amount of the drawer space that is current visible, with drawer space being defined as the edge of the screen to the maxmimum drawer width. Note that you do have access to the drawerController, which will allow you to update things like the anchor point of the side drawer layer.
    */
    open var drawerVisualStateBlock: DrawerControllerDrawerVisualStateBlock?
    
    /**
    Sets a callback to be called to determine if a UIGestureRecognizer should recieve the given UITouch.
    
    This block provides a way to allow a gesture to be recognized with custom logic. For example, you may have a certain part of your view that should accept a pan gesture recognizer to open the drawer, but not another a part. If you return YES, the gesture is recognized and the appropriate action is taken. This provides similar support to how Facebook allows you to pan on the background view of the main table view, but not the content itself. You can inspect the `openSide` property of the `drawerController` to determine the current state of the drawer, and apply the appropriate logic within your block.
    
    Note that either `openDrawerGestureModeMask` must contain `OpenDrawerGestureModeCustom`, or `closeDrawerGestureModeMask` must contain `CloseDrawerGestureModeCustom` for this block to be consulted.
    
    - parameter gestureShouldRecognizeTouchBlock: A block object to be called to determine if the given `touch` should be recognized by the given gesture.
    */
    open var gestureShouldRecognizeTouchBlock: DrawerGestureShouldRecognizeTouchBlock?
    
    /**
    How a user is allowed to open a drawer using gestures.
    
    By default, this is set to `OpenDrawerGestureModeNone`. Note these gestures may affect user interaction with the `centerViewController`, so be sure to use appropriately.
    */
    open var openDrawerGestureModeMask: OpenDrawerGestureMode = []
    
    /**
    How a user is allowed to close a drawer.
    
    By default, this is set to `CloseDrawerGestureModeNone`. Note these gestures may affect user interaction with the `centerViewController`, so be sure to use appropriately.
    */
    open var closeDrawerGestureModeMask: CloseDrawerGestureMode = []
    
    /**
    The value determining if the user can interact with the `centerViewController` when a side drawer is open.
    
    By default, it is `DrawerOpenCenterInteractionModeNavigationBarOnly`, meaning that the user can only interact with the buttons on the `UINavigationBar`, if the center view controller is a `UINavigationController`. Otherwise, the user cannot interact with any other center view controller elements.
    */
    open var centerHiddenInteractionMode: DrawerOpenCenterInteractionMode = .navigationBarOnly {
        didSet {
            self.centerContainerView.centerInteractionMode = self.centerHiddenInteractionMode
        }
    }
    
    // MARK: - Initializers
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    /**
    Creates and initializes an `DrawerController` object with the specified center view controller, left drawer view controller, and right drawer view controller.
    
    - parameter centerViewController: The center view controller. This argument must not be `nil`.
    - parameter leftDrawerViewController: The left drawer view controller.
    - parameter rightDrawerViewController: The right drawer controller.
    
    - returns: The newly-initialized drawer container view controller.
    */
    public init(centerViewController: UIViewController, leftDrawerViewController: UIViewController?, rightDrawerViewController: UIViewController?) {
        super.init(nibName: nil, bundle: nil)
        
        self.centerViewController = centerViewController
        self.leftDrawerViewController = leftDrawerViewController
        self.rightDrawerViewController = rightDrawerViewController
    }
    
    /**
    Creates and initializes an `DrawerController` object with the specified center view controller, left drawer view controller.
    
    - parameter centerViewController: The center view controller. This argument must not be `nil`.
    - parameter leftDrawerViewController: The left drawer view controller.
    
    - returns: The newly-initialized drawer container view controller.
    */
    public convenience init(centerViewController: UIViewController, leftDrawerViewController: UIViewController?) {
        self.init(centerViewController: centerViewController, leftDrawerViewController: leftDrawerViewController, rightDrawerViewController: nil)
    }
    
    /**
    Creates and initializes an `DrawerController` object with the specified center view controller, right drawer view controller.
    
    - parameter centerViewController: The center view controller. This argument must not be `nil`.
    - parameter rightDrawerViewController: The right drawer controller.
    
    - returns: The newly-initialized drawer container view controller.
    */
    public convenience init(centerViewController: UIViewController, rightDrawerViewController: UIViewController?) {
        self.init(centerViewController: centerViewController, leftDrawerViewController: nil, rightDrawerViewController: rightDrawerViewController)
    }
    
    // MARK: - State Restoration
    
    open override func encodeRestorableState(with coder: NSCoder) {
        super.encodeRestorableState(with: coder)
        
        if let leftDrawerViewController = self.leftDrawerViewController {
            coder.encode(leftDrawerViewController, forKey: DrawerLeftDrawerKey)
        }
        
        if let rightDrawerViewController = self.rightDrawerViewController {
            coder.encode(rightDrawerViewController, forKey: DrawerRightDrawerKey)
        }
        
        if let centerViewController = self.centerViewController {
            coder.encode(centerViewController, forKey: DrawerCenterKey)
        }
        
        coder.encode(self.openSide.rawValue, forKey: DrawerOpenSideKey)
    }
    
    open override func decodeRestorableState(with coder: NSCoder) {
        super.decodeRestorableState(with: coder)
        
        if let leftDrawerViewController: AnyObject = coder.decodeObject(forKey: DrawerLeftDrawerKey) as AnyObject? {
            self.leftDrawerViewController = leftDrawerViewController as? UIViewController
        }
        
        if let rightDrawerViewController: AnyObject = coder.decodeObject(forKey: DrawerRightDrawerKey) as AnyObject? {
            self.rightDrawerViewController = rightDrawerViewController as? UIViewController
        }
        
        if let centerViewController: AnyObject = coder.decodeObject(forKey: DrawerCenterKey) as AnyObject? {
            self.centerViewController = centerViewController as? UIViewController
        }
        
        if let openSide = DrawerSide(rawValue: coder.decodeInteger(forKey: DrawerOpenSideKey)) {
            self.openSide = openSide
        }
    }
    
    // MARK: - UIViewController Containment
    
    override open var childViewControllerForStatusBarHidden : UIViewController? {
        return self.childViewController(for: self.openSide)
    }
    
    override open var childViewControllerForStatusBarStyle : UIViewController? {
        return self.childViewController(for: self.openSide)
    }
    
    // MARK: - Animation helpers
    
    fileprivate func finishAnimationForPanGesture(withXVelocity xVelocity: CGFloat, completion: ((Bool) -> Void)?) {
        var currentOriginX = self.centerContainerView.frame.minX
        let animationVelocity = max(abs(xVelocity), DrawerPanVelocityXAnimationThreshold * 2)
        
        if self.openSide == .left {
            let midPoint = self.maximumLeftDrawerWidth / 2.0
            
            if xVelocity > DrawerPanVelocityXAnimationThreshold {
                self.openDrawerSide(.left, animated: true, velocity: animationVelocity, animationOptions: [], completion: completion)
            } else if xVelocity < -DrawerPanVelocityXAnimationThreshold {
                self.closeDrawer(animated: true, velocity: animationVelocity, animationOptions: [], completion: completion)
            } else if currentOriginX < midPoint {
                self.closeDrawer(animated: true, completion: completion)
            } else {
                self.openDrawerSide(.left, animated: true, completion: completion)
            }
        } else if self.openSide == .right {
            currentOriginX = self.centerContainerView.frame.maxX
            let midPoint = (self.childControllerContainerView.bounds.width - self.maximumRightDrawerWidth) + (self.maximumRightDrawerWidth / 2.0)
            
            if xVelocity > DrawerPanVelocityXAnimationThreshold {
                self.closeDrawer(animated: true, velocity: animationVelocity, animationOptions: [], completion: completion)
            } else if xVelocity < -DrawerPanVelocityXAnimationThreshold {
                self.openDrawerSide(.right, animated: true, velocity: animationVelocity, animationOptions: [], completion: completion)
            } else if currentOriginX > midPoint {
                self.closeDrawer(animated: true, completion: completion)
            } else {
                self.openDrawerSide(.right, animated: true, completion: completion)
            }
        } else {
            completion?(false)
        }
    }
    
    fileprivate func updateDrawerVisualState(for drawerSide: DrawerSide, percentVisible: CGFloat) {
        if let drawerVisualState = self.drawerVisualStateBlock {
            drawerVisualState(self, drawerSide, percentVisible)
        } else if self.shouldStretchDrawer {
            self.applyOvershootScaleTransform(for: drawerSide, percentVisible: percentVisible)
        }
    }
    
    fileprivate func applyOvershootScaleTransform(for drawerSide: DrawerSide, percentVisible: CGFloat) {
        if percentVisible >= 1.0 {
            var transform = CATransform3DIdentity
            
            if let sideDrawerViewController = self.sideDrawerViewController(for: drawerSide) {
                if drawerSide == .left {
                    transform = CATransform3DMakeScale(percentVisible, 1.0, 1.0)
                    transform = CATransform3DTranslate(transform, self._maximumLeftDrawerWidth * (percentVisible - 1.0) / 2, 0, 0)
                } else if drawerSide == .right {
                    transform = CATransform3DMakeScale(percentVisible, 1.0, 1.0)
                    transform = CATransform3DTranslate(transform, -self._maximumRightDrawerWidth * (percentVisible - 1.0) / 2, 0, 0)
                }
                
                sideDrawerViewController.view.layer.transform = transform
            }
        }
    }
    
    fileprivate func resetDrawerVisualState(for drawerSide: DrawerSide) {
        if let sideDrawerViewController = self.sideDrawerViewController(for: drawerSide) {
            sideDrawerViewController.view.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            sideDrawerViewController.view.layer.transform = CATransform3DIdentity
            sideDrawerViewController.view.alpha = 1.0
        }
    }
    
    fileprivate func roundedOriginX(forDrawerConstraints originX: CGFloat) -> CGFloat {
        if originX < -self.maximumRightDrawerWidth {
            if self.shouldStretchDrawer && self.rightDrawerViewController != nil {
                let maxOvershoot: CGFloat = (self.centerContainerView.frame.width - self.maximumRightDrawerWidth) * DrawerOvershootPercentage
                return self.originX(forDrawerOriginX: originX, andTargetOriginOffset: -self.maximumRightDrawerWidth, maxOvershoot: maxOvershoot)
            } else {
                return -self.maximumRightDrawerWidth
            }
        } else if originX > self.maximumLeftDrawerWidth {
            if self.shouldStretchDrawer && self.leftDrawerViewController != nil {
                let maxOvershoot = (self.centerContainerView.frame.width - self.maximumLeftDrawerWidth) * DrawerOvershootPercentage;
                return self.originX(forDrawerOriginX: originX, andTargetOriginOffset: self.maximumLeftDrawerWidth, maxOvershoot: maxOvershoot)
            } else {
                return self.maximumLeftDrawerWidth
            }
        }
        
        return originX
    }
    
    fileprivate func originX(forDrawerOriginX originX: CGFloat, andTargetOriginOffset targetOffset: CGFloat, maxOvershoot: CGFloat) -> CGFloat {
        let delta: CGFloat = abs(originX - targetOffset)
        let maxLinearPercentage = DrawerOvershootLinearRangePercentage
        let nonLinearRange = maxOvershoot * maxLinearPercentage
        let nonLinearScalingDelta = delta - nonLinearRange
        let overshoot = nonLinearRange + nonLinearScalingDelta * nonLinearRange / sqrt(pow(nonLinearScalingDelta, 2.0) + 15000)
        
        if delta < nonLinearRange {
            return originX
        } else if targetOffset < 0 {
            return targetOffset - round(overshoot)
        } else {
            return targetOffset + round(overshoot)
        }
    }
    
    // MARK: - Helpers
    
    fileprivate func setupGestureRecognizers() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panGestureCallback(_:)))
        pan.delegate = self
        self.view.addGestureRecognizer(pan)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapGestureCallback(_:)))
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
    }
    
    fileprivate func childViewController(for drawerSide: DrawerSide) -> UIViewController? {
        var childViewController: UIViewController?
        
        switch drawerSide {
        case .left:
            childViewController = self.leftDrawerViewController
        case .right:
            childViewController = self.rightDrawerViewController
        case .none:
            childViewController = self.centerViewController
        }
        
        return childViewController
    }
    
    fileprivate func sideDrawerViewController(for drawerSide: DrawerSide) -> UIViewController? {
        var sideDrawerViewController: UIViewController?
        
        if drawerSide != .none {
            sideDrawerViewController = self.childViewController(for: drawerSide)
        }
        
        return sideDrawerViewController
    }
    
    fileprivate func prepareToPresentDrawer(for drawer: DrawerSide, animated: Bool) {
        var drawerToHide: DrawerSide = .none
        
        if drawer == .left {
            drawerToHide = .right
        } else if drawer == .right {
            drawerToHide = .left
        }
        
        if let sideDrawerViewControllerToHide = self.sideDrawerViewController(for: drawerToHide) {
            self.childControllerContainerView.sendSubview(toBack: sideDrawerViewControllerToHide.view)
            sideDrawerViewControllerToHide.view.isHidden = true
        }
        
        if let sideDrawerViewControllerToPresent = self.sideDrawerViewController(for: drawer) {
            sideDrawerViewControllerToPresent.view.isHidden = false
            self.resetDrawerVisualState(for: drawer)
            sideDrawerViewControllerToPresent.view.frame = sideDrawerViewControllerToPresent.evo_visibleDrawerFrame
            self.updateDrawerVisualState(for: drawer, percentVisible: 0.0)
            sideDrawerViewControllerToPresent.beginAppearanceTransition(true, animated: animated)
        }
    }
    
    fileprivate func updateShadowForCenterView() {
        if self.showsShadows {
            self.centerContainerView.layer.masksToBounds = false
            self.centerContainerView.layer.shadowRadius = shadowRadius
            self.centerContainerView.layer.shadowOpacity = shadowOpacity
            
            /** In the event this gets called a lot, we won't update the shadowPath
            unless it needs to be updated (like during rotation) */
            if let shadowPath = centerContainerView.layer.shadowPath {
                let currentPath = shadowPath.boundingBoxOfPath

                if currentPath.equalTo(centerContainerView.bounds) == false {
                    centerContainerView.layer.shadowPath = UIBezierPath(rect: centerContainerView.bounds).cgPath
                }
            } else {
                self.centerContainerView.layer.shadowPath = UIBezierPath(rect: self.centerContainerView.bounds).cgPath
            }
        } else if self.centerContainerView.layer.shadowPath != nil {
            self.centerContainerView.layer.shadowRadius = 0.0
            self.centerContainerView.layer.shadowOpacity = 0.0
            self.centerContainerView.layer.shadowPath = nil
            self.centerContainerView.layer.masksToBounds = true
        }
    }
    
    fileprivate func animationDuration(forAnimationDistance distance: CGFloat) -> TimeInterval {
        return TimeInterval(max(distance / self.animationVelocity, DrawerMinimumAnimationDuration))
    }
    
    // MARK: - Size Methods
    
    /**
    Sets the maximum width of the left drawer view controller.
    
    If the drawer is open, and `animated` is YES, it will animate the drawer frame as well as adjust the center view controller. If the drawer is not open, this change will take place immediately.
    
    - parameter width: The new width of left drawer view controller. This must be greater than zero.
    - parameter animated: Determines whether the drawer should be adjusted with an animation.
    - parameter completion: The block called when the animation is finished.
    
    */
    open func setMaximumLeftDrawerWidth(_ width: CGFloat, animated: Bool, completion: ((Bool) -> Void)?) {
        self.setMaximumDrawerWidth(width, forSide: .left, animated: animated, completion: completion)
    }
    
    /**
    Sets the maximum width of the right drawer view controller.
    
    If the drawer is open, and `animated` is YES, it will animate the drawer frame as well as adjust the center view controller. If the drawer is not open, this change will take place immediately.
    
    - parameter width: The new width of right drawer view controller. This must be greater than zero.
    - parameter animated: Determines whether the drawer should be adjusted with an animation.
    - parameter completion: The block called when the animation is finished.
    
    */
    open func setMaximumRightDrawerWidth(_ width: CGFloat, animated: Bool, completion: ((Bool) -> Void)?) {
        self.setMaximumDrawerWidth(width, forSide: .right, animated: animated, completion: completion)
    }
    
    fileprivate func setMaximumDrawerWidth(_ width: CGFloat, forSide drawerSide: DrawerSide, animated: Bool, completion: ((Bool) -> Void)?) {
        assert({ () -> Bool in
            return width > 0
            }(), "width must be greater than 0")
        
        assert({ () -> Bool in
            return drawerSide != .none
            }(), "drawerSide cannot be .None")
        
        if let sideDrawerViewController = self.sideDrawerViewController(for: drawerSide) {
            var oldWidth: CGFloat = 0.0
            var drawerSideOriginCorrection: NSInteger = 1
            
            if drawerSide == .left {
                oldWidth = self._maximumLeftDrawerWidth
                self._maximumLeftDrawerWidth = width
            } else if (drawerSide == .right) {
                oldWidth = self._maximumRightDrawerWidth
                self._maximumRightDrawerWidth = width
                drawerSideOriginCorrection = -1
            }
            
            let distance: CGFloat = abs(width - oldWidth)
            let duration: TimeInterval = animated ? self.animationDuration(forAnimationDistance: distance) : 0.0
            
            if self.openSide == drawerSide {
                var newCenterRect = self.centerContainerView.frame
                newCenterRect.origin.x = CGFloat(drawerSideOriginCorrection) * width
                
                UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: self.drawerDampingFactor, initialSpringVelocity: self.animationVelocity / distance, options: [], animations: { () -> Void in
                    self.centerContainerView.frame = newCenterRect
                    sideDrawerViewController.view.frame = sideDrawerViewController.evo_visibleDrawerFrame
                    }, completion: { (finished) -> Void in
                        completion?(finished)
                        return
                })
            } else {
                sideDrawerViewController.view.frame = sideDrawerViewController.evo_visibleDrawerFrame
                completion?(true)
            }
        }
    }
    
    // MARK: - Setters
    
    fileprivate func setRightDrawer(_ rightDrawerViewController: UIViewController?) {
        self.setDrawer(rightDrawerViewController, for: .right)
    }
    
    fileprivate func setLeftDrawer(_ leftDrawerViewController: UIViewController?) {
        self.setDrawer(leftDrawerViewController, for: .left)
    }
    
    fileprivate func setDrawer(_ viewController: UIViewController?, for drawerSide: DrawerSide) {
        assert({ () -> Bool in
            return drawerSide != .none
            }(), "drawerSide cannot be .None")
        
        let currentSideViewController = self.sideDrawerViewController(for: drawerSide)
        
        if currentSideViewController == viewController {
            return
        }
        
        if currentSideViewController != nil {
            currentSideViewController!.beginAppearanceTransition(false, animated: false)
            currentSideViewController!.view.removeFromSuperview()
            currentSideViewController!.endAppearanceTransition()
            currentSideViewController!.willMove(toParentViewController: nil)
            currentSideViewController!.removeFromParentViewController()
        }
        
        var autoResizingMask = UIViewAutoresizing()
        
        if drawerSide == .left {
            self._leftDrawerViewController = viewController
            autoResizingMask = [.flexibleRightMargin, .flexibleHeight]
        } else if drawerSide == .right {
            self._rightDrawerViewController = viewController
            autoResizingMask = [.flexibleLeftMargin, .flexibleHeight]
        }
        
        if viewController != nil {
            self.addChildViewController(viewController!)
            
            if (self.openSide == drawerSide) && (self.childControllerContainerView.subviews as NSArray).contains(self.centerContainerView) {
                self.childControllerContainerView.insertSubview(viewController!.view, belowSubview: self.centerContainerView)
                viewController!.beginAppearanceTransition(true, animated: false)
                viewController!.endAppearanceTransition()
            } else {
                self.childControllerContainerView.addSubview(viewController!.view)
                self.childControllerContainerView.sendSubview(toBack: viewController!.view)
                viewController!.view.isHidden = true
            }
            
            viewController!.didMove(toParentViewController: self)
            viewController!.view.autoresizingMask = autoResizingMask
            viewController!.view.frame = viewController!.evo_visibleDrawerFrame
        }
    }
    
    // MARK: - Updating the Center View Controller
    
    fileprivate func setCenter(_ centerViewController: UIViewController?, animated: Bool) {
        if self._centerViewController == centerViewController {
            return
        }
        
        if let oldCenterViewController = self._centerViewController {
            oldCenterViewController.willMove(toParentViewController: nil)
            
            if animated == false {
                oldCenterViewController.beginAppearanceTransition(false, animated: false)
            }
            
            oldCenterViewController.removeFromParentViewController()
            oldCenterViewController.view.removeFromSuperview()
            
            if animated == false {
                oldCenterViewController.endAppearanceTransition()
            }
        }
        
        self._centerViewController = centerViewController
        
        if self._centerViewController != nil {
            self.addChildViewController(self._centerViewController!)
            self._centerViewController!.view.frame = self.childControllerContainerView.bounds
            self.centerContainerView.addSubview(self._centerViewController!.view)
            self.childControllerContainerView.bringSubview(toFront: self.centerContainerView)
            self._centerViewController!.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.updateShadowForCenterView()
            
            if animated == false {
                // If drawer is offscreen, then viewWillAppear: will take care of this
                if self.view.window != nil {
                    self._centerViewController!.beginAppearanceTransition(true, animated: false)
                    self._centerViewController!.endAppearanceTransition()
                }
                
                self._centerViewController!.didMove(toParentViewController: self)
            }
        }
    }
    
    /**
    Sets the new `centerViewController`.
    
    This sets the view controller and will automatically adjust the frame based on the current state of the drawer controller. If `closeAnimated` is YES, it will immediately change the center view controller, and close the drawer from its current position.
    
    - parameter centerViewController: The new `centerViewController`.
    - parameter closeAnimated: Determines whether the drawer should be closed with an animation.
    - parameter completion: The block called when the animation is finsihed.
    
    */
    open func setCenter(_ newCenterViewController: UIViewController, withCloseAnimation animated: Bool, completion: ((Bool) -> Void)?) {
        var animated = animated

        if self.openSide == .none {
            // If a side drawer isn't open, there is nothing to animate
            animated = false
        }
        
        let forwardAppearanceMethodsToCenterViewController = (self.centerViewController! == newCenterViewController) == false
        self.setCenter(newCenterViewController, animated: animated)
        
        if animated {
            self.updateDrawerVisualState(for: self.openSide, percentVisible: 1.0)
            
            if forwardAppearanceMethodsToCenterViewController {
                self.centerViewController!.beginAppearanceTransition(true, animated: animated)
            }
            
            self.closeDrawer(animated: animated, completion: { (finished) in
                if forwardAppearanceMethodsToCenterViewController {
                    self.centerViewController!.endAppearanceTransition()
                    self.centerViewController!.didMove(toParentViewController: self)
                }
                
                completion?(finished)
            })
        } else {
            completion?(true)
        }
    }
    
    /**
    Sets the new `centerViewController`.
    
    This sets the view controller and will automatically adjust the frame based on the current state of the drawer controller. If `closeFullAnimated` is YES, the current center view controller will animate off the screen, the new center view controller will then be set, followed by the drawer closing across the full width of the screen.
    
    - parameter newCenterViewController: The new `centerViewController`.
    - parameter fullCloseAnimated: Determines whether the drawer should be closed with an animation.
    - parameter completion: The block called when the animation is finsihed.
    
    */
    open func setCenter(_ newCenterViewController: UIViewController, withFullCloseAnimation animated: Bool, completion: ((Bool) -> Void)?) {
        if self.openSide != .none && animated {
            let forwardAppearanceMethodsToCenterViewController = (self.centerViewController! == newCenterViewController) == false
            let sideDrawerViewController = self.sideDrawerViewController(for: self.openSide)
            
            var targetClosePoint: CGFloat = 0.0
            
            if self.openSide == .right {
                targetClosePoint = -self.childControllerContainerView.bounds.width
            } else if self.openSide == .left {
                targetClosePoint = self.childControllerContainerView.bounds.width
            }
            
            let distance: CGFloat = abs(self.centerContainerView.frame.origin.x - targetClosePoint)
            let firstDuration = self.animationDuration(forAnimationDistance: distance)
            
            var newCenterRect = self.centerContainerView.frame
            
            self.animatingDrawer = animated
            
            let oldCenterViewController = self.centerViewController
            
            if forwardAppearanceMethodsToCenterViewController {
                oldCenterViewController?.beginAppearanceTransition(false, animated: animated)
            }
            
            newCenterRect.origin.x = targetClosePoint
            
            UIView.animate(withDuration: firstDuration, delay: 0.0, usingSpringWithDamping: self.drawerDampingFactor, initialSpringVelocity: distance / self.animationVelocity, options: [], animations: { () -> Void in
                self.centerContainerView.frame = newCenterRect
                sideDrawerViewController?.view.frame = self.childControllerContainerView.bounds
                }, completion: { (finished) -> Void in
                    let oldCenterRect = self.centerContainerView.frame
                    self.setCenter(newCenterViewController, animated: animated)
                    self.centerContainerView.frame = oldCenterRect
                    self.updateDrawerVisualState(for: self.openSide, percentVisible: 1.0)
                    
                    if forwardAppearanceMethodsToCenterViewController {
                        oldCenterViewController?.endAppearanceTransition()
                        self.centerViewController?.beginAppearanceTransition(true, animated: animated)
                    }
                    
                    sideDrawerViewController?.beginAppearanceTransition(false, animated: animated)
                    
                    UIView.animate(withDuration: self.animationDuration(forAnimationDistance: self.childControllerContainerView.bounds.width), delay: DrawerDefaultFullAnimationDelay, usingSpringWithDamping: self.drawerDampingFactor, initialSpringVelocity: self.childControllerContainerView.bounds.width / self.animationVelocity, options: [], animations: { () -> Void in
                        self.centerContainerView.frame = self.childControllerContainerView.bounds
                        self.updateDrawerVisualState(for: self.openSide, percentVisible: 0.0)
                        }, completion: { (finished) -> Void in
                            if forwardAppearanceMethodsToCenterViewController {
                                self.centerViewController?.endAppearanceTransition()
                                self.centerViewController?.didMove(toParentViewController: self)
                            }
                            
                            sideDrawerViewController?.endAppearanceTransition()
                            self.resetDrawerVisualState(for: self.openSide)
                            
                            if sideDrawerViewController != nil {
                                sideDrawerViewController!.view.frame = sideDrawerViewController!.evo_visibleDrawerFrame
                            }
                            
                            self.openSide = .none
                            self.animatingDrawer = false
                            
                            completion?(finished)
                    })
            })
        } else {
            self.setCenter(newCenterViewController, animated: animated)
            
            if self.openSide != .none {
                self.closeDrawer(animated: animated, completion: completion)
            } else if completion != nil {
                completion!(true)
            }
        }
    }
    
    // MARK: - Bounce Methods
    
    /**
    Bounce preview for the specified `drawerSide` a distance of 40 points.
    
    - parameter drawerSide: The drawer to preview. This value cannot be `DrawerSideNone`.
    - parameter completion: The block called when the animation is finsihed.
    
    */
    open func bouncePreview(for drawerSide: DrawerSide, completion: ((Bool) -> Void)?) {
        assert({ () -> Bool in
            return drawerSide != .none
            }(), "drawerSide cannot be .None")
        
        self.bouncePreview(for: drawerSide, distance: DrawerDefaultBounceDistance, completion: nil)
    }
    
    /**
    Bounce preview for the specified `drawerSide`.
    
    - parameter drawerSide: The drawer side to preview. This value cannot be `DrawerSideNone`.
    - parameter distance: The distance to bounce.
    - parameter completion: The block called when the animation is finsihed.
    
    */
    open func bouncePreview(for drawerSide: DrawerSide, distance: CGFloat, completion: ((Bool) -> Void)?) {
        assert({ () -> Bool in
            return drawerSide != .none
            }(), "drawerSide cannot be .None")
        
        let sideDrawerViewController = self.sideDrawerViewController(for: drawerSide)
        
        if sideDrawerViewController == nil || self.openSide != .none {
            completion?(false)
            return
        } else {
            self.prepareToPresentDrawer(for: drawerSide, animated: true)
            
            self.updateDrawerVisualState(for: drawerSide, percentVisible: 1.0)
            
            CATransaction.begin()
            CATransaction.setCompletionBlock {
                sideDrawerViewController!.endAppearanceTransition()
                sideDrawerViewController!.beginAppearanceTransition(false, animated: false)
                sideDrawerViewController!.endAppearanceTransition()
                
                completion?(true)
            }
            
            let modifier: CGFloat = (drawerSide == .left) ? 1.0 : -1.0
            let animation = bounceKeyFrameAnimation(forDistance: distance * modifier, on: self.centerContainerView)
            self.centerContainerView.layer.add(animation, forKey: "bouncing")
            
            CATransaction.commit()
        }
    }
    
    // MARK: - Gesture Handlers
    
    func tapGestureCallback(_ tapGesture: UITapGestureRecognizer) {
        if self.openSide != .none && self.animatingDrawer == false {
            self.closeDrawer(animated: true, completion: { (finished) in
                if self.gestureCompletionBlock != nil {
                    self.gestureCompletionBlock!(self, tapGesture)
                }
            })
        }
    }
    
    func panGestureCallback(_ panGesture: UIPanGestureRecognizer) {
        switch panGesture.state {
        case .began:
            if self.animatingDrawer {
                panGesture.isEnabled = false
            } else {
                self.startingPanRect = self.centerContainerView.frame
            }
        case .changed:
            self.view.isUserInteractionEnabled = false
            var newFrame = self.startingPanRect
            let translatedPoint = panGesture.translation(in: self.centerContainerView)
            newFrame.origin.x = self.roundedOriginX(forDrawerConstraints: self.startingPanRect.minX + translatedPoint.x)
            newFrame = newFrame.integral
            let xOffset = newFrame.origin.x
            
            var visibleSide: DrawerSide = .none
            var percentVisible: CGFloat = 0.0
            
            if xOffset > 0 {
                visibleSide = .left
                percentVisible = xOffset / self.maximumLeftDrawerWidth
            } else if xOffset < 0 {
                visibleSide = .right
                percentVisible = abs(xOffset) / self.maximumRightDrawerWidth
            }
            
            if let visibleSideDrawerViewController = self.sideDrawerViewController(for: visibleSide) {
                if self.openSide != visibleSide {
                    // Handle disappearing the visible drawer
                    if let sideDrawerViewController = self.sideDrawerViewController(for: self.openSide) {
                        sideDrawerViewController.beginAppearanceTransition(false, animated: false)
                        sideDrawerViewController.endAppearanceTransition()
                    }
                    
                    // Drawer is about to become visible
                    self.prepareToPresentDrawer(for: visibleSide, animated: false)
                    visibleSideDrawerViewController.endAppearanceTransition()
                    self.openSide = visibleSide
                } else if visibleSide == .none {
                    self.openSide = .none
                }
                
                self.updateDrawerVisualState(for: visibleSide, percentVisible: percentVisible)
                self.centerContainerView.frame.origin.x = newFrame.origin.x
            }
        case .ended, .cancelled:
            self.startingPanRect = CGRect.null
            let velocity = panGesture.velocity(in: self.childControllerContainerView)
            self.finishAnimationForPanGesture(withXVelocity: velocity.x) { finished in
                if self.gestureCompletionBlock != nil {
                    self.gestureCompletionBlock!(self, panGesture)
                }
            }
            panGesture.isEnabled = true
            self.view.isUserInteractionEnabled = true
        default:
            break
        }
    }
    
    // MARK: - Open / Close Methods
    
    // DrawerSide enum is not exported to Objective-C, so use these two methods instead
    open func toggleLeftDrawerSide(animated: Bool, completion: ((Bool) -> Void)?) {
        self.toggleDrawerSide(.left, animated: animated, completion: completion)
    }
    
    open func toggleRightDrawerSide(animated: Bool, completion: ((Bool) -> Void)?) {
        self.toggleDrawerSide(.right, animated: animated, completion: completion)
    }
    
    /**
    Toggles the drawer open/closed based on the `drawer` passed in.
    
    Note that if you attempt to toggle a drawer closed while the other is open, nothing will happen. For example, if you pass in DrawerSideLeft, but the right drawer is open, nothing will happen. In addition, the completion block will be called with the finished flag set to NO.
    
    - parameter drawerSide: The `DrawerSide` to toggle. This value cannot be `DrawerSideNone`.
    - parameter animated: Determines whether the `drawer` should be toggle animated.
    - parameter completion: The block that is called when the toggle is complete, or if no toggle took place at all.
    
    */
    open func toggleDrawerSide(_ drawerSide: DrawerSide, animated: Bool, completion: ((Bool) -> Void)?) {
        assert({ () -> Bool in
            return drawerSide != .none
            }(), "drawerSide cannot be .None")
        
        if self.openSide == DrawerSide.none {
            self.openDrawerSide(drawerSide, animated: animated, completion: completion)
        } else {
            if (drawerSide == DrawerSide.left && self.openSide == DrawerSide.left) || (drawerSide == DrawerSide.right && self.openSide == DrawerSide.right) {
                self.closeDrawer(animated: animated, completion: completion)
            } else if completion != nil {
                completion!(false)
            }
        }
    }
    
    /**
    Opens the `drawer` passed in.
    
    - parameter drawerSide: The `DrawerSide` to open. This value cannot be `DrawerSideNone`.
    - parameter animated: Determines whether the `drawer` should be open animated.
    - parameter completion: The block that is called when the toggle is open.
    
    */
    open func openDrawerSide(_ drawerSide: DrawerSide, animated: Bool, completion: ((Bool) -> Void)?) {
        assert({ () -> Bool in
            return drawerSide != .none
            }(), "drawerSide cannot be .None")
        
        self.openDrawerSide(drawerSide, animated: animated, velocity: self.animationVelocity, animationOptions: [], completion: completion)
    }
    
    fileprivate func openDrawerSide(_ drawerSide: DrawerSide, animated: Bool, velocity: CGFloat, animationOptions options: UIViewAnimationOptions, completion: ((Bool) -> Void)?) {
        assert({ () -> Bool in
            return drawerSide != .none
            }(), "drawerSide cannot be .None")
        
        if self.animatingDrawer {
            completion?(false)
        } else {
            self.animatingDrawer = animated
            let sideDrawerViewController = self.sideDrawerViewController(for: drawerSide)
            
            if self.openSide != drawerSide {
                self.prepareToPresentDrawer(for: drawerSide, animated: animated)
            }
            
            if sideDrawerViewController != nil {
                var newFrame: CGRect
                let oldFrame = self.centerContainerView.frame
                
                if drawerSide == .left {
                    newFrame = self.centerContainerView.frame
                    newFrame.origin.x = self._maximumLeftDrawerWidth
                } else {
                    newFrame = self.centerContainerView.frame
                    newFrame.origin.x = 0 - self._maximumRightDrawerWidth
                }
                
                let distance = abs(oldFrame.minX - newFrame.origin.x)
                let duration: TimeInterval = animated ? TimeInterval(max(distance / abs(velocity), DrawerMinimumAnimationDuration)) : 0.0
                
                UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: self.drawerDampingFactor, initialSpringVelocity: velocity / distance, options: options, animations: { () -> Void in
                    self.setNeedsStatusBarAppearanceUpdate()
                    self.centerContainerView.frame = newFrame
                    self.updateDrawerVisualState(for: drawerSide, percentVisible: 1.0)
                    }, completion: { (finished) -> Void in
                        if drawerSide != self.openSide {
                            sideDrawerViewController!.endAppearanceTransition()
                        }
                        
                        self.openSide = drawerSide
                        
                        self.resetDrawerVisualState(for: drawerSide)
                        self.animatingDrawer = false
                        
                        completion?(finished)
                })
            }
        }
    }
    
    /**
    Closes the open drawer.
    
    - parameter animated: Determines whether the drawer side should be closed animated
    - parameter completion: The block that is called when the close is complete
    
    */
    open func closeDrawer(animated: Bool, completion: ((Bool) -> Void)?) {
        self.closeDrawer(animated: animated, velocity: self.animationVelocity, animationOptions: [], completion: completion)
    }
    
    fileprivate func closeDrawer(animated: Bool, velocity: CGFloat, animationOptions options: UIViewAnimationOptions, completion: ((Bool) -> Void)?) {
        if self.animatingDrawer {
            completion?(false)
        } else {
            self.animatingDrawer = animated
            let newFrame = self.childControllerContainerView.bounds
            
            let distance = abs(self.centerContainerView.frame.minX)
            let duration: TimeInterval = animated ? TimeInterval(max(distance / abs(velocity), DrawerMinimumAnimationDuration)) : 0.0
            
            let leftDrawerVisible = self.centerContainerView.frame.minX > 0
            let rightDrawerVisible = self.centerContainerView.frame.minX < 0
            
            var visibleSide: DrawerSide = .none
            var percentVisible: CGFloat = 0.0
            
            if leftDrawerVisible {
                let visibleDrawerPoint = self.centerContainerView.frame.minX
                percentVisible = max(0.0, visibleDrawerPoint / self._maximumLeftDrawerWidth)
                visibleSide = .left
            } else if rightDrawerVisible {
                let visibleDrawerPoints = self.centerContainerView.frame.width - self.centerContainerView.frame.maxX
                percentVisible = max(0.0, visibleDrawerPoints / self._maximumRightDrawerWidth)
                visibleSide = .right
            }
            
            let sideDrawerViewController = self.sideDrawerViewController(for: visibleSide)
            
            self.updateDrawerVisualState(for: visibleSide, percentVisible: percentVisible)
            sideDrawerViewController?.beginAppearanceTransition(false, animated: animated)
            
            UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: self.drawerDampingFactor, initialSpringVelocity: velocity / distance, options: options, animations: { () -> Void in
                self.setNeedsStatusBarAppearanceUpdate()
                self.centerContainerView.frame = newFrame
                self.updateDrawerVisualState(for: visibleSide, percentVisible: 0.0)
                }, completion: { (finished) -> Void in
                    sideDrawerViewController?.endAppearanceTransition()
                    self.openSide = .none
                    self.resetDrawerVisualState(for: visibleSide)
                    self.animatingDrawer = false
                    completion?(finished)
            })
        }
    }
    
    // MARK: - UIViewController
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black
        
        self.setupGestureRecognizers()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.centerViewController?.beginAppearanceTransition(true, animated: animated)
        
        if self.openSide == .left {
            self.leftDrawerViewController?.beginAppearanceTransition(true, animated: animated)
        } else if self.openSide == .right {
            self.rightDrawerViewController?.beginAppearanceTransition(true, animated: animated)
        }
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.updateShadowForCenterView()
        self.centerViewController?.endAppearanceTransition()
        
        if self.openSide == .left {
            self.leftDrawerViewController?.endAppearanceTransition()
        } else if self.openSide == .right {
            self.rightDrawerViewController?.endAppearanceTransition()
        }
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.centerViewController?.beginAppearanceTransition(false, animated: animated)
        
        if self.openSide == .left {
            self.leftDrawerViewController?.beginAppearanceTransition(false, animated: animated)
        } else if self.openSide == .right {
            self.rightDrawerViewController?.beginAppearanceTransition(false, animated: animated)
        }
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.centerViewController?.endAppearanceTransition()
        
        if self.openSide == .left {
            self.leftDrawerViewController?.endAppearanceTransition()
        } else if self.openSide == .right {
            self.rightDrawerViewController?.endAppearanceTransition()
        }
    }
    
    open override var shouldAutomaticallyForwardAppearanceMethods : Bool {
        return false
    }
    
    override open var shouldAutorotate: Bool {
        if let controller = centerViewController {
            return controller.shouldAutorotate
        }

        return super.shouldAutorotate
    }

    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if let controller = centerViewController {
            return controller.supportedInterfaceOrientations
        }

        return super.supportedInterfaceOrientations
    }

    // MARK: - Rotation
    
    open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        //If a rotation begins, we are going to cancel the current gesture and reset transform and anchor points so everything works correctly
        var gestureInProgress = false
        
        for gesture in self.view.gestureRecognizers! as [UIGestureRecognizer] {
            if gesture.state == .changed {
                gesture.isEnabled = false
                gesture.isEnabled = true
                gestureInProgress = true
            }
            
            if gestureInProgress {
                self.resetDrawerVisualState(for: self.openSide)
            }
        }
        
        coordinator.animate(alongsideTransition: { (context) -> Void in
            //We need to support the shadow path rotation animation
            //Inspired from here: http://blog.radi.ws/post/8348898129/calayers-shadowpath-and-uiview-autoresizing
            if self.showsShadows {
                let oldShadowPath = self.centerContainerView.layer.shadowPath
                
                self.updateShadowForCenterView()
                
                if oldShadowPath != nil {
                    let transition = CABasicAnimation(keyPath: "shadowPath")
                    transition.fromValue = oldShadowPath
                    transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                    transition.duration = context.transitionDuration
                    self.centerContainerView.layer.add(transition, forKey: "transition")
                }
            }
        }, completion:nil)
    }
    
    // MARK: - UIGestureRecognizerDelegate
    
    open func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if self.openSide == .none {
            let possibleOpenGestureModes = self.possibleOpenGestureModes(for: gestureRecognizer, with: touch)
            
            return !self.openDrawerGestureModeMask.intersection(possibleOpenGestureModes).isEmpty
        } else {
            let possibleCloseGestureModes = self.possibleCloseGestureModes(for: gestureRecognizer, with: touch)
            
            return !self.closeDrawerGestureModeMask.intersection(possibleCloseGestureModes).isEmpty
        }
    }
    
    // MARK: - Gesture Recognizer Delegate Helpers
    
    func possibleCloseGestureModes(for gestureRecognizer: UIGestureRecognizer, with touch: UITouch) -> CloseDrawerGestureMode {
        let point = touch.location(in: self.childControllerContainerView)
        var possibleCloseGestureModes: CloseDrawerGestureMode = []
        
        if gestureRecognizer.isKind(of: UITapGestureRecognizer.self) {
            if self.isPointContained(withinNavigationRect: point) {
                possibleCloseGestureModes.insert(.tapNavigationBar)
            }
            
            if self.isPointContained(withinCenterViewContentRect: point) {
                possibleCloseGestureModes.insert(.tapCenterView)
            }
        } else if gestureRecognizer.isKind(of: UIPanGestureRecognizer.self) {
            if self.isPointContained(withinNavigationRect: point) {
                possibleCloseGestureModes.insert(.panningNavigationBar)
            }
            
            if self.isPointContained(withinCenterViewContentRect: point) {
                possibleCloseGestureModes.insert(.panningCenterView)
            }
            
            if self.isPointContained(withinRightBezelRect: point) && self.openSide == .left {
                possibleCloseGestureModes.insert(.bezelPanningCenterView)
            }
            
            if self.isPointContained(withinLeftBezelRect: point) && self.openSide == .right {
                possibleCloseGestureModes.insert(.bezelPanningCenterView)
            }
            
            if self.isPointContained(withinCenterViewContentRect: point) == false && self.isPointContained(withinNavigationRect: point) == false {
                possibleCloseGestureModes.insert(.panningDrawerView)
            }
        }
        
        if self.closeDrawerGestureModeMask.contains(.custom) && self.gestureShouldRecognizeTouchBlock != nil {
            if self.gestureShouldRecognizeTouchBlock!(self, gestureRecognizer, touch) {
                possibleCloseGestureModes.insert(.custom)
            }
        }
        
        return possibleCloseGestureModes
    }
    
    func possibleOpenGestureModes(for gestureRecognizer: UIGestureRecognizer, with touch: UITouch) -> OpenDrawerGestureMode {
        let point = touch.location(in: self.childControllerContainerView)
        var possibleOpenGestureModes: OpenDrawerGestureMode = []
        
        if gestureRecognizer.isKind(of: UIPanGestureRecognizer.self) {
            if self.isPointContained(withinNavigationRect: point) {
                possibleOpenGestureModes.insert(.panningNavigationBar)
            }
            
            if self.isPointContained(withinCenterViewContentRect: point) {
                possibleOpenGestureModes.insert(.panningCenterView)
            }
            
            if self.isPointContained(withinLeftBezelRect: point) && self.leftDrawerViewController != nil {
                possibleOpenGestureModes.insert(.bezelPanningCenterView)
            }
            
            if self.isPointContained(withinRightBezelRect: point) && self.rightDrawerViewController != nil {
                possibleOpenGestureModes.insert(.bezelPanningCenterView)
            }
        }
        
        if self.openDrawerGestureModeMask.contains(.custom) && self.gestureShouldRecognizeTouchBlock != nil {
            if self.gestureShouldRecognizeTouchBlock!(self, gestureRecognizer, touch) {
                possibleOpenGestureModes.insert(.custom)
            }
        }
        
        return possibleOpenGestureModes
    }
    
    func isPointContained(withinNavigationRect point: CGPoint) -> Bool {
        var navigationBarRect = CGRect.null
        
        if let centerViewController = self.centerViewController {
            if centerViewController.isKind(of: UINavigationController.self) {
                let navBar = (self.centerViewController as! UINavigationController).navigationBar
                navigationBarRect = navBar.convert(navBar.bounds, to: self.childControllerContainerView)
                navigationBarRect = navigationBarRect.intersection(self.childControllerContainerView.bounds)
            }
        }
        
        return navigationBarRect.contains(point)
    }
    
    func isPointContained(withinCenterViewContentRect point: CGPoint) -> Bool {
        var centerViewContentRect = self.centerContainerView.frame
        centerViewContentRect = centerViewContentRect.intersection(self.childControllerContainerView.bounds)
        
        return centerViewContentRect.contains(point) && self.isPointContained(withinNavigationRect: point) == false
    }
    
    func isPointContained(withinLeftBezelRect point: CGPoint) -> Bool {
        let (leftBezelRect, _) = childControllerContainerView.bounds.divided(atDistance: bezelRange, from: .minXEdge)

        return leftBezelRect.contains(point) && self.isPointContained(withinCenterViewContentRect: point)
    }
    
    func isPointContained(withinRightBezelRect point: CGPoint) -> Bool {
        let (rightBezelRect, _) = childControllerContainerView.bounds.divided(atDistance: bezelRange, from: .maxXEdge)

        return rightBezelRect.contains(point) && self.isPointContained(withinCenterViewContentRect: point)
    }
}

