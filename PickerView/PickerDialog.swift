import Foundation
import UIKit

private extension Selector {
    static let buttonTapped = #selector(PickerDialog.buttonTapped)
//    static let deviceOrientationDidChange = #selector(PickerDialog.deviceOrientationDidChange)
}

open class PickerDialog: UIView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    open var SelectedIndex: Int! = 0
    open var PickerArray: [String]!
    
    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "AvenirNext-Medium", size: 17)
            pickerLabel?.textAlignment = .center
            pickerLabel?.adjustsFontSizeToFitWidth = true
        }
        pickerLabel?.text = PickerArray[row]
        pickerLabel?.textColor = UIColor.black

        return pickerLabel!
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return PickerArray.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return PickerArray[row]
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        SelectedIndex = row
    }
    
    public typealias PickerCallback = ( Int ) -> Void

    // MARK: - Constants
    private let kDefaultButtonHeight: CGFloat = 50
    private let kDefaultButtonSpacerHeight: CGFloat = 1
    private let kCornerRadius: CGFloat = 7
    private let kDoneButtonTag: Int = 1

    // MARK: - Views
    private var dialogView: UIView!
    private var titleLabel: UILabel!
    open var viewPicker: UIPickerView!
    private var cancelButton: UIButton!
    private var doneButton: UIButton!

    // MARK: - Variables
    private var callback: PickerCallback?
    var showCancelButton: Bool = false
    var locale: Locale?

    private var textColor: UIColor!
    private var buttonColor: UIColor!
    private var font: UIFont!

    // MARK: - Dialog initialization
    @objc public init(textColor: UIColor = UIColor.black,
                buttonColor: UIColor = UIColor.blue,
                font: UIFont = .boldSystemFont(ofSize: 15),
                locale: Locale? = nil,
                showCancelButton: Bool = true) {
        let size = UIScreen.main.bounds.size
        super.init(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        self.textColor = textColor
        self.buttonColor = buttonColor
        self.font =  UIFont(name: "AvenirNext-Medium", size: 20)
        self.showCancelButton = showCancelButton
        self.locale = locale
        setupView()
    }

    @objc required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setupView() {
        dialogView = createContainerView()

        dialogView?.layer.shouldRasterize = true
        dialogView?.layer.rasterizationScale = UIScreen.main.scale

        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale

        dialogView?.layer.opacity = 0.5
        dialogView?.layer.transform = CATransform3DMakeScale(1.3, 1.3, 1)

        backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)

        if let dialogView = dialogView {
            addSubview(dialogView)
        }
    }

//    /// Handle device orientation changes
//    @objc func deviceOrientationDidChange(_ notification: Notification) {
//        self.frame = UIScreen.main.bounds
//        let dialogSize = CGSize(width: 320, height: 330 + kDefaultButtonHeight + kDefaultButtonSpacerHeight)
//        dialogView.frame = CGRect(
//            x: (UIScreen.main.bounds.size.width - dialogSize.width) / 2,
//            y: (UIScreen.main.bounds.size.height - dialogSize.height) / 2,
//            width: dialogSize.width,
//            height: dialogSize.height
//        )
//    }

    /// Create the dialog view, and animate opening the dialog
    open func showPicker(
        _ title: String,
        doneButtonTitle: String = "Done",
        cancelButtonTitle: String = "Cancel",
        PickerArrayValue: [String],
        parentView: UIView,
        callback: @escaping PickerCallback
    ) {
        SelectedIndex = 0
        self.titleLabel.text = title
        self.doneButton.setTitle(doneButtonTitle, for: .normal)
        if showCancelButton { self.cancelButton.setTitle(cancelButtonTitle, for: .normal) }
        PickerArray = PickerArrayValue
        self.callback = callback
        //if let locale = self.locale { self.viewPicker.locale = locale }

        /* Add dialog to main window */
        parentView.addSubview(self)
        parentView.bringSubviewToFront(self)
        parentView.endEditing(true)

//        NotificationCenter.default.addObserver(
//            self,
//            selector: .deviceOrientationDidChange,
//            name: UIDevice.orientationDidChangeNotification, object: nil
//        )

        /* Anim */
        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                self.backgroundColor = UIColor.black.withAlphaComponent(0.6)
                self.dialogView?.layer.opacity = 1
                self.dialogView?.layer.transform = CATransform3DMakeScale(1, 1, 1)
            }
        )
    }

    /// Dialog close animation then cleaning and removing the view from the parent
    private func close() {
        let currentTransform = self.dialogView.layer.transform

        let startRotation = (self.value(forKeyPath: "layer.transform.rotation.z") as? NSNumber) as? Double ?? 0.0
        let rotation = CATransform3DMakeRotation((CGFloat)(-startRotation + .pi * 270 / 180), 0, 0, 0)

        self.dialogView.layer.transform = CATransform3DConcat(rotation, CATransform3DMakeScale(1, 1, 1))
        self.dialogView.layer.opacity = 1

        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            options: [],
            animations: {
                self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
                let transform = CATransform3DConcat(currentTransform, CATransform3DMakeScale(0.6, 0.6, 1))
                self.dialogView.layer.transform = transform
                self.dialogView.layer.opacity = 0
            }
        ) { _ in
            for v in self.subviews {
                v.removeFromSuperview()
            }

            self.removeFromSuperview()
            self.setupView()
        }
    }

    /// Creates the container view here: create the dialog, then add the custom content and buttons
    private func createContainerView() -> UIView {
        let screenSize = UIScreen.main.bounds.size
        let dialogSize = CGSize(width: 320, height: 330 + kDefaultButtonHeight + kDefaultButtonSpacerHeight)

        // For the black background
        self.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)

        // This is the dialog's container; we attach the custom content and the buttons to this one
        let container = UIView(frame: CGRect(
            x: (screenSize.width - dialogSize.width) / 2,
            y: (screenSize.height - dialogSize.height) / 2,
            width: dialogSize.width,
            height: dialogSize.height
        ))

        // First, we style the dialog to match the iOS8 UIAlertView >>>
        let gradient: CAGradientLayer = CAGradientLayer(layer: self.layer)
        gradient.frame = container.bounds
        gradient.colors = [
            UIColor(red: 218/255, green: 218/255, blue: 218/255, alpha: 1).cgColor,
            UIColor(red: 233/255, green: 233/255, blue: 233/255, alpha: 1).cgColor,
            UIColor(red: 218/255, green: 218/255, blue: 218/255, alpha: 1).cgColor
        ]

        let cornerRadius = kCornerRadius
        gradient.cornerRadius = cornerRadius
        container.layer.insertSublayer(gradient, at: 0)

        container.layer.cornerRadius = cornerRadius
        container.layer.borderColor = UIColor(red: 198/255, green: 198/255, blue: 198/255, alpha: 1).cgColor
        container.layer.borderWidth = 1
        container.layer.shadowRadius = cornerRadius + 5
        container.layer.shadowOpacity = 0.1
        container.layer.shadowOffset = CGSize(width: 0 - (cornerRadius + 5) / 2, height: 0 - (cornerRadius + 5) / 2)
        container.layer.shadowColor = UIColor.black.cgColor
        container.layer.shadowPath = UIBezierPath(
            roundedRect: container.bounds,
            cornerRadius: container.layer.cornerRadius
        ).cgPath

        // There is a line above the button
        let yPosition = container.bounds.size.height - kDefaultButtonHeight - kDefaultButtonSpacerHeight
        let lineView = UIView(frame: CGRect(
            x: 0,
            y: yPosition,
            width: container.bounds.size.width,
            height: kDefaultButtonSpacerHeight
        ))

        lineView.backgroundColor = UIColor(red: 198/255, green: 198/255, blue: 198/255, alpha: 1)
        container.addSubview(lineView)

        //Title
        self.titleLabel = UILabel(frame: CGRect(x: 10, y: 10, width: 300, height: 50))
        self.titleLabel.textAlignment = .center
        self.titleLabel.textColor = self.textColor
//        self.titleLabel.font = self.font.withSize(17)
        self.titleLabel.font = self.font
        container.addSubview(self.titleLabel)

        self.viewPicker = configuredPicker()
        container.addSubview(self.viewPicker)

        // Add the buttons
        addButtonsToView(container: container)

        return container
    }

    fileprivate func configuredPicker() -> UIPickerView {
        
        let Picker_PV = UIPickerView(frame: CGRect(x: 0.0, y: 30.0, width: 0.0, height: 0.0))
//        Picker_PV.setValue(self.textColor, forKeyPath: "textColor")
        Picker_PV.autoresizingMask = .flexibleRightMargin
        Picker_PV.delegate = self
        Picker_PV.dataSource = self
        Picker_PV.frame.size.width = 320
        Picker_PV.frame.size.height = 316
        return Picker_PV
    }

    /// Add buttons to container
    private func addButtonsToView(container: UIView) {
        var buttonWidth = container.bounds.size.width / 2

        var leftButtonFrame = CGRect(
            x: 0,
            y: container.bounds.size.height - kDefaultButtonHeight,
            width: buttonWidth,
            height: kDefaultButtonHeight
        )
        var rightButtonFrame = CGRect(
            x: buttonWidth+1,
            y: container.bounds.size.height - kDefaultButtonHeight,
            width: buttonWidth,
            height: kDefaultButtonHeight
        )
        if showCancelButton == false {
            buttonWidth = container.bounds.size.width
            leftButtonFrame = CGRect()
            rightButtonFrame = CGRect(
                x: 0,
                y: container.bounds.size.height - kDefaultButtonHeight,
                width: buttonWidth,
                height: kDefaultButtonHeight
            )
        }
        let interfaceLayoutDirection = UIApplication.shared.userInterfaceLayoutDirection
        let isLeftToRightDirection = interfaceLayoutDirection == .leftToRight

        if showCancelButton {
            self.cancelButton = UIButton(type: .custom) as UIButton
            self.cancelButton.frame = isLeftToRightDirection ? leftButtonFrame : rightButtonFrame
            self.cancelButton.setTitleColor(self.buttonColor, for: .normal)
            self.cancelButton.setTitleColor(self.buttonColor, for: .highlighted)
            self.cancelButton.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 15)
            self.cancelButton.layer.cornerRadius = kCornerRadius
            self.cancelButton.addTarget(self, action: .buttonTapped, for: .touchUpInside)
            container.addSubview(self.cancelButton)
        }
        
        let strip1 = UIView()
        strip1.frame = CGRect(x: self.cancelButton.frame.size.width, y: self.cancelButton.frame.origin.y, width: 1, height: self.cancelButton.frame.size.height)
        strip1.backgroundColor = UIColor(red: 198/255, green: 198/255, blue: 198/255, alpha: 1)
        container.addSubview(strip1)
        
        self.doneButton = UIButton(type: .custom) as UIButton
        self.doneButton.frame = isLeftToRightDirection ? rightButtonFrame : leftButtonFrame
        self.doneButton.tag = kDoneButtonTag
        self.doneButton.setTitleColor(self.buttonColor, for: .normal)
        self.doneButton.setTitleColor(self.buttonColor, for: .highlighted)
        self.doneButton.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 15)
        self.doneButton.layer.cornerRadius = kCornerRadius
        self.doneButton.addTarget(self, action: .buttonTapped, for: .touchUpInside)
        container.addSubview(self.doneButton)
    }

    @objc func buttonTapped(sender: UIButton) {
        
        if sender.tag == kDoneButtonTag {
            self.callback?(SelectedIndex)
        } else {
            self.callback?(-1)
        }

        close()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
