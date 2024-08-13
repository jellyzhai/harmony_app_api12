import { RoutePagesInfo } from '../constants/pageTitleUrl';
import { PageHeader } from '../views/PageHeader';
import { notificationManager } from '@kit.NotificationKit';

@Entry
@ComponentV2
struct NotificationManagerProgressBar {
  defaultTitle = RoutePagesInfo.find(item => item.url.includes('NotificationManagerProgressBar'))?.title
  intervalId = -1
  @Local progressVal: number = 0;

  build() {
    Column({ space: 16 }) {
      PageHeader({ title: this.defaultTitle })

      Column({ space: 16 }) {
        Text('点击下载，退出应用后，可在下拉通知中心查看下载')

        Column({ space: 8 }) {
          Progress({ value: this.progressVal, total: 100, type: ProgressType.Linear })

          Stack() {
            Progress({ value: this.progressVal, total: 100, type: ProgressType.Ring })
            Text(this.progressVal + '%')
          }

          Progress({ value: this.progressVal, total: 100, type: ProgressType.Eclipse })
          Progress({ value: this.progressVal, total: 100, type: ProgressType.ScaleRing })
          Progress({ value: this.progressVal, total: 100, type: ProgressType.Capsule })

          Row({ space: 16 }) {
            Button('取消下载')
              .onClick(() => {
                clearInterval(this.intervalId)
                this.intervalId = -1
                this.progressVal = 0
                notificationManager.cancel(11)
              })

            Button('暂停下载')
              .onClick(() => {
                clearInterval(this.intervalId)
                this.intervalId = -1
              })

            Button('下载')
              .onClick(() => {
                if (this.intervalId < 0) {
                  this.intervalId = setInterval(() => {
                    if (this.progressVal >= 100) {
                      this.progressVal = 100
                      clearInterval(this.intervalId)
                      return
                    }

                    this.progressVal += 10

                    const template: notificationManager.NotificationTemplate = {
                      name: 'downloadTemplate', // 目前只支持当前模板名称
                      data: {
                        title: '文件标题',
                        fileName: 'music.mp3',
                        progressValue: this.progressVal
                      }
                    }

                    const notificationRequest: notificationManager.NotificationRequest = {
                      id: 11,
                      notificationSlotType: notificationManager.SlotType.SERVICE_INFORMATION,
                      content: {
                        notificationContentType: notificationManager.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT,
                        normal: {
                          title: '下载标题',
                          text: '下载内容',
                        }
                      },
                      template
                    }

                    notificationManager.publish(notificationRequest)
                  }, 1500)
                }
              })
          }
          .justifyContent(FlexAlign.End)
        }
      }
    }
    .height('100%')
    .width('100%')
  }
}