import { INewsListItem } from '../../viewModels/newsCreateLoadRefresh'
import { promptAction } from '@kit.ArkUI'
import { fileUri, fileIo as fs } from '@kit.CoreFileKit'
import { JSON } from '@kit.ArkTS'
import { common } from '@kit.AbilityKit'
import { photoAccessHelper } from '@kit.MediaLibraryKit'

@ComponentV2
export struct PublishNews {
  @Local news = new INewsListItem()
  @Local selectImgUrl: string = ''
  navPathStack: NavPathStack = new NavPathStack()
  uiAbilityContext = getContext(this) as common.UIAbilityContext

  build() {
    NavDestination() {
      Column() {
        Column({ space: 8 }) {
          TextInput({ placeholder: '输入标题' })
            .backgroundColor(Color.White)
            .onChange(value => {
              if (value.trim()) {
                this.news.title = value.trim()
              }
            })

          Divider()
            .color('rgba(0,0,0,0.3)')

          TextArea({ placeholder: '输入内容' })
            .maxLines(5)
            .lineHeight(20)
            .height(120)
            .backgroundColor(Color.White)
            .onChange(value => {
              if (value.trim()) {
                this.news.content = value.trim()
              }
            })

          Row() {
            if (this.selectImgUrl) {
              Image(this.selectImgUrl)
                .width(80)
            }

            Text('+')
              .fontColor('rgba(0,0,0,0.2)')
              .backgroundColor('rgba(0,0,0,0.1)')
              .fontSize(40)
              .width(80)
              .height(80)
              .textAlign(TextAlign.Center)
              .borderRadius(16)
              .onClick(() => {
                const selectOptions = new photoAccessHelper.PhotoSelectOptions()
                selectOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE
                selectOptions.maxSelectNumber = 1

                const viewPicker = new photoAccessHelper.PhotoViewPicker()
                viewPicker.select(selectOptions)
                  .then((result: photoAccessHelper.PhotoSelectResult) => {
                    const selectedImgUrl = result.photoUris[0]
                    if (selectedImgUrl) {
                      const destFilePath = this.uiAbilityContext.filesDir + selectedImgUrl.split('/').reverse()[0]
                      console.log('test_tag destFilePath', destFilePath)

                      const destFileUriObj = fileUri.getUriFromPath(destFilePath)

                      try {
                        const selectedFile = fs.openSync(selectedImgUrl, fs.OpenMode.READ_ONLY)
                        const destFile =
                          fs.openSync(destFileUriObj.toString(), fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE)

                        const isExisted = fs.statSync(selectedFile.fd).ino === fs.statSync(destFile.fd).ino

                        if (!isExisted) {
                          // 将相册图片 复制到 应用沙箱文件夹, 用于后续网络上传到服务器
                          fs.copyFileSync(selectedFile.fd, destFile.fd)
                          promptAction.showToast({ message: '复制文件成功', duration: 4000 })
                        } else {
                          console.log('test_tag 沙箱目录中已存在 destFilePath', destFilePath)
                        }

                        this.selectImgUrl = destFileUriObj.toString()
                        this.news.icon = destFileUriObj.toString()
                        console.log('test_tag destFileUriObj.toString()', destFileUriObj.toString())

                        fs.closeSync(selectedFile)
                        fs.closeSync(destFile)
                      } catch (error) {
                        console.error('test_tag copyFileSync error', JSON.stringify(error))
                      }
                    }
                    console.log('test_tag viewPicker result', JSON.stringify(result))
                  })
                  .catch((error: Object) => {
                    console.error('test_tag viewPicker result error', JSON.stringify(error))
                  })
              })
          }
        }
        .width('100%')
        .alignItems(HorizontalAlign.Start)
        .backgroundColor(Color.White)
        .borderRadius(8)
        .padding(8)

        Blank()

        Button('发布')
          .width(100)
          .enabled(!!this.news.title && !!this.news.content && !!this.news.icon)
          .onClick(() => {
            this.navPathStack.pop(this.news)
          })
      }
      .height('100%')
      .padding({
        left: 16,
        right: 16,
        bottom: 16
      })
    }
    .title('新闻发布')
    .backgroundColor('rgba(0,0,0,0.1)')
    .onReady(context => {
      this.navPathStack = context.pathStack
    })
    .onBackPressed(() => {
      promptAction.showDialog({
        message: '输入内容将会被保存，在您下次发布新闻时显示(待实现)，确定要放弃本次新闻发布么？',
        buttons: [
          {
            text: '取消',
            color: 'blue'
          },
          {
            text: '确定',
            color: 'red'
          }
        ]
      })
        .then(clickResult => {
          if (clickResult.index === 1) {
            this.navPathStack.pop()
          }
        })
      return true
    })
  }
}