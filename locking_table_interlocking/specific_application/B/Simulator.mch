MACHINE Simulator
SEES
  Enums
INCLUDES
  System
DEFINITIONS
  VISB_SVG_FILE == "trackplan.svg";
  VISB_SVG_UPDATES1== rec(`id`:"W1R",visibility: bool(SCICC_Point_W1.CurrentPosition = EulynxEndPosition_RIGHT));
  VISB_SVG_UPDATES2== rec(`id`:"W2R",visibility: bool(SCICC_Point_W2.CurrentPosition = EulynxEndPosition_RIGHT));
VARIABLES
  SIM_SCIP_Point_W1_DetectedEndPosition,
  SIM_SCIP_Point_W2_DetectedEndPosition,
  SIM_SCICC_Route_A_DOT_N1_MsgRequestRoute,
  SIM_SCICC_Route_A_DOT_N1_MsgReleaseRoute,
  SIM_SCICC_Route_A_DOT_N2_MsgRequestRoute,
  SIM_SCICC_Route_A_DOT_N2_MsgReleaseRoute,
  SIM_SCIRBC_Signal_A_ApproachLockingActive,
  SIM_SCIRBC_Signal_N1_ApproachLockingActive,
  SIM_SCIRBC_Signal_N2_ApproachLockingActive,
  SIM_SCITDS_Zone_G11_OccupancyStatus,
  SIM_SCITDS_Zone_W1_OccupancyStatus,
  SIM_SCITDS_Zone_W2_OccupancyStatus,
  SIM_SCITDS_Zone_G12_OccupancyStatus,
  SIM_SCITDS_Zone_G21_OccupancyStatus,
  SIM_TIME
INVARIANT
  SIM_SCIP_Point_W1_DetectedEndPosition : E_EulynxEndPosition &
  SIM_SCIP_Point_W2_DetectedEndPosition : E_EulynxEndPosition &
  SIM_SCICC_Route_A_DOT_N1_MsgRequestRoute : BOOL &
  SIM_SCICC_Route_A_DOT_N1_MsgReleaseRoute : BOOL &
  SIM_SCICC_Route_A_DOT_N2_MsgRequestRoute : BOOL &
  SIM_SCICC_Route_A_DOT_N2_MsgReleaseRoute : BOOL &
  SIM_SCIRBC_Signal_A_ApproachLockingActive : BOOL &
  SIM_SCIRBC_Signal_N1_ApproachLockingActive : BOOL &
  SIM_SCIRBC_Signal_N2_ApproachLockingActive : BOOL &
  SIM_SCITDS_Zone_G11_OccupancyStatus : E_OccupancyStatus &
  SIM_SCITDS_Zone_W1_OccupancyStatus : E_OccupancyStatus &
  SIM_SCITDS_Zone_W2_OccupancyStatus : E_OccupancyStatus &
  SIM_SCITDS_Zone_G12_OccupancyStatus : E_OccupancyStatus &
  SIM_SCITDS_Zone_G21_OccupancyStatus : E_OccupancyStatus &
  SIM_TIME : INTEGER
INITIALIZATION
  SIM_SCIP_Point_W1_DetectedEndPosition := EulynxEndPosition_NO_END_POSITION ||
  SIM_SCIP_Point_W2_DetectedEndPosition := EulynxEndPosition_NO_END_POSITION ||
  SIM_SCICC_Route_A_DOT_N1_MsgRequestRoute := FALSE ||
  SIM_SCICC_Route_A_DOT_N1_MsgReleaseRoute := FALSE ||
  SIM_SCICC_Route_A_DOT_N2_MsgRequestRoute := FALSE ||
  SIM_SCICC_Route_A_DOT_N2_MsgReleaseRoute := FALSE ||
  SIM_SCIRBC_Signal_A_ApproachLockingActive := FALSE ||
  SIM_SCIRBC_Signal_N1_ApproachLockingActive := FALSE ||
  SIM_SCIRBC_Signal_N2_ApproachLockingActive := FALSE ||
  SIM_SCITDS_Zone_G11_OccupancyStatus := OccupancyStatus_VACANT ||
  SIM_SCITDS_Zone_W1_OccupancyStatus := OccupancyStatus_VACANT ||
  SIM_SCITDS_Zone_W2_OccupancyStatus := OccupancyStatus_VACANT ||
  SIM_SCITDS_Zone_G12_OccupancyStatus := OccupancyStatus_VACANT ||
  SIM_SCITDS_Zone_G21_OccupancyStatus := OccupancyStatus_VACANT ||
  SIM_TIME := 0
OPERATIONS
  EmptyTick =
    BEGIN
      SIM_TIME := SIM_TIME + 150;
      BigStep(SIM_SCIP_Point_W1_DetectedEndPosition, SIM_SCIP_Point_W2_DetectedEndPosition, SIM_SCICC_Route_A_DOT_N1_MsgRequestRoute, SIM_SCICC_Route_A_DOT_N1_MsgReleaseRoute, SIM_SCICC_Route_A_DOT_N2_MsgRequestRoute, SIM_SCICC_Route_A_DOT_N2_MsgReleaseRoute, SIM_SCIRBC_Signal_A_ApproachLockingActive, SIM_SCIRBC_Signal_N1_ApproachLockingActive, SIM_SCIRBC_Signal_N2_ApproachLockingActive, SIM_SCITDS_Zone_G11_OccupancyStatus, SIM_SCITDS_Zone_W1_OccupancyStatus, SIM_SCITDS_Zone_W2_OccupancyStatus, SIM_SCITDS_Zone_G12_OccupancyStatus, SIM_SCITDS_Zone_G21_OccupancyStatus, SIM_TIME)
    END
END//MACHINE