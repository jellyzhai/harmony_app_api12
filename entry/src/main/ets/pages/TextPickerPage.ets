import { JSON } from '@kit.ArkTS';
import { PageHeader } from '../views/PageHeader';
import { RouterParams } from '../viewModels/common';
import { router } from '@kit.ArkUI';
import { RoutePagesInfo } from '../constants/pageTitleUrl';

@Entry
@ComponentV2
struct TextPickerPage {
  routerParams = router.getParams() as RouterParams;
  defaultTitle = RoutePagesInfo.find(item => item.url.includes('TextPickerPage'))?.title
  private singleSelectedTextColor: Color = Color.Green
  @Local textFruits: string[] = ['0-peach', '1-apple', '2-pear', '3-orange', '4-banana'];
  @Local singleSelectedIndex: number = 2
  @Local singleSelectedValue: string = this.textFruits[this.singleSelectedIndex]
  @Local singleIconTextSelectedValue: string = ''
  @Local iconTextFruits: TextPickerRangeContent[] = [
    'peach', 'apple', 'pear', 'orange', 'banana'
  ].map(item => ({
    icon: $r(`app.media.${item}`),
    text: item
  } as TextPickerRangeContent))
  @Local firstIconTextSelectedIndex = 0
  @Local secondIconTextSelectedIndex = 1
  @Local thirdIconTextSelectedIndex = 2
  private raffleInitTimes = 5
  @Local raffleTimes = this.raffleInitTimes
  @Local raffleInProgress = false
  @Local multiColumnText: string[][] = [
    ['2020年', '2021年', '2022年', '2023年', '2024年'],
    ['1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月']
  ];
  @Local multiColumnTextSelectedValues: string[] = []
  @Local multiColumnTextSelectedIndex: number[] = []
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
  @Local multiColumnTextCascadeSelectedValue: string[] = []
  @Local multiColumnTextCascadeSelectedIndex: number[] = []

  build() {
    Column({ space: 16 }) {
      PageHeader({ title: this.defaultTitle })

      Scroll() {
        Column({ space: 20 }) {
          Column({ space: 16 }) {
            Row() {
              Text('单列文本选择器：')
              // TextPicker({ range: this.textFruits, selected: this.singleSelectedIndex })
              TextPicker({ range: this.textFruits })
                .textPickerStyle(this.singleSelectedTextColor)
                .selectedIndex(this.singleSelectedIndex)
                .onChange((value, index) => {
                  this.singleSelectedValue = value as string
                  this.singleSelectedIndex = index as number
                })

            }

            Row({ space: 16 }) {
              Column() {
                Text() {
                  Span('已选择索引：')
                  Span(this.singleSelectedIndex.toString())
                    .spanSelectedStyle(this.singleSelectedTextColor)
                }

                Text() {
                  Span('已选择值：')
                  Span(this.singleSelectedValue)
                    .spanSelectedStyle(this.singleSelectedTextColor)
                }
              }

              Button('循环增加')
                .onClick(() => {
                  this.singleSelectedIndex = ++this.singleSelectedIndex > 4 ? 0 : this.singleSelectedIndex
                })
              /*Text('改变已选择的索引')
            TextInput({ placeholder: '输入索引值' })
              .type(InputType.Number)
              .onChange(value => {
                this.singleSelectedIndex = Number(value)
              })*/
            }
          }
          .cardColumnStyle()

          Column({ space: 16 }) {
            Row() {
              Text('单列图片文本选择器：')
              TextPicker({ range: this.iconTextFruits })
                .textPickerStyle(this.singleSelectedTextColor)
                .onChange((value) => {
                  // value 只是文本值，不包括图片信息
                  this.singleIconTextSelectedValue = value as string
                })

            }

            Text() {
              Span('已选择值：')
              Span(this.singleIconTextSelectedValue)
                .fontColor(this.singleSelectedTextColor)
                .fontSize(18)
                .fontWeight(FontWeight.Bold)
            }
          }
          .cardColumnStyle()

          Column({ space: 16 }) {
            Text('多列图片文本选择器：')

            Row() {
              TextPicker({ range: this.iconTextFruits, selected: this.firstIconTextSelectedIndex })
                .textPickerStyle(this.singleSelectedTextColor)


              TextPicker({ range: this.iconTextFruits, selected: this.secondIconTextSelectedIndex })
                .textPickerStyle(this.singleSelectedTextColor)

              TextPicker({ range: this.iconTextFruits, selected: this.thirdIconTextSelectedIndex })
                .textPickerStyle(this.singleSelectedTextColor)
            }

            if (!this.raffleInProgress && this.firstIconTextSelectedIndex === this.secondIconTextSelectedIndex &&
              this.firstIconTextSelectedIndex === this.thirdIconTextSelectedIndex) {
              Text('恭喜你中奖了！')
                .fontColor(Color.Orange)
                .fontSize(20)
                .fontWeight(FontWeight.Bold)
            } else {
              Text('继续加油！')
                .fontSize(20)
                .fontWeight(FontWeight.Bold)
            }

            Row({ space: 8 }) {
              Button('重置抽奖次数')
                .onClick(() => {
                  this.raffleTimes = this.raffleInitTimes
                })

              Text('抽奖次数还剩' + this.raffleTimes)

              Button('抽奖')
                .enabled(this.raffleTimes > 0 && !this.raffleInProgress)
                .onClick(() => {
                  this.raffleInProgress = true

                  const firstRandomLengthArr: number[] =
                    Array(this.iconTextFruits.length + getRandom(this.iconTextFruits.length)).fill(0);
                  firstRandomLengthArr
                    .forEach((_, index) => {
                      setTimeout(() => {
                        this.firstIconTextSelectedIndex =
                          getCycleIndex(this.firstIconTextSelectedIndex, this.iconTextFruits.length - 1)
                      }, (index + 1) * 200)
                    })

                  const secondRandomLengthArr: number[] =
                    Array(this.iconTextFruits.length + getRandom(this.iconTextFruits.length)).fill(0);
                  secondRandomLengthArr.forEach((_, index) => {
                    setTimeout(() => {
                      this.secondIconTextSelectedIndex =
                        getCycleIndex(this.secondIconTextSelectedIndex, this.iconTextFruits.length - 1)
                    }, (index + 1) * 200)
                  })

                  const thirdRandomLengthArr: number[] =
                    Array(this.iconTextFruits.length + getRandom(this.iconTextFruits.length)).fill(0);
                  thirdRandomLengthArr.forEach((_, index) => {
                    setTimeout(() => {
                      this.thirdIconTextSelectedIndex =
                        getCycleIndex(this.thirdIconTextSelectedIndex, this.iconTextFruits.length - 1)
                    }, (index + 1) * 200)
                  })

                  setTimeout(() => {
                    this.raffleInProgress = false
                  }, Math.max(firstRandomLengthArr.length, secondRandomLengthArr.length, thirdRandomLengthArr.length) *
                    200)

                  this.raffleTimes--
                })
            }
          }
          .cardColumnStyle()

          Column({ space: 16 }) {
            Text('多列文本选择器(列之间无从属关系)：')

            Row() {
              TextPicker({ range: this.multiColumnText })
                .textPickerStyle(this.singleSelectedTextColor)
                .onChange((value, index) => {
                  this.multiColumnTextSelectedValues = value as string[]
                  this.multiColumnTextSelectedIndex = index as number[]
                })
            }

            Row({ space: 16 }) {
              Column() {
                Text() {
                  Span('已选择索引：')
                  Span(JSON.stringify(this.multiColumnTextSelectedIndex))
                    .spanSelectedStyle(this.singleSelectedTextColor)
                }

                Text() {
                  Span('已选择值：')
                  Span(JSON.stringify(this.multiColumnTextSelectedValues))
                    .spanSelectedStyle(this.singleSelectedTextColor)
                }
              }
            }
          }
          .cardColumnStyle()

          Column({ space: 16 }) {
            Text('多列级联文本选择器(列之间有从属关系)：')

            Row() {
              TextPicker({ range: this.multiColumnTextCascadeContent })
                .textPickerStyle(this.singleSelectedTextColor)
                .onChange((value, index) => {
                  this.multiColumnTextCascadeSelectedValue = value as string[]
                  this.multiColumnTextCascadeSelectedIndex = index as number[]
                })
            }

            Row({ space: 16 }) {
              Column() {
                Text() {
                  Span('已选择索引：')
                  Span(JSON.stringify(this.multiColumnTextCascadeSelectedIndex))
                    .spanSelectedStyle(this.singleSelectedTextColor)
                }

                Text() {
                  Span('已选择值：')
                  Span(JSON.stringify(this.multiColumnTextCascadeSelectedValue))
                    .spanSelectedStyle(this.singleSelectedTextColor)
                }
              }
            }
          }
          .cardColumnStyle()
        }
      }
      .layoutWeight(1)
    }
    .backgroundColor('rgba(0,0,0,0.1)')
    .height('100%')
    .width('100%')
  }
}

@Extend(TextPicker)
function textPickerStyle(color: Color | string) {
  .textStyle({ font: { size: 18 } })
  .defaultPickerItemHeight(35) // 最上和最下两端消失状态的文本样式
  .disappearTextStyle({ color: 'red' })
  .selectedTextStyle({ color, font: { weight: FontWeight.Bold } })
  .divider({ startMargin: 5, endMargin: 5 })
  .gradientHeight('25%') // 最上和最下两端消失状态文本，模糊渐变高度
}

@Extend(Span)
function spanSelectedStyle(color: Color | string) {
  .fontColor(color)
  .fontSize(18)
  .fontWeight(FontWeight.Bold)
}

@Styles
function cardColumnStyle() {
  .backgroundColor(Color.White)
  .borderRadius(16)
  .padding(16)
}

function getCycleIndex(current: number, maxIndex: number, minIndex = 0) {
  return ++current > maxIndex ? minIndex : current
}

function getRandom(lessThanNum: number, minNum = 0) {
  const max = Math.floor(Math.random() * lessThanNum);
  return max <= minNum ? minNum : max;
}