/*
 * 【待解决】
 * wantAgent.getWantAgent(wantAgentInfo) 获取的wantAgent 为空对象
 * */

import { RoutePagesInfo } from '../constants/pageTitleUrl';
import { PageHeader } from '../views/PageHeader';
// import wantAgent from '@ohos.app.ability.wantAgent';
import { Notification_Want_Agent } from '../constants/want';
import { notificationManager } from '@kit.NotificationKit';
import { promptAction } from '@kit.ArkUI';
import { JSON } from '@kit.ArkTS';
import { wantAgent } from '@kit.AbilityKit';

@Entry
@ComponentV2
struct NotificationManagerWantAgent {
  defaultTitle = RoutePagesInfo.find(item => item.url.includes('NotificationManagerWantAgent'))?.title
  @Local message: string = '【待解决获取意图代理对象为{}】';

  build() {
    Column({ space: 16 }) {
      PageHeader({ title: this.defaultTitle })

      Text(this.message)

      Button('发布一个带有意图的通知')
        .onClick(() => {
          /*
           * 构建 WantAgentInfo 类型对象
           * -> 通过wantAgent.getWantAgent 创建意图代理对象
           * -> 放入创建的NotificationRequest中
           * -> 通过 notificationManager.publish 发布
           * */
          const wantAgentInfo: wantAgent.WantAgentInfo = {
            requestCode: 0,
            actionType: wantAgent.OperationType.START_ABILITY,
            actionFlags: [wantAgent.WantAgentFlags.CONSTANT_FLAG],
            // operationType: wantAgent.OperationType.START_ABILITY,
            // wantAgentFlags: [wantAgent.WantAgentFlags.CONSTANT_FLAG],
            wants: [
              {
                bundleName: 'com.example.harmony_app_api12',
                abilityName: 'EntryAbility',
                // parameters: {
                //   from: Notification_Want_Agent
                // }
              }
            ]
          }

          wantAgent.getWantAgent(wantAgentInfo)
            .then((wantAgentObj) => {
              const notificationRequest: notificationManager.NotificationRequest = {
                id: 22,
                label: 'TEST',
                content: {
                  notificationContentType: notificationManager.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT,
                  normal: {
                    title: '意图代理通知标题',
                    text: '意图代理通知内容',
                    additionalText: '附加文本'
                  }
                },
                // actionButtons: [
                //   {
                //     title: '打开',
                //     wantAgent: wantAgentObj
                //   }
                // ],
                // wantAgent: wantAgentObj
              }

              notificationManager.publish(notificationRequest, (err, data) => {
                if (err) {
                  promptAction.showToast({ message: '发布意图代理通知失败' })
                }
              })
              console.log('test_tag wantAgent.getWantAgent wantAgentObj', JSON.stringify(wantAgentObj))
            })
            .catch((err: object) => {
              if (err) {
                console.log('test_tag wantAgent.getWantAgent err', JSON.stringify(err))
                promptAction.showToast({ message: '获取意图代理对象失败' })
              }
            })
        })
    }
    .height('100%')
    .width('100%')
  }
}