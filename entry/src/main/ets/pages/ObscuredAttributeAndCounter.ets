import { RoutePagesInfo } from '../constants/pageTitleUrl';
import { PageHeader } from '../views/PageHeader';
import { JSON } from '@kit.ArkTS';

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
        Text('当前商品2件起拍，最多可拍19件:')

        /* 计数器的两端按钮的默认宽高为 32 vp */
        Counter() {
          Text(this.count.toString())
        }
        .enableInc(this.count < 19)
        .enableDec(this.count > 2)
        .onInc(() => {
          this.count++
        })
        .onDec(() => {
          this.count--
        })
        .onSizeChange((_, newvalue) => {
          console.log('test_tag onSizeChange newvalue', JSON.stringify(newvalue));
        })
        .gesture(
          LongPressGesture({ repeat: true, duration: 300 })
            // tag 设置Pinch手势标志，用于自定义手势判定时区分绑定的手势。
            // .tag('counter')
            .onAction(event => {
              // 点击处相对触发事件组件的X轴偏移距离
              const tapLocalX = event.fingerList[0].localX
              const targetCompWidth = event.target.area.width as number
              const incAreaTriggerWidth = targetCompWidth - 32

              if (tapLocalX < 32 && this.count > 2) {
                //   触发减法操作
                this.count--
              }
              if (tapLocalX > incAreaTriggerWidth && this.count < 19) {
                this.count++
              }
              // console.log('test_tag LongPressGesture event', JSON.stringify(event));
            })
        )
      }
    }
    .height('100%')
    .width('100%')
  }
}