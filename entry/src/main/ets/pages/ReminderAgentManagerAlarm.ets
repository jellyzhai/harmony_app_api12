import reminderAgentManager from '@ohos.reminderAgentManager';
import notificationManager from '@ohos.notificationManager';
import { JSON } from '@kit.ArkTS';
import { RoutePagesInfo } from '../constants/pageTitleUrl';
import { PageHeader } from '../views/PageHeader';
import { LengthMetrics, promptAction } from '@kit.ArkUI';

@Entry
@ComponentV2
struct ReminderAgentManagerAlarm {
  defaultTitle = RoutePagesInfo.find(item => item.url.includes('ReminderAgentManagerAlarm'))?.title
  notificationId: number = 44
  @Local reminderId: number = -1
  private daysOfWeekTextArr = ['周一到周五', '周末', '周一到周日']
  private daysOfWeekValArr = [[1, 2, 3, 4, 5], [6, 7], [1, 2, 3, 4, 5, 6, 7]]
  @Local selectedDaysOfWeekText: string = this.daysOfWeekTextArr[0];
  @Local isShowDaysOfWeekModal: boolean = false;
  @Local isShowHourMinuteModal: boolean = false;
  @Local isMilitaryTime: boolean = false; // false 为12小时制
  @Local ringDuration: string = '';
  @Local snoozeTimes: string = '';
  @Local snoozeInterval: string = '';
  currentDate: Date = new Date()
  @Local hours: number = this.currentDate.getHours();
  @Local minutes: number = this.currentDate.getMinutes();
  @Local isSnoozeIntervalErr: boolean = false
  @Local selectedDaysOfWeek: number[] = this.daysOfWeekValArr[0];
  @Local isRingDurationError: boolean = false

  @Computed
  get uiHour(): string {
    return this.isMilitaryTime ? this.hours.toString() :
    (this.hours > 12 ? this.hours - 12 : this.hours).toString()
  }

  @Computed
  get uiMinute(): string {
    return this.minutes.toString().padStart(2, '0')
  }

  @Computed
  get isReminderEnabled(): boolean {
    return !!this.ringDuration && !!this.snoozeInterval && !this.isSnoozeIntervalErr
  }

  @Computed
  get isCancelReminderEnabled(): boolean {
    return this.reminderId > 0
  }

  initData() {
    this.ringDuration = '10'
    this.snoozeTimes = '2'
    this.snoozeInterval = '5' //最少5分钟
    promptAction.showToast({ message: '成功设置初始数据', duration: 4000 })
  }

  setAlarmReminder() {
    // 闹钟提醒
    let alarmReminderRequest: reminderAgentManager.ReminderRequestAlarm = {
      notificationId: this.notificationId, // 指明提醒使用的通知的ID号，相同ID号的提醒会覆盖
      reminderType: reminderAgentManager.ReminderType.REMINDER_TYPE_ALARM, // 提醒类型为闹钟类型
      slotType: notificationManager.SlotType.SOCIAL_COMMUNICATION, // 指明提醒的Slot类型
      title: '闹钟', // 指明提醒标题
      content: `${this.uiHour}:${this.uiMinute}的闹钟提醒中`, // 指明提醒内容
      expiredContent: `${this.uiHour}:${this.uiMinute}的闹钟提醒结束`, // 指明提醒过期后需要显示的内容
      snoozeContent: `延迟闹钟将在${this.snoozeInterval}分钟后提醒`, // 指明延迟提醒后需要显示的内容
      ringDuration: Number(this.ringDuration), // 铃声持续时间(s)
      snoozeTimes: Number(this.snoozeTimes), // 指明延迟提醒次数，默认0次(不适用于闹钟提醒类型)。
      timeInterval: Number(this.snoozeInterval) * 60, // 执行延迟提醒间隔（单位：秒），最少5分钟(不适用于闹钟提醒类型)。
      hour: this.hours,
      minute: this.minutes,
      daysOfWeek: [...this.selectedDaysOfWeek], // 只能传入新的数组，传入组件内数组应用崩溃
      actionButton: [// 设置弹出的提醒通知信息上显示的按钮类型和标题
        {
          title: '关闭闹钟',
          type: reminderAgentManager.ActionButtonType.ACTION_BUTTON_TYPE_CLOSE
        },
        {
          title: `${this.snoozeInterval}分钟后提醒`,
          type: reminderAgentManager.ActionButtonType.ACTION_BUTTON_TYPE_SNOOZE
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
       **/
      /*maxScreenWantAgent: {
        pkgName: 'com.example.harmony_app_api12',
        abilityName: 'EntryAbility'
      }*/
    }

    reminderAgentManager.publishReminder(alarmReminderRequest).then(reminderId => {
      this.reminderId = reminderId; // 发布的提醒ID
      promptAction.showToast({ message: `${this.uiHour}:${this.uiMinute}的闹钟设置成功`, duration: 4000 });
    }).catch((err: Object) => {
      promptAction.showToast({ message: '闹钟设置失败', duration: 4000 });
      console.error(`test_tag Failed to publish reminder. err:`, JSON.stringify(err));
    })
  }

  @Builder
  TimePickerBuilder() {
    TimePicker({ selected: new Date() })
      .padding({ top: 16, bottom: 40 })
      .useMilitaryTime(this.isMilitaryTime)
      .onChange(result => {
        this.hours = result.hour
        this.minutes = result.minute
      })
  }

  @Builder
  DaysPickerBuilder() {
    TextPicker({ range: this.daysOfWeekTextArr })
      .padding({ top: 16, bottom: 40 })
      .onChange(result => {
        this.selectedDaysOfWeekText = result as string
        this.selectedDaysOfWeek = this.daysOfWeekValArr[this.daysOfWeekTextArr.findIndex(item => item === result)]
      })
  }

  build() {
    Column({ space: 16 }) {
      PageHeader({ title: this.defaultTitle })

      Column({ space: 16 }) {
        Row({ space: 6 }) {
          Text('切换小时制12/24小时制：')
            .width(110)
          Row({ space: 12 }) {
            Row({ space: 4 }) {
              Text('12小时制')
              Radio({ group: 'time', value: '12' })
                .checked(!this.isMilitaryTime)
                .onChange(() => {
                  this.isMilitaryTime = false
                })
            }

            Row({ space: 4 }) {
              Text('24小时制')
              Radio({ group: 'time', value: '24' })
                .checked(this.isMilitaryTime)
                .onChange(() => {
                  this.isMilitaryTime = true
                })
            }
          }
        }
        .width('100%')

        Row() {
          Text('*每次响铃持续时间(s)：')
            .width(110)
          TextInput({ text: $$this.ringDuration, placeholder: '请输入每次响铃持续秒数' })
            .type(InputType.Number)
            .layoutWeight(1) // onWillDismiss: false, 只根据数据变化显隐弹框，点击其他区域弹框不消失
            .bindPopup(this.isRingDurationError, { message: '持续时间必须大于或等于1秒', onWillDismiss: false })
            .onChange(value => {
              this.isRingDurationError = Number(value) < 1
            })
        }
        .width('100%')

        Row() {
          Text('暂停(延迟)响铃次数(默认0次)：')
            .width(110)
          TextInput({ text: $$this.snoozeTimes, placeholder: '请输入延迟响铃次数' })
            .type(InputType.Number)
            .layoutWeight(1)
        }
        .width('100%')

        Row() {
          Text('*每次暂停(延迟)响铃的间隔时间(min)：')
            .width(110)
          TextInput({ text: $$this.snoozeInterval, placeholder: '请输入每次延迟响铃的间隔时间' })
            .type(InputType.Number)
            .layoutWeight(1)
            .bindPopup(this.isSnoozeIntervalErr, { message: '分钟数不能小于5', onWillDismiss: false }) // onWillDismiss: false, 只根据数据变化显隐弹框
            .onChange(value => {
              this.isSnoozeIntervalErr = Number(value) < 5
            })
        }
        .width('100%')

        Row() {
          Text('*闹钟时间：')
            .width(110)

          Text() {
            Span(this.uiHour + ':' + this.uiMinute)
            Span(' ▼')
              .fontSize(12)
          }
          .onClick(() => {
            this.isShowHourMinuteModal = !this.isShowHourMinuteModal
          })
          .bindSheet(this.isShowHourMinuteModal, this.TimePickerBuilder(), {
            title: {
              title: '请选择'
            },
            height: SheetSize.FIT_CONTENT,
            onDisappear: () => {
              this.isShowHourMinuteModal = !this.isShowHourMinuteModal
            }
          })
        }
        .width('100%')

        Row() {
          Text('闹钟日：')
            .width(110)

          Text() {
            Span(this.selectedDaysOfWeekText)
            Span(' ▼')
              .fontSize(12)
          }
          .onClick(() => {
            this.isShowDaysOfWeekModal = !this.isShowDaysOfWeekModal
          })
          .bindSheet(this.isShowDaysOfWeekModal, this.DaysPickerBuilder(), {
            title: {
              title: '请选择'
            },
            height: SheetSize.FIT_CONTENT,
            onDisappear: () => {
              this.isShowDaysOfWeekModal = !this.isShowDaysOfWeekModal
            }
          })

        }
        .width('100%')

        Flex({
          wrap: FlexWrap.Wrap,
          justifyContent: FlexAlign.Center,
          space: { main: LengthMetrics.vp(10), cross: LengthMetrics.vp(10) }
        }) {
          Button('取消所有提醒')
            .enabled(this.isCancelReminderEnabled)
            .onClick(() => {
              reminderAgentManager.cancelAllReminders()
                .then(() => {
                  this.reminderId = -1
                  promptAction.showToast({ message: '成功取消所有提醒', duration: 4000 })
                })
                .catch(() => {
                  promptAction.showToast({ message: '失败取消所有提醒', duration: 4000 })
                })
            })

          Button('取消当前ID提醒')
            .enabled(this.isCancelReminderEnabled)
            .onClick(() => {
              reminderAgentManager.cancelReminder(this.reminderId)
                .then(() => {
                  this.reminderId = -1
                  promptAction.showToast({ message: '成功取消当前提醒', duration: 4000 })
                })
                .catch(() => {
                  promptAction.showToast({ message: '失败取消当前提醒', duration: 4000 })
                })
            })

          Button('设置初始数据')
            .onClick(() => {
              this.initData()
            })

          Button('设置闹钟提醒')
            .enabled(this.isReminderEnabled)
            .onClick(() => {
              this.setAlarmReminder()
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