export class PermissionsConstants {
  /* user_grant（用户授权）*/
  static readonly LOCATION = 'ohos.permission.LOCATION' // 定位-精确
  static readonly APPROXIMATELY_LOCATION = 'ohos.permission.APPROXIMATELY_LOCATION' // 定位-模糊
  static readonly LOCATION_IN_BACKGROUND = 'ohos.permission.LOCATION_IN_BACKGROUND' // 定位-后台
  static readonly CAMERA = 'ohos.permission.CAMERA' // 相机
  static readonly MICROPHONE = 'ohos.permission.MICROPHONE' // 麦克风
  static readonly READ_CONTACTS = 'ohos.permission.READ_CONTACTS' // 通讯录-读
  static readonly WRITE_CONTACTS = 'ohos.permission.WRITE_CONTACTS' // 通讯录-写
  static readonly READ_CALENDAR = 'ohos.permission.READ_CALENDAR' // 日历-读
  static readonly WRITE_CALENDAR = 'ohos.permission.WRITE_CALENDAR' // 日历-写
  static readonly WRITE_IMAGEVIDEO = 'ohos.permission.WRITE_IMAGEVIDEO' // 图片视频-写
  static readonly READ_IMAGEVIDEO = 'ohos.permission.READ_IMAGEVIDEO' // 图片视频-读
  static readonly MEDIA_LOCATION = 'ohos.permission.MEDIA_LOCATION' // 多媒体-本地
  static readonly WRITE_AUDIO = 'ohos.permission.WRITE_AUDIO' // 音频-写
  static readonly READ_AUDIO = 'ohos.permission.READ_AUDIO' // 音频-读
  static readonly READ_MEDIA = 'ohos.permission.READ_MEDIA' // 文件-读
  static readonly WRITE_MEDIA = 'ohos.permission.WRITE_MEDIA' // 文件-写
  static readonly APP_TRACKING_CONSENT = 'ohos.permission.APP_TRACKING_CONSENT' // 广告标识符
  static readonly DISTRIBUTED_DATASYNC = 'ohos.permission.DISTRIBUTED_DATASYNC' // 多设备协同
  static readonly ACCESS_BLUETOOTH = 'ohos.permission.ACCESS_BLUETOOTH' // 使用蓝牙能力
  static readonly READ_PASTEBOARD = 'ohos.permission.READ_PASTEBOARD' // 剪贴板
  static readonly READ_HEALTH_DATA = 'ohos.permission.READ_HEALTH_DATA' // 健康数据
  static readonly ACTIVITY_MOTION = 'ohos.permission.ACTIVITY_MOTION' // 健身运动

  /* system_grant（系统授权）*/
  static readonly INTERNET = 'ohos.permission.INTERNET' // 网路请求
  static readonly GET_NETWORK_INFO = 'ohos.permission.GET_NETWORK_INFO' // 网络信息-读
  static readonly GET_WIFI_INFO = 'ohos.permission.GET_WIFI_INFO' // WIFI信息-读
  static readonly GYROSCOPE = 'ohos.permission.GYROSCOPE' // 陀螺仪传感器
  static readonly ACCELEROMETER = 'ohos.permission.ACCELEROMETER' // 加速度传感器
}
