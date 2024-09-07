export class NavPathStackManager {
  private navPathStack: NavPathStack | undefined = undefined
  private static navPathStackManager: NavPathStackManager | undefined = undefined

  // Navigation 导航根容器组件中，初始化 NavPathStackManager 对象，并获取该对象
  static getNavPathStackManager() {
    if (!NavPathStackManager.navPathStackManager) {
      NavPathStackManager.navPathStackManager = new NavPathStackManager()
    }
    return NavPathStackManager.navPathStackManager
  }

  // Navigation 导航根容器组件中，保存 UIAbilityContext 内 NavPathStack 单例对象
  setNavPathStack(navPathStack: NavPathStack): boolean {
    if (!this.navPathStack) {
      this.navPathStack = navPathStack
      return true
    }
    return false
  }

  // NavDestination 子路由容器组件内，获取 NavPathStack 单例对象
  getNavPathStack(): NavPathStack {
    return this.navPathStack as NavPathStack
  }
}