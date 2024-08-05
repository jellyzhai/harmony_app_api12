import { router } from '@kit.ArkUI'

@Entry
@ComponentV2
export struct Login {
  textUserName = '用户名'
  textUserNamePlaceholder = '请输入用户名'
  textPassword = '密码'
  textPasswordPlaceholder = '请输入密码'
  textLogin = '登录'
  fromPageUrl: string | undefined = (router.getParams() as Record<'fromPageUrl', string>)?.fromPageUrl
  @Local username: string = ''
  @Local password: string = ''

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
            router.replaceUrl({
              url: this.fromPageUrl,
              params: {
                username: this.username,
                password: this.password
              }
            })
          } else {
            router.back()
          }

          // 这种方式跳转过去拿不到参数信息
          /*if (this.fromPageUrl) {
            router.back({
              url: this.fromPageUrl,
              params: {
                username: this.username,
                password: this.password
              }
            })
          }*/
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
  }
}