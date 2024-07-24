import { promptAction, router } from '@kit.ArkUI';
import { RouterParams } from '../viewModels/common';

// 在RouteMap中的路由组件，如何获取路由参数？
/* 答：
 * 从 NavDestination 组件的 onReady 的回调方法中的NavDestinationContext类型的参数中，
 * pathInfo 的 param 中获取
 * */
@Entry
@ComponentV2
struct NavigationPage {
  routerParams = router.getParams() as RouterParams
  pathStack: NavPathStack = new NavPathStack()
  // 不显示图标
  menus: NavigationMenuItem[] = [
    {
      value: '搜索',
      icon: 'resources/base/media/startIcon.png',
      action: () => {
        promptAction.showToast({ message: '你点击了搜索' })
      }
    },
    {
      value: '设置',
      icon: 'resources/base/media/startIcon.png',
      action: () => {
        promptAction.showToast({ message: '你点击了设置' })
      }
    },
    {
      value: '分享',
      icon: 'resources/base/media/startIcon.png',
      action: () => {
        promptAction.showToast({ message: '你点击了分享' })
      }
    },
    {
      value: '编辑',
      icon: 'resources/base/media/startIcon.png',
      action: () => {
        promptAction.showToast({ message: '你点击了编辑' })
      }
    }
  ]
  toolbars: ToolbarItem[] = this.menus

/*  @Builder
  NavDestinationBuilder(name: string, param: Record<string, string>) {
    if (name === 'InitNavDestinationPage') {
      InitNavDestinationPage({ name, param })
    }
  }*/

  build() {
    Navigation(this.pathStack) {
      Button('返回到 Index 组件')
        .onClick(() => {
          router.back()
        })

      Button('push到 ComponentOne 组件')
        .margin({ top: 16 })
        .onClick(() => {
          this.pathStack.removeByName('ComponentOne')
          this.pathStack.pushDestinationByName('ComponentOne', { info: 'i from NavBar' })
        })
    }
    .titleMode(NavigationTitleMode.Mini)
    .title(this.routerParams.title)
    .menus(this.menus)
    .toolbarConfiguration(this.toolbars)
    /*
     * 只能添加一次 navDestination 属性，
     * 属性值组件 作为 路由组件显示的容器
     * 每次导航传递的 name 和 param 都会传递到 navDestination 属性组件中
     * 在 自定义builder 函数组件中，根据路由名称 判断显示对应组件
     * 特点：不需要配置 router_map.json 到 module.json5中
     * */
    // .navDestination(this.NavDestinationBuilder)
    .height('100%')
    .width('100%')
  }
}
