
import androidx.compose.ui.uikit.ComposeUIViewControllerDelegate
import androidx.compose.ui.window.ComposeUIViewController
import com.russhwolf.settings.NSUserDefaultsSettings
import platform.Foundation.NSUserDefaults
import platform.UIKit.UIViewController

@Suppress("FunctionName", "unused")
fun MainViewController(): UIViewController {
    val model = AppViewModel()
    val settings = NSUserDefaultsSettings(NSUserDefaults())
    return ComposeUIViewController(
        configure = {
            delegate = object : ComposeUIViewControllerDelegate {
                override fun viewWillAppear(animated: Boolean) {
                    super.viewWillAppear(animated)
                    model.loadData(settings)
                }
                override fun viewWillDisappear(animated: Boolean) {
                    super.viewWillDisappear(animated)
                    model.saveData(settings)
                }
            }
        }
    ) {
        App(model = model)
    }
}
