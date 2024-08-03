import { IPayWantParams } from '@ohos/typesCommon'
import { common, OpenLinkOptions } from '@kit.AbilityKit'

const localStorage = LocalStorage.getShared()

@Entry()
@ComponentV2
struct PayPage {
  payInfo = localStorage.get('payInfo') as IPayWantParams;
  context = getContext(this) as common.UIAbilityContext

  build() {
    Column({ space: 20 }) {
      Text(`向ID为 ${this.payInfo.storeId ?? ''} 的商户，成功支付 ￥${this.payInfo.payAmount}`)
        .fontSize(25)
        .fontWeight(FontWeight.Bold)

      Button('完成')
        .onClick(() => {
          const abilityResult: common.AbilityResult = {
            resultCode: 0,
            want: {
              uri: this.payInfo.fromAbilityUri
            }
          }
          // this.context.openLink(this.payInfo.fromAbilityUri, linkOptions)
          this.context.terminateSelfWithResult(abilityResult)
        })
    }
    .height('100%')
    .width('100%')
  }
}