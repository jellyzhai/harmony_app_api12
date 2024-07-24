import { router } from '@kit.ArkUI'

@ComponentV2
export struct PageHeader {
  @Param title: string = 'Page Title'
  @Param callbackBeforeBack: () => void = () => {}
  backArrow: string = String.fromCodePoint(0x2190)

  build() {
    Row({ space: 16 }) {
      Text(this.backArrow)
        .fontSize(20)
        .onClick(() => {
          this.callbackBeforeBack()
          router.back()
        })

      Text(this.title)
        .layoutWeight(1)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
    }
    .padding(8)
    .border({
      width: {
        bottom: 1
      },
      color: Color.Gray
    })
  }
}