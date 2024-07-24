import { common } from '@kit.AbilityKit';
import { HiLogDomainTagEnum, WantParametersForResult } from '../models/common';
import hilog from '@ohos.hilog';
import { JSON } from '@kit.ArkTS';
import { promptAction, router } from '@kit.ArkUI';

@Entry
@ComponentV2
struct DestroyAbilityWithResult {
  uiAbilityContext = getContext(this) as common.UIAbilityContext
  wantParameters = JSON.parse(LocalStorage.getShared().get('wantParameters')) as WantParametersForResult
  @Local returnContent: string = ''

  @Computed
  get isEnabled(): boolean {
    return !!this.returnContent.trim()
  }
  build() {
    Column({ space: 16 }) {
      Text(`调用方传递的数据：${Reflect.get(this.wantParameters, 'info') || '无'}`)

      Column({ space: 8 }) {
        Text('输入返回给调用方ability的内容:')

        TextInput({ placeholder: '请输入' })
          .onChange(value => {
            this.returnContent = value
          })

        Button('确定')
          .enabled(this.isEnabled)
          .onClick(() => {
            this.wantParameters.callerWant.parameters = {
              info: this.returnContent
            }
            const result: common.AbilityResult = {
              resultCode: 0,
              want: this.wantParameters.callerWant
            }
            this.uiAbilityContext.terminateSelfWithResult(result)
              .then(() => {
                promptAction.showToast({ message: '返回给调用方ability数据成功' })
              })
              .catch((reason: Object) => {
                hilog.error(Number(HiLogDomainTagEnum.domain), HiLogDomainTagEnum.tag,
                  'terminateSelfWithResult 失败：%{public}s', JSON.stringify(reason))
              })
          })
      }

    }
    .height('100%')
    .width('100%')
  }
}