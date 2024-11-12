#if canImport(CarPlay)
import CarPlay
#endif
import UIKit

extension UIWindow {

    /// The `UIScene` containing this window.
    @available(iOS 13.0, *)
    internal var parentScene: UIScene? {
#if canImport(CarPlay)
        switch self {
        case let carPlayWindow as CPWindow:
            return carPlayWindow.templateApplicationScene
        default:
            return windowScene
        }
#else
        return windowScene
#endif
    }

    var isCarPlay: Bool {
#if canImport(CarPlay)
        return self is CPWindow
#else
        return false
#endif
    }
}

@available(iOS 13.0, *)
extension UIScene {

    internal var allWindows: [UIWindow] {
        if let windowScene = self as? UIWindowScene {
            return windowScene.windows
        }
#if canImport(CarPlay)
        if let carPlayScene = self as? CPTemplateApplicationScene {
            return [carPlayScene.carWindow]
        } else if #available(iOS 13.4, *), let carPlayDashboardScene = self as? CPTemplateApplicationDashboardScene {
            return [carPlayDashboardScene.dashboardWindow]
        } else if #available(iOS 15.4, *), let carPlayInstrumentClusterScene = self as? CPTemplateApplicationInstrumentClusterScene {
            if let instrumentClusterWindow = carPlayInstrumentClusterScene.instrumentClusterController.instrumentClusterWindow {
                return [instrumentClusterWindow]
            } else {
                return []
            }
        }
#endif
        Log.info(forMessage: "Found no window attached to the current scene: \(self)")
        return []
    }
}
