import { RoutePagesInfo } from '../constants/pageTitleUrl';
import { PageHeader } from '../views/PageHeader';
import { mediaquery, promptAction } from '@kit.ArkUI';

@Entry
@ComponentV2
struct MediaQueryUsage {
  defaultTitle = RoutePagesInfo.find(item => item.url.includes('MediaQueryUsage'))?.title
  private xmScreenCondition = 'width <= 320vp'
  private smScreenCondition = '(width > 320vp) and (width <= 640vp)'
  private mdScreenCondition = '(width > 640vp) and (width <= 960vp)'
  private lgScreenCondition = '(width > 960vp)'
  private roundScreenCondition = 'round-screen: true'
  private landscapeScreenCondition = 'orientation: landscape'
  private darkModeCondition = 'dark-mode: true'
  private tabletDeviceCondition = 'device-type: tablet'
  @Local isXM: boolean = false;
  @Local isSM: boolean = false;
  @Local isMD: boolean = false;
  @Local isLG: boolean = false;
  @Local isRoundScreen: boolean = false;
  @Local isLandscape: boolean = false;
  @Local isDarkMode: boolean = false;
  @Local isTabletDevice: boolean = false;
  xmListener: mediaquery.MediaQueryListener = mediaquery.matchMediaSync(this.xmScreenCondition)
  smListener: mediaquery.MediaQueryListener = mediaquery.matchMediaSync(this.smScreenCondition)
  mdListener: mediaquery.MediaQueryListener = mediaquery.matchMediaSync(this.mdScreenCondition)
  lgListener: mediaquery.MediaQueryListener = mediaquery.matchMediaSync(this.lgScreenCondition)
  roundScreenListener: mediaquery.MediaQueryListener = mediaquery.matchMediaSync(this.roundScreenCondition)
  landscapeScreenListener: mediaquery.MediaQueryListener = mediaquery.matchMediaSync(this.landscapeScreenCondition)
  darkModeListener: mediaquery.MediaQueryListener = mediaquery.matchMediaSync(this.darkModeCondition)
  tabletDeviceListener: mediaquery.MediaQueryListener = mediaquery.matchMediaSync(this.tabletDeviceCondition)

  aboutToAppear(): void {
    this.landscapeScreenListener.on('change', (result: mediaquery.MediaQueryResult) => {
      promptAction.showToast({ message: '触发屏幕方向媒体查询' })
      this.isLandscape = result.matches
    })

    this.roundScreenListener.on('change', (result: mediaquery.MediaQueryResult) => {
      this.isRoundScreen = result.matches
    })

    this.lgListener.on('change', (result: mediaquery.MediaQueryResult) => {
      this.isLG = result.matches
    })

    this.mdListener.on('change', (result: mediaquery.MediaQueryResult) => {
      this.isMD = result.matches
    })

    this.smListener.on('change', (result: mediaquery.MediaQueryResult) => {
      this.isSM = result.matches
    })

    this.xmListener.on('change', (result: mediaquery.MediaQueryResult) => {
      this.isXM = result.matches
    })

    this.darkModeListener.on('change', (result: mediaquery.MediaQueryResult) => {
      this.isDarkMode = result.matches
    })

    this.tabletDeviceListener.on('change', (result: mediaquery.MediaQueryResult) => {
      this.isTabletDevice = result.matches
    })
  }

  aboutToDisappear(): void {
    this.landscapeScreenListener.off('change')
    this.roundScreenListener.off('change')
    this.lgListener.off('change')
    this.mdListener.off('change')
    this.smListener.off('change')
    this.xmListener.off('change')
    this.darkModeListener.off('change')
    this.tabletDeviceListener.off('change')
  }

  build() {
    Column({ space: 16 }) {
      PageHeader({ title: this.defaultTitle })

      Scroll() {
        Column({ space: 16 }) {
          Row() {
            Text('是横向屏幕:')
            Blank()
            Text(String(this.isLandscape))
              .fontColor(this.isLandscape ? Color.Orange : Color.Black)
          }
          .width('100%')

          Row() {
            Text('是圆形屏幕:')
            Blank()
            Text(String(this.isRoundScreen))
              .fontColor(this.isRoundScreen ? Color.Orange : Color.Black)
          }
          .width('100%')
          .backgroundColor('rgba(0,0,0,0.1)')
          .padding(8)
          .borderRadius(8)

          Row() {
            Text('是大屏幕:')
            Blank()
            Text(String(this.isLG))
              .fontColor(this.isLG ? Color.Orange : Color.Black)
          }
          .width('100%')

          Row() {
            Text('是中屏幕:')
            Blank()
            Text(String(this.isMD))
              .fontColor(this.isMD ? Color.Orange : Color.Black)
          }
          .width('100%')
          .backgroundColor('rgba(0,0,0,0.1)')
          .padding(8)
          .borderRadius(8)

          Row() {
            Text('是小屏幕:')
            Blank()
            Text(String(this.isSM))
              .fontColor(this.isSM ? Color.Orange : Color.Black)
          }
          .width('100%')

          Row() {
            Text('是超小屏幕:')
            Blank()
            Text(String(this.isXM))
              .fontColor(this.isXM ? Color.Orange : Color.Black)
          }
          .width('100%')
          .backgroundColor('rgba(0,0,0,0.1)')
          .padding(8)
          .borderRadius(8)

          Row() {
            Text('是深色模式:')
            Blank()
            Text(String(this.isDarkMode))
              .fontColor(this.isDarkMode ? Color.Orange : Color.Black)
          }
          .width('100%')

          Row() {
            Text('是平板设备:')
            Blank()
            Text(String(this.isTabletDevice))
              .fontColor(this.isTabletDevice ? Color.Orange : Color.Black)
          }
          .width('100%')
          .backgroundColor('rgba(0,0,0,0.1)')
          .padding(8)
          .borderRadius(8)
        }
        .width('100%')
        .padding(16)
        .backgroundColor(Color.White)
        .borderRadius(16)
      }
      .layoutWeight(1)
    }
    .height('100%')
    .width('100%')
    .padding(16)
    .backgroundColor('rgba(0,0,0,0.1)')
  }
}