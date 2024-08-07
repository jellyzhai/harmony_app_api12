import { router } from '@kit.ArkUI'

@Entry({ routeName: 'appLogin' })
@ComponentV2
export struct Login {
  textUserName = '用户名'
  textUserNamePlaceholder = '请输入用户名'
  textPassword = '密码'
  textPasswordPlaceholder = '请输入密码'
  textLogin = '登录'
  fromPageUrl: string | undefined = (router.getParams() as Record<'fromPageUrl', string>)?.fromPageUrl
  fromPageName: string | undefined = (router.getParams() as Record<'fromPageName', string>)?.fromPageName
  @Local username: string = ''
  @Local password: string = ''
  @Local pageTranslateX: number | string = 0

  @Builder
  LabelBuilder(text: string) {
    Text(text)
      .fontSize(20)
      .constraintSize({ minWidth: 80 })
  }

  build() {
    Column({ space: 24 }) {
      Row() {
        this.LabelBuilder(this.textUserName)

        TextInput({ placeholder: this.textUserNamePlaceholder })
          .layoutWeight(1)
          .onChange(value => {
            this.username = value.trim()
          })
      }
      .width('100%')

      Row() {
        this.LabelBuilder(this.textPassword)

        TextInput({ placeholder: this.textUserNamePlaceholder })
          .type(InputType.Password)
          .layoutWeight(1)
          .onChange(value => {
            this.password = value.trim()
          })
      }
      .width('100%')

      Button(this.textLogin)
        .enabled(!!this.username && !!this.password)
        .backgroundColor('rgba(255,0,0,0.65)')
        .width(200)
        .fontSize(20)
        .onClick(() => {
            if (this.fromPageUrl) {
              router.back({
                url: this.fromPageUrl,
                params: {
                  username: this.username,
                  password: this.password
                }
              })
              // 这里不能使用路由的单例模式，否则，会从路由栈中把已存在的路由移动到栈顶，导致当前路由数据丢失
              // }, router.RouterMode.Single)
            } else if (this.fromPageName) {
              router.replaceNamedRoute({
                name: this.fromPageName,
                params: {
                  username: this.username,
                  password: this.password
                }
              })
            } else {
              router.back()
            }
        })
    }
    .width('100%')
    .height('100%')
    .padding({ left: 24, right: 24 })
    .justifyContent(FlexAlign.Center)
    .linearGradient({
      direction: GradientDirection.RightBottom,
      colors: [['rgba(255,0,0,0.1)', 0.33], ['rgba(255,0,0,0.2)', 0.66], ['rgba(255,0,0,0.3)', 1]]
    })
    .translate({ x: this.pageTranslateX })
  }
}