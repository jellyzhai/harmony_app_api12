import { RoutePagesInfo } from '../constants/pageTitleUrl';
import { PageHeader } from '../views/PageHeader';
import { curves } from '@kit.ArkUI';

@Entry
@ComponentV2
struct ProgressMaskAttributeUsage {
  defaultTitle = RoutePagesInfo.find(item => item.url.includes('ProgressMaskAttributeUsage'))?.title
  @Local progressflag1: boolean = true;
  initColor: Color = Color.Gray;
  @Local color: Color = this.initColor;
  initValue: number = 10.0;
  @Local value: number = this.initValue;
  @Local enableBreathingAnimation: boolean = false;
  initProgressMask: ProgressMask = new ProgressMask(this.initValue, 100, this.initColor);
  @Local progressMask: ProgressMask = this.initProgressMask;

  aboutToAppear(): void {
    this.progressMask.enableBreathingAnimation(true)
  }

  build() {
    Column({ space: 16 }) {
      PageHeader({ title: this.defaultTitle })

      Column({ space: 15 }) {
        Text('progress mask').fontSize(12).width('75%')

        // 给图片添加了一个280px*280px的进度遮罩
        Image($r('app.media.startIcon'))
          .width('500px').height('280px')
          .mask(this.progressMask)
          .animation({
            duration: 2000, // 动画时长
            curve: curves.springMotion(), // 动画曲线
            delay: 0, // 动画延迟
            iterations: 1, // 播放次数
            playMode: PlayMode.Normal // 动画模式
          }) // 对Button组件的宽高属性进行动画配置

        // 更新进度遮罩的进度值
        Button('updateProgress')
          .width(200).height(50).margin(20)
          .onClick((event?: ClickEvent) => {
            this.value += 20;
            // this.progress.updateProgress(this.value);
            this.progressMask = new ProgressMask(this.value, 100, this.color);
          })

        // 更新进度遮罩的颜色
        Button('updateColor')
          .onClick((event?: ClickEvent) => {
            if (this.progressflag1) {
              this.color = 0x9fff0000
              const mask = new ProgressMask(this.value, 100, this.color);
              this.progressMask = mask;
            } else {
              this.color = 0x9f0000ff
              const mask = new ProgressMask(this.value, 100, this.color);
              this.progressMask = mask;
            }
            this.progressflag1 = !this.progressflag1
          }).width(200).height(50).margin(20)

        // 开关呼吸光晕动画
        Button('enableBreathingAnimation:' + this.enableBreathingAnimation).height(50).margin(20)
          .onClick((event?: ClickEvent) => {
            this.enableBreathingAnimation = !this.enableBreathingAnimation
            const mask = new ProgressMask(this.value, 100, this.color);
            mask.enableBreathingAnimation(this.enableBreathingAnimation);
            this.progressMask = mask;
          })
      }
      .width('100%')
      .margin({ top: 15 })
    }
    .height('100%')
    .width('100%')
  }
}