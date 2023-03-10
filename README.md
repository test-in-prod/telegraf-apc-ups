# telegraf, in a Docker container, for APC UPS monitoring

This just uses the `telegraf` container to monitor an APC UPS via SNMPv1 (network management card / NMC).
[Search around for PowerNet-MIB](https://www.apc.com/us/en/product/SFPMIB441/powernet-mib-v4-4-1/) from APC for latest updates.

Refer to telegraf.conf file for example usage (or just copy-paste if you're lazy). Note: some properties refer to AP9619, which supports environmental monitoring (like a temperature dongle).
You might want to cut that out if you just have a plain old management card. It also assumes you've already configured the NMC to enable SNMPv1 with a "public" community string (I'd recommend leaving access as Read Only).

Refer to SNMP walk dumps below for figuring out stats you're interested in.

## SNMP Walk the UPS (main UPS stats)

```shell
$ snmpwalk -c public -v 1 -t 30 <ups hostname or IP> .1.3.6.1.4.1.318.1.1.1
```

Example output:

```
PowerNet-MIB::upsBasicIdentModel.0 = STRING: "Smart-UPS 2200 XL"
PowerNet-MIB::upsBasicIdentName.0 = STRING: "Rack"
PowerNet-MIB::upsAdvIdentFirmwareRevision.0 = STRING: "690.18.D"
PowerNet-MIB::upsAdvIdentDateOfManufacture.0 = STRING: "10/20/08"
PowerNet-MIB::upsAdvIdentSerialNumber.0 = STRING: "[REDACTED]"
PowerNet-MIB::upsAdvIdentFirmwareRevision2.0 = ""
PowerNet-MIB::upsBasicBatteryStatus.0 = INTEGER: batteryNormal(2)
PowerNet-MIB::upsBasicBatteryTimeOnBattery.0 = Timeticks: (0) 0:00:00.00
PowerNet-MIB::upsBasicBatteryLastReplaceDate.0 = STRING: "11/01/22"
PowerNet-MIB::upsAdvBatteryCapacity.0 = Gauge32: 100
PowerNet-MIB::upsAdvBatteryTemperature.0 = Gauge32: 11
PowerNet-MIB::upsAdvBatteryRunTimeRemaining.0 = Timeticks: (366000) 1:01:00.00
PowerNet-MIB::upsAdvBatteryReplaceIndicator.0 = INTEGER: noBatteryNeedsReplacing(1)
PowerNet-MIB::upsAdvBatteryNumOfBattPacks.0 = INTEGER: 1
PowerNet-MIB::upsAdvBatteryNumOfBadBattPacks.0 = INTEGER: -1
PowerNet-MIB::upsAdvBatteryNominalVoltage.0 = INTEGER: -1
PowerNet-MIB::upsAdvBatteryActualVoltage.0 = INTEGER: 55
PowerNet-MIB::upsAdvBatteryCurrent.0 = INTEGER: 0
PowerNet-MIB::upsAdvTotalDCCurrent.0 = INTEGER: 0
PowerNet-MIB::upsHighPrecBatteryCapacity.0 = Gauge32: 1000
PowerNet-MIB::upsHighPrecBatteryTemperature.0 = Gauge32: 117
PowerNet-MIB::upsHighPrecBatteryActualVoltage.0 = INTEGER: 550
PowerNet-MIB::upsBasicInputPhase.0 = INTEGER: 1
PowerNet-MIB::upsAdvInputLineVoltage.0 = Gauge32: 120
PowerNet-MIB::upsAdvInputMaxLineVoltage.0 = Gauge32: 120
PowerNet-MIB::upsAdvInputMinLineVoltage.0 = Gauge32: 119
PowerNet-MIB::upsAdvInputFrequency.0 = Gauge32: 60
PowerNet-MIB::upsAdvInputLineFailCause.0 = INTEGER: selfTest(9)
PowerNet-MIB::upsHighPrecInputLineVoltage.0 = Gauge32: 1209
PowerNet-MIB::upsHighPrecInputMaxLineVoltage.0 = Gauge32: 1209
PowerNet-MIB::upsHighPrecInputMinLineVoltage.0 = Gauge32: 1195
PowerNet-MIB::upsHighPrecInputFrequency.0 = Gauge32: 600
PowerNet-MIB::upsBasicOutputStatus.0 = INTEGER: onLine(2)
PowerNet-MIB::upsBasicOutputPhase.0 = INTEGER: 1
PowerNet-MIB::upsAdvOutputVoltage.0 = Gauge32: 120
PowerNet-MIB::upsAdvOutputFrequency.0 = Gauge32: 60
PowerNet-MIB::upsAdvOutputLoad.0 = Gauge32: 50
PowerNet-MIB::upsAdvOutputCurrent.0 = Gauge32: 8
PowerNet-MIB::upsHighPrecOutputVoltage.0 = Gauge32: 1209
PowerNet-MIB::upsHighPrecOutputFrequency.0 = Gauge32: 600
PowerNet-MIB::upsHighPrecOutputLoad.0 = Gauge32: 500
PowerNet-MIB::upsHighPrecOutputCurrent.0 = Gauge32: 88
PowerNet-MIB::upsBasicConfigNumDevices.0 = INTEGER: 4
PowerNet-MIB::deviceIndex.1 = INTEGER: 1
PowerNet-MIB::deviceIndex.2 = INTEGER: 2
PowerNet-MIB::deviceIndex.3 = INTEGER: 3
PowerNet-MIB::deviceIndex.4 = INTEGER: 4
PowerNet-MIB::deviceName.1 = STRING: "Device 1"
PowerNet-MIB::deviceName.2 = STRING: "Device 2"
PowerNet-MIB::deviceName.3 = STRING: "Device 3"
PowerNet-MIB::deviceName.4 = STRING: "Device 4"
PowerNet-MIB::vaRating.1 = INTEGER: 0
PowerNet-MIB::vaRating.2 = INTEGER: 0
PowerNet-MIB::vaRating.3 = INTEGER: 0
PowerNet-MIB::vaRating.4 = INTEGER: 0
PowerNet-MIB::acceptThisDevice.1 = INTEGER: yes(1)
PowerNet-MIB::acceptThisDevice.2 = INTEGER: yes(1)
PowerNet-MIB::acceptThisDevice.3 = INTEGER: yes(1)
PowerNet-MIB::acceptThisDevice.4 = INTEGER: yes(1)
PowerNet-MIB::upsAdvConfigRatedOutputVoltage.0 = INTEGER: 120
PowerNet-MIB::upsAdvConfigHighTransferVolt.0 = INTEGER: 127
PowerNet-MIB::upsAdvConfigLowTransferVolt.0 = INTEGER: 106
PowerNet-MIB::upsAdvConfigAlarm.0 = INTEGER: timed(1)
PowerNet-MIB::upsAdvConfigAlarmTimer.0 = Timeticks: (0) 0:00:00.00
PowerNet-MIB::upsAdvConfigMinReturnCapacity.0 = INTEGER: 0
PowerNet-MIB::upsAdvConfigSensitivity.0 = INTEGER: high(4)
PowerNet-MIB::upsAdvConfigLowBatteryRunTime.0 = Timeticks: (12000) 0:02:00.00
PowerNet-MIB::upsAdvConfigReturnDelay.0 = Timeticks: (0) 0:00:00.00
PowerNet-MIB::upsAdvConfigShutoffDelay.0 = Timeticks: (9000) 0:01:30.00
PowerNet-MIB::upsAdvConfigUpsSleepTime.0 = Timeticks: (0) 0:00:00.00
PowerNet-MIB::upsAdvConfigSetEEPROMDefaults.0 = INTEGER: noSetEEPROMDefaults(1)
PowerNet-MIB::dipSwitchIndex.1 = INTEGER: 1
PowerNet-MIB::dipSwitchStatus.1 = INTEGER: on(1)
PowerNet-MIB::upsAdvConfigBattExhaustThresh.0 = Timeticks: (0) 0:00:00.00
PowerNet-MIB::upsAdvConfigPassword.0 = Hex-STRING: 01 00 00 00
PowerNet-MIB::apcUpsConfigFieldIndex.1 = INTEGER: 1
PowerNet-MIB::apcUpsConfigFieldIndex.2 = INTEGER: 2
PowerNet-MIB::apcUpsConfigFieldIndex.3 = INTEGER: 3
PowerNet-MIB::apcUpsConfigFieldIndex.4 = INTEGER: 4
PowerNet-MIB::apcUpsConfigFieldIndex.5 = INTEGER: 5
PowerNet-MIB::apcUpsConfigFieldIndex.6 = INTEGER: 6
PowerNet-MIB::apcUpsConfigFieldIndex.7 = INTEGER: 7
PowerNet-MIB::apcUpsConfigFieldIndex.8 = INTEGER: 8
PowerNet-MIB::apcUpsConfigFieldIndex.9 = INTEGER: 9
PowerNet-MIB::apcUpsConfigFieldOID.1 = OID: PowerNet-MIB::upsAdvConfigRatedOutputVoltage
PowerNet-MIB::apcUpsConfigFieldOID.2 = OID: PowerNet-MIB::upsAdvConfigHighTransferVolt
PowerNet-MIB::apcUpsConfigFieldOID.3 = OID: PowerNet-MIB::upsAdvConfigLowTransferVolt
PowerNet-MIB::apcUpsConfigFieldOID.4 = OID: PowerNet-MIB::upsAdvConfigAlarmTimer
PowerNet-MIB::apcUpsConfigFieldOID.5 = OID: PowerNet-MIB::upsAdvConfigMinReturnCapacity
PowerNet-MIB::apcUpsConfigFieldOID.6 = OID: PowerNet-MIB::upsAdvConfigLowBatteryRunTime
PowerNet-MIB::apcUpsConfigFieldOID.7 = OID: PowerNet-MIB::upsAdvConfigReturnDelay
PowerNet-MIB::apcUpsConfigFieldOID.8 = OID: PowerNet-MIB::upsAdvConfigShutoffDelay
PowerNet-MIB::apcUpsConfigFieldOID.9 = OID: PowerNet-MIB::upsAdvConfigBattExhaustThresh
PowerNet-MIB::apcUpsConfigFieldValueRange.1 = STRING: "Not Configurable"
PowerNet-MIB::apcUpsConfigFieldValueRange.2 = STRING: "127, 130, 133, 136 Vac"
PowerNet-MIB::apcUpsConfigFieldValueRange.3 = STRING: "097, 100, 103, 106 Vac"
PowerNet-MIB::apcUpsConfigFieldValueRange.4 = STRING: "0 , 30 seconds"
PowerNet-MIB::apcUpsConfigFieldValueRange.5 = STRING: "00, 15, 30, 45, 60, 75, 90 percent"
PowerNet-MIB::apcUpsConfigFieldValueRange.6 = STRING: "02, 05, 08, 11, 14, 17, 20, 23 minutes"
PowerNet-MIB::apcUpsConfigFieldValueRange.7 = STRING: "000, 060, 120, 180, 240, 300, 360, 420 seconds"
PowerNet-MIB::apcUpsConfigFieldValueRange.8 = STRING: "000, 090, 180, 270, 360, 450, 540, 630 seconds"
PowerNet-MIB::apcUpsConfigFieldValueRange.9 = STRING: "Not Configurable"
PowerNet-MIB::upsAdvConfigBattCabAmpHour.0 = INTEGER: 0
PowerNet-MIB::upsAdvConfigPositionSelector.0 = INTEGER: unknown(1)
PowerNet-MIB::upsAdvConfigOutputFreqRange.0 = INTEGER: unknown(1)
PowerNet-MIB::upsAdvConfigUPSFail.0 = INTEGER: unknown(1)
PowerNet-MIB::upsAdvConfigAlarmRedundancy.0 = INTEGER: 0
PowerNet-MIB::upsAdvConfigAlarmLoadOver.0 = INTEGER: 0
PowerNet-MIB::upsAdvConfigAlarmRuntimeUnder.0 = INTEGER: 0
PowerNet-MIB::upsAdvConfigVoutReporting.0 = INTEGER: unknown(1)
PowerNet-MIB::upsAdvConfigNumExternalBatteries.0 = INTEGER: 1
PowerNet-MIB::upsAdvConfigSimpleSignalShutdowns.0 = INTEGER: disabled(2)
PowerNet-MIB::upsAdvConfigMaxShutdownTime.0 = INTEGER: 2
PowerNet-MIB::upsAsiUpsControlServerRequestShutdown.0 = INTEGER: 0
PowerNet-MIB::upsAdvConfigMinReturnRuntime.0 = Timeticks: (0) 0:00:00.00
PowerNet-MIB::upsAdvConfigBasicSignalLowBatteryDuration.0 = Timeticks: (0) 0:00:00.00
PowerNet-MIB::upsAdvConfigBypassPhaseLockRequired.0 = INTEGER: unknown(1)
PowerNet-MIB::upsAdvConfigBypassToleranceSetting.0 = INTEGER: unknown(1)
PowerNet-MIB::upsBasicControlConserveBattery.0 = INTEGER: noTurnOffUps(1)
PowerNet-MIB::upsAdvControlUpsOff.0 = INTEGER: noTurnUpsOff(1)
PowerNet-MIB::upsAdvControlRebootShutdownUps.0 = INTEGER: noRebootShutdownUps(1)
PowerNet-MIB::upsAdvControlUpsSleep.0 = INTEGER: noPutUpsToSleep(1)
PowerNet-MIB::upsAdvControlSimulatePowerFail.0 = INTEGER: noSimulatePowerFailure(1)
PowerNet-MIB::upsAdvControlFlashAndBeep.0 = INTEGER: noFlashAndBeep(1)
PowerNet-MIB::upsAdvControlTurnOnUPS.0 = INTEGER: noTurnOnUPS(1)
PowerNet-MIB::upsAdvControlBypassSwitch.0 = INTEGER: noBypassSwitch(1)
PowerNet-MIB::upsAdvTestDiagnosticSchedule.0 = INTEGER: biweekly(2)
PowerNet-MIB::upsAdvTestDiagnostics.0 = INTEGER: noTestDiagnostics(1)
PowerNet-MIB::upsAdvTestDiagnosticsResults.0 = INTEGER: ok(1)
PowerNet-MIB::upsAdvTestLastDiagnosticsDate.0 = STRING: "02/11/2023"
PowerNet-MIB::upsAdvTestRuntimeCalibration.0 = INTEGER: noPerformCalibration(1)
PowerNet-MIB::upsAdvTestCalibrationResults.0 = INTEGER: ok(1)
PowerNet-MIB::upsAdvTestCalibrationDate.0 = STRING: "11/23/2022"
PowerNet-MIB::upsCommStatus.0 = INTEGER: ok(1)
PowerNet-MIB::upsPhaseResetMaxMinValues.0 = INTEGER: none(1)
PowerNet-MIB::upsPhaseNumInputs.0 = INTEGER: 0
PowerNet-MIB::upsPhaseNumOutputs.0 = INTEGER: 0
PowerNet-MIB::upsSCGMembershipGroupNumber.0 = INTEGER: 1
PowerNet-MIB::upsSCGActiveMembershipStatus.0 = INTEGER: disabledSCG(2)
PowerNet-MIB::upsSCGPowerSynchronizationDelayTime.0 = INTEGER: 120
PowerNet-MIB::upsSCGReturnBatteryCapacityOffset.0 = INTEGER: 10
PowerNet-MIB::upsSCGMultiCastIP.0 = IpAddress: 224.0.0.100
PowerNet-MIB::upsSCGNumOfGroupMembers.0 = INTEGER: 0
PowerNet-MIB::upsBasicStateOutputState.0 = STRING: "0001010000000000001000000000000000000000000000000000000000000000"
PowerNet-MIB::upsAdvStateAbnormalConditions.0 = STRING: "00000000000000000000000000000000"
PowerNet-MIB::upsAdvStateSymmetra3PhaseSpecificFaults.0 = ""
PowerNet-MIB::upsAdvStateDP300ESpecificFaults.0 = ""
PowerNet-MIB::upsAdvStateSymmetraSpecificFaults.0 = ""
PowerNet-MIB::upsAdvStateSmartUPSSpecificFaults.0 = ""
PowerNet-MIB::upsAdvStateSystemMessages.0 = ""
PowerNet-MIB::upsOutletGroupStatusTableSize.0 = INTEGER: 1
PowerNet-MIB::upsOutletGroupConfigTableSize.0 = INTEGER: 1
PowerNet-MIB::upsOutletGroupControlTableSize.0 = INTEGER: 0
PowerNet-MIB::upsDiagIMTableSize.0 = INTEGER: 0
PowerNet-MIB::upsDiagPMTableSize.0 = INTEGER: 1
PowerNet-MIB::upsDiagPMIndex.1 = INTEGER: 1
PowerNet-MIB::upsDiagPMStatus.1 = INTEGER: unknown(1)
PowerNet-MIB::upsDiagPMFirmwareRev.1 = STRING: "NA"
PowerNet-MIB::upsDiagPMHardwareRev.1 = STRING: "NA"
PowerNet-MIB::upsDiagPMSerialNum.1 = STRING: "NA"
PowerNet-MIB::upsDiagPMManufactureDate.1 = STRING: "NA"
PowerNet-MIB::upsDiagBatteryTableSize.0 = INTEGER: 0
PowerNet-MIB::upsDiagSubSysFrameTableSize.0 = INTEGER: 1
PowerNet-MIB::upsDiagSubSysFrameIndex.1 = INTEGER: 1
PowerNet-MIB::upsDiagSubSysFrameType.1 = INTEGER: unknown(1)
PowerNet-MIB::upsDiagSubSysFrameFirmwareRev.1 = ""
PowerNet-MIB::upsDiagSubSysFrameHardwareRev.1 = ""
PowerNet-MIB::upsDiagSubSysFrameSerialNum.1 = ""
PowerNet-MIB::upsDiagSubSysFrameManufactureDate.1 = ""
PowerNet-MIB::upsDiagSubSysIntBypSwitchTableSize.0 = INTEGER: 1
PowerNet-MIB::upsDiagSubSysIntBypSwitchFrameIndex.1 = INTEGER: 0
PowerNet-MIB::upsDiagSubSysIntBypSwitchIndex.1 = INTEGER: 1
PowerNet-MIB::upsDiagSubSysIntBypSwitchStatus.1 = INTEGER: 0
PowerNet-MIB::upsDiagSubSysIntBypSwitchFirmwareRev.1 = STRING: "Not available"
PowerNet-MIB::upsDiagSubSysIntBypSwitchHardwareRev.1 = STRING: "Not available"
PowerNet-MIB::upsDiagSubSysIntBypSwitchSerialNum.1 = STRING: "Not available"
PowerNet-MIB::upsDiagSubSysIntBypSwitchManufactureDate.1 = STRING: "Not available"
PowerNet-MIB::upsDiagSubSysBattMonitorTableSize.0 = INTEGER: 1
PowerNet-MIB::upsDiagSubSysBattMonitorFrameIndex.1 = INTEGER: 1
PowerNet-MIB::upsDiagSubSysBattMonitorIndex.1 = INTEGER: 1
PowerNet-MIB::upsDiagSubSysBattMonitorStatus.1 = INTEGER: notInstalled(2)
PowerNet-MIB::upsDiagSubSysBattMonitorFirmwareRev.1 = STRING: "Not available"
PowerNet-MIB::upsDiagSubSysBattMonitorHardwareRev.1 = STRING: "Not available"
PowerNet-MIB::upsDiagSubSysBattMonitorSerialNum.1 = STRING: "Not available"
PowerNet-MIB::upsDiagSubSysBattMonitorManufactureDate.1 = STRING: "Not available"
PowerNet-MIB::upsDiagSubSysExternalSwitchGearTableSize.0 = INTEGER: 1
PowerNet-MIB::upsDiagSubSysExternalSwitchGearFrameIndex.1 = INTEGER: 0
PowerNet-MIB::upsDiagSubSysExternalSwitchGearIndex.1 = INTEGER: 1
PowerNet-MIB::upsDiagSubSysExternalSwitchGearStatus.1 = INTEGER: notInstalled(2)
PowerNet-MIB::upsDiagSubSysExternalSwitchGearFirmwareRev.1 = STRING: "Not available"
PowerNet-MIB::upsDiagSubSysExternalSwitchGearHardwareRev.1 = STRING: "Not available"
PowerNet-MIB::upsDiagSubSysExternalSwitchGearSerialNum.1 = STRING: "Not available"
PowerNet-MIB::upsDiagSubSysExternalSwitchGearManufactureDate.1 = STRING: "Not available"
PowerNet-MIB::upsDiagSubSysDisplayInterfaceCardTableSize.0 = INTEGER: 1
PowerNet-MIB::upsDiagSubSysDisplayInterfaceCardFrameIndex.1 = INTEGER: 0
PowerNet-MIB::upsDiagSubSysDisplayInterfaceCardIndex.1 = INTEGER: 1
PowerNet-MIB::upsDiagSubSysDisplayInterfaceCardStatus.1 = INTEGER: notInstalled(2)
PowerNet-MIB::upsDiagSubSysDCCircuitBreakerTableSize.0 = INTEGER: 1
PowerNet-MIB::upsDiagSubSysDCCircuitBreakerFrameIndex.1 = INTEGER: 0
PowerNet-MIB::upsDiagSubSysDCCircuitBreakerIndex.1 = INTEGER: 1
PowerNet-MIB::upsDiagSubSysDCCircuitBreakerStatus.1 = INTEGER: notInstalled(2)
PowerNet-MIB::upsDiagSubSysSystemPowerSupplyTableSize.0 = INTEGER: 1
PowerNet-MIB::upsDiagSubSysSystemPowerSupplyFrameIndex.1 = INTEGER: 1
PowerNet-MIB::upsDiagSubSysSystemPowerSupplyIndex.1 = INTEGER: 1
PowerNet-MIB::upsDiagSubSysSystemPowerSupplyStatus.1 = INTEGER: unknown(1)
PowerNet-MIB::upsDiagSubSysSystemPowerSupplyFirmwareRev.1 = STRING: "Not available"
PowerNet-MIB::upsDiagSubSysSystemPowerSupplyHardwareRev.1 = STRING: "Not available"
PowerNet-MIB::upsDiagSubSysSystemPowerSupplySerialNum.1 = STRING: "Not available"
PowerNet-MIB::upsDiagSubSysSystemPowerSupplyManufactureDate.1 = STRING: "Not available"
PowerNet-MIB::upsDiagSubSysXRCommunicationCardTableSize.0 = INTEGER: 1
PowerNet-MIB::upsDiagSubSysXRCommunicationCardFrameIndex.1 = INTEGER: 0
PowerNet-MIB::upsDiagSubSysXRCommunicationCardIndex.1 = INTEGER: 1
PowerNet-MIB::upsDiagSubSysXRCommunicationCardStatus.1 = INTEGER: notInstalled(2)
PowerNet-MIB::upsDiagSubSysXRCommunicationCardFirmwareRev.1 = STRING: "Not available"
PowerNet-MIB::upsDiagSubSysXRCommunicationCardSerialNum.1 = STRING: "Not available"
PowerNet-MIB::upsDiagSubSysExternalPowerFrameBoardTableSize.0 = INTEGER: 1
PowerNet-MIB::upsDiagSubSysExternalPowerFrameBoardFrameIndex.1 = INTEGER: 0
PowerNet-MIB::upsDiagSubSysExternalPowerFrameBoardIndex.1 = INTEGER: 1
PowerNet-MIB::upsDiagSubSysExternalPowerFrameBoardStatus.1 = INTEGER: notInstalled(2)
PowerNet-MIB::upsDiagSubSysChargerTableSize.0 = INTEGER: 0
PowerNet-MIB::upsDiagSubSysInverterTableSize.0 = INTEGER: 1
PowerNet-MIB::upsDiagSubSysInverterFrameIndex.1 = INTEGER: 1
PowerNet-MIB::upsDiagSubSysInverterIndex.1 = INTEGER: 1
PowerNet-MIB::upsDiagSubSysInverterStatus.1 = INTEGER: unknown(1)
PowerNet-MIB::upsDiagSubSysInverterFirmwareRev.1 = STRING: "Not available"
PowerNet-MIB::upsDiagSubSysInverterHardwareRev.1 = STRING: "Not available"
PowerNet-MIB::upsDiagSubSysInverterSerialNum.1 = STRING: "Not available"
PowerNet-MIB::upsDiagSubSysInverterManufactureDate.1 = STRING: "Not available"
PowerNet-MIB::upsDiagSubSysPowerFactorCorrectionTableSize.0 = INTEGER: 1
PowerNet-MIB::upsDiagSubSysPowerFactorCorrectionFrameIndex.1 = INTEGER: 1
PowerNet-MIB::upsDiagSubSysPowerFactorCorrectionIndex.1 = INTEGER: 1
PowerNet-MIB::upsDiagSubSysPowerFactorCorrectionStatus.1 = INTEGER: unknown(1)
PowerNet-MIB::upsDiagSubSysPowerFactorCorrectionFirmwareRev.1 = STRING: "Not available"
PowerNet-MIB::upsDiagSubSysPowerFactorCorrectionHardwareRev.1 = STRING: "Not available"
PowerNet-MIB::upsDiagSubSysPowerFactorCorrectionSerialNum.1 = STRING: "Not available"
PowerNet-MIB::upsDiagSubSysPowerFactorCorrectionManufactureDate.1 = STRING: "Not available"
PowerNet-MIB::upsDiagSwitchGearStatus.0 = INTEGER: 0
PowerNet-MIB::upsDiagSwitchGearInputSwitchStatus.0 = INTEGER: 0
PowerNet-MIB::upsDiagSwitchGearOutputSwitchStatus.0 = INTEGER: 0
PowerNet-MIB::upsDiagSwitchGearBypassSwitchStatus.0 = INTEGER: 0
PowerNet-MIB::upsDiagMCCBBoxStatus.0 = INTEGER: unknown(1)
PowerNet-MIB::upsDiagTransformerStatus.0 = INTEGER: 0
PowerNet-MIB::upsDiagComBusInternalMIMStatus.0 = INTEGER: unknown(1)
PowerNet-MIB::upsDiagComBusInternalRIMStatus.0 = INTEGER: unknown(1)
PowerNet-MIB::upsDiagComBusMIMtoRIMStatus.0 = INTEGER: unknown(1)
PowerNet-MIB::upsDiagComBusExternalMIMStatus.0 = INTEGER: unknown(1)
PowerNet-MIB::upsDiagComBusExternalRIMStatus.0 = INTEGER: unknown(1)
```

## snmpwalk for environmental monitor (e.g. AP9619 with a temperature probe)

```shell
$ snmpwalk -c public -v 1 -t 30 192.168.1.16 PowerNet-MIB::environmentalMonitor
```

```
PowerNet-MIB::emConfigProbeNumber.1 = INTEGER: 1
PowerNet-MIB::emConfigProbeNumber.2 = INTEGER: 2
PowerNet-MIB::emConfigProbeName.1 = STRING: "Temp Sensor 1"
PowerNet-MIB::emConfigProbeName.2 = STRING: "Temp Sensor 2"
PowerNet-MIB::emConfigProbeHighTempThreshold.1 = INTEGER: 40
PowerNet-MIB::emConfigProbeHighTempThreshold.2 = INTEGER: 40
PowerNet-MIB::emConfigProbeLowTempThreshold.1 = INTEGER: 10
PowerNet-MIB::emConfigProbeLowTempThreshold.2 = INTEGER: 10
PowerNet-MIB::emConfigProbeTempUnits.1 = INTEGER: celsius(1)
PowerNet-MIB::emConfigProbeTempUnits.2 = INTEGER: celsius(1)
PowerNet-MIB::emConfigProbeHighHumidThreshold.1 = INTEGER: 60
PowerNet-MIB::emConfigProbeHighHumidThreshold.2 = INTEGER: 60
PowerNet-MIB::emConfigProbeLowHumidThreshold.1 = INTEGER: 30
PowerNet-MIB::emConfigProbeLowHumidThreshold.2 = INTEGER: 30
PowerNet-MIB::emConfigProbeHighTempEnable.1 = INTEGER: disabled(1)
PowerNet-MIB::emConfigProbeHighTempEnable.2 = INTEGER: disabled(1)
PowerNet-MIB::emConfigProbeLowTempEnable.1 = INTEGER: disabled(1)
PowerNet-MIB::emConfigProbeLowTempEnable.2 = INTEGER: disabled(1)
PowerNet-MIB::emConfigProbeHighHumidEnable.1 = INTEGER: disabled(1)
PowerNet-MIB::emConfigProbeHighHumidEnable.2 = INTEGER: disabled(1)
PowerNet-MIB::emConfigProbeLowHumidEnable.1 = INTEGER: disabled(1)
PowerNet-MIB::emConfigProbeLowHumidEnable.2 = INTEGER: disabled(1)
PowerNet-MIB::emConfigProbeMaxTempThreshold.1 = INTEGER: 60
PowerNet-MIB::emConfigProbeMaxTempThreshold.2 = INTEGER: 60
PowerNet-MIB::emConfigProbeMinTempThreshold.1 = INTEGER: 0
PowerNet-MIB::emConfigProbeMinTempThreshold.2 = INTEGER: 0
PowerNet-MIB::emConfigProbeMaxHumidThreshold.1 = INTEGER: 90
PowerNet-MIB::emConfigProbeMaxHumidThreshold.2 = INTEGER: 90
PowerNet-MIB::emConfigProbeMinHumidThreshold.1 = INTEGER: 10
PowerNet-MIB::emConfigProbeMinHumidThreshold.2 = INTEGER: 10
PowerNet-MIB::emConfigProbeMaxTempEnable.1 = INTEGER: disabled(1)
PowerNet-MIB::emConfigProbeMaxTempEnable.2 = INTEGER: disabled(1)
PowerNet-MIB::emConfigProbeMinTempEnable.1 = INTEGER: disabled(1)
PowerNet-MIB::emConfigProbeMinTempEnable.2 = INTEGER: disabled(1)
PowerNet-MIB::emConfigProbeMaxHumidEnable.1 = INTEGER: disabled(1)
PowerNet-MIB::emConfigProbeMaxHumidEnable.2 = INTEGER: disabled(1)
PowerNet-MIB::emConfigProbeMinHumidEnable.1 = INTEGER: disabled(1)
PowerNet-MIB::emConfigProbeMinHumidEnable.2 = INTEGER: disabled(1)
PowerNet-MIB::emConfigProbeTempHysteresis.1 = INTEGER: 0
PowerNet-MIB::emConfigProbeTempHysteresis.2 = INTEGER: 0
PowerNet-MIB::emConfigProbeHumidHysteresis.1 = INTEGER: 0
PowerNet-MIB::emConfigProbeHumidHysteresis.2 = INTEGER: 0
PowerNet-MIB::emConfigProbeLocation.1 = STRING: "Temp Sensor 1 Loc"
PowerNet-MIB::emConfigProbeLocation.2 = STRING: "Temp Sensor 2 Loc"
PowerNet-MIB::emConfigContactNumber.1 = INTEGER: 1
PowerNet-MIB::emConfigContactNumber.2 = INTEGER: 2
PowerNet-MIB::emConfigContactNumber.3 = INTEGER: 3
PowerNet-MIB::emConfigContactNumber.4 = INTEGER: 4
PowerNet-MIB::emConfigContactName.1 = STRING: "Contact 1"
PowerNet-MIB::emConfigContactName.2 = STRING: "Contact 2"
PowerNet-MIB::emConfigContactName.3 = STRING: "Contact 3"
PowerNet-MIB::emConfigContactName.4 = STRING: "Contact 4"
PowerNet-MIB::emConfigContactEnable.1 = INTEGER: disabled(1)
PowerNet-MIB::emConfigContactEnable.2 = INTEGER: disabled(1)
PowerNet-MIB::emConfigContactEnable.3 = INTEGER: disabled(1)
PowerNet-MIB::emConfigContactEnable.4 = INTEGER: disabled(1)
PowerNet-MIB::emConfigContactSeverity.1 = INTEGER: warning(2)
PowerNet-MIB::emConfigContactSeverity.2 = INTEGER: warning(2)
PowerNet-MIB::emConfigContactSeverity.3 = INTEGER: warning(2)
PowerNet-MIB::emConfigContactSeverity.4 = INTEGER: warning(2)
PowerNet-MIB::emConfigContactNormalState.1 = INTEGER: open(1)
PowerNet-MIB::emConfigContactNormalState.2 = INTEGER: open(1)
PowerNet-MIB::emConfigContactNormalState.3 = INTEGER: open(1)
PowerNet-MIB::emConfigContactNormalState.4 = INTEGER: open(1)
PowerNet-MIB::emConfigContactLocation.1 = STRING: "Contact Location"
PowerNet-MIB::emConfigContactLocation.2 = STRING: "Contact Location"
PowerNet-MIB::emConfigContactLocation.3 = STRING: "Contact Location"
PowerNet-MIB::emConfigContactLocation.4 = STRING: "Contact Location"
PowerNet-MIB::emStatusCommStatus.0 = INTEGER: noComm(1)
PowerNet-MIB::emStatusProbesNumProbes.0 = INTEGER: 2
PowerNet-MIB::emStatusContactsNumContacts.0 = INTEGER: 4
PowerNet-MIB::iemIdentHardwareRevision.0 = STRING: "1"
PowerNet-MIB::iemConfigProbesNumProbes.0 = INTEGER: 1
PowerNet-MIB::iemConfigProbeNumber.1 = INTEGER: 1
PowerNet-MIB::iemConfigProbeName.1 = STRING: "Front"
PowerNet-MIB::iemConfigProbeHighTempThreshold.1 = INTEGER: 25
PowerNet-MIB::iemConfigProbeLowTempThreshold.1 = INTEGER: 15
PowerNet-MIB::iemConfigProbeTempUnits.1 = INTEGER: celsius(1)
PowerNet-MIB::iemConfigProbeHighHumidThreshold.1 = INTEGER: 60
PowerNet-MIB::iemConfigProbeLowHumidThreshold.1 = INTEGER: 30
PowerNet-MIB::iemConfigProbeHighTempEnable.1 = INTEGER: enabled(2)
PowerNet-MIB::iemConfigProbeLowTempEnable.1 = INTEGER: enabled(2)
PowerNet-MIB::iemConfigProbeHighHumidEnable.1 = INTEGER: disabled(1)
PowerNet-MIB::iemConfigProbeLowHumidEnable.1 = INTEGER: disabled(1)
PowerNet-MIB::iemConfigProbeMaxTempThreshold.1 = INTEGER: 30
PowerNet-MIB::iemConfigProbeMinTempThreshold.1 = INTEGER: 10
PowerNet-MIB::iemConfigProbeMaxHumidThreshold.1 = INTEGER: 90
PowerNet-MIB::iemConfigProbeMinHumidThreshold.1 = INTEGER: 10
PowerNet-MIB::iemConfigProbeMaxTempEnable.1 = INTEGER: enabled(2)
PowerNet-MIB::iemConfigProbeMinTempEnable.1 = INTEGER: enabled(2)
PowerNet-MIB::iemConfigProbeMaxHumidEnable.1 = INTEGER: disabled(1)
PowerNet-MIB::iemConfigProbeMinHumidEnable.1 = INTEGER: disabled(1)
PowerNet-MIB::iemConfigProbeTempHysteresis.1 = INTEGER: 0
PowerNet-MIB::iemConfigProbeHumidHysteresis.1 = INTEGER: 0
PowerNet-MIB::iemConfigProbeLocation.1 = STRING: "Front Rack"
PowerNet-MIB::iemConfigContactsNumContacts.0 = INTEGER: 2
PowerNet-MIB::iemConfigContactNumber.1 = INTEGER: 1
PowerNet-MIB::iemConfigContactNumber.2 = INTEGER: 2
PowerNet-MIB::iemConfigContactName.1 = STRING: "Int Contact 1"
PowerNet-MIB::iemConfigContactName.2 = STRING: "Int Contact 2"
PowerNet-MIB::iemConfigContactEnable.1 = INTEGER: disabled(1)
PowerNet-MIB::iemConfigContactEnable.2 = INTEGER: disabled(1)
PowerNet-MIB::iemConfigContactSeverity.1 = INTEGER: warning(2)
PowerNet-MIB::iemConfigContactSeverity.2 = INTEGER: warning(2)
PowerNet-MIB::iemConfigContactNormalState.1 = INTEGER: open(1)
PowerNet-MIB::iemConfigContactNormalState.2 = INTEGER: open(1)
PowerNet-MIB::iemConfigContactLocation.1 = STRING: "Contact Location"
PowerNet-MIB::iemConfigContactLocation.2 = STRING: "Contact Location"
PowerNet-MIB::iemConfigConfigRelaysNumRelays.0 = INTEGER: 1
PowerNet-MIB::iemConfigRelayNumber.1 = INTEGER: 1
PowerNet-MIB::iemConfigRelayName.1 = STRING: "Int Relay"
PowerNet-MIB::iemConfigRelayNormalState.1 = INTEGER: open(1)
PowerNet-MIB::iemStatusProbesNumProbes.0 = INTEGER: 1
PowerNet-MIB::iemStatusProbeNumber.1 = INTEGER: 1
PowerNet-MIB::iemStatusProbeName.1 = STRING: "Front"
PowerNet-MIB::iemStatusProbeStatus.1 = INTEGER: connected(2)
PowerNet-MIB::iemStatusProbeCurrentTemp.1 = INTEGER: 16
PowerNet-MIB::iemStatusProbeTempUnits.1 = INTEGER: celsius(1)
PowerNet-MIB::iemStatusProbeCurrentHumid.1 = INTEGER: -1
PowerNet-MIB::iemStatusProbeHighTempViolation.1 = INTEGER: noViolation(1)
PowerNet-MIB::iemStatusProbeLowTempViolation.1 = INTEGER: noViolation(1)
PowerNet-MIB::iemStatusProbeHighHumidViolation.1 = INTEGER: disabled(3)
PowerNet-MIB::iemStatusProbeLowHumidViolation.1 = INTEGER: disabled(3)
PowerNet-MIB::iemStatusProbeMaxTempViolation.1 = INTEGER: noViolation(1)
PowerNet-MIB::iemStatusProbeMinTempViolation.1 = INTEGER: noViolation(1)
PowerNet-MIB::iemStatusProbeMaxHumidViolation.1 = INTEGER: disabled(3)
PowerNet-MIB::iemStatusProbeMinHumidViolation.1 = INTEGER: disabled(3)
PowerNet-MIB::iemStatusProbeLocation.1 = STRING: "Front Rack"
PowerNet-MIB::iemStatusContactsNumContacts.0 = INTEGER: 2
PowerNet-MIB::iemStatusContactNumber.1 = INTEGER: 1
PowerNet-MIB::iemStatusContactNumber.2 = INTEGER: 2
PowerNet-MIB::iemStatusContactName.1 = STRING: "Int Contact 1"
PowerNet-MIB::iemStatusContactName.2 = STRING: "Int Contact 2"
PowerNet-MIB::iemStatusContactStatus.1 = INTEGER: disabled(3)
PowerNet-MIB::iemStatusContactStatus.2 = INTEGER: disabled(3)
PowerNet-MIB::iemStatusRelaysNumRelays.0 = INTEGER: 1
PowerNet-MIB::iemStatusRelayNumber.1 = INTEGER: 1
PowerNet-MIB::iemStatusRelayName.1 = STRING: "Int Relay"
PowerNet-MIB::iemStatusRelayStatus.1 = INTEGER: normalState(2)
```