import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { HiLogDomainTagEnum } from '../models/common';

const localStorage = new LocalStorage()

export default class TerminateSelfWithResultAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    localStorage.setOrCreate('wantParameters', JSON.stringify(want.parameters))
    hilog.info(Number(HiLogDomainTagEnum.domain), HiLogDomainTagEnum.tag, 'TerminateSelfWithResultAbility onCreate 调用方传递的参数：%{public}s',
      JSON.stringify(want.parameters));
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
  }

  // 页面中直接调用 terminalSelf() 销毁了当前 ability实例，所以永远不会走到 onNewWant 方法中
  onNewWant(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(Number(HiLogDomainTagEnum.domain), HiLogDomainTagEnum.tag, 'onNewWant 调用方传递的参数：%{public}s',
      JSON.stringify(want.parameters));
  }

  onDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/DestroyAbilityWithResult', localStorage, (err) => {
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
