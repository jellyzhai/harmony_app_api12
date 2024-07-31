import { AbilityConstant, common, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';

export default class EntryAbility extends UIAbility {

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    const context: common.UIAbilityContext = this.context
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
  }

  /*
   * 如果当前UIAbility配置为 单实例 或 指定实例 启动模式，
   * 应用的UIAbility实例若已创建，再次调用startAbility()方法启动该UIAbility实例时；
   * 由于启动的还是原来的 或 匹配到实例名称的 UIAbility实例，并未重新创建一个新的UIAbility实例，
   * 此时只会进入该UIAbility的 onNewWant() 回调，
   * 不会进入其onCreate()和onWindowStageCreate()生命周期回调。
   * */
  onNewWant(want: Want, launchParam: AbilityConstant.LaunchParam): void {
  }

  onDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content.');
    });
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
