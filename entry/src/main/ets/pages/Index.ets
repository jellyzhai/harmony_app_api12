import { IPageForIndex } from '../viewModels';
import { router } from '@kit.ArkUI';
import { RoutePagesInfo } from '../constants/pageTitleUrl';

@Entry
@ComponentV2
struct Index {
  pages: IPageForIndex[] = RoutePagesInfo;

  build() {
    Column() {
      Text('可滑动查看')
        .width('100%')
        .textAlign(TextAlign.Center)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .backgroundColor(Color.Transparent)

      Divider()
        .height(4)
        .backgroundColor(Color.Transparent)
        .margin({ top: 6, bottom: 6 })
        .shadow({
          radius: 24,
          offsetY: 22,
          color: Color.Gray,
          type: ShadowType.COLOR
        })

      List({ space: 16 }) {
        Repeat(this.pages)
          .each((data) => {
            ListItem() {
              Text((data.index ?? 0) + 1 + `. ${data.item.title}`)
                .fontSize(18)
                .fontColor(Color.Blue)
                .onClick(() => {
                  router.pushUrl({ url: data.item.url, params: { title: data.item.title } })
                })
            }
          })
      }
      .layoutWeight(1)
    }
    .padding(16)
    .height('100%')
    .width('100%')
  }
}