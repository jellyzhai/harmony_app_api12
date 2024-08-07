import { RouterParams } from '../viewModels/common';
import { PageHeader } from '../views/PageHeader'
import { router } from '@kit.ArkUI';

const localStorageFromEntry = LocalStorage.getShared()
const nameFromEntryKey = 'nameFromEntry'

@Entry()
@ComponentV2
struct LocalStorageUsageTest {
  private routerParams = router.getParams() as RouterParams;
  @Local nameFromEntry: string | undefined = ''
  @Local newNameFromEntry: string = ''

  updateNameFromEntry() {
    this.nameFromEntry = localStorageFromEntry.get(nameFromEntryKey)
  }

  aboutToAppear(): void {
    this.updateNameFromEntry()
    // console.log('test_tag localStorageFromEntry keys', localStorageFromEntry.keys().next().value)
  }

  onPageShow(): void {
    this.updateNameFromEntry()
  }

  build() {
    Column({ space: 16 }) {
      PageHeader({
        title: (this.routerParams as RouterParams).title
      })

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
    }
    .height('100%')
    .width('100%')
    .padding(16)
    .backgroundColor('rgba(0,0,0,0.1)')
  }
}