import { RoutePagesInfo } from '../constants/pageTitleUrl';
import { PageHeader } from '../views/PageHeader';
import { curves, promptAction } from '@kit.ArkUI';

@Entry
@ComponentV2
struct BindContentCoverUsage {
  defaultTitle = RoutePagesInfo.find(item => item.url.includes('BindContentCoverUsage'))?.title
  private initImageScale: number = 1
  private initImageAngle: number = 0
  @Local message: string = '点击图片可全屏查看';
  @Local isShowFullModal: boolean = false
  @Local imageScale: number = 1
  @Local imageAngle: number = 0
  fj1ImgUrl: Resource = $r('app.media.fj1');

  toggleFullScreen() {
    this.isShowFullModal = !this.isShowFullModal
  }

  @Builder
  ImageBuilder() {
    RelativeContainer() {
      Row() {
        Text('可旋转缩放')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)

        Text('×')
          .fontSize(25)
          .fontColor(Color.White)
          .textAlign(TextAlign.Center)
          .width(30)
          .height(30)
          .lineHeight(30)
          .borderRadius(15)
          .backgroundColor('rgba(0,0,0,0.3)')
          .onClick(() => {
            this.toggleFullScreen()
          })
      }
      .id('row')
      .width('100%')
      .padding(20)
      .justifyContent(FlexAlign.SpaceBetween)

      // .geometryTransition('fullScreenImage', { follow: true }) 是组件过度，sharedTransition 是页面过度
      Image(this.fj1ImgUrl)
        .id('image')
        .alignRules({
          // 外层位置key, 表示自身内部的 上中下 左中右
          center: {
            anchor: '__container__',
            // 里面对齐方式，是相对锚点的位置
            align: VerticalAlign.Center
          }
        })
        .width('100%')
        .alignSelf(ItemAlign.Center)
        .scale({ x: this.imageScale, y: this.imageScale })
        .rotate({ angle: this.imageAngle })
        .gesture(
          // 当多个手势事件，同时作用于一个组件时，在手势绑定方法中，使用GestureGroup方法包裹
          GestureGroup(
            GestureMode.Parallel,
            PinchGesture()
              .onActionUpdate((event: GestureEvent) => {
                this.imageScale = event.scale
              }),
            RotationGesture()
              .onActionUpdate(event => {
                // 垂直0点方向为 0°，顺时针正数，到6点方向为180°；
                // 垂直0点方向为 0°，逆时针负数，到6点方向为-180°；
                console.log('test_tag RotationGesture event.angle', event.angle.toString())
                this.imageAngle = event.angle
              })
          )
        )
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.White)
    .padding({ top: 30 })
  }

  build() {
    Column({ space: 16 }) {
      PageHeader({ title: this.defaultTitle })

      Text(this.message)
        .fontSize(18)

      Image(this.fj1ImgUrl)
        .width(200)// .geometryTransition('fullScreenImage', { follow: true })
        .onClick(() => {
          this.toggleFullScreen()
        })
        .bindContentCover(this.isShowFullModal!!, this.ImageBuilder(), {
          // modalTransition: ModalTransition.ALPHA,
          transition: TransitionEffect.OPACITY.combine(TransitionEffect.scale({ x: 0, y: 0 }))
            .animation({ duration: 300, curve: curves.springMotion() }),
          /*
           * 定义了当前函数，且不在函数内手动关闭模态框，用户无法关闭
           * 可根据 回调函数参数中的 data.reason 判断，是否能关闭
           * */
          onWillDismiss: (data: DismissContentCoverAction) => {
            this.toggleFullScreen()
            promptAction.showToast({ message: data.reason.toString() })
          },
          onDisappear: () => {
            this.imageScale = this.initImageScale
            this.imageAngle = this.initImageAngle
          }
        })
    }
    .height('100%')
    .width('100%')
  }
}