import { IPageForIndex } from '../viewModels';
import { router } from '@kit.ArkUI';

@Entry
@ComponentV2
struct Index {
  pages: IPageForIndex[] = [
    {
      title: '启动ability获取结果',
      url: 'pages/StartAbilityForResult'
    },
    {
      title: 'Navigation组件导航路由实践',
      url: 'pages/NavigationPage'
    },
    {
      title: '相册选择/下拉刷新/上滑加载',
      url: 'pages/NewsCreateLoadRefresh'
    },
    {
      title: '自定义二次确认弹窗',
      url: 'pages/CustomDialogPage'
    },
    {
      title: 'ActionSheet列表选择对话框',
      url: 'pages/ActionSheetOrListSelectDialog'
    },
    {
      title: 'openLink启动其他模块的Ability进入指定页面',
      url: 'pages/StartAbilitySpecifiedPage'
    },
    {
      title: '文本选择器/文本选择对话框',
      url: 'pages/TextPickerPage'
    },
    {
      title: 'Refresh刷新容器使用示例',
      url: 'pages/RefreshContainerComponentExample'
    },
    {
      title: '使用HSP动态共享包中的资源',
      url: 'pages/UseHspContent'
    }
  ];

  build() {
    List({ space: 16 }) {
      Repeat(this.pages)
        .each((data) => {
          ListItem() {
            Text((data.index ?? 0) + 1 + `. ${data.item.title}`)
              .fontSize(18)
              .fontColor(Color.Blue)
              .onClick(() => {
                router.pushUrl({ url: data.item.url, params: { title: data.item.title } })
              })
          }
        })
    }
    .padding(20)
    .height('100%')
    .width('100%')
  }
}