# harmonyos-permission

## 基于HarmonyOS的Permission服务，实现APP权限相关的API封装，单个/多个权限的查询与申请，引导用户跳转设置页开启权限。

### 具体的代码调用参考 EntryAbility 中的代码示例，或者 PermissionsInterface 的接口注释

```typescript
// 用AppStorage存储AbilityContext
AppStorage.setOrCreate('ability_context', this.context)

// 单个权限查询与申请
PermissionsManager.getInstance().checkPermissions(PermissionsConstants.LOCATION, true, [PermissionsConstants.LOCATION, PermissionsConstants.APPROXIMATELY_LOCATION], true).then((status: boolean) => {
  console.debug(`location_status: ${status}`)
})

// 通知权限查询与申请
PermissionsManager.getInstance().checkNotificationPermissions(true, true).then((status => {
  console.debug(`notification_status: ${status}`)
}))

// 多个权限查询与申请
PermissionsManager.getInstance().checkPermissionsList([PermissionsConstants.READ_CALENDAR, PermissionsConstants.WRITE_CALENDAR], true).then((statusResults: boolean[]) => {
  console.debug(`calendar_statusResults: ${statusResults}`)
})

// 引导用户开启权限
PermissionsManager.getInstance().showGotoSettingAlertView(PermissionsConstants.LOCATION)
```
