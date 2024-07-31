import { uiObserver } from '@kit.ArkUI'
import { JSON } from '@kit.ArkTS'

@ComponentV2({ freezeWhenInactive: true })
export struct MyCustomComponent {
  navDestinationInfo: uiObserver.NavDestinationInfo | undefined = undefined

  aboutToAppear(): void {
    // 向上查找第一个类型为NavDestination的节点组件信息
    this.navDestinationInfo = this.queryNavDestinationInfo()
  }

  build() {
    Text('当前NavDestination信息：' + JSON.stringify(this.navDestinationInfo))
  }
}