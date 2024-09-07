import { RoutePagesInfo } from '../constants/pageTitleUrl';
import { PageHeader } from '../views/PageHeader';
import { emitter } from '@kit.BasicServicesKit';

@Entry
@ComponentV2
struct EmitterUsage {
  defaultTitle = RoutePagesInfo.find(item => item.url.includes('EmitterUsage'))?.title
  innerEvent: emitter.InnerEvent = { eventId: 101 }
  @Local dataFromParentForEmit: string = ''
  @Local dataFromParent: string = ''
  eventId: string = 'emitter2'
  @Local dataFromParentForEmit2: string = ''
  @Local dataFromParent2: string = ''

  aboutToAppear(): void {
    emitter.on(this.innerEvent, (data) => {
      this.dataFromParent = (data.data as Record<'result', string>).result
    })

    emitter.on(this.eventId, (result: emitter.GenericEventData<string>) => {
      this.dataFromParent2 = result.data as string
    })
  }

  build() {
    Column({ space: 16 }) {
      PageHeader({ title: this.defaultTitle })

      Column({ space: 8 }) {
        Text('使用emitter.InnerEvent 对象，发布订阅事件')

        Column({ space: 16 }) {
          Text('父组件使用Emitter发事件')

          Row({ space: 16 }) {
            TextInput({ placeholder: '输入要传递的时间数据' })
              .layoutWeight(1)
              .onChange(value => {
                this.dataFromParentForEmit = value
              })

            Button('发送事件')
              .enabled(!!this.dataFromParentForEmit.trim())
              .onClick(() => {
                const eventData: emitter.EventData = {
                  data: { result: this.dataFromParentForEmit }
                }
                emitter.emit(this.innerEvent, eventData)
              })
          }
          .width('100%')
        }
        .width('100%')
        .borderRadius(16)
        .border({ width: 1, color: Color.Gray })
        .padding(8)

        Column({ space: 16 }) {
          Text('子组件使用emitter.InnerEvent接收事件：\n' + this.dataFromParent)
        }
        .width('100%')
        .borderRadius(16)
        .border({ width: 1, color: Color.Gray })
        .padding(8)
      }

      Column({ space: 8 }) {
        Text('使用 eventId 字符串，发布订阅取消事件')

        Column({ space: 16 }) {
          Text('父组件使用Emitter发事件')

          Row({ space: 16 }) {
            TextInput({ text: $$this.dataFromParentForEmit2, placeholder: '输入要传递的时间数据' })
              .layoutWeight(1)

            Button('发送事件')
              .enabled(!!this.dataFromParentForEmit2.trim())
              .onClick(() => {
                emitter.emit(this.eventId, { data: this.dataFromParentForEmit2 })
                this.dataFromParentForEmit2 = ''
              })
          }
          .width('100%')
        }
        .width('100%')
        .borderRadius(16)
        .border({ width: 1, color: Color.Gray })
        .padding(8)

        Column({ space: 16 }) {
          Text('子组件使用eventId接收事件：\n' + this.dataFromParent2)
        }
        .width('100%')
        .borderRadius(16)
        .border({ width: 1, color: Color.Gray })
        .padding(8)
      }
    }
    .height('100%')
    .width('100%')
    .padding(16)
  }
}