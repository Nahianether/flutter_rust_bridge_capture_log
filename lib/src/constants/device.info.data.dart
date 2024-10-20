import 'package:device_info_plus/device_info_plus.dart';

Map<String, dynamic> readLinuxDeviceInfo(LinuxDeviceInfo data) {
  return <String, dynamic>{
    'name': data.name,
    'version': data.version,
    'id': data.id,
    'idLike': data.idLike,
    'versionCodename': data.versionCodename,
    'versionId': data.versionId,
    'prettyName': data.prettyName,
    'buildId': data.buildId,
    'variant': data.variant,
    'variantId': data.variantId,
    'machineId': data.machineId,
  };
}

Map<String, dynamic> readMacOsDeviceInfo(MacOsDeviceInfo data) {
  return <String, dynamic>{
    'computerName': data.computerName,
    'hostName': data.hostName,
    'arch': data.arch,
    'model': data.model,
    'kernelVersion': data.kernelVersion,
    'majorVersion': data.majorVersion,
    'minorVersion': data.minorVersion,
    'patchVersion': data.patchVersion,
    'osRelease': data.osRelease,
    'activeCPUs': data.activeCPUs,
    'memorySize': data.memorySize,
    'cpuFrequency': data.cpuFrequency,
    'systemGUID': data.systemGUID,
  };
}

Map<String, dynamic> readWindowsDeviceInfo(WindowsDeviceInfo data) {
  return <String, dynamic>{
    // 'numberOfCores': data.numberOfCores,
    'computerName': data.computerName,
    // 'systemMemoryInMegabytes': data.systemMemoryInMegabytes,
    'userName': data.userName,
    // 'majorVersion': data.majorVersion,
    // 'minorVersion': data.minorVersion,
    // 'buildNumber': data.buildNumber,
    // 'platformId': data.platformId,
    // 'csdVersion': data.csdVersion,
    // 'servicePackMajor': data.servicePackMajor,
    // 'servicePackMinor': data.servicePackMinor,
    // 'suitMask': data.suitMask,
    // 'productType': data.productType,
    // 'reserved': data.reserved,
    // 'buildLab': data.buildLab,
    // 'buildLabEx': data.buildLabEx,
    // 'digitalProductId': data.digitalProductId,
    // 'displayVersion': data.displayVersion,
    // 'editionId': data.editionId,
    'installDate': data.installDate,
    // 'productId': data.productId,
    'productName': data.productName,
    // 'registeredOwner': data.registeredOwner,
    // 'releaseId': data.releaseId,
    'deviceId': data.deviceId,
  };
}