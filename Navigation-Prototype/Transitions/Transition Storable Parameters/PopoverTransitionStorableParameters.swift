import UIKit

final class PopoverTransitionStorableParameters: NSObject  {
    /// если показывать дочерний контроллер внутри поповера,
    /// то кто-то должен держать сильную ссылку на этот поповер
    var popoverController: UIPopoverController? {
        willSet {
            // старые версии iOS крешились, если не убирать зануляемый поповер
            if newValue == nil {
                popoverController?.dismissPopoverAnimated(true)
            }
        }
    }
    
    /// дочерний контроллер как правило - UINavigationController,
    /// поэтому кто-то должен держать сильную ссылку на его обработчика переходов.
    /// роутеры держат слабые ссылки на свои обработчики переходов
    var presentedTransitionsHandler: TransitionsHandler?
    
    init (
        popoverController: UIPopoverController,
        presentedTransitionsHandler: TransitionsHandler)
    {
        self.popoverController = popoverController
        self.presentedTransitionsHandler = presentedTransitionsHandler
        
        super.init()
        
        popoverController.delegate = self
    }
}

// MARK: - UIPopoverControllerDelegate
extension PopoverTransitionStorableParameters: UIPopoverControllerDelegate {
    func popoverControllerShouldDismissPopover(popoverController: UIPopoverController)
        -> Bool
    {
        return true
    }
    
    func popoverControllerDidDismissPopover(popoverController: UIPopoverController)
    {
        self.popoverController = nil
    }
}

// MARK: - TransitionStorableParameters
extension PopoverTransitionStorableParameters: TransitionStorableParameters {
    func releaseStorableParameters() {
        popoverController?.dismissPopoverAnimated(false)
        popoverController = nil
    }
}