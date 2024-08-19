import { RoutePagesInfo } from '../constants/pageTitleUrl';
import { PageHeader } from '../views/PageHeader';
import pasteboard from '@ohos.pasteboard';
import { promptAction } from '@kit.ArkUI';
import { geoLocationManager } from '@kit.LocationKit';
import { JSON } from '@kit.ArkTS';
import { common } from '@kit.AbilityKit';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { fileIo } from '@kit.CoreFileKit';

@Entry
@ComponentV2
struct LocationPasteSaveButton {
  defaultTitle = RoutePagesInfo.find(item => item.url.includes('LocationPasteSaveButton'))?.title
  textInputController: TextInputController = new TextInputController()
  context = getContext(this) as common.UIAbilityContext;
  @Local isClickedLocationBtn = false
  @Local inputText: string = '';
  @Local currentLocation: geoLocationManager.Location | geoLocationManager.GeoAddress[] | undefined = undefined;
  @Local imgUri: string = ''

  build() {
    Column({ space: 16 }) {
      PageHeader({ title: this.defaultTitle })

      Column({ space: 16 }) {
        TextInput({ text: $$this.inputText, placeholder: '请输入', controller: this.textInputController })

        PasteButton()
          .onClick((event, result) => {
            if (result === PasteButtonOnClickResult.SUCCESS) {
              try {
                this.inputText = pasteboard.getSystemPasteboard().getDataSync().getPrimaryText()
                promptAction.showToast({ message: '粘贴成功' })
              } catch (e) {
                promptAction.showToast({ message: JSON.stringify(e) })
              }
              return
            }
            promptAction.showToast({ message: '粘贴失败' })
          })
      }
      .padding(16)
      .backgroundColor('rgba(0,0,0,0.05)')
      .borderRadius(16)

      Column({ space: 16 }) {
        Text() {
          Span('当前位置：')
          Span((JSON.stringify(this.currentLocation) ?? ''))
            .visibility(this.currentLocation ? Visibility.Visible : Visibility.None)
        }

        LoadingProgress()
          .width(32)
          .height(32)
          .visibility(this.isClickedLocationBtn ? Visibility.Visible : Visibility.None)

        LocationButton()
          .onClick((event, result) => {
            if (this.isClickedLocationBtn) {
              promptAction.showToast({ message: '请在完成当前位置请求后，再点击。' })
              return
            }

            if (result === LocationButtonOnClickResult.SUCCESS) {
              // 如果没有开启定位，跳转到系统设置的位置开关页面；若没有当前操作，应用crash
              if (!geoLocationManager.isLocationEnabled()) {
                promptAction.showToast({ message: '请先开启定位服务' })

                this.context.startAbility({
                  bundleName: 'com.huawei.hmos.settings',
                  abilityName: 'com.huawei.hmos.settings.MainAbility',
                  uri: 'location_manager_settings', //application_settings application_info_entry
                });

                return
              }

              this.currentLocation = undefined
              this.isClickedLocationBtn = true

              const locationRequest: geoLocationManager.SingleLocationRequest = {
                locatingPriority: geoLocationManager.LocatingPriority.PRIORITY_ACCURACY,
                locatingTimeoutMs: 3000
              }

              geoLocationManager.getCurrentLocation(locationRequest)
                .then(location => {
                  promptAction.showToast({ message: '定位成功' })
                  this.currentLocation = location
                  // 坐标转文字描述地址失败，可能模拟器不支持【待解决】
                  /* geoLocationManager.getAddressesFromLocation({
                      locale: 'zh',
                      // country: 'CN',
                      latitude: location.latitude,
                      longitude: location.longitude
                    })
                      .then((result) => {
                        promptAction.showToast({ message: '定位成功' })
                        this.currentLocation = result
                      })
                      .catch((reason: ESObject) => {
                        console.log('test_tag reason', JSON.stringify(reason))
                        promptAction.showToast({ message: '定位失败' })
                      })*/
                })
                .catch((e: ESObject) => {
                  promptAction.showToast({ message: JSON.stringify(e), duration: 5000 })
                })
                .finally(() => {
                  this.isClickedLocationBtn = false
                })
              return
            }

            promptAction.showToast({ message: '定位失败' })
          })
      }
      .padding(16)
      .backgroundColor('rgba(0,0,0,0.05)')
      .borderRadius(16)

      Column({ space: 16 }) {
        Text('点击下载可将应用中的资源图片，保存到相册当中，保存成功后，可到相册查看')

        Image($r('app.media.fj1'))
          .width(150)

        SaveButton()
          .onClick(async (event, result) => {
            if (result === SaveButtonOnClickResult.SUCCESS) {
              try {
                const fj1Uint8Arr = await this.context.resourceManager.getMediaContent($r('app.media.fj1'))
                const helper = photoAccessHelper.getPhotoAccessHelper(this.context)
                const newImgUri = await helper.createAsset(photoAccessHelper.PhotoType.IMAGE, 'jpg')
                const newImgFile = await fileIo.open(newImgUri, fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE)
                const newImgName = newImgUri.split('/').reverse()[0]

                fileIo.writeSync(newImgFile.fd, fj1Uint8Arr.buffer)
                this.imgUri = newImgUri

                fileIo.closeSync(newImgFile.fd)
                helper.release()
                promptAction.showToast({ message: `保存图片${newImgName}到图库成功`, duration: 3000 })
              } catch (e) {
                promptAction.showToast({ message: '保存图片到图库失败', duration: 3000 })
              }
              return
            }
            promptAction.showToast({ message: '保存图片到图库失败', duration: 3000 })
          })
      }
      .padding(16)
      .backgroundColor('rgba(0,0,0,0.05)')
      .borderRadius(16)
    }
    .height('100%')
    .width('100%')
  }
}