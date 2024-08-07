import { PageHeader } from '../views/PageHeader';
import { promptAction, router } from '@kit.ArkUI';
import { RouterParams } from '../viewModels/common';
import { common, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { HiLogDomainTagEnum, WantParametersForResult } from '../models/common';
import { JSON } from '@kit.ArkTS';
import { RoutePagesInfo } from '../constants/pageTitleUrl';

@Entry
@ComponentV2
struct StartAbilityForResult {
  routerParams = router.getParams() as RouterParams;
  defaultTitle = RoutePagesInfo.find(item => item.url.includes('StartAbilityForResult'))?.title
  uiAbilityContext = getContext(this) as common.UIAbilityContext
  @Local resultStr: string = ''

  build() {
    Column({ space: 16 }) {
      PageHeader({
        title: this.defaultTitle,
        callbackBeforeBack: () => {
          router.showAlertBeforeBackPage({ message: '确定要离开么？' })
        }
      })

      Button('启动其他ability，获取返回结果')
        .onClick(() => {
          this.resultStr = ''

          const wantParametersForResult: WantParametersForResult = {
            info: '*来自StartAbilityForResult组件的消息*',
            callerWant: {
              deviceId: '',
              bundleName: 'com.example.harmony_app_api12',
              moduleName: 'entry',
              abilityName: 'EntryAbility',
            }
          }
          const wantInfo: Want = {
            deviceId: '',
            bundleName: 'com.example.harmony_app_api12',
            moduleName: 'entry',
            abilityName: 'TerminateSelfWithResultAbility',
            parameters: wantParametersForResult
          }

          this.uiAbilityContext.startAbilityForResult(wantInfo)
            .then(result => {
              if (result.resultCode === 0) {
                this.resultStr = (result.want?.parameters?.info as string) ?? '无'
              }
              promptAction.showToast({ message: '获取被调用方ability 返回的数据成功' })
            })
            .catch((reason: Object) => {
              hilog.error(Number(HiLogDomainTagEnum.domain), HiLogDomainTagEnum.tag,
                'startAbilityForResult 收到返回信息 %{public}s', JSON.stringify(reason))
              promptAction.showToast({ message: '获取被拉起ability的返回数据失败' })
            })
        })

      Text('来自其他ability的结果：' + this.resultStr)
    }
    .height('100%')
    .width('100%')
  }
}