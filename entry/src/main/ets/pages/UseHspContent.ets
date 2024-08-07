import { PageHeader } from '../views/PageHeader';
import { router } from '@kit.ArkUI';
import { RouterParams } from '../viewModels/common';
import { getFibonacciArrBySum, ILogin, ResourceManagerHSP1 } from 'hsp1';
import { RoutePagesInfo } from '../constants/pageTitleUrl';

// 使用明明路由跳转前，需要先引入HSP中的页面
import 'hsp1/ets/pages/Login'

@Entry({ routeName: 'useHspContentPage' })
@ComponentV2
struct UseHspContent {
  private routerParams = router.getParams() as (RouterParams | ILogin);
  defaultTitle = RoutePagesInfo.find(item => item.url.includes('UseHspContent'))?.title
  fibonacciArr = getFibonacciArrBySum(3000)
  loginUrl = '@bundle:com.example.harmony_app_api12/hsp1/ets/pages/Login'
  loginPageName = 'appLogin'
  currentPageUrl = 'pages/UseHspContent'
  currentPagePage = 'useHspContentPage'
  isEnterStack = true
  @Local poemTextWidth = 16
  @Local pageTranslateX: number | string = 0

  onPageShow(): void {
    console.log('test_tag onPageShow this.routerParams', JSON.stringify(this.routerParams))
    animateTo(
      { duration: 200, curve: Curve.Smooth },
      () => {
        this.pageTranslateX = 0
      })
  }

  onPageHide(): void {
    if (this.isEnterStack) {
      animateTo(
        { duration: 300, curve: Curve.Smooth },
        () => {
          this.pageTranslateX = '-100%'
        }
      )
    }
  }

  build() {
    Column({ space: 16 }) {
      PageHeader({
        title: this.defaultTitle,
        callbackBeforeBack: () => {
          this.isEnterStack = false
        }
      })

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

      Button('使用路由页面路径跳转到HSP的登录页')
        .onClick(() => {
          router.pushUrl({ url: this.loginUrl, params: { fromPageUrl: this.currentPageUrl } }, router.RouterMode.Single)
        })

      Button('使用路由页面命名跳转到HSP的登录页')
        .onClick(() => {
          router.pushNamedRoute({ name: this.loginPageName, params: { fromPageName: this.currentPagePage } },
            router.RouterMode.Single)
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
    .translate({ x: this.pageTranslateX })
  }
}