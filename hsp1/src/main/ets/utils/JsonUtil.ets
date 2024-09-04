import { JSON } from '@kit.ArkTS'

/*
 * 将json 字符串格式化，可以使用text组件，显示正确格式
 * */
export class JsonUtil {
  static formatJsonString(jsonStr: string): string {
    let str = ''
    try {
      JSON.parse(jsonStr)

      for (let index = 0; index < jsonStr.length; index++) {
        if (jsonStr[index] === ',') {
          str += jsonStr[index]
          str += '\n'
        } else if (jsonStr[index] === ':') {
          str += jsonStr[index]
          str += ' '
        } else if (jsonStr[index] === '{') {
          if (jsonStr[index+1] === '}') {
            str += jsonStr[index]
          } else {
            str += jsonStr[index]
            str += '\n'
          }
        } else if (jsonStr[index] === '}') {
          if (jsonStr[index-1] === '{') {
            str += jsonStr[index]
          } else {
            str += '\n'
            str += jsonStr[index]
          }
        } else {
          str += jsonStr[index]
        }
      }
      return str
    } catch (e) {
      console.error('test_tag 传入的参数不是正确格式的json字符串')
      return ''
    }
  }
}