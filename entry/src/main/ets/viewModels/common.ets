export interface RouterParams {
  title: string;
}

export interface IRefreshLoadState {
  pullDownRefreshing: boolean;
  pullUpLoading: boolean;
}

export class CommonUtils {
  static startMoveY = 0
  static endMoveY = 0
  static isPullDownInitPosition = false
  static isPullUpInitPosition = false

  static getLoadingStateByTouch(event: TouchEvent, limitHeight: number, scroller: Scroller): IRefreshLoadState {
    const stateObj: IRefreshLoadState = {
      pullDownRefreshing: false,
      pullUpLoading: false
    }

    switch (event.type) {
      case TouchType.Down:
        CommonUtils.startMoveY = event.changedTouches[0].displayY
        console.log('test_tag TouchType.Down CommonUtils.startMoveY', CommonUtils.startMoveY)
        const firstItemRect = scroller.getItemRect(0)
        CommonUtils.isPullDownInitPosition = firstItemRect.y === 0 && firstItemRect.height > 0
        CommonUtils.isPullUpInitPosition = scroller.isAtEnd()
        break;

      case TouchType.Move:
        CommonUtils.endMoveY = event.changedTouches[0].displayY
        console.log('test_tag TouchType.Move CommonUtils.endMoveY', CommonUtils.endMoveY)
        break;

      case TouchType.Up:
        if (CommonUtils.isPullDownInitPosition && CommonUtils.endMoveY - CommonUtils.startMoveY >= limitHeight) {
          stateObj.pullDownRefreshing = true
        }
        if (CommonUtils.isPullUpInitPosition && CommonUtils.endMoveY > 0 &&
          CommonUtils.startMoveY - CommonUtils.endMoveY >= limitHeight) {
          stateObj.pullUpLoading = true
        }
        CommonUtils.startMoveY = 0
        CommonUtils.endMoveY = 0
        break;

      case TouchType.Cancel:
        stateObj.pullDownRefreshing = false
        stateObj.pullUpLoading = false
        CommonUtils.startMoveY = 0
        CommonUtils.endMoveY = 0
        break;

      default:
        break;
    }

    return stateObj
  }
}