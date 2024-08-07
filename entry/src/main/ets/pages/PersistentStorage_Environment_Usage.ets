/*
 * AppStorage 应用自动创建单例对象，只有静态方法，数据在内存中
 * PersistentStorage UI框架自带，数据在磁盘中，直接使用：
 * 1，先调用 PersistentStorage.persistProp(key, value) 从设备的持久化文件中将数据存到 AppStorage 中，
 *    某个属性成为持久化属性
 * 1.1 如果磁盘中没有数据，使用 AppStorage 中属性数据，持久化到磁盘
 * 1.2 如果 AppStorage 中没有属性，则使用PersistentStorage.persistProp(key, value) 的默认值
 *    先持久化到磁盘，再同步保存到 AppStorage
 * 2. 组件中使用 @StorageLink 装饰成员属性，属性变化后，同步持久化磁盘中
 * */
import { RoutePagesInfo } from '../constants/pageTitleUrl';
import { PageHeader } from '../views/PageHeader';
import { promptAction } from '@kit.ArkUI';

PersistentStorage.persistProp('readingProgress', 0)
Environment.envProp('colorMode', ColorMode.LIGHT)
Environment.envProp('fontScale', 20)
Environment.envProp('fontWeightScale', FontWeight.Lighter)
Environment.envProp('languageCode', 'zh_CN')

@Entry
@Component
struct PersistentStorage_Environment_Usage {
  @StorageLink('readingProgress') readingProgress: number = 0;
  @StorageProp('colorMode') colorMode: ColorMode = ColorMode.LIGHT
  @StorageProp('fontScale') fontScale: number = 20
  @StorageProp('fontWeightScale') fontWeightScale: FontWeight = FontWeight.Lighter
  @StorageProp('languageCode') languageCode: string = 'zh_CN'
  @State @Watch('checkInputError') readingProgressCopy: number = 0
  @State isInputError: boolean = false
  defaultTitle = RoutePagesInfo.find(item => item.url.includes('PersistentStorage_Environment_Usage'))?.title

  checkInputError() {
    this.isInputError = this.readingProgressCopy < 0 || this.readingProgressCopy > 100
  }

  build() {
    Column({ space: 16 }) {
      PageHeader({ title: this.defaultTitle })

      Column({ space: 16 }) {
        Text('持久化文件中，存储的阅读进度：')

        Row({ space: 16 }) {
          TextInput({ text: this.readingProgress.toString(), placeholder: '输入要修改的进度值' })
            .type(InputType.Number)
            .layoutWeight(1)
            .onChange(value => {
              this.readingProgressCopy = Number(value)
            })

          Button('更新进度')
            .enabled(!this.isInputError)
            .onClick(() => {
              promptAction.showToast({ message: '更新成功' })
              this.readingProgress = this.readingProgressCopy
            })
        }
        .width('100%')

        Text('输入值范围为1-100之间')
          .fontColor('rgba(255,0,0,0.6)')
          .visibility(this.isInputError ? Visibility.Visible : Visibility.None)
      }
      .borderRadius(16)
      .border({ width: 1, color: Color.Gray })
      .padding(8)

      Column({ space: 16 }) {
        Text('读取设备 Environment 中的数据：')

        Column({ space: 10 }) {
          Text() {
            Span('颜色模式：')
            Span(this.colorMode === ColorMode.LIGHT ? '浅色模式' : '深色模式')
              .fontWeight(FontWeight.Bold)
          }

          Text() {
            Span('字体大小比例：')
            Span(this.fontScale.toString())
              .fontWeight(FontWeight.Bold)
          }

          Text() {
            Span('字重大小比例：')
            Span(this.fontWeightScale.toString())
              .fontWeight(FontWeight.Bold)
          }

          Text() {
            Span('语言：')
            Span(this.languageCode)
              .fontWeight(FontWeight.Bold)
          }
        }
        .width('100%')
      }
      .borderRadius(16)
      .border({ width: 1, color: Color.Gray })
      .padding(8)
    }
    .height('100%')
    .width('100%')
    .padding(16)
  }
}