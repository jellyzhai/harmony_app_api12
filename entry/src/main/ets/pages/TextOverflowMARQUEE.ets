import { RoutePagesInfo } from '../constants/pageTitleUrl';
import { PageHeader } from '../views/PageHeader';

@Entry
@ComponentV2
struct TextOverflowMARQUEE {
  defaultTitle = RoutePagesInfo.find(item => item.url.includes('TextOverflowMARQUEE'))?.title
  @Local message: string = 'Hello World 现在时间是' + new Date().toLocaleString();

  build() {
    Column({ space: 16 }) {
      PageHeader({ title: this.defaultTitle })

      Text(this.message)
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
        .width('100%')
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.MARQUEE })
        .padding(16)
        .backgroundColor(Color.Black)
        .foregroundColor(Color.Orange)
    }
    .height('100%')
    .width('100%')
  }
}