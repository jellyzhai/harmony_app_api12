import Lottie from '@ohos/lottie';
import { RoutePagesInfo } from '../constants/pageTitleUrl';
import { PageHeader } from '../views/PageHeader';
import { common } from '@kit.AbilityKit';
import { fileIo } from '@kit.CoreFileKit';
import { JSON, util } from '@kit.ArkTS';

@Entry
@ComponentV2
struct ThirdPartLibUsageLottie {
  defaultTitle = RoutePagesInfo.find(item => item.url.includes('ThirdPartLibUsageLottie'))?.title
  private uiAbilityContext = getContext(this) as common.UIAbilityContext
  private contextSetting = new RenderingContextSettings()
  private renderingContext = new CanvasRenderingContext2D(this.contextSetting)
  private animationName = 'star'
  @Local lottieJsonObj: Object | null = null;

  onPageShow(): void {
    try {
      const fd = this.uiAbilityContext.resourceManager.getRawFdSync('lottie/starAnimation.json').fd
      const arrBuffer = new ArrayBuffer(fileIo.statSync(fd).size)
      fileIo.readSync(fd, arrBuffer)
      const textDecoder = util.TextDecoder.create('utf-8', { ignoreBOM: true })
      const strContent = textDecoder.decodeWithStream(new Uint8Array(arrBuffer), { stream: false })
      // 读取的字符串乱码内容少：PK 【待解决】
      console.log('test_tag strContent', strContent)
    } catch (e) {
      console.error('test_tag lottieJsonObj error', JSON.stringify(e))
    }
  }

  build() {
    Column({ space: 16 }) {
      PageHeader({ title: this.defaultTitle })

      Canvas(this.renderingContext)
        .width('336')
        .height('191')
        .backgroundImage($r('app.media.canvasBg'))
        .backgroundImageSize(ImageSize.Contain)
        .onReady(() => {
          Lottie.loadAnimation({
            name: this.animationName,
            container: this.renderingContext,
            renderer: 'canvas',
            path: 'resources/rawfile/lottie/starAnimation.json',
            loop: true,
            autoplay: true,
            frameRate: 30
          })
        })
        .onDisAppear(() => {
          Lottie.destroy(this.animationName)
        })

      Button('播放动画')
        .onClick(() => {
          Lottie.play(this.animationName)
        })

      Button('暂停动画')
        .onClick(() => {
          Lottie.pause(this.animationName)
        })

      Button('播放/暂停')
        .onClick(() => {
          Lottie.togglePause(this.animationName)
        })

      Button('停止动画')
        .onClick(() => {
          Lottie.stop(this.animationName)
        })
    }
    .height('100%')
    .width('100%')
  }
}