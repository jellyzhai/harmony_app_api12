import { promptAction, router } from '@kit.ArkUI';
import { RouterParams } from '../viewModels/common';
import { PageHeader } from '../views/PageHeader';

@Entry
@ComponentV2
struct RefreshContainerComponentExample {
  routerParams = router.getParams() as RouterParams;
  promptText: string = '刷新中...'
  @Local isRefreshing: boolean = false
  @Local dataArr: number[] = Array(11).fill(0)
  @Local isBottomShow: boolean = false
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
      PageHeader({ title: this.routerParams.title })

      // 正常V2版本中，!!使用在内置和自定义组件后，可以实现双向绑定；目前暂时不生效，使用V1版本 $$ 生效
      /*
       * 使用builder 自定义显示刷新显示区域视图时，promptText 设置不生效
       * */
      Refresh({
        refreshing: $$this.isRefreshing,
        promptText: this.promptText,
        builder: this.customRefreshView('刷新中...')
      }) {
        List({ space: 16 }) {
          ForEach(this.dataArr, (_: number, index) => {
            ListItem() {
              Text(index.toString())
            }
            .backgroundColor(Color.White)
            .padding(16)
            .borderRadius(16)
            .height(100)
            .width('100%')
          })

          if (this.isLoading) {
            ListItem() {
              this.customRefreshView('加载中...')
            }
            .width('100%')
            .height(62)
          }
        }
        .height('100%')
        .padding(16)
        .onReachStart(() => {
          promptAction.showToast({ message: 'onReachStart', offset: { dx: 0, dy: -50 } })
        })
        .onReachEnd(() => {
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
            /* 不适合处理数据加载，还需使用 onTouch 能精确控制 */
            this.isLoading = true
            promptAction.showToast({ message: '触发上滑加载, 5s后完成' + offset })

            setTimeout(() => {
              promptAction.showToast({ message: '加载完成' + offset })
              this.isLoading = false
            }, 5000)
          }
          return { offsetRemain: offset }
        })
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