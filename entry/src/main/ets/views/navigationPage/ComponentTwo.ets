import { MyCustomComponent } from './MyCustomComponent'
import { router } from '@kit.ArkUI'

@Builder
// function ComponentOneBuilder(name: string, param: Record<string, string>) {
export function ComponentTwoBuilder() {
  ComponentTwo()
}


@ComponentV2
struct ComponentTwo {
  @Local name: string = ''
  @Local param: Record<string, string> | undefined = undefined
  pathStack: NavPathStack = new NavPathStack()

  @Computed
  get paramEntries() {
    return Object.entries(this.param ?? {})
  }

  build() {
    NavDestination() {
      Column({ space: 16 }) {
        Column({ space: 8 }) {
          Text('上一个组件调用路由压栈push方法传递的信息：')
            .fontSize(18)
            .fontWeight(FontWeight.Bold)

          Column() {
            Text('目的组件name: ')
              .fontWeight(FontWeight.Bold)
            Text(this.name || '没有名称数据')
          }

          Column() {
            Text('param: ')
              .fontWeight(FontWeight.Bold)
            Text(this.param ? JSON.stringify(this.param) : '没有参数')
          }
        }

        Button('pop返回到上一个组件').onClick((event: ClickEvent) => {
          animateTo({ duration: 500 }, () => {
            this.pathStack.pop({ info: 'this message is from pop function which is used in ComponentTwo' }, false)
          })
        })

        Button('push到ComponentThree组件').onClick((event: ClickEvent) => {
          this.pathStack.removeByName('ComponentThree')
          this.pathStack.pushDestinationByName('ComponentThree', { info: 'hi, i am from ComponentTwo' })
        })

        Image($r('app.media.app_icon'))
          .width(35)
          .height(35)
          .geometryTransition('sharedId')

        MyCustomComponent()
      }
    }
    .title('ComponentTwo')
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack
      this.name = context.pathInfo.name
      this.param = (context.pathInfo.param as Record<string, string>) || {}
    })
  }
}