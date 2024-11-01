import { AuthorityAlertParams } from './AuthorityAlertParams';
import { PermissionsInterface } from './PermissionsInterface';
import { PermissionsConstants } from './PermissionsConstants';
import { abilityAccessCtrl, bundleManager, common, PermissionRequestResult, Permissions, Want } from '@kit.AbilityKit';
import notificationManager from '@ohos.notificationManager';
import { BusinessError } from '@kit.BasicServicesKit';
import { JSON } from '@kit.ArkTS';

export class PermissionsManager implements PermissionsInterface {

  private static instance: PermissionsManager
  public static getInstance(): PermissionsManager {
    if (!PermissionsManager.instance) {
      PermissionsManager.instance = new PermissionsManager()
    }
    return PermissionsManager.instance
  }

  public async checkNotificationPermissions(isApplyPermissions?: boolean, isShowAlert?: boolean, alertParams?: AuthorityAlertParams): Promise<boolean> {
    try {
      let grantStatus = await notificationManager.isNotificationEnabled()
      if (!grantStatus) {
        if (isShowAlert && !alertParams) {
          alertParams = {
            alertTitle: '通知权限未开启',
            alertContent: '你可以点击\"去设置\"，开启通知权限。'
          }
        }

        if (isApplyPermissions) {
          await notificationManager.requestEnableNotification()
          grantStatus = await notificationManager.isNotificationEnabled()
          if (!grantStatus && isShowAlert) {
            this.showAlertView(alertParams!)
          }
          return grantStatus
        } else {
          if (isShowAlert) {
            this.showAlertView(alertParams!)
          }
          return false
        }
      } else {
        return true
      }
    } catch (e) {
      if (isShowAlert && e.code === 1600004) {
        this.showAlertView(alertParams!)
      }
      return false
    }
  }

  public async checkPermissions(permissionName: Permissions, isApplyPermissions?: boolean, permissions?: Array<Permissions>, isShowAlert?: boolean, alertParams?: AuthorityAlertParams): Promise<boolean> {
    try {
      const bundleInfo: bundleManager.BundleInfo = await bundleManager.getBundleInfoForSelf(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION)
      const tokenId = bundleInfo.appInfo.accessTokenId
      const atManager = abilityAccessCtrl.createAtManager()
      const state = atManager.checkAccessTokenSync(tokenId, permissionName)

      if (state !== abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED) {
        if (isApplyPermissions && permissions) {
          const context = AppStorage.get('ability_context') as common.UIAbilityContext
          const result: PermissionRequestResult = await atManager.requestPermissionsFromUser(context, permissions)
          const authResults: Array<number> = result.authResults
          const grantStatus: boolean = (authResults[0] === 0)
          if (!grantStatus && isShowAlert) {
            this.showGotoSettingAlertView(permissionName, alertParams)
          }
          return grantStatus
        } else {
          if (isShowAlert) {
            this.showGotoSettingAlertView(permissionName, alertParams)
          }
          return false
        }
      } else {
        return true
      }
    } catch (e) {
      if (isShowAlert) {
        this.showGotoSettingAlertView(permissionName, alertParams)
      }
      return false
    }
  }

  public async checkPermissionsList(permissions: Permissions[], isApplyPermissions?: boolean): Promise<boolean[]> {
    try {
      const bundleInfo: bundleManager.BundleInfo = await bundleManager.getBundleInfoForSelf(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION)
      const tokenId = bundleInfo.appInfo.accessTokenId
      const atManager = abilityAccessCtrl.createAtManager()

      const statusResults: boolean[] = []
      for (let permissionName of permissions) {
        const state = atManager.checkAccessTokenSync(tokenId, permissionName)
        const grantStatus = (state === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED)
        statusResults.push(grantStatus)
      }

      if (isApplyPermissions) {
        const context = AppStorage.get('ability_context') as common.UIAbilityContext
        const requestResult: PermissionRequestResult = await atManager.requestPermissionsFromUser(context, permissions)
        const authResults: Array<number> = requestResult.authResults

        if (authResults.length === permissions.length) {
          for (let i=0; i<permissions.length; i++) {
            statusResults[i] = (authResults[i] === 0)
          }
        }
      }
      return statusResults
    } catch (e) {
      const statusResults: boolean[] = []
      for (let i=0; i<permissions.length; i++) {
        statusResults.push(false);
      }
      return statusResults
    }
  }

  public showGotoSettingAlertView(permissionName: Permissions, alertParams?: AuthorityAlertParams): void {
    if (!alertParams) {
      alertParams = this.defaultAlertParams(permissionName)
    }
    this.showAlertView(alertParams)
  }

  private showAlertView(alertParams: AuthorityAlertParams): void {
    AlertDialog.show({
      title: alertParams.alertTitle,
      message: alertParams.alertContent,
      autoCancel: false,
      alignment: DialogAlignment.Center,
      primaryButton: {
        value: alertParams.cancelBtnTitle ?? '取消',
        action: () => { }
      },
      secondaryButton: {
        value: alertParams.confirmBtnTitle ?? '去设置',
        action: () => {
          this.gotoSetting()
        }
      }
    });
  }

  private async gotoSetting(): Promise<void> {
    const context = AppStorage.get('ability_context') as common.UIAbilityContext
    const bundleFlags = bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION
    const bundleParam = bundleManager.getBundleInfoForSelfSync(bundleFlags)
    const bundleId = bundleParam.name
    let wantInfo: Want = {
      bundleName: 'com.huawei.hmos.settings',
      abilityName: 'com.huawei.hmos.settings.MainAbility',
      uri: 'application_info_entry',
      parameters: {
        pushParams: bundleId
      }
    }
    context.startAbility(wantInfo).catch((error: BusinessError) => {
      console.error(`startAbility-error: ${JSON.stringify(error)}`)
    })
  }

  private defaultAlertParams(permissionName: Permissions): AuthorityAlertParams {
    let title: string = '权限未开启'
    let content: string | undefined

    switch (permissionName) {
      case PermissionsConstants.LOCATION:
      case PermissionsConstants.APPROXIMATELY_LOCATION:
      case PermissionsConstants.LOCATION_IN_BACKGROUND:
        title = '定位权限未开启'
        content = '你可以点击\"去设置\"，开启定位权限。'
        break
      case PermissionsConstants.ACCESS_BLUETOOTH:
        title = '蓝牙权限未开启'
        content = '你可以点击\"去设置\"，开启蓝牙权限。'
        break
      case PermissionsConstants.READ_CALENDAR:
      case PermissionsConstants.WRITE_CALENDAR:
        title = '日历权限未开启'
        content = '你可以点击\"去设置\"，开启日历权限。'
        break
      case PermissionsConstants.READ_CONTACTS:
      case PermissionsConstants.WRITE_CONTACTS:
        title = '通讯录权限未开启'
        content = '你可以点击\"去设置\"，开启通讯录权限。'
        break
      case PermissionsConstants.WRITE_IMAGEVIDEO:
      case PermissionsConstants.READ_IMAGEVIDEO:
        title = '相册权限未开启'
        content = '你可以点击\"去设置\"，开启相册权限。'
        break
      case PermissionsConstants.READ_AUDIO:
      case PermissionsConstants.WRITE_AUDIO:
        title = '音频权限未开启'
        content = '你可以点击\"去设置\"，开启音频权限。'
        break
      case PermissionsConstants.CAMERA:
        title = '相机权限未开启'
        content = '你可以点击\"去设置\"，开启相机权限。'
        break
      case PermissionsConstants.MEDIA_LOCATION:
      case PermissionsConstants.READ_MEDIA:
      case PermissionsConstants.WRITE_MEDIA:
        title = '多媒体权限未开启'
        content = '你可以点击\"去设置\"，开启多媒体权限。'
        break
      case PermissionsConstants.MICROPHONE:
        title = '麦克风权限未开启'
        content = '你可以点击\"去设置\"，开启麦克风权限。'
        break
      case PermissionsConstants.APP_TRACKING_CONSENT:
        title = '应用跟踪权限未开启'
        content = '你可以点击\"去设置\"，开启应用跟踪权限。'
        break
      case PermissionsConstants.DISTRIBUTED_DATASYNC:
        title = '多设备协同权限未开启'
        content = '你可以点击\"去设置\"，开启多设备协同权限。'
        break
      case PermissionsConstants.READ_PASTEBOARD:
        title = '剪贴板权限未开启'
        content = '你可以点击\"去设置\"，开启剪贴板权限。'
        break
      case PermissionsConstants.ACTIVITY_MOTION:
        title = '运动权限未开启'
        content = '你可以点击\"去设置\"，开启运动权限。'
        break
      case PermissionsConstants.READ_HEALTH_DATA:
        title = '健康权限未开启'
        content = '你可以点击\"去设置\"，开启健康权限。'
        break
      default:
        break
    }

    return {
      alertTitle: title,
      alertContent: content,
      cancelBtnTitle: '取消',
      confirmBtnTitle: '去设置'
    }
  }
}