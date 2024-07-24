@Builder
// function ComponentOneBuilder(name: string, param: Record<string, string>) {
export function ComponentThreeBuilder() {
  ComponentThree()
}


@ComponentV2
struct ComponentThree {
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

        Button('clear 清空导航栈, 回到导航根容器').onClick((event: ClickEvent) => {
          this.pathStack.clear()
        })

        Button('push到ComponentOne组件').onClick((event: ClickEvent) => {
          // 参数不会传递到 ComponentOne
          // this.pathStack.popToName('ComponentOne', { info: 'this message is from popToName function which is used in ComponentThree' })

          this.pathStack.removeByName('ComponentOne')
          this.pathStack.pushDestinationByName('ComponentOne',
            { info: 'this message is from pushDestinationByName function which is used in ComponentThree' })
        })
      }
    }
    .title('ComponentThree')
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack
      this.name = context.pathInfo.name
      this.param = (context.pathInfo.param as Record<string, string>) || {}
    })
  }
}