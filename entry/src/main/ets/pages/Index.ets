import { IPageForIndex } from '../viewModels';
import { router } from '@kit.ArkUI';
import { RoutePagesInfo } from '../constants/pageTitleUrl';

@Entry
@ComponentV2
struct Index {
  pages: IPageForIndex[] = RoutePagesInfo;

  build() {
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
    .padding(20)
    .height('100%')
    .width('100%')
  }
}