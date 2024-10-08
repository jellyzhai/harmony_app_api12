import { abilityAccessCtrl, AbilityConstant, common, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { Router, window } from '@kit.ArkUI';
import { JSON } from '@kit.ArkTS';
import { IPayWantParams } from '@ohos/typesCommon';
import { notificationManager } from '@kit.NotificationKit';
import { BusinessError } from '@kit.BasicServicesKit';

const localStorage = new LocalStorage()
localStorage.setOrCreate('nameFromEntry', 'jack')

export default class EntryAbility extends UIAbility {
  windowStage?: window.WindowStage

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    const context: common.UIAbilityContext = this.context
    console.log('test_tag EntryAbility onCreate want', JSON.stringify(want))
  }

  /*
   * 如果当前UIAbility配置为 单实例 或 指定实例 启动模式，
   * 应用的UIAbility实例若已创建，再次调用startAbility()方法启动该UIAbility实例时；
   * 由于启动的还是原来的 或 匹配到实例名称的 UIAbility实例，并未重新创建一个新的UIAbility实例，
   * 此时只会进入该UIAbility的 onNewWant() 回调，
   * 不会进入其onCreate()和onWindowStageCreate()生命周期回调。
   * */
  onNewWant(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    console.log('test_tag EntryAbility onNewWant want', JSON.stringify(want))

    let routerObj: Router | undefined = undefined

    try {
      routerObj = this.windowStage?.getMainWindowSync().getUIContext().getRouter()
    } catch (e) {
      hilog.error(0x0000, 'test_tag', '获取router失败：' + JSON.stringify(e))
    }

    // const params: undefined | IPayWantParams = want.parameters?.payInfo as IPayWantParams
    //
    // if (params?.fromAbilityUri && params?.fromPageUrl) {
    //   routerObj?.replaceUrl({
    //     url: params.fromPageUrl, params
    //   })
    // }
  }

  onDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    this.windowStage = windowStage

    windowStage.loadContent('pages/Index', localStorage, (err) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content.');

      /*const atManager = abilityAccessCtrl.createAtManager();

      // 向用户请求位置权限设置。
      atManager.requestPermissionsFromUser(this.context, ["ohos.permission.APPROXIMATELY_LOCATION"])
        .then((data) => {
          console.info('test_tag data:' + JSON.stringify(data));
          console.info('test_tag data permissions:' + data.permissions);
          console.info('test_tag data authResults:' + data.authResults);
        }).catch((error: BusinessError) => {
        console.error(`test_tag Failed to request permissions from user. Code is ${error.code}, message is ${error.message}`);
      })*/

      if (!notificationManager.isNotificationEnabledSync()) {
        notificationManager.requestEnableNotification(this.context)
          .catch((err: Object) => {
            console.log('test_tag notificationManager.requestEnableNotification err', JSON.stringify(err))
          })
      }
    });

    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }
}
