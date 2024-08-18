import { RoutePagesInfo } from '../constants/pageTitleUrl';
import { PageHeader } from '../views/PageHeader';

@Entry
@ComponentV2
struct SymbolSpanSymbolGlyph {
  defaultTitle = RoutePagesInfo.find(item => item.url.includes('SymbolSpanSymbolGlyph'))?.title
  @Local message: string = 'Hello World';

  build() {
    Column({ space: 16 }) {
      PageHeader({ title: this.defaultTitle })

      Column({ space: 16 }) {
        Text('SymbolSpan 组件只能在Text组件内使用, 只能显示symbol类型图标资源, 字体大小控制图标大小。')
        Text() {
          SymbolSpan($r('sys.symbol.checkmark_shield_fill'))
            .fontSize(80)
            .fontColor([Color.Green, Color.Pink])
            .effectStrategy(SymbolEffectStrategy.SCALE)
            .renderingStrategy(SymbolRenderingStrategy.MULTIPLE_COLOR)
        }
      }
      .padding(8)
      .backgroundColor('rgba(0,0,0,0.1)')
      .borderRadius(8)

      Column({ space: 16 }) {
        Text('SymbolGlyph 组件不能在Text组件内使用, 只能显示symbol类型图标资源, 字体大小控制图标大小。')
        SymbolGlyph($r('sys.symbol.checkmark_clipboard'))
          .fontSize(80)
          .backgroundColor(Color.White)
          .effectStrategy(SymbolEffectStrategy.HIERARCHICAL)
          .renderingStrategy(SymbolRenderingStrategy.MULTIPLE_OPACITY)

      }
      .padding(8)
      .backgroundColor('rgba(0,0,0,0.1)')
      .borderRadius(8)

      Column({ space: 16 }) {
        Text('在')
        Hyperlink('https://developer.huawei.com/consumer/cn/design/harmonyos-symbol/', '华为开发者联盟Symbol资源官网')
        Text('中，可以找到想要图标，在图标上复制名称使用')

        SymbolGlyph($r('sys.symbol.square_and_pencil_fill'))
          .fontSize(80)
          .fontWeight(FontWeight.Lighter)
          .effectStrategy(SymbolEffectStrategy.SCALE)
      }
      .padding(8)
      .backgroundColor('rgba(0,0,0,0.1)')
      .borderRadius(8)
    }
    .height('100%')
    .width('100%')
  }
}