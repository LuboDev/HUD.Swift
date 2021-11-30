import UIKit

open class DimCoverView: HUDCoverView {
    private let model: HUDCoverModel

    override public var isVisible: Bool {
        return !isHidden
    }

    override public var coverBackgroundColor: UIColor? {
        get {
            return dimBackgroundView.backgroundColor
        }
        set {
            dimBackgroundView.backgroundColor = newValue
        }
    }

    private let dimBackgroundView: UIView

    public init(withModel model: HUDCoverModel, backgroundView: UIView? = nil) {
        self.model = model
        self.dimBackgroundView = backgroundView ?? UIView()
        super.init(frame: .zero)

        commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    internal func commonInit() {
        isHidden = true

        dimBackgroundView.backgroundColor = model.coverBackgroundColor
        dimBackgroundView.alpha = 0

        addSubview(dimBackgroundView)
    }

    override public func show(animated: Bool) {
        delegate?.willShow()
        isHidden = false
        if animated {
            UIView.animate(withDuration: model.coverInAnimationDuration, delay: 0, options: model.coverAnimationCurve, animations: {
                self.dimBackgroundView.alpha = 1
            }, completion: { [weak self] _ in
                self?.delegate?.didShow()
            })
        } else {
            dimBackgroundView.alpha = 1
            delegate?.didShow()
        }
    }

    override public func hide(animated: Bool, completion: (() -> ())?) {
        delegate?.willHide()
        if animated {
            UIView.animate(withDuration: model.coverOutAnimationDuration, delay: 0, options: model.coverAnimationCurve, animations: {
                self.dimBackgroundView.alpha = 0
            }, completion: { [weak self] _ in
                self?.isHidden = true

                self?.delegate?.didHide()
                completion?()
            })
        } else {
            dimBackgroundView.alpha = 0
            isHidden = true

            delegate?.didHide()
            completion?()
        }
    }

    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        onTapCover?()

        super.touchesEnded(touches, with: event)
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        dimBackgroundView.frame = bounds
    }

    deinit {
//        print("deinit coverView \(self)")
    }

}
