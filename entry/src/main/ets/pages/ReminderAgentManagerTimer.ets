import reminderAgentManager from '@ohos.reminderAgentManager';
import notificationManager from '@ohos.notificationManager';
import { JSON } from '@kit.ArkTS';
import { RoutePagesInfo } from '../constants/pageTitleUrl';
import { PageHeader } from '../views/PageHeader';
import { LengthMetrics } from '@kit.ArkUI';

@Entry
@ComponentV2
struct ReminderAgentManagerTimer {
  defaultTitle = RoutePagesInfo.find(item => item.url.includes('ReminderAgentManagerTimer'))?.title
  notificationId: number = 33
  @Local reminderId: number = -1
  @Local countdownSeconds: string = '';
  @Local ringDuration: string = '';

  @Computed
  get isReminderEnabled(): boolean {
    return !!this.countdownSeconds && !!this.ringDuration
  }

  initData() {
    this.countdownSeconds = '5'
    this.ringDuration = '5'
  }

  setTimerReminder() {
    const minutes = Math.floor(Number(this.countdownSeconds) / 60)
    const seconds = Number(this.countdownSeconds) % 60
    const contentMinutes = minutes > 0 ? `${minutes}分钟` : ''
    const contentSeconds = seconds > 0 ? `${seconds}秒` : ''
    const content = contentMinutes + contentSeconds + '倒计时正在提醒中'
    const expiredContent = contentMinutes + contentSeconds + '倒计时已提醒结束'

    // 倒计时提醒
    let timerReminderRequest: reminderAgentManager.ReminderRequestTimer = {
      notificationId: this.notificationId, // 指明提醒使用的通知的ID号，相同ID号的提醒会覆盖
      reminderType: reminderAgentManager.ReminderType.REMINDER_TYPE_TIMER, // 提醒类型为倒计时类型
      slotType: notificationManager.SlotType.SOCIAL_COMMUNICATION, // 指明提醒的Slot类型
      title: '倒计时', // 指明提醒标题
      content, // 指明提醒内容
      expiredContent, // 指明提醒过期后需要显示的内容
      triggerTimeInSeconds: Number(this.countdownSeconds), // 10秒后触发
      ringDuration: Number(this.ringDuration), // 铃声持续时间(s)
      // snoozeTimes: Number(this.snoozeTimes), // 指明延迟提醒次数，默认0次(不适用于倒计时提醒类型)。
      // timeInterval: Number(this.snoozeInterval), // 执行延迟提醒间隔（单位：秒），最少5分钟(不适用于倒计时提醒类型)。
      actionButton: [// 设置弹出的提醒通知信息上显示的按钮类型和标题
        {
          title: '关闭倒计时',
          type: reminderAgentManager.ActionButtonType.ACTION_BUTTON_TYPE_CLOSE
        }
      ],
      wantAgent: {
        // 点击提醒通知后跳转的目标UIAbility信息
        pkgName: 'com.example.harmony_app_api12',
        abilityName: 'EntryAbility'
      },
      /*
       * 提醒到达时，全屏显示自动拉起目标的ability信息。如果设备正在使用中，则弹出一个通知横幅框。
       * 预留接口暂不支持
       * */
      /*maxScreenWantAgent: {
        pkgName: 'com.example.harmony_app_api12',
        abilityName: 'EntryAbility'
      }*/
    }

    reminderAgentManager.publishReminder(timerReminderRequest).then(reminderId => {
      console.info('test_tag Succeeded in publishing reminder. ');
      this.reminderId = reminderId; // 发布的提醒ID
    }).catch((err: Object) => {
      console.error(`test_tag Failed to publish reminder. err:`, JSON.stringify(err));
    })
  }

  build() {
    Column({ space: 16 }) {
      PageHeader({ title: this.defaultTitle })

      Column({ space: 16 }) {
        Row({ space: 6 }) {
          Text('*多长时间后倒计时响铃(s)：')
            .width(100)
          TextInput({ text: $$this.countdownSeconds, placeholder: '请输入倒计时秒数' })
            .type(InputType.Number)
            .layoutWeight(1)
        }
        .width('100%')

        Row() {
          Text('*每次响铃持续时间(s)：')
            .width(100)
          TextInput({ text: $$this.ringDuration, placeholder: '请输入每次响铃持续秒数' })
            .type(InputType.Number)
            .layoutWeight(1)
        }
        .width('100%')

        Flex({
          wrap: FlexWrap.Wrap,
          justifyContent: FlexAlign.Center,
          space: { main: LengthMetrics.vp(10), cross: LengthMetrics.vp(10) }
        }) {
          Button('取消所有提醒')
            .enabled(this.reminderId > 0)
            .onClick(() => {
              reminderAgentManager.cancelAllReminders()
              this.reminderId = -1
            })

          Button('取消当前ID提醒')
            .enabled(this.reminderId > 0)
            .onClick(() => {
              reminderAgentManager.cancelReminder(this.reminderId)
              this.reminderId = -1
            })

          Button('设置初始数据')
            .onClick(() => {
              this.initData()
            })

          Button('设置倒计时提醒')// .enabled(this.isReminderEnabled)
            .onClick(() => {
              this.setTimerReminder()
            })
        }
      }
      .padding(8)
      .width('100%')
    }
    .height('100%')
    .width('100%')
  }
}