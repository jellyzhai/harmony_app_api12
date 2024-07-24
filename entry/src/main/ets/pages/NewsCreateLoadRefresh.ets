import { INewsListItem } from '../viewModels/newsCreateLoadRefresh'
import { JSON } from '@kit.ArkTS'
import { common } from '@kit.AbilityKit'

@Entry
@ComponentV2
struct NewsCreateLoadRefresh {
  @Local selectedIndex: number = 0
  @Local isFocus: boolean = false
  @Local newsList: INewsListItem[] = []
  @Local listWidth: number = 0

  // 实际为 UIAbilityContext, 继承 Context, 可以获取应用沙箱的文件路径
  context = getContext(this) as common.UIAbilityContext

  uiContext = this.getUIContext()

  tabsController: TabsController = new TabsController()
  icons: string[] = ['my', 'news', 'play', 'search', 'startIcon']

  @Computed
  get contentWidth(): number {
    return this.listWidth - 72
  }

  aboutToAppear(): void {
    this.newsList = [1, 2, 3, 4, 5].map((value, index) => {
      return {
        title: value + '、Object literal must correspond to some explicitly declared class or interface',
        icon: $r(`app.media.${this.icons[index % 5]}`),
        content: '对象文字必须对应于某个显式声明的类或接口（标记没有非类型化的obj文字）<ArkTSCheck>'
      } as INewsListItem
    })


    console.log('test_tag uiContext', JSON.stringify(this.uiContext))
  }

  @Builder
  TabBarBuilder(icon: ResourceStr, text: string, index: number) {
    Column({ space: 4 }) {
      Image($r(`app.media.${icon}`))
        .width(32)
        .height(32)
        .fillColor(this.selectedIndex === index ? Color.Red : Color.Gray)

      Text(text)
        .fontColor(this.selectedIndex === index ? Color.Red : Color.Gray)
    }
    .onClick(() => {
      this.tabsController.changeIndex(index)
      this.selectedIndex = index
    })
  }

  build() {
    Column() {
      Row() {
        Search({ placeholder: '搜索新闻' })
          .fontColor(Color.Gray)
          .layoutWeight(1)
          .searchIcon({ src: $r('app.media.search') })
          .searchButton(this.isFocus ? '搜索' : '')
          .onFocus(() => {
            this.isFocus = true
            console.log('test_tag onFocus')
          })
          .onBlur(() => {
            this.isFocus = false
            console.log('test_tag onBlur')
          })
          .onSubmit(value => {
            console.log('test_tag onSubmit value:', value)
          })

        Column({ space: 4 }) {
          Text('＋')
            .width(20)
            .height(20)
            .textAlign(TextAlign.Center)
            .fontSize(14)
            .fontColor(Color.White)
            .fontWeight(FontWeight.Bold)
            .backgroundColor('rgba(0,0,0,0.3)')
            .borderRadius('50%')
          Text('发布')
            .fontSize(14)
            .fontColor(Color.Gray)
            .fontWeight(FontWeight.Lighter)
        }
        .width(28)
        .margin({ left: 8 })
      }

      Tabs({ controller: this.tabsController, barPosition: BarPosition.End }) {
        TabContent() {
          List({ space: 24 }) {
            Repeat(this.newsList)
              .each((repeatItem) => {
                ListItem() {
                  Row({ space: 8 }) {
                    Image(repeatItem.item.icon)
                      .width(64)

                    Column({ space: 8 }) {
                      Text(repeatItem.item.title)
                        .width(this.contentWidth)
                        .maxLines(1)
                        .textOverflow({ overflow: TextOverflow.Ellipsis })

                      Text(repeatItem.item.content)
                        .width(this.contentWidth)
                        .lineHeight(24)
                        .maxLines(2)
                        .textOverflow({ overflow: TextOverflow.Ellipsis })
                    }
                  }
                  .width('100%')
                }
                .width('100%')
              })
          }
          .divider({
            strokeWidth: 1,
            color: 'rgba(0,0,0,0.3)',
            startMargin: 8,
            endMargin: 8
          })
          .height('100%')
          .onAreaChange((oldValue: Area, newValue: Area) => {
            console.log('test_tag onAreaChange listItemContent', JSON.stringify(oldValue),
              JSON.stringify(newValue))
            this.listWidth = newValue.width as number
          })
        }
        .tabBar(this.TabBarBuilder('news', '头条', 0))

        TabContent() {
          Text('视频')
            .fontColor(Color.Gray)
        }
        .tabBar(this.TabBarBuilder('play', '视频', 1))

        TabContent() {
          Text('我的')
            .fontColor(Color.Gray)
        }
        .tabBar(this.TabBarBuilder('my', '我的', 2))
      }
      .scrollable(false)
      .layoutWeight(1)
    }
    .padding({
      left: 16,
      right: 16,
      top: 8,
      bottom: 8
    })
  }
}