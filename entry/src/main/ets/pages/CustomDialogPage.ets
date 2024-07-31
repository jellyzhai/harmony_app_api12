import { RouterParams } from '../viewModels/common';
import { PageHeader } from '../views/PageHeader';
import { router } from '@kit.ArkUI';

@Entry
@ComponentV2
struct CustomDialogPage {
  @Local enableNotify = true
  routerParams = router.getParams() as RouterParams;
  firstDialogController = new CustomDialogController({
    builder: FirstCustomDialog({
      secondDialogConfirm: () => {
        this.secondDialogConfirm()
      },
      firstDialogCancel: () => {
        this.firstDialogCancel()
      }
    }),
    autoCancel: false
  })

  secondDialogConfirm() {
    this.firstDialogController.close()
  }

  firstDialogCancel() {
    this.enableNotify = true
    this.firstDialogController.close()
  }

  build() {
    Column({ space: 16 }) {
      PageHeader({ title: this.routerParams.title })

      Row() {
        Text('通知')
          .fontSize(20)

        Blank()

        Toggle({ type: ToggleType.Checkbox, isOn: this.enableNotify })
          .onChange(isOn => {
            this.enableNotify = isOn
            if (!isOn) {
              this.firstDialogController.open()
            }
          })
      }
      .width('100%')
      .padding(16)
      .backgroundColor('rgba(0,0,0,0.1)')
      .borderRadius(10)
    }
    .height('100%')
    .width('100%')
    .padding(16)
  }
}

@CustomDialog
struct FirstCustomDialog {
  secondDialogConfirm?: () => void
  firstDialogCancel?: () => void
  secondDialogController = new CustomDialogController({
    builder: SecondCustomDialog({
      secondDialogConfirm: this.secondDialogConfirm,
      firstDialogCancel: this.firstDialogCancel,
    }),
    autoCancel: false
  })
  // 以下注释来自官方示例
  /*
   * 若尝试在CustomDialog中传入多个其他的Controller，
   * 以实现在CustomDialog中打开另一个或另一些CustomDialog，
   * 那么此处需要将指向自己的controller放在所有controller的后面
   * */
  firstDialogController?: CustomDialogController

  build() {
    Column({ space: 18 }) {
      Text('您将要取消通知，取消通知后，将不会再收到通知，确定要执行当前操作么？')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)

      Row() {
        Text('取消')
          .fontSize(18)
          .onClick(() => {
            this.firstDialogCancel?.()
          })

        Text('确认')
          .fontSize(18)
          .fontColor(Color.Red)
          .onClick(() => {
            this.secondDialogController.open()
          })
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceEvenly)
    }
    .padding(20)
  }
}

@CustomDialog
struct SecondCustomDialog {
  firstDialogCancel?: () => void
  secondDialogConfirm?: () => void
  secondDialogController?: CustomDialogController

  build() {
    Column({ space: 20 }) {
      Text('确定要取消通知么？')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)

      Row() {
        Text('取消')
          .fontSize(18)
          .onClick(() => {
            this.secondDialogController?.close()
            this.firstDialogCancel?.()
          })

        Text('确认')
          .fontSize(18)
          .fontColor(Color.Red)
          .onClick(() => {
            this.secondDialogController?.close()
            this.secondDialogConfirm?.()
          })
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceEvenly)
    }
    .padding(20)
  }
}