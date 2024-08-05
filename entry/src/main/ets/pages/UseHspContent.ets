import { PageHeader } from '../views/PageHeader';
import { router } from '@kit.ArkUI';
import { RouterParams } from '../viewModels/common';
import { getFibonacciArrBySum, ILogin, ResourceManagerHSP1 } from 'hsp1';
import { UseHspContentPageTitle } from '../constants/title';

@Entry
@ComponentV2
struct UseHspContent {
  private routerParams = router.getParams() as (RouterParams | ILogin);
  fibonacciArr = getFibonacciArrBySum(3000)
  loginUrl = '@bundle:com.example.harmony_app_api12/hsp1/ets/pages/Login'
  currentPageUrl = 'pages/UseHspContent'
  @Local poemTextWidth = 16

  build() {
    Column({ space: 16 }) {
      PageHeader({ title: (this.routerParams as RouterParams).title || UseHspContentPageTitle })

      Column({ space: 16 }) {
        Text(ResourceManagerHSP1.getStringByName('poem_from_mao'))
          .fontSize(20)
          .fontColor(ResourceManagerHSP1.getColorByName('gold'))
          .fontWeight(FontWeight.Bold)
          .textShadow({
            radius: 8,
            // offsetY: -4,
            type: ShadowType.BLUR,
            fill: true
          })
          .onSizeChange((_, newValue) => {
            this.poemTextWidth = newValue.width as number
          })

        Text('——毛泽东')
          .fontSize(18)
          .width(this.poemTextWidth)
          .textAlign(TextAlign.End)
          .fontWeight(FontWeight.Bold)
          .padding({ right: 8 })
      }

      Image(ResourceManagerHSP1.getRawfileByName('startIcon.png'))
        .width(64)

      Text('数组项之和小于3000的斐波那契数列：\n' + this.fibonacciArr.toString())
        .wordBreak(WordBreak.BREAK_WORD)

      Button('跳转到HSP的登录页面')
        .onClick(() => {
          router.pushUrl({ url: this.loginUrl, params: { fromPageUrl: this.currentPageUrl } })
        })

      Text() {
        Span('来自登录页的信息：\n')
        if ((this.routerParams as ILogin).username) {
          Span(JSON.stringify(this.routerParams))
        }
      }
    }
    .height('100%')
    .width('100%')
    .backgroundColor('rgba(0,0,0,0.1)')
    .padding(16)
  }
}