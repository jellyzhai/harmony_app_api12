export class ResourceManagerHSP1 {
  static getColorByName(name: string): Resource {
    return $r(`app.string.${name}`)
  }

  static getStringByName(name: string): Resource {
    return $r(`app.string.${name}`)
  }

  static getPictureByName(name: string): Resource {
    return $r(`app.media.${name}`)
  }

  /*
   * @param name { string }, 直接传入rawfile 文件夹下资源名称，包含扩展屏
   * */
  static getRawfileByName(name: string): Resource {
    return $rawfile(name)
  }
}