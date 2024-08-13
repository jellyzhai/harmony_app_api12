import { IPageForIndex } from '../viewModels';
import { router } from '@kit.ArkUI';
import { RoutePagesInfo } from '../constants/pageTitleUrl';

@Entry
@ComponentV2
struct Index {
  pages: IPageForIndex[] = RoutePagesInfo;
  listMarginTop: number = 52

  build() {
    Stack({ alignContent: Alignment.Top }) {
      Text('可滑动查看')
        .height(this.listMarginTop)
        .width('110%')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .textAlign(TextAlign.Center)
        .backdropBlur(60)
        .zIndex(9)

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
            .margin({ top: data.index === 0 ? this.listMarginTop : 0 })
          })
      }
    }
    .padding({ right: 16, bottom: 16, left: 16 })
    .height('100%')
    .width('100%')
  }
}