import { common, OpenLinkOptions } from '@kit.AbilityKit';
import { JSON } from '@kit.ArkTS';
import { IPayWantParams } from '@ohos/typesCommon'
import { router } from '@kit.ArkUI';
import { PageHeader } from '../views/PageHeader';
import { RouterParams } from '../viewModels/common';
import { RoutePagesInfo } from '../constants/pageTitleUrl';

@Entry
@ComponentV2
struct StartAbilitySpecifiedPage {
  routerParams = router.getParams() as (RouterParams | IPayWantParams);
  defaultTitle = RoutePagesInfo.find(item => item.url.includes('StartAbilitySpecifiedPage'))?.title
  context = getContext(this) as common.UIAbilityContext
  storeId: string = '202408021802'
  payAmount: number = 100
  message: string = '启动其他模块Ability进入指定页面,完成操作后返回数据'
  targetPageUrl: string = 'pages/PayPage'
  fromPageUrl: string = 'pages/StartAbilitySpecifiedPage'
  @Local isPaySuccess: boolean = false

  build() {
    Column({ space: 16 }) {
      PageHeader({ title: this.defaultTitle })

      Button(this.message)
        .onClick(() => {
          const appLink = 'http://harmony_app_api12.example.com/pay'
          const linkOptions: OpenLinkOptions = {
            parameters: {
              payInfo: {
                fromAbilityUri: 'http://harmony_app_api12.example.com/entry',
                fromPageUrl: this.fromPageUrl,
                storeId: this.storeId,
                payAmount: this.payAmount,
                targetPageUrl: this.targetPageUrl
              }
            }
          }

          this.context.openLink(appLink, linkOptions, (err, abilityResult) => {
            if (err) {
              console.error('StartAbilitySpecifiedPage  this.context.openLink 获取返回的abilityResult失败：',
                JSON.stringify(err))
              return
            }
            this.isPaySuccess = abilityResult?.resultCode === 0
          })
        })

      if (this.isPaySuccess) {
        Text('支付成功，这里显示支付成功后的订单信息:')
          .fontSize(20)

        Column() {
          Text('订单Id: ' + this.storeId)
            .fontSize(20)
            .fontColor(Color.Green)

          Text('订单金额: ' + this.payAmount)
            .fontSize(20)
            .fontColor(Color.Green)
        }
      }
    }
    .height('100%')
    .width('100%')
  }
}