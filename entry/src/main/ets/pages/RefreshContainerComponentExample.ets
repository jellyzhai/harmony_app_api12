import { promptAction, router } from '@kit.ArkUI';
import { RouterParams } from '../viewModels/common';
import { PageHeader } from '../views/PageHeader';
import { JSON } from '@kit.ArkTS';
import { RoutePagesInfo } from '../constants/pageTitleUrl';

@Entry
@ComponentV2
struct RefreshContainerComponentExample {
  routerParams = router.getParams() as RouterParams;
  defaultTitle = RoutePagesInfo.find(item => item.url.includes('RefreshContainerComponentExample'))?.title
  promptText: string = '刷新中...'
  isReachEnd = false
  listScroller = new Scroller()
  @Local isRefreshing: boolean = false
  @Local dataArr: string[] = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J']
  @Local isBottomShow: boolean = false
  @Local isPrepareLoading: boolean = false
  @Local isLoading: boolean = false

  /*  @Builder
    customApplyContent() {
      Text('数据刷新中...')
    }

    applyContent() {
      return new WrappedBuilder(this.customApplyContent)
    }*/

  @Builder
  customRefreshView(text: string) {
    Row({ space: 16 }) {
      LoadingProgress()
        .width(32)
      /*.enableLoading(true)
      .contentModifier({ applyContent: this.applyContent })*/

      Text(text)
        .fontSize(18)
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .linearGradient({ colors: [[Color.Transparent, 0], [Color.White, 0.5], [Color.Transparent, 1]] })
    // .linearGradientBlur(100, { fractionStops: [[0.6, 1], [0.6, 1], [0.6, 1]], direction: GradientDirection.Top })
    // 不加 限制最小高度，会导致刷新区消失时，内容区已恢复，刷新区内容仍然短暂显示，延迟消失
    .constraintSize({ minHeight: 32 })
  }

  build() {
    Column() {
      PageHeader({ title: this.defaultTitle })

      // 正常V2版本中，!!使用在内置和自定义组件后，可以实现双向绑定；目前暂时不生效，使用V1版本 $$ 生效
      /*
       * 使用builder 自定义显示刷新显示区域视图时，promptText 设置不生效
       * */
      Refresh({
        refreshing: $$this.isRefreshing,
        promptText: this.promptText,
        builder: this.customRefreshView('刷新中...')
      }) {
        Column() {
          List({ space: 16, scroller: this.listScroller }) {
            ForEach(this.dataArr, (value: string, index) => {
              ListItem() {
                Text(`${index + 1}、${value} \n可长按拖动列表项位置`)
              }
              .backgroundColor(Color.White)
              .padding(16)
              .borderRadius(16)
              .height(100)
              .width('100%')
            })
              .onMove((from: number, to: number) => { // 动态节点的事件, 是在forEach方法上调用，回调函数参数是变动的索引值
                const movedItem = this.dataArr[from]
                this.dataArr.splice(from, 1)
                this.dataArr.splice(to, 0, movedItem)
              })
          }
          .height('100%')
          .padding(16)
          .layoutWeight(1)
          .parallelGesture(
            PanGesture({ direction: PanDirection.Down })
              .onActionStart(() => { // 向下拖动时，才出发；否则，初始向上又向下后不会触发
                this.isReachEnd = false
              })
          )
          .parallelGesture(
            // 拖动手势
            PanGesture({ direction: PanDirection.Up, distance: 64 })
              .onActionStart(() => {
                // 向拖动距离 >= 64vp 时触发
              })
              .onActionUpdate(event => { // onActionStart 触发后的，更新拖动中触发
                // 向上拖动，offSetX 和 Y 都是负数
                if (event.offsetY < 0) {

                }
                if (this.isReachEnd && Math.abs(event.offsetY) >= 64) {
                  this.isPrepareLoading = true
                  this.listScroller.scrollBy(0, 64)
                } else {
                  this.isPrepareLoading = false
                }
              }) // 拖动事件结束
            .onActionEnd((event: GestureEvent) => {
              console.log('test_tag onActionEnd event', JSON.stringify(event))

              if (this.isLoading) {
                return
              }

              // 拖动事件结束后，如果触发了loading，则开始请求加载数据
              if (event.offsetY < 0 && Math.abs(event.offsetY) >= 64) {
                this.isLoading = true
                this.listScroller.scrollBy(0, 64)
                promptAction.showToast({ message: '触发上滑加载, 3s后完成', offset: { dx: 0, dy: -150 } })

                setTimeout(() => {
                  promptAction.showToast({ message: '加载完成', offset: { dx: 0, dy: -200 } })
                  this.isLoading = false
                  this.isPrepareLoading = false
                }, 3000)
              } else {
                this.isPrepareLoading = false
                this.isLoading = false
              }
            })
          )
          .onReachStart(() => {
            promptAction.showToast({ message: 'onReachStart', offset: { dx: 0, dy: -50 } })
          })
          .onReachEnd(() => {
            this.isReachEnd = true
            promptAction.showToast({ message: 'onReachEnd', offset: { dx: 0, dy: -100 } })
          })
          .onScrollStart(() => {
            promptAction.showToast({ message: 'onScrollStart', offset: { dx: 0, dy: -150 } })
          })
          .onScrollStop(() => {
            promptAction.showToast({ message: 'onScrollStop', offset: { dx: 0, dy: -200 } })
          })
          .onScrollIndex((start, end) => {
            this.isBottomShow = end === this.dataArr.length - 1
          })
          .onScrollFrameBegin((offset, state) => {
            // 当页面自己滑动时，触发 ScrollState 的 Fling
            //   offset > 0 时向上滑动, 页面向下显示，offset < 0 表示页面在向下滑动, 应该表示偏移速度
            if (!this.isLoading && this.isBottomShow && offset > 5) {
              /* 不适合处理数据加载 */
            }
            return { offsetRemain: offset }
          })
          .onScrollVisibleContentChange((_, end) => {
            console.log('test_tag onScrollVisibleContentChange end', JSON.stringify(end))
          })
          Row() {
            this.customRefreshView('加载准备中...')
          }
          .width('100%')
          .height(64)
          .visibility(this.isPrepareLoading && !this.isLoading ? Visibility.Visible : Visibility.None)

          Row() {
            this.customRefreshView('加载中...')
          }
          .width('100%')
          .height(64)
          .visibility(this.isLoading ? Visibility.Visible : Visibility.None)

          Button('向下滚动')
            .onClick(() => {
              this.listScroller.scrollBy(0, 64)
            })

        }
      }
      .layoutWeight(1)
      .onStateChange((state) => {
        promptAction.showToast({ message: state.toString() })
      })
      .onRefreshing(() => {
        promptAction.showToast({ message: '2s 后刷新结束' })

        setTimeout(() => {
          this.isRefreshing = false
          promptAction.showToast({ message: '后刷完成' })
        }, 2000)
      })
    }
    .height('100%')
    .width('100%')
    .backgroundColor('rgba(0,0,0,0.1)')
  }
}