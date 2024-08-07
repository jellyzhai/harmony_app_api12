import { RouterParams } from '../viewModels/common';
import { PageHeader } from '../views/PageHeader'
import { router } from '@kit.ArkUI';

const localStorageFromEntry = LocalStorage.getShared()
const nameFromEntryKey = 'nameFromEntry'

interface Person {
  name: string,
  age: number,
  hobbies: string[]
}

const localStorage: LocalStorage =
  new LocalStorage({ name: 'jelly', age: 18, hobbies: ['sing', 'coding', 'sport'] } as Person)

@Entry()
@ComponentV2
struct LocalStorageUsage {
  private routerParams = router.getParams() as RouterParams;
  @Local nameFromEntry: string | undefined = ''
  @Local age: number | undefined = localStorage.get('age')
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

      Column({ space: 16 }) {
        Row({ space: 16 }) {
          Text('姓名')
            .fontSize(16)
            .width('33.33%')
            .fontWeight(FontWeight.Bold)
          Text('年龄')
            .fontSize(16)
            .width('33.33%')
            .fontWeight(FontWeight.Bold)
          Text('爱好')
            .fontSize(16)
            .width('33.33%')
            .fontWeight(FontWeight.Bold)
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceEvenly)

        Row() {
          Text('this.name')
            .fontSize(16)
            .width('33.33%')
          Text((this.age as number).toString())
            .fontSize(16)
            .width('33.33%')
          Text('this.hobbies')
            .fontSize(16)
            .width('33.33%')
            .maxLines(3)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .wordBreak(WordBreak.BREAK_ALL)
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceEvenly)
      }
      .width('100%')
      .borderRadius(16)

      Row() {
        Button('修改年龄')
          .onClick(() => {
            localStorage.set('age', 20)
            this.age = localStorage.get('age')
          })
      }
    }
    .height('100%')
    .width('100%')
    .padding(16)
    .backgroundColor('rgba(0,0,0,0.1)')
  }
}