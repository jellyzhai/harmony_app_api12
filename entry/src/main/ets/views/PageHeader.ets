import { router } from '@kit.ArkUI'

@ComponentV2
export struct PageHeader {
  @Param title: string = 'Page Title'
  @Param callbackBeforeBack: () => void = () => {
  }
  backArrow: string = String.fromCodePoint(0x2190)

  build() {
    Stack() {
      Text(this.backArrow)
        .fontSize(20)
        .width('100%')
        .onClick(() => {
          this.callbackBeforeBack()
          router.back()
        })

      Text(this.title)
        .margin({ left: 28, right: 28 })
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .maxLines(3)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
    }
    .width('100%')
    .padding(8)
    .border({
      width: {
        bottom: 1
      },
      color: Color.Gray
    })
  }
}