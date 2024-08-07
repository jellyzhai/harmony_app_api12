import { RouterParams } from '../viewModels/common';
import { PageHeader } from '../views/PageHeader'
import { router } from '@kit.ArkUI';
import { RoutePagesInfo } from '../constants/pageTitleUrl';

const localStorageFromEntry = LocalStorage.getShared()
const nameFromEntryKey = 'nameFromEntry'

@Entry()
@ComponentV2
struct LocalStorageUsageTest {
  private routerParams = router.getParams() as RouterParams;
  defaultTitle = RoutePagesInfo.find(item => item.url.includes('LocalStorageUsageTest'))?.title
  @Local nameFromEntry: string | undefined = ''
  @Local newNameFromEntry: string = ''
  @Local localStorageKeys: string[] = []

  updateNameFromEntry() {
    this.nameFromEntry = localStorageFromEntry.get(nameFromEntryKey)
  }

  aboutToAppear(): void {
    this.updateNameFromEntry()

    for (const key of localStorageFromEntry.keys()) {
      this.localStorageKeys.push(key)
    }
    // console.log('test_tag localStorageFromEntry keys', localStorageFromEntry.keys().next().value)
  }

  onPageShow(): void {
    this.updateNameFromEntry()
  }

  build() {
    Column({ space: 16 }) {
      PageHeader({ title: this.defaultTitle })

      Text(`
      当前路由页面中，LocalStorage.getShared() 获取的LocalStorage对象，是当前页面所在windowStage 所在的ability 中，
      window.loadContent方法传递的LocalStorage对象;
      当前页面 被哪个ability窗口舞台加载的页面 给唤醒压入路由栈，LocalStorage.getShared()就属于哪个ability`
      )
        .fontWeight(FontWeight.Bold)

      Column({ space: 16 }) {
        TextInput({ placeholder: '输入nameFromEntry属性的值' })
          .onChange(value => {
            this.newNameFromEntry = value.trim()
          })
        Button('修改localStorageFromEntry中nameFromEntry值')
          .enabled(!!this.newNameFromEntry)
          .onClick((event: ClickEvent) => {
            localStorageFromEntry.set(nameFromEntryKey, this.newNameFromEntry)
            this.updateNameFromEntry()
          })

        Text('nameFromEntry: ' + this.nameFromEntry)
      }
      .border({ width: 1 })
      .borderRadius(16)
      .width('100%')
      .padding(16)

      Text('LocalStorage.getShared 返回的共享LocalStorage中的keys: \n' + this.localStorageKeys.toString())
    }
    .height('100%')
    .width('100%')
    .padding(16)
    .backgroundColor('rgba(0,0,0,0.1)')
  }
}