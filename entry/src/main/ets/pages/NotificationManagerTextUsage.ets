import { RoutePagesInfo } from '../constants/pageTitleUrl';
import { PageHeader } from '../views/PageHeader';
import { notificationManager } from '@kit.NotificationKit';
import promptAction from '@ohos.promptAction';
import { JSON } from '@kit.ArkTS';
import { common } from '@kit.AbilityKit';

@Entry
@ComponentV2
struct NotificationManagerTextUsage {
  defaultTitle = RoutePagesInfo.find(item => item.url.includes('NotificationManagerTextUsage'))?.title
  uiAbilityContext = getContext(this) as common.UIAbilityContext
  bgColor: string = 'rgba(0,0,0,0.1)'
  @Local textNotificationTip: string = '发布文本类型通知后，可在下拉通知中心查看结果：';
  @Local notificationText: string = '';

  aboutToAppear(): void {
    // if (!notificationManager.isNotificationEnabledSync()) {
    //   notificationManager.requestEnableNotification(this.uiAbilityContext)
    //     .catch((err: Object) => {
    //       console.log('test_tag notificationManager.requestEnableNotification err', JSON.stringify(err))
    //     })
    // }
  }

  build() {
    Column({ space: 16 }) {
      PageHeader({ title: this.defaultTitle })

      Column({ space: 16 }) {
        Text(this.textNotificationTip)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Column({ space: 8 }) {
          TextInput({ text: $$this.notificationText, placeholder: '请输入' })

          Column({ space: 6 }) {
            Text('普通文本内容类型超过3行省略显示')

            Row() {
              Button('发布/更新普通文本通知')
                .fontSize(16)
                .enabled(!!this.notificationText)
                .onClick(() => {
                  const notificationRequest: notificationManager.NotificationRequest = {
                    id: 1,
                    // notificationSlotType: notificationManager.SlotType.CUSTOMER_SERVICE,
                    notificationSlotType: notificationManager.SlotType.SOCIAL_COMMUNICATION, // 模拟器不显示横幅，无声音
                    content: {
                      notificationContentType: notificationManager.ContentType.NOTIFICATION_CONTENT_LONG_TEXT,
                      longText: {
                        title: '普通文本通知标题',
                        text: this.notificationText,
                        expandedTitle: 'chang',
                        longText: this.notificationText,
                        briefText: 'brief'
                      }
                    },
                  }

                  notificationManager.publish(notificationRequest)
                    .then(() => {
                      this.notificationText = ''
                    })
                    .catch((err: Object) => {
                      promptAction.showToast({ message: '发送通知失败' })
                      console.log('test_tag notificationManager.publish err', JSON.stringify(err))
                    })
                })

              Button('取消普通文本通知')
                .fontSize(16)
                .onClick(() => {
                  notificationManager.cancel(1)
                })
            }
          }
          .backgroundColor(this.bgColor)
          .padding(4)
          .borderRadius(4)

          Column({ space: 6 }) {
            Text('长文本内容类型效果与普通文本内容类型一致(不推荐使用长文本通知)')

            Row() {
              Button('发布/更新长文本通知')
                .enabled(!!this.notificationText)
                .onClick(() => {
                  const notificationRequest: notificationManager.NotificationRequest = {
                    id: 2,
                    notificationSlotType: notificationManager.SlotType.CONTENT_INFORMATION, // 通知栏不显示图标，无声音，无横幅
                    content: {
                      notificationContentType: notificationManager.ContentType.NOTIFICATION_CONTENT_LONG_TEXT,
                      longText: {
                        title: '长文本通知标题1',
                        text: this.notificationText,
                        expandedTitle: '扩展文本标题2',
                        longText: this.notificationText,
                        briefText: '简要文本'
                      }
                    },
                  }

                  notificationManager.publish(notificationRequest)
                    .then(() => {
                      this.notificationText = ''
                    })
                    .catch((err: Object) => {
                      promptAction.showToast({ message: '发送通知失败' })
                      console.log('test_tag notificationManager.publish err', JSON.stringify(err))
                    })
                })

              Button('取消长文本通知')
                .onClick(() => {
                  notificationManager.cancel(2)
                })
            }
          }
          .backgroundColor(this.bgColor)
          .padding(4)
          .borderRadius(4)

          Column({ space: 6 }) {
            Text('多行文本内容类型通知, 最多显示3行，超过行行内容不显示')

            Row() {
              Button('发布/更新多行文本通知')
                .enabled(!!this.notificationText)
                .onClick(() => {
                  const notificationRequest: notificationManager.NotificationRequest = {
                    id: 3,
                    notificationSlotType: notificationManager.SlotType.SERVICE_INFORMATION,
                    content: {
                      notificationContentType: notificationManager.ContentType.NOTIFICATION_CONTENT_MULTILINE,
                      multiLine: {
                        title: '多行文本通知标题1', // 没用，模拟器没显示，但目前必须写
                        text: this.notificationText, // 没用，模拟器没显示，但目前必须写
                        longTitle: '多行文本通知标题2',
                        lines: [this.notificationText, this.notificationText, this.notificationText,
                          this.notificationText],
                        briefText: '简要文本'
                      }
                    },
                  }

                  notificationManager.publish(notificationRequest)
                    .then(() => {
                      this.notificationText = ''
                    })
                    .catch((err: Object) => {
                      promptAction.showToast({ message: '发送通知失败' })
                      console.log('test_tag notificationManager.publish err', JSON.stringify(err))
                    })
                })

              Button('取消多行文本通知')
                .onClick(() => {
                  notificationManager.cancel(3)
                })
            }
          }
          .backgroundColor(this.bgColor)
          .padding(4)
          .borderRadius(4)
        }

        Button('取消当前应用的所有通知')
          .onClick(() => {
            notificationManager.cancelAll()
          })
      }
      .padding(8)
      .border({ width: 1 })
      .borderRadius(16)
    }
    .height('100%')
    .width('100%')
  }
}