import { RoutePagesInfo } from '../constants/pageTitleUrl';
import { PageHeader } from '../views/PageHeader';

@Entry
@ComponentV2
struct ObscuredAttributeAndCounter {
  defaultTitle = RoutePagesInfo.find(item => item.url.includes('ObscuredAttributeAndCounter'))?.title
  @Local count: number = 2;

  build() {
    Column({ space: 16 }) {
      PageHeader({ title: this.defaultTitle })

      Column({ space: 8 }) {
        Text('以下文本组件使用了 obscured 属性，文本被遮罩')

        Text('隐私文本。。。')
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .obscured([ObscuredReasons.PLACEHOLDER])
      }

      Row({ space: 8 }) {
        Text('当前商品2件起拍，最多可拍9件:')

        Counter() {
          Text(this.count.toString())
        }
        .enableInc(this.count < 9)
        .enableDec(this.count > 2)
        .onInc(() => {
          this.count++
        })
        .onDec(() => {
          this.count--
        })
      }
    }
    .height('100%')
    .width('100%')
  }
}