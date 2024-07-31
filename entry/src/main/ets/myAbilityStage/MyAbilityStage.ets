import { AbilityConstant, AbilityStage, Configuration, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { HiLogDomainTagEnum } from '../models/common';

class MyAbilityStage extends AbilityStage {
  // 应用的HAP在首次加载的时，为该Module初始化操作
  onCreate(): void {
    hilog.info(HiLogDomainTagEnum.domain, HiLogDomainTagEnum.tag, 'AbilityStage onCreate')
  }

  /*
   * 只在启动的 UIAbility 的 launchType 为 specified 时，执行当前回调
   * 用户返回 UIAbility 实例名称字符串。如果之前已经创建过此名称的 UIAbility 实例，
   * 则直接启动该 UIAbility。 否则，会创建一个新的 UIAbility 实例。
   * */
  onAcceptWant(want: Want): string {
    if (want.abilityName === 'SpecifiedLaunchAbility') {
      if (want.parameters) {
        return `SpecifiedAbilityInstance_${want.parameters.instanceKey}`;
      }
    }
    return ''
  }

  /*
   * 只在启动的 UIAbility 的 launchType 为 specified 时，执行当前回调
   * 用户返回进程字符串 ID。如果之前已经创建过此 ID 的进程，则让该UIAbility在此进程中运行。
   * 否则，会创建一个新进程。
   * */
  onNewProcessRequest(want: Want): string {
    if (want.abilityName === 'SpecifiedLaunchAbility') {
      return want.parameters?.processId as string ?? ''
    }
    return ''
  }

  // 在更新系统配置时调用。
  onConfigurationUpdate(newConfig: Configuration): void {
  }

  // 当系统已确定修剪内存时调用，如，当Ability在后台运行,且没有足够的内存来运行其他的后台进程时。
  onMemoryLevel(level: AbilityConstant.MemoryLevel): void {
  }

  onDestroy(): void {
    hilog.info(HiLogDomainTagEnum.domain, HiLogDomainTagEnum.tag, 'AbilityStage onDestroy')
  }
}