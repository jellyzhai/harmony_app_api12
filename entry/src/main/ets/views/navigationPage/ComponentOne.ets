// 跳转页面入口函数
@Builder
function ComponentOneBuilder() {
  ComponentOne()
}

@ComponentV2({ freezeWhenInactive: true })
struct ComponentOne {
  @Local name: string = ''
  @Local param: Record<string, string> = {}
  @Local pathStack: NavPathStack = new NavPathStack()
  @Local popComponentPathInfo: NavPathInfo = new NavPathInfo('', null)
  @Local popComponentReturnResult: Object | undefined = undefined

  @Computed
  get paramEntries() {
    return Object.entries(this.param || {})
  }

  build() {
    NavDestination() {
      Column({ space: 16 }) {
        Image($r('app.media.app_icon'))
          .width(35)
          .height(35)
          .geometryTransition('sharedId')

        Column({ space: 8 }) {
          Text('上一个组件调用路由压栈push方法传递的信息：')
            .fontSize(18)
            .fontWeight(FontWeight.Bold)

          Column() {
            Text('目的组件name: ')
              .fontWeight(FontWeight.Bold)
            Text(this.name ?? '没有名称数据')
          }

          Column() {
            Text('param: ')
              .fontWeight(FontWeight.Bold)
            Text(this.param ? JSON.stringify(this.param) : '没有参数')
          }
        }

        Column({ space: 8 }) {
          Text('上一个组件调用路由出栈pop / popToName方法传递的信息：')
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
          Column() {
            Text('popComponentPathInfo: ')
              .fontWeight(FontWeight.Bold)
            Text(this.popComponentPathInfo ? JSON.stringify(this.popComponentPathInfo) : '没有popComponentPathInfo数据')
          }

          Column() {
            Text('popComponentReturnResult: ')
              .fontWeight(FontWeight.Bold)
            Text(this.popComponentReturnResult ? JSON.stringify(this.popComponentReturnResult) :
              '没有popComponentReturnResult参数')
          }
        }

        Button() {
          Text('push到 ComponentOnTwo 组件，当ComponentTwo组件 弹出路由栈 并携带参数时，当前组件可以处理')
            .padding(16)
            .fontColor(Color.White)
        }
        .onClick(() => {
          this.pathStack.removeByName('ComponentTwo')

          animateTo({ duration: 500 }, () => {
            // 第3个 onPop 方法的参数，是当前组件到达目的组件后，目的组件弹出组件路由栈时，传递的参数
            this.pathStack.pushDestinationByName('ComponentTwo', { info: 'i from ComponentOne' },
              (popInfo: PopInfo) => {
                this.popComponentPathInfo = popInfo.info
                this.popComponentReturnResult = popInfo.result
              }, false)
          })
        })
      }
    }
    .title('ComponentOne')
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack
      this.name = context.pathInfo.name
      this.param = (context.pathInfo.param as Record<string, string>) || {}
    })
  }
}
