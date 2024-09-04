import { image } from '@kit.ImageKit'
import { common } from '@kit.AbilityKit'

export class ImageUtil {
  // 参数 UIAbilityContext 和 资源，必须在同一个Ability 内
  static async getPixmapFromMedia(
    UiAbilityContext: common.UIAbilityContext,
    resource: Resource
  ): Promise<image.PixelMap> {
    let uint8Array = await UiAbilityContext?.resourceManager?.getMediaContent({
      bundleName: resource.bundleName,
      moduleName: resource.moduleName,
      id: resource.id
    })
    let imageSource = image.createImageSource(uint8Array.buffer.slice(0, uint8Array.buffer.byteLength))
    let createdPixelMap: image.PixelMap = await imageSource.createPixelMap({
      desiredPixelFormat: image.PixelMapFormat.RGBA_8888
    })

    await imageSource.release()
    return createdPixelMap
  }
}