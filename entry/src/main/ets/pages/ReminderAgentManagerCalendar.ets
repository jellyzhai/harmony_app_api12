import reminderAgentManager from '@ohos.reminderAgentManager';
import notificationManager from '@ohos.notificationManager';
import { JSON } from '@kit.ArkTS';
import { RoutePagesInfo } from '../constants/pageTitleUrl';
import { PageHeader } from '../views/PageHeader';
import { LengthMetrics, promptAction } from '@kit.ArkUI';

@Entry
@ComponentV2
struct ReminderAgentManagerCalendar {
  defaultTitle = RoutePagesInfo.find(item => item.url.includes('ReminderAgentManagerCalendar'))?.title
  notificationId: number = 44
  @Local reminderId: number = -1
  @Local isShowDaysOfWeekModal: boolean = false;
  @Local isShowHourMinuteModal: boolean = false;
  @Local isMilitaryTime: boolean = false; // false 为12小时制
  @Local ringDuration: string = '';
  @Local snoozeTimes: string = '';
  @Local snoozeInterval: string = '';
  @Local isSnoozeIntervalErr: boolean = false
  @Local isRingDurationError: boolean = false
  @Local selectedDate: Date = new Date()
  @Local isMonthFormatError: boolean = false
  @Local monthNumArr: number[] = []
  @Local isDayFormatError: boolean = false
  @Local dayNumArr: number[] = []
  currentDate: Date = new Date()
  @Local hours: number = this.currentDate.getHours();
  @Local minutes: number = this.currentDate.getMinutes();

  @Computed
  get isReminderEnabled(): boolean {
    return !!this.ringDuration && !!this.snoozeInterval && !this.isSnoozeIntervalErr && !!this.monthNumArr.length &&
      !this.isMonthFormatError && !!this.dayNumArr.length && !this.isDayFormatError
  }

  @Computed
  get isCancelReminderEnabled(): boolean {
    return this.reminderId > 0
  }

  @Computed
  get uiHour(): string {
    return this.isMilitaryTime ? this.hours.toString() :
    (this.hours > 12 ? this.hours - 12 : this.hours).toString()
  }

  @Computed
  get uiMinute(): string {
    return this.minutes.toString().padStart(2, '0')
  }

  initData() {
    this.ringDuration = '10'
    this.snoozeTimes = '2'
    this.snoozeInterval = '5' //最少5分钟
    this.monthNumArr = [this.selectedDate.getMonth() + 1]
    this.dayNumArr = [this.selectedDate.getDate()]
    promptAction.showToast({ message: '成功设置初始数据', duration: 4000 })
  }

  setCalendarReminder() {
    // 日历提醒
    const calendarReminderRequest: reminderAgentManager.ReminderRequestCalendar = {
      notificationId: this.notificationId, // 指明提醒使用的通知的ID号，相同ID号的提醒会覆盖
      reminderType: reminderAgentManager.ReminderType.REMINDER_TYPE_CALENDAR, // 提醒类型为日历类型
      slotType: notificationManager.SlotType.SOCIAL_COMMUNICATION, // 指明提醒的Slot类型
      title: '日历提醒', // 指明提醒标题
      content: `${this.selectedDate.toLocaleDateString()} ${this.uiHour}:${this.uiMinute}的日历提醒中`, // 指明提醒内容
      expiredContent: `${this.selectedDate.toLocaleDateString()} ${this.uiHour}:${this.uiMinute}的日历提醒结束`, // 指明提醒过期后需要显示的内容
      snoozeContent: `延迟日历将在${this.snoozeInterval}分钟后提醒`, // 指明延迟提醒后需要显示的内容
      dateTime: {
        year: this.selectedDate.getFullYear(),
        month: this.selectedDate.getMonth() + 1,
        day: this.selectedDate.getDate(),
        hour: this.hours,
        minute: this.minutes,
      },
      repeatMonths: [...this.monthNumArr],
      repeatDays: [...this.dayNumArr],
      ringDuration: Number(this.ringDuration), // 铃声持续时间(s)
      snoozeTimes: Number(this.snoozeTimes), // 指明延迟提醒次数，默认0次(不适用于日历提醒类型)。
      timeInterval: Number(this.snoozeInterval) * 60, // 执行延迟提醒间隔（单位：秒），最少5分钟(不适用于日历提醒类型)。
      actionButton: [// 设置弹出的提醒通知信息上显示的按钮类型和标题
        {
          title: '关闭日历',
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
      }
      /*
       * 提醒到达时，全屏显示自动拉起目标的ability信息。如果设备正在使用中，则弹出一个通知横幅框。
       * 预留接口暂不支持
       * */
      /*maxScreenWantAgent: {
        pkgName: 'com.example.harmony_app_api12',
        abilityName: 'EntryAbility'
      }*/
    }

    reminderAgentManager.publishReminder(calendarReminderRequest).then(reminderId => {
      this.reminderId = reminderId; // 发布的提醒ID
      promptAction.showToast({
        message: `${this.selectedDate.toLocaleDateString()} ${this.uiHour}:${this.uiMinute}的日历设置成功`,
        duration: 4000
      });
    }).catch((err: Object) => {
      promptAction.showToast({ message: '日历设置失败', duration: 4000 });
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

  build() {
    Column({ space: 16 }) {
      PageHeader({ title: this.defaultTitle })

      Text('日历提醒暂停次数，未生效，5分钟后没有再次提醒【待处理】')
        .fontColor(Color.Red)
        .fontWeight(FontWeight.Bold)

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
            .layoutWeight(1)// onWillDismiss: false, 只根据数据变化显隐弹框，点击其他区域弹框不消失
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
            .bindPopup(this.isSnoozeIntervalErr,
              { message: '分钟数不能小于5', onWillDismiss: false })// onWillDismiss: false, 只根据数据变化显隐弹框
            .onChange(value => {
              this.isSnoozeIntervalErr = Number(value) < 5
            })
        }
        .width('100%')

        Row() {
          Text('*日历日期：')
            .width(110)

          CalendarPicker({ hintRadius: 8, selected: this.selectedDate })
            .textStyle({ color: 'rgba(0,0,255,0.6)', font: { weight: FontWeight.Bold } })
            .onChange(value => {
              this.selectedDate = new Date(value)
              const selectedMonth = this.selectedDate.getMonth() + 1
              const selectedDay = this.selectedDate.getDay()

              if (!this.monthNumArr.includes(selectedMonth)) {
                this.monthNumArr.push(selectedMonth)
              }

              if (!this.dayNumArr.includes(selectedDay)) {
                this.dayNumArr.push(selectedDay)
              }
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
          Text('*重复月份：')
            .width(110)

          TextInput({ text: this.monthNumArr.toString(), placeholder: '请输入有效月份数字,多个以英文逗号分割' })
            .placeholderFont({ size: 14 })
            .layoutWeight(1)
            .bindPopup(this.isMonthFormatError,
              { message: '请输入有效月份数字,多个以英文逗号分割', onWillDismiss: false })
            .onChange(value => {
              const numArr = value.split(',').map(item => Number(item.trim()))
              this.isMonthFormatError =
                numArr.some(item =>!Number.isInteger(item) || Number(item) > 12 || Number(item) < 0)

              if (!this.isMonthFormatError) {
                this.monthNumArr = numArr
              }
            })
        }
        .width('100%')

        Row() {
          Text('*重复天数：')
            .width(110)

          TextInput({ text: this.dayNumArr.toString(), placeholder: '请输入有效月内天数,多个以英文逗号分割' })
            .placeholderFont({ size: 14 })
            .layoutWeight(1)
            .bindPopup(this.isDayFormatError, { message: '多个月内天数以英文逗号分割', onWillDismiss: false })
            .onChange(value => {
              const numArr = value.split(',').map(item => Number(item.trim()))
              this.isDayFormatError =
                numArr.some(item =>!Number.isInteger(item) || Number(item) > 31 || Number(item) < 0)

              if (!this.isDayFormatError) {
                this.dayNumArr = numArr
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

          Button('设置日历提醒')
            .enabled(this.isReminderEnabled)
            .onClick(() => {
              this.setCalendarReminder()
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
