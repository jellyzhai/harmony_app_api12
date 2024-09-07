import { INewsListItem } from '../viewModels/newsCreateLoadRefresh'
import { JSON } from '@kit.ArkTS'
import { CommonUtils } from '../viewModels/common'
import { PublishNews } from '../views/newsCreateLoadRefresh/PublishNews'
import { NavPathStackManager } from '../viewModels/NavPathStackManager'

@Entry
@ComponentV2
struct NewsCreateLoadRefresh {
  @Local selectedIndex: number = 0
  @Local isFocus: boolean = false
  @Local newsList: INewsListItem[] = []
  @Local listWidth: number = 0
  @Local isRefreshing: boolean = false
  @Local hasRefreshResult: boolean = false
  @Local isLoadingMore: boolean = false
  @Local noLoadMoreData: boolean = false
  @Local visibleStartIndex: number = 0
  @Local visibleEndIndex: number = 0
  publishNewsPageName = 'publishNews'
  tabsController: TabsController = new TabsController()
  icons: string[] = ['my', 'news', 'play', 'search', 'startIcon']
  listScroller: Scroller = new Scroller()
  navPathStack: NavPathStack = new NavPathStack()

  @Computed
  get contentWidth(): number {
    return this.listWidth - 88
  }

  setGlobalNavPathStack(navPathStack: NavPathStack) {
    NavPathStackManager.getNavPathStackManager().setNavPathStack(navPathStack)
  }

  aboutToAppear(): void {
    this.setGlobalNavPathStack(this.navPathStack)
    this.newsList = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J'].map((value, index) => {
      return {
        title: index + 1 + `${value}、Object literal must correspond to some explicitly declared class or interface`,
        icon: $r(`app.media.${this.icons[index % 5]}`),
        // 也可以正常显示图片，app 和 sys功能结果一致
        // icon: $r(`sys.media.${this.icons[index % 5]}`),
        content: '对象文字必须对应于某个显式声明的类或接口（标记没有非类型化的obj文字）<ArkTSCheck>'
      } as INewsListItem
    })

    this.visibleEndIndex = this.newsList.length - 1
  }

  onTouchCallback(event: TouchEvent) {
    if (this.isRefreshing || this.isLoadingMore) {
      return
    }

    const stateObj = CommonUtils.getLoadingStateByTouch(event, 64, this.listScroller)
    this.isRefreshing = stateObj.pullDownRefreshing
    this.isLoadingMore = stateObj.pullUpLoading

    if (this.isRefreshing) {
      setTimeout(() => {
        this.hasRefreshResult = true

        setTimeout(() => {
          this.isRefreshing = false
          this.hasRefreshResult = false
        }, 2000)
      }, 2000)
    }

    if (this.isLoadingMore) {
      // 滚动到数据的长度，才是滚动到最后一项
      this.listScroller.scrollToIndex(this.newsList.length, true, ScrollAlign.END)
      setTimeout(() => {
        this.isLoadingMore = false
      }, 2000)
    }
  }

  @Builder
  NavDestinationBuilder(name: string, param: Object) {
    if (name === this.publishNewsPageName) {
      PublishNews()
    }
  }

  @Builder
  LoadingLayout(content: string, showLoadingProgress: boolean = true) {
    Row() {
      if (showLoadingProgress) {
        LoadingProgress()
          .width(32)
      }
      Text(content)
        .fontSize(18)
    }
    .width('100%')
    .padding(16)
    .justifyContent(FlexAlign.Center)
  }

  build() {
    Navigation(this.navPathStack) {
      Row() {
        Search({ placeholder: '搜索新闻' })
          .fontColor(Color.Gray)
          .layoutWeight(1)
          .searchIcon({ src: $r('app.media.search') })
          .searchButton(this.isFocus ? '搜索' : '')
          .onFocus(() => {
            this.isFocus = true
          })
          .onBlur(() => {
            this.isFocus = false
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
            .fontWeight(FontWeight.Lighter)
        }
        .width(28)
        .margin({ left: 8 })
        .onClick(() => {
          this.navPathStack.pushDestinationByName(this.publishNewsPageName, null, (popInfo: PopInfo) => {
            if (popInfo) {
              this.newsList.unshift(popInfo.result as INewsListItem)
            }
          })
        })
      }
      .margin({
        left: 16,
        right: 16,
        top: 8,
      })

      Tabs({ controller: this.tabsController, barPosition: BarPosition.End }) {
        TabContent() {
          Column() {
            if (this.isRefreshing) {
              if (this.hasRefreshResult) {
                this.LoadingLayout('数据已刷新', false)
              } else {
                this.LoadingLayout('刷新中')
              }
            }

            List({ scroller: this.listScroller }) {
              Repeat(this.newsList)
                .each((repeatItem) => {
                })
                .template('defaultTpl', (repeatItem) => {
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
                  .backgroundColor(Color.White)
                  .borderRadius(10)
                  .padding(10)
                  .margin({ bottom: 14 })
                }, { cachedCount: 3 })
                .templateId(() => 'defaultTpl')
            }
            .layoutWeight(1)
            // .divider({
            //   strokeWidth: 1,
            //   color: 'rgba(0,0,0,0.3)',
            //   startMargin: 8,
            //   endMargin: 8
            // })
            // 不能使用，否则应用崩溃
            // .fadingEdge(true)
            .onAreaChange((oldValue: Area, newValue: Area) => {
              console.log('test_tag onAreaChange listItemContent', JSON.stringify(oldValue),
                JSON.stringify(newValue))
              this.listWidth = newValue.width as number
            })
            .onScrollIndex((start: number, end: number) => {
              this.visibleStartIndex = start
              this.visibleEndIndex = end
            })
            .onTouch((event: TouchEvent) => {
              this.onTouchCallback(event)
            })

            if (this.isLoadingMore) {
              this.LoadingLayout('加载更多中')
            }
          }
        }
        .tabBar(
          BottomTabBarStyle.of($r(`app.media.news`), '头条')
            .labelStyle({ selectedColor: Color.Red, font: { size: 16 } })
            .iconStyle({ selectedColor: Color.Red })
            .padding({ top: 8 })
        )

        TabContent() {
          Text('视频')
        }
        .tabBar(
          BottomTabBarStyle.of($r(`app.media.play`), '视频')
            .labelStyle({ selectedColor: Color.Red, font: { size: 16 } })
            .iconStyle({ selectedColor: Color.Red })
            .padding({ top: 8 })
        )

        TabContent() {
          Text('我的')
        }
        .tabBar(
          BottomTabBarStyle.of($r(`app.media.my`), '我的')
            .labelStyle({ selectedColor: Color.Red, font: { size: 16 } })
            .iconStyle({ selectedColor: Color.Red })
            .padding({ top: 8 })
        )
      }
      .scrollable(false)
      .layoutWeight(1)
      .padding({
        left: 16,
        right: 16,
        // top: 8,
        // bottom: 8
      })
    }
    .navDestination(this.NavDestinationBuilder)
    .hideTitleBar(true)
    .hideToolBar(true)
    .backgroundColor('rgba(0,0,0,0.1)')
  }
}