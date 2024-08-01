import { RouterParams } from '../viewModels/common';
import { PageHeader } from '../views/PageHeader';
import { router } from '@kit.ArkUI';

@Entry
@ComponentV2
struct ActionSheetOrListSelectDialog {
  @Local selectedFruit: string = ''
  routerParams = router.getParams() as RouterParams;
  fruits: string[] = ['苹果', '葡萄', '香蕉', '蟠桃', '菠萝', '椰子', '火龙果', '山足']
  sheets: SheetInfo[] = this.fruits.map(item => {
    return {
      title: item,
      action: () => {
        this.selectedFruit = item
      }
    } as SheetInfo
  })

  showListSelectionDialog() {
    ActionSheet.show({
      title: '水果列表',
      message: '请选择最喜欢的水果',
      // autoCancel: false,
      height: 200,
      sheets: this.sheets,
      // confirm: {
      //   value: '确认',
      //   action: () => {
      //     // this.selectedFruit = this.selectedTemporaryFruit
      //   }
      // }
    })
  }

  build() {
    Column({ space: 16 }) {
      PageHeader({ title: this.routerParams.title })

      Row() {
        Text('最喜欢的水果')

        Blank()

        Text() {
          Span(this.selectedFruit || '请选择')
          Span(String.fromCodePoint(9660))
            .fontSize(12)
        }
        .fruitText()
        .onClick(() => {
          this.showListSelectionDialog()
        })
      }
      .width('100%')
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

@Extend(Text)
function fruitText() {
  .padding(8)
  .backgroundColor('rgba(0,0,0,0.2)')
  .borderRadius(8)
}