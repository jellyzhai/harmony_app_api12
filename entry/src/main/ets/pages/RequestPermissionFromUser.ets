import { RoutePagesInfo } from '../constants/pageTitleUrl';
import { PageHeader } from '../views/PageHeader';
import { abilityAccessCtrl, common, PermissionRequestResult } from '@kit.AbilityKit';
import { promptAction } from '@kit.ArkUI';
import { JSON } from '@kit.ArkTS';
import { JsonUtil } from 'hsp1';
import { geoLocationManager } from '@kit.LocationKit';


@Entry
@ComponentV2
struct RequestPermissionFromUser {
  defaultTitle = RoutePagesInfo.find(item => item.url.includes('RequestPermissionFromUser'))?.title
  context = getContext(this) as common.UIAbilityContext
  accessTokenManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager()
  @Local permissionRequestResult: string = '';
  @Local geoLocation: string = '';
  @Local enableLocationDialogId: number = -1;

  getApproximatelyLocation() {
    this.accessTokenManager.requestPermissionsFromUser(this.context, ['ohos.permission.APPROXIMATELY_LOCATION'])
      .then((result: PermissionRequestResult) => {
        if (result.authResults[0] === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED) {
          promptAction.showToast({ message: '您授权了应用获取大致位置权限！', duration: 2000 })
        }
        this.permissionRequestResult = JSON.stringify(result)
      })
      .catch((reason: ESObject) => {
        promptAction.showToast({
          message: (reason && typeof reason === 'object') ? JSON.stringify(reason) : '出错了！',
          duration: 2000
        })
      })
  }

  @Builder
  EnableLocationBuilder() {
    Column({ space: 16 }) {
      Text('当前设备位未开启定位！')
      Row() {
        Button('先不开启')
          .onClick(() => {
            promptAction.closeCustomDialog(this.enableLocationDialogId)
          })
        Button('去开启')
          .onClick(() => {
            promptAction.closeCustomDialog(this.enableLocationDialogId)

            this.context.startAbility({
              bundleName: 'com.huawei.hmos.settings',
              abilityName: 'com.huawei.hmos.settings.MainAbility',
              uri: 'location_manager_settings'
            })
          })
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceEvenly)
    }
    .width('100%')
    .padding(16)
  }

  build() {
    Column({ space: 16 }) {
      PageHeader({ title: this.defaultTitle })

      Scroll() {
        Column({ space: 16 }) {
          Text('在使用权限处手动申请权限前提：需要在module.json5中配置 RequestPermissions')
            .fontWeight(FontWeight.Bold)

          Column({ space: 8 }) {
            Text('相应请求权限结果说明：值 0 表示授予权限，值 -1 表示未授予权限，值 2 表示请求无效')

            Button('获取大致位置权限')
              .onClick(() => {
                this.getApproximatelyLocation()
              })

            Text('权限请求结果：\n') {
              if (this.permissionRequestResult) {
                Span(JsonUtil.formatJsonString(this.permissionRequestResult))
              }
            }

            Button('获取当前位置')
              .onClick(() => {
                if (!geoLocationManager.isLocationEnabled()) {
                  promptAction.openCustomDialog({ builder: () => this.EnableLocationBuilder(), autoCancel: false })
                    .then(id => {
                      this.enableLocationDialogId = id
                    })

                  return
                }
                geoLocationManager.getCurrentLocation()
                  .then((location: geoLocationManager.Location) => {
                    this.geoLocation = JsonUtil.formatJsonString(JSON.stringify(location))
                  })
              })

            Text('获取位置前提：\n' +
              '1、需要设备提前开启定位，否则直接通过 geoLocationManager 获取位置会导致应用crash\n' +
              '2、需要先获取位置权限')
              .fontWeight(FontWeight.Bold)

            Text('当前位置信息：\n') {
              if (this.permissionRequestResult) {
                Span(JsonUtil.formatJsonString(this.geoLocation))
              }
            }
          }
          .padding(8)
          .backgroundColor('rgba(0,0,0,0.1)')
          .borderRadius(8)
        }
        .width('100%')
        .layoutWeight(1)
      }
      .layoutWeight(1)
      .padding(16)
    }
    .height('100%')
    .width('100%')
  }
}