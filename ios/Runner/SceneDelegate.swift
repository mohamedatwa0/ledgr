import Flutter
import UIKit

@objc(SceneDelegate)
class SceneDelegate: FlutterSceneDelegate {
  override func scene(
    _ scene: UIScene,
    openURLContexts URLContexts: Set<UIOpenURLContext>
  ) {
    for context in URLContexts {
      SmsPlugin.handle(url: context.url)
    }
    super.scene(scene, openURLContexts: URLContexts)
  }
}
