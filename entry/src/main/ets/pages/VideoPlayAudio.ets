import { RoutePagesInfo } from '../constants/pageTitleUrl'
import { PageHeader } from '../views/PageHeader'

@Entry
@ComponentV2
struct VideoPlayAudio {
  defaultTitle = RoutePagesInfo.find(item => item.url.includes('VideoPlayAudio'))?.title
  @Local videoSrc: Resource = $rawfile('soft-music.mp3')
  @Local previewUri: Resource = $r('app.media.fj2')
  @Local showControls: boolean = true
  controller: VideoController = new VideoController()
  config: ImageAnalyzerConfig = {
    types: [ImageAnalyzerType.SUBJECT, ImageAnalyzerType.TEXT]
  }
  private aiController: ImageAnalyzerController = new ImageAnalyzerController()
  private options: ImageAIOptions = {
    types: [ImageAnalyzerType.SUBJECT, ImageAnalyzerType.TEXT],
    aiController: this.aiController
  }

  build() {
    Column({ space: 16 }) {
      PageHeader({ title: this.defaultTitle })

      Text('视频窗口在资源播放后中，最大化后，显示黑窗口，最小化后也一样(待解决)')

      Video({
        src: this.videoSrc,
        previewUri: this.previewUri
      })
        .width(320)
        .height(180)
        .controls(true)

      Video({
        src: this.videoSrc,
        previewUri: this.previewUri,
        controller: this.controller,
        imageAIOptions: this.options
      })
        .width(320)
        .height(180)
        .controls(false)
        .enableAnalyzer(true)
        .analyzerConfig(this.config)
        .onStart(() => {
          console.info('onStart')
        })
        .onPause(() => {
          console.info('onPause')
        })

      Row() {
        Button('start').onClick(() => {
          this.controller.start() // 开始播放
        }).margin(5)
        Button('pause').onClick(() => {
          this.controller.pause() // 暂停播放
        }).margin(5)
        Button('getTypes').onClick(() => {
          this.aiController.getImageAnalyzerSupportTypes()
        }).margin(5)
      }
    }
    .width('100%')
    .height('100%')
  }
}