import { RoutePagesInfo } from '../constants/pageTitleUrl';
import { PageHeader } from '../views/PageHeader';
import { promptAction } from '@kit.ArkUI';

@Entry
@ComponentV2
struct BindSheetAttribute {
  defaultTitle = RoutePagesInfo.find(item => item.url.includes('BindSheetAttribute'))?.title
  @Local multiColumnTextCascadeContent: TextCascadePickerRangeContent[] = [
    {
      text: '北京',
      children: [
        {
          text: '昌平',
          children: [
            {
              text: '沙河'
            },
            {
              text: '十三陵'
            }
          ]
        }
      ]
    },
    {
      text: '郑州',
      children: [
        {
          text: '二七',
          children: [
            {
              text: '二七广场'
            },
            {
              text: '二七纪念塔'
            }
          ]
        },
        {
          text: '高新区',
          children: [
            {
              text: '北龙湖'
            },
            {
              text: '东龙湖'
            }
          ]
        }
      ]
    },
    {
      text: '长春',
      children: [
        {
          text: '净月',
          children: [
            {
              text: '东师大'
            },
            {
              text: '吉林财经'
            }
          ]
        }
      ]
    },
  ]
  private firstLayerAddr = this.multiColumnTextCascadeContent[0]
  private secondLayerAddr = this.firstLayerAddr.children?.[0]
  @Local selectedAddress: string =
    `${this.firstLayerAddr.text}-${this.secondLayerAddr?.text}-${this.secondLayerAddr?.children?.[0].text}`;
  @Local isShowSheet = false

  @Builder
  AddressBuilder() {
    TextPicker({ range: this.multiColumnTextCascadeContent })
      .height(160)
      .margin({ bottom: 50 })
      .onChange(value => {
        this.selectedAddress = (value as string[]).join('-')
      })
  }

  build() {
    Column({ space: 16 }) {
      PageHeader({ title: this.defaultTitle })

      Column() {
        Row() {
          Text('地址')

          Blank()

          Text() {
            Span(this.selectedAddress)
            Span(' ▼')
              .fontSize(12)
          }
          .onClick(() => {
            this.isShowSheet = true
          })
          .bindSheet(this.isShowSheet!!, this.AddressBuilder(), {
            title: { title: '请选择' },
            height: SheetSize.FIT_CONTENT,
            preferType: SheetType.BOTTOM,
            onWillDismiss: (data: DismissSheetAction) => {
              promptAction.showToast({ message: data.reason.toString() })
              // data.dismiss()
            },
            onDisappear: () => {
              this.isShowSheet = !this.isShowSheet
            }
          })
        }
        .width('100%')
        .padding(16)
        .backgroundColor('rgba(0,0,0,0.1)')
        .borderRadius(16)
      }
      .padding(16)
      .layoutWeight(1)
    }
    .height('100%')
    .width('100%')
  }
}