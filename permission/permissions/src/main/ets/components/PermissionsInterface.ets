import { Permissions } from '@kit.AbilityKit';
import  { AuthorityAlertParams } from './AuthorityAlertParams'

export interface PermissionsInterface {
  /**
   * 查询通知权限
   * @param isApplyPermissions  是否申请权限
   * @param isShowAlert         是否显示引导弹窗
   * @param alertParams         引导弹窗的文案
   * @returns
   */
  checkNotificationPermissions(isApplyPermissions?: boolean, isShowAlert?: boolean, alertParams?: AuthorityAlertParams): Promise<boolean>

  /**
   * 查询单个权限
   * @param permissionName      权限名称
   * @param isApplyPermissions  是否申请权限
   * @param permissions         申请的权限名称（可以多个子权限一起申请）
   * @param isShowAlert         是否显示引导弹窗
   * @param alertParams         引导弹窗的文案
   * @returns
   */
  checkPermissions(permissionName: Permissions, isApplyPermissions?: boolean, permissions?: Array<Permissions>, isShowAlert?: boolean, alertParams?: AuthorityAlertParams): Promise<boolean>

  /**
   * 查询多个权限
   * @param permissions         查询的权限名称列表
   * @param isApplyPermissions  是否申请权限
   * @returns
   */
  checkPermissionsList(permissions: Array<Permissions>, isApplyPermissions?: boolean): Promise<boolean[]>

  /**
   * 权限引导弹窗
   * @param permissionName      权限名称
   * @param alertParams         引导弹窗的文案
   * @returns
   */
  showGotoSettingAlertView(permissionName: Permissions, alertParams?: AuthorityAlertParams): void
}