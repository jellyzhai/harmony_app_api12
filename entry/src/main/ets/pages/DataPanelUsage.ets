import { RoutePagesInfo } from '../constants/pageTitleUrl';
import { PageHeader } from '../views/PageHeader';
import { DataPanelModifier } from '@kit.ArkUI';

// class MyDataPanelModifier extends DataPanelModifier implements ContentModifier<DataPanelConfiguration> {
//   applyContent(builder: (...args: [DataPanelConfiguration]) => void): WrappedBuilder<[DataPanelConfiguration]> {
//     return new WrappedBuilder(builder);
//   }
// }

@Entry
@ComponentV2
struct DataPanelUsage {
  defaultTitle = RoutePagesInfo.find(item => item.url.includes('DataPanelUsage'))?.title
  @Local numArr: number[] = [5, 7, 9, 11, 13, 15, 17, 19, 21];
  @Local colorArr: string[] = Array(7).fill(0).map((_: ESObject, i) => `rgba(0,0,255,0.${i + 1})`)
  @Local progressVal: number = 30;
  @Local contentModifier = new DataPanelModifier()

  build() {
    Column({ space: 16 }) {
      PageHeader({ title: this.defaultTitle })

      List({ space: 16 }) {
        ListItem() {
          Column() {
            Text() {
              SymbolSpan($r('sys.symbol.ohos_trash'))
                .fontSize(20)
            }
            Text('基本使用, 自定义最大值，数据个数最多9个')

            DataPanel({ values: this.numArr, max: 150 })
              .width(200)
              .height(200)
          }
          .padding(8)
          .borderRadius(8)
          .border({ width: 1 })
        }
        .width('100%')

        ListItem() {
          Column() {
            Text('自定义颜色, 颜色个数少于数值个数时，使用默认颜色填充')

            DataPanel({ values: this.numArr, max: 150 })
              .width(200)
              .height(200)
              .valueColors(this.colorArr)
              // 待确认使用方法
              // .contentModifier(this.contentModifier)


          }
          .padding(8)
          .borderRadius(8)
          .border({ width: 1 })
        }
        .width('100%')

        ListItem() {
          Column({ space: 16 }) {
            Text('线型数据面板')

            DataPanel({ values: this.numArr, max: 150, type: DataPanelType.Line })
              .width(250)
              .height(25)

            Text(`[${this.numArr.join(',  ')}]`)
          }
          .padding(8)
          .borderRadius(8)
          .border({ width: 1 })
        }
        .width('100%')

        ListItem() {
          Column() {
            Text('只有一个数据，显示进度')

            Stack() {
              DataPanel({ values: [this.progressVal], max: 100 })
                .width(200)
                .height(200)

              Text(`${this.progressVal}%`)
            }

            Row({ space: 16 }) {
              Button('减少')
                .onClick(() => {
                  if (this.progressVal > 0) {
                    this.progressVal--
                  }
                })

              Button('增加')
                .onClick(() => {
                  if (this.progressVal < 100) {
                    this.progressVal++
                  }
                })
            }
          }
          .padding(8)
          .borderRadius(8)
          .border({ width: 1 })
        }
        .width('100%')
      }
      .layoutWeight(1)
    }
    .height('100%')
    .width('100%')
  }
}