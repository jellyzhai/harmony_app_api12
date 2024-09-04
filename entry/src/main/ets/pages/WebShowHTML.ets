import { RoutePagesInfo } from '../constants/pageTitleUrl';
import { PageHeader } from '../views/PageHeader';
import { webview } from '@kit.ArkWeb';
import { promptAction, router } from '@kit.ArkUI';
import { JSON, url } from '@kit.ArkTS';
import { ILogin } from 'hsp1';
import { IWebMessage } from '../models/common';
import { request } from '@kit.BasicServicesKit';
import { fileIo, fileUri } from '@kit.CoreFileKit';
import { common } from '@kit.AbilityKit';

class UsingInH5 {
  goLoginPage?: (...params: ESObject[]) => void

  constructor(goLoginPage: (...params: ESObject[]) => void) {
    this.goLoginPage = goLoginPage
  }
}

@Entry
@ComponentV2
struct WebShowHTML {
  defaultTitle = RoutePagesInfo.find(item => item.url.includes('WebShowHTML'))?.title
  readonly loginUrl = '@bundle:com.example.harmony_app_api12/hsp1/ets/pages/Login'
  webController = new webview.WebviewController()
  // 该服务器地址，需要与 https://github.com/jellyzhai/express_server_for_hap 项目中，bin/www 文件中的 hostIp 一致
  readonly webUrl = 'http://192.168.1.100:3000'
  readonly originImgName = 'screen_shot_win11.png'
  readonly imgUrl = this.webUrl + '/images/' + this.originImgName
  context = getContext(this) as common.UIAbilityContext
  usingInH5 = new UsingInH5(() => {
  })
  loginDialogId = -1
  @Local message: string = 'Hello World';
  @Local pageProgress: number = 0;
  @Local userAgent: string = ''
  @Local uploadProgress: number = 0
  @Local downloadProgress: number = 0
  @Local appCacheFiles: string[] = []
  @Local downloadedImgUrl: string = ''
  @Local serverError: string = ''
  @Local isPageVisible: boolean = false

  @Computed
  get displayedAppCacheFiles() {
    return this.appCacheFiles.map(name => {
      const filePath = this.context.cacheDir + '/' + name
      return name + (fileIo.statSync(filePath).isFile() ? '(文件)' : '(文件夹)')
    })
  }

  aboutToAppear(): void {
    // 设置服务器连接超时时间(s)
    webview.WebviewController.setConnectionTimeout(10)

    // 用于 Html 中 window 调用
    this.usingInH5.goLoginPage = this.goLoginPage.bind(this)

    this.setDownloadedImgUrl(this.context.cacheDir + '/' + this.originImgName)
    this.getAppCacheFiles()
  }

  onPageShow(): void {
    const routerParams = router.getParams() as ILogin
    const username = routerParams?.username
    const password = routerParams?.password

    console.log('test_tag username', username)

    if (username && password) {
      webview.WebCookieManager.configCookieSync(this.webUrl,
        `username=${encodeURI(username)}`)
      webview.WebCookieManager.configCookieSync(this.webUrl,
        `password=${password}`)

      // this.webController.removeCache(true)
      // 登录后文本大小异常，【待解决】
      this.webController.refresh()
    }
  }

  getAppCacheFiles() {
    this.appCacheFiles = fileIo.listFileSync(this.context.cacheDir, { recursion: false })
  }

  showLoginTipDialog() {
    promptAction.openCustomDialog({ builder: () => this.CustomLoginDialog(), autoCancel: false }).then(id => {
      this.loginDialogId = id
    })
  }

  establishCommunicationWithHtml() {
    const ports = this.webController.createWebMessagePorts()

    ports[0].onMessageEvent(result => {
      if (IWebMessage.NotLogin === result) {
        this.showLoginTipDialog()
      }
    })

    // 将 Web 消息端口发布到 html
    this.webController.postMessage('init_message_port', [ports[1]], this.webUrl)
  }

  removeCacheFiles() {
    const rmFilePromises = this.appCacheFiles.map(name => {
      const path = `${this.context.cacheDir}/${name}`

      if (!fileIo.accessSync(path, fileIo.AccessModeType.EXIST)) {
        return Promise.resolve()
      }

      return fileIo.stat(path).then((stat: fileIo.Stat) => {
        if (stat.isDirectory()) {
          return fileIo.rmdir(path)
        }
        return fileIo.unlink(path)
      })
    })

    Promise.all(rmFilePromises)
      .then(() => {
        this.getAppCacheFiles()
        promptAction.showToast({ message: '清除缓存成功！' })
      })
      .catch((reason: ESObject) => {
        console.log('test_tag 删除失败', JSON.stringify(reason))
        promptAction.showToast({ message: '清除缓存失败！' })
      })
  }

  setDownloadedImgUrl(filePath: string) {
    this.downloadedImgUrl = fileUri.getUriFromPath(filePath)
  }

  downloadImg() {
    request.downloadFile(this.context, { url: this.imgUrl, filePath: this.context.cacheDir + '/' + this.originImgName })
      .then((task: request.DownloadTask) => {
        task.on('progress', (receivedSize, totalSize) => {
          this.downloadProgress = Math.ceil((receivedSize / totalSize) * 100)
        })

        task.on('complete', async () => {
          this.getAppCacheFiles()
          const downloadInfo = await task.getTaskInfo()
          this.setDownloadedImgUrl(downloadInfo.filePath)
        })

        task.on('fail', (errNum) => {
          promptAction.showToast({ message: '下载失败：' + errNum })
        })
      })
      .catch((reason: ESObject) => {
        promptAction.showToast({
          message: '下载失败了：' + ((reason && typeof reason === 'object') ? JSON.stringify(reason) : 'error')
        })
      })
  }

  uploadImg() {
    const uploadConfig: request.UploadConfig = {
      url: this.webUrl + '/upload',
      method: 'POST',
      header: { Accept: 'image/png' },
      files: [{
        filename: this.originImgName, // multipart提交时，请求头中的文件名。
        name: 'file', // 【必填】提交 multipart 时，表单项的字段名称。默认值为 file。
        /*
         * 文件的本地存储路径。
         * 仅支持"internal"协议类型，仅支持"internal://cache/"，即调用方（即传入的context）对应的缓存路径context.cacheDir。
         * */
        uri: `internal://cache/${this.originImgName}`,
        type: 'png' // 上传文件的扩展类型
      }],
      data: [{ name: 'image', value: 'screenshot' }] // POST 请求的body 数据
    }

    request.uploadFile(this.context, uploadConfig)
      .then((task: request.UploadTask) => {
        task.on('complete', () => {
          promptAction.showToast({ message: '上传成功！' })
        })

        task.on('fail', () => {
          promptAction.showToast({ message: '上传失败！' })
        })

        task.on('progress', (uploadedSize, totalSize) => {
          this.uploadProgress = Math.ceil((uploadedSize / totalSize) * 100)
          promptAction.showToast({ message: '上传进度：' + this.uploadProgress + '%' })
        })
      })
  }

  goLoginPage(dataFromH5?: ESObject) {
    router.pushUrl({ url: this.loginUrl, params: { fromPageUrl: 'pages/WebShowHTML' } })
  }

  @Builder
  CustomLoginDialog() {
    Column({ space: 20 }) {
      Text('请先登录 Web 网站再操作。')

      Row() {
        Button('稍后登录')
          .onClick(() => {
            promptAction.closeCustomDialog(this.loginDialogId)
          })

        Button('去登录')
          .onClick(() => {
            promptAction.closeCustomDialog(this.loginDialogId)
            this.goLoginPage()
          })
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceEvenly)
    }
    .width('100%')
    .padding(16)
  }

  build() {
    Column({ space: 16 }) {
      PageHeader({ title: this.defaultTitle })

      Scroll() {
        Column({ space: 8 }) {
          Text('web组件使用和上传下载功能，需要与 https://github.com/jellyzhai/express_server_for_hap 项目配合使用')

          Column() {
            Progress({ value: this.pageProgress, total: 100, type: ProgressType.Linear })
              .margin({ left: 8, right: 8 })
              .color('rgba(0,0,255,0.7)')
              .privacySensitive(true)

            Stack({ alignContent: Alignment.Center }) {
              Web({ src: this.webUrl, controller: this.webController })
                .overScrollMode(OverScrollMode.NEVER)
                .zoomAccess(false)
                .constraintSize({ maxHeight: '30%' })
                .javaScriptAccess(true)
                .border({ width: 1 })
                .margin({ left: 8, right: 8 })
                .javaScriptProxy({
                  controller: this.webController,
                  object: this.usingInH5,
                  name: 'objFromHap',
                  methodList: ['goLoginPage']
                })
                .onErrorReceive((event: OnErrorReceiveEvent) => { // 服务器错误
                  if (event.error.getErrorInfo().toLowerCase() !== 'err_cache_miss') {
                    promptAction.showToast({ message: event.error.getErrorInfo() })
                  }
                  this.serverError = event.error.getErrorInfo()
                })
                .onHttpErrorReceive((event: OnHttpErrorReceiveEvent) => { // 接口错误
                  if (event.response.getResponseData()) {
                    promptAction.showToast({ message: event.response.getResponseData(), duration: 3000 })
                  }
                })
                .onAlert((event: OnAlertEvent) => {
                  console.log('test_tag onAlert OnAlertEvent', JSON.stringify(event))
                  if (event.message) {
                    promptAction.showDialog({ message: event.message })
                  }
                  return false
                })
                .onPrompt((event: OnPromptEvent) => {
                  if (event.message) {
                    promptAction.showToast({ message: event.message, duration: 2000, bottom: 60 })
                  }
                  return false
                })
                .onConsole((event: OnConsoleEvent) => {
                  console.log('test_tag onConsole', JSON.stringify(event))
                  return false
                })
                .onControllerAttached(() => {
                  console.log('test_tag onControllerAttached')
                })
                .onLoadIntercept((interceptEvent) => {
                  const method = interceptEvent.data.getRequestMethod()
                  const requestHeader = interceptEvent.data.getRequestHeader()
                  const url = interceptEvent.data.getRequestUrl()
                  const isRedirect = interceptEvent.data.isRedirect()
                  console.log('test_tag onLoadIntercept', isRedirect, method, url, JSON.stringify(requestHeader))
                  // 返回true表示阻止此次加载，否则允许此次加载
                  return false
                })/*.onInterceptRequest((requestEvent) => {
            console.log('test_tag onInterceptRequest', JSON.stringify(requestEvent))
            const response = new WebResourceResponse()
            response.setResponseCode(200)
            response.setResponseMimeType('text/html')
            response.setResponseEncoding('utf-8')
            response.setResponseData('<div style="font-size: 40px">拦截后，返回的数据<div/>')
            return response
          })*/
                .onPageBegin((beginEvent) => {
                  console.log('test_tag onPageBegin', JSON.stringify(beginEvent))
                })
                .onProgressChange((progressEvent) => {
                  this.pageProgress = progressEvent.newProgress
                  console.log('test_tag onProgressChange', JSON.stringify(progressEvent))
                })
                .onPageVisible((visibleEvent) => {
                  this.isPageVisible = true
                  this.establishCommunicationWithHtml()
                  console.log('test_tag onPageVisible', JSON.stringify(visibleEvent))
                })
                .onPageEnd((endEvent) => {
                  console.log('test_tag onPageEnd', JSON.stringify(endEvent))
                })

              if (this.pageProgress !== 100) {
                LoadingProgress()
                  .width(30)
              } else if (!this.isPageVisible && this.serverError) {
                Text(this.serverError.toLowerCase() === 'err_timed_out' ? `服务器地址 ${this.webUrl} 未启动或超时` :
                this.serverError)
                  .width('90%')
                  .fontWeight(FontWeight.Bold)
              }
            }
          }

          Column({ space: 8 }) {
            Text('用户代理：\n' + this.userAgent)

            Button('WebViewController.getUserAgent()')
              .onClick(() => {
                this.userAgent = this.webController.getUserAgent()
              })
          }
          .padding(8)
          .backgroundColor('rgba(0,0,0,0.1)')
          .borderRadius(8)

          Button('删除web网址的cookie')
            .onClick(() => {
              webview.WebCookieManager.clearAllCookiesSync()
              this.webController.refresh()
            })

          Column({ space: 8 }) {
            Button('清除应用缓存文件(包括文件夹)')
              .onClick(() => {
                this.downloadedImgUrl = ''
                this.removeCacheFiles()
              })

            Text(`应用缓存文件夹中文件：${this.displayedAppCacheFiles}`)
          }
          .padding(8)
          .backgroundColor('rgba(0,0,0,0.1)')
          .borderRadius(8)

          Column({ space: 8 }) {
            Button('下载图片')
              .onClick(() => {
                if (fileIo.accessSync(`${this.context.cacheDir}/${this.originImgName}`,
                  fileIo.AccessModeType.EXIST)) {
                  promptAction.showToast({ message: `要下載的 ${this.originImgName} 文件已存在` })
                  return
                }
                this.downloadImg()
              })

            Text(`下载进度：${this.downloadProgress}%`)

            if (this.downloadedImgUrl) {
              Image(this.downloadedImgUrl)
                .width(300)
            }
          }
          .padding(8)
          .backgroundColor('rgba(0,0,0,0.1)')
          .borderRadius(8)

          Column({ space: 8 }) {
            Button('上传图片(上传的文件必须在应用沙箱的缓存文件夹)')
              .onClick(() => {
                if (this.uploadProgress === 100) {
                  promptAction.showToast({ message: `${this.originImgName} 文件已上传` })
                  return
                }
                this.uploadImg()
              })

            Text(`上传进度：${this.uploadProgress}%`)
          }
          .padding(8)
          .backgroundColor('rgba(0,0,0,0.1)')
          .borderRadius(8)
        }
        .layoutWeight(1)
      }
      .layoutWeight(1)
    }
    .height('100%')
    .width('100%')
  }
}