MACHINE Simulator
SEES
  Enums
INCLUDES
  System
DEFINITIONS
  VISB_SVG_FILE == "trackplan.svg";
  VISB_SVG_UPDATES1== rec(`id`:"W1",fill: IF SCICC_Zone_W1.CurrentOccupancy = OccupancyStatus_OCCUPIED THEN IF SCICC_Transit_W1_L_PLUS_.Active = TRUE or SCICC_Transit_W1_L_MINUS_.Active = TRUE or SCICC_Transit_W1_R_PLUS_.Active = TRUE or SCICC_Transit_W1_R_MINUS_.Active = TRUE THEN "green" ELSE "gray" END ELSE "red" END);
  VISB_SVG_UPDATES2== rec(`id`:"G11",fill: IF SCICC_Zone_G11.CurrentOccupancy = OccupancyStatus_OCCUPIED THEN IF SCICC_Transit_G11_PLUS_.Active = TRUE or SCICC_Transit_G11_MINUS_.Active = TRUE THEN "green" ELSE "gray" END ELSE "red" END);
  VISB_SVG_UPDATES3== rec(`id`:"G12",fill: IF SCICC_Zone_G12.CurrentOccupancy = OccupancyStatus_OCCUPIED THEN IF SCICC_Transit_G12_PLUS_.Active = TRUE or SCICC_Transit_G12_MINUS_.Active = TRUE THEN "green" ELSE "gray" END ELSE "red" END);
  VISB_SVG_UPDATES4== rec(`id`:"W1L2",fill: IF SCICC_Zone_W1.CurrentOccupancy = OccupancyStatus_OCCUPIED THEN IF SCICC_Transit_W1_L_PLUS_.Active = TRUE or SCICC_Transit_W1_L_MINUS_.Active = TRUE THEN "green" ELSE "gray" END ELSE "red" END);
  VISB_SVG_UPDATES5== rec(`id`:"W2L2",fill: IF SCICC_Zone_W2.CurrentOccupancy = OccupancyStatus_OCCUPIED THEN IF SCICC_Transit_W2_L_PLUS_.Active = TRUE or SCICC_Transit_W2_L_MINUS_.Active = TRUE THEN "green" ELSE "gray" END ELSE "red" END);
  VISB_SVG_UPDATES6== rec(`id`:"W1R",fill: IF SCICC_Zone_W1.CurrentOccupancy = OccupancyStatus_OCCUPIED THEN IF SCICC_Transit_W1_R_PLUS_.Active = TRUE or SCICC_Transit_W1_R_MINUS_.Active = TRUE THEN "green" ELSE "gray" END ELSE "red" END,visibility: bool(SCICC_Point_W1.CurrentPosition = EulynxEndPosition_RIGHT));
  VISB_SVG_UPDATES7== rec(`id`:"W2",fill: IF SCICC_Zone_W2.CurrentOccupancy = OccupancyStatus_OCCUPIED THEN IF SCICC_Transit_W2_L_PLUS_.Active = TRUE or SCICC_Transit_W2_L_MINUS_.Active = TRUE or SCICC_Transit_W2_R_PLUS_.Active = TRUE or SCICC_Transit_W2_R_MINUS_.Active = TRUE THEN "green" ELSE "gray" END ELSE "red" END);
  VISB_SVG_UPDATES8== rec(`id`:"G21",fill: IF SCICC_Zone_G21.CurrentOccupancy = OccupancyStatus_OCCUPIED THEN IF SCICC_Transit_G21_PLUS_.Active = TRUE or SCICC_Transit_G21_MINUS_.Active = TRUE THEN "green" ELSE "gray" END ELSE "red" END);
  VISB_SVG_UPDATES9== rec(`id`:"W2R",fill: IF SCICC_Zone_W2.CurrentOccupancy = OccupancyStatus_OCCUPIED THEN IF SCICC_Transit_W2_R_PLUS_.Active = TRUE or SCICC_Transit_W2_R_MINUS_.Active = TRUE THEN "green" ELSE "gray" END ELSE "red" END,visibility: bool(SCICC_Point_W2.CurrentPosition = EulynxEndPosition_RIGHT));
  VISB_SVG_UPDATES10== rec(`id`:"W1L",fill: IF SCICC_Zone_W1.CurrentOccupancy = OccupancyStatus_OCCUPIED THEN IF SCICC_Transit_W1_L_PLUS_.Active = TRUE or SCICC_Transit_W1_L_MINUS_.Active = TRUE THEN "green" ELSE "gray" END ELSE "red" END,visibility: bool(SCICC_Point_W1.CurrentPosition = EulynxEndPosition_LEFT));
  VISB_SVG_UPDATES11== rec(`id`:"W2L",fill: IF SCICC_Zone_W2.CurrentOccupancy = OccupancyStatus_OCCUPIED THEN IF SCICC_Transit_W2_L_PLUS_.Active = TRUE or SCICC_Transit_W2_L_MINUS_.Active = TRUE THEN "green" ELSE "gray" END ELSE "red" END,visibility: bool(SCICC_Point_W2.CurrentPosition = EulynxEndPosition_LEFT));
  VISB_SVG_UPDATES12== rec(`id`:"A",fill: IF SCICC_Signal_A.signal_open = TRUE THEN "green" ELSE "red" END);
  VISB_SVG_UPDATES13== rec(`id`:"N2",fill: IF SCICC_Signal_N2.signal_open = TRUE THEN "green" ELSE "red" END);
  VISB_SVG_UPDATES14== rec(`id`:"N1",fill: IF SCICC_Signal_N1.signal_open = TRUE THEN "green" ELSE "red" END);
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
    END;
  Set_SCIP_Point_W1_DetectedEndPosition(value) =
    BEGIN
      SIM_TIME := SIM_TIME + 150;
      SIM_SCIP_Point_W1_DetectedEndPosition := value;
      BigStep(SIM_SCIP_Point_W1_DetectedEndPosition, SIM_SCIP_Point_W2_DetectedEndPosition, SIM_SCICC_Route_A_DOT_N1_MsgRequestRoute, SIM_SCICC_Route_A_DOT_N1_MsgReleaseRoute, SIM_SCICC_Route_A_DOT_N2_MsgRequestRoute, SIM_SCICC_Route_A_DOT_N2_MsgReleaseRoute, SIM_SCIRBC_Signal_A_ApproachLockingActive, SIM_SCIRBC_Signal_N1_ApproachLockingActive, SIM_SCIRBC_Signal_N2_ApproachLockingActive, SIM_SCITDS_Zone_G11_OccupancyStatus, SIM_SCITDS_Zone_W1_OccupancyStatus, SIM_SCITDS_Zone_W2_OccupancyStatus, SIM_SCITDS_Zone_G12_OccupancyStatus, SIM_SCITDS_Zone_G21_OccupancyStatus, SIM_TIME);
      skip
    END;
  Set_SCIP_Point_W2_DetectedEndPosition(value) =
    BEGIN
      SIM_TIME := SIM_TIME + 150;
      SIM_SCIP_Point_W2_DetectedEndPosition := value;
      BigStep(SIM_SCIP_Point_W1_DetectedEndPosition, SIM_SCIP_Point_W2_DetectedEndPosition, SIM_SCICC_Route_A_DOT_N1_MsgRequestRoute, SIM_SCICC_Route_A_DOT_N1_MsgReleaseRoute, SIM_SCICC_Route_A_DOT_N2_MsgRequestRoute, SIM_SCICC_Route_A_DOT_N2_MsgReleaseRoute, SIM_SCIRBC_Signal_A_ApproachLockingActive, SIM_SCIRBC_Signal_N1_ApproachLockingActive, SIM_SCIRBC_Signal_N2_ApproachLockingActive, SIM_SCITDS_Zone_G11_OccupancyStatus, SIM_SCITDS_Zone_W1_OccupancyStatus, SIM_SCITDS_Zone_W2_OccupancyStatus, SIM_SCITDS_Zone_G12_OccupancyStatus, SIM_SCITDS_Zone_G21_OccupancyStatus, SIM_TIME);
      skip
    END;
  Set_SCICC_Route_A_DOT_N1_MsgRequestRoute(value) =
    BEGIN
      SIM_TIME := SIM_TIME + 150;
      SIM_SCICC_Route_A_DOT_N1_MsgRequestRoute := value;
      BigStep(SIM_SCIP_Point_W1_DetectedEndPosition, SIM_SCIP_Point_W2_DetectedEndPosition, SIM_SCICC_Route_A_DOT_N1_MsgRequestRoute, SIM_SCICC_Route_A_DOT_N1_MsgReleaseRoute, SIM_SCICC_Route_A_DOT_N2_MsgRequestRoute, SIM_SCICC_Route_A_DOT_N2_MsgReleaseRoute, SIM_SCIRBC_Signal_A_ApproachLockingActive, SIM_SCIRBC_Signal_N1_ApproachLockingActive, SIM_SCIRBC_Signal_N2_ApproachLockingActive, SIM_SCITDS_Zone_G11_OccupancyStatus, SIM_SCITDS_Zone_W1_OccupancyStatus, SIM_SCITDS_Zone_W2_OccupancyStatus, SIM_SCITDS_Zone_G12_OccupancyStatus, SIM_SCITDS_Zone_G21_OccupancyStatus, SIM_TIME);
      SIM_SCICC_Route_A_DOT_N1_MsgRequestRoute := FALSE
    END;
  Set_SCICC_Route_A_DOT_N1_MsgReleaseRoute(value) =
    BEGIN
      SIM_TIME := SIM_TIME + 150;
      SIM_SCICC_Route_A_DOT_N1_MsgReleaseRoute := value;
      BigStep(SIM_SCIP_Point_W1_DetectedEndPosition, SIM_SCIP_Point_W2_DetectedEndPosition, SIM_SCICC_Route_A_DOT_N1_MsgRequestRoute, SIM_SCICC_Route_A_DOT_N1_MsgReleaseRoute, SIM_SCICC_Route_A_DOT_N2_MsgRequestRoute, SIM_SCICC_Route_A_DOT_N2_MsgReleaseRoute, SIM_SCIRBC_Signal_A_ApproachLockingActive, SIM_SCIRBC_Signal_N1_ApproachLockingActive, SIM_SCIRBC_Signal_N2_ApproachLockingActive, SIM_SCITDS_Zone_G11_OccupancyStatus, SIM_SCITDS_Zone_W1_OccupancyStatus, SIM_SCITDS_Zone_W2_OccupancyStatus, SIM_SCITDS_Zone_G12_OccupancyStatus, SIM_SCITDS_Zone_G21_OccupancyStatus, SIM_TIME);
      SIM_SCICC_Route_A_DOT_N1_MsgReleaseRoute := FALSE
    END;
  Set_SCICC_Route_A_DOT_N2_MsgRequestRoute(value) =
    BEGIN
      SIM_TIME := SIM_TIME + 150;
      SIM_SCICC_Route_A_DOT_N2_MsgRequestRoute := value;
      BigStep(SIM_SCIP_Point_W1_DetectedEndPosition, SIM_SCIP_Point_W2_DetectedEndPosition, SIM_SCICC_Route_A_DOT_N1_MsgRequestRoute, SIM_SCICC_Route_A_DOT_N1_MsgReleaseRoute, SIM_SCICC_Route_A_DOT_N2_MsgRequestRoute, SIM_SCICC_Route_A_DOT_N2_MsgReleaseRoute, SIM_SCIRBC_Signal_A_ApproachLockingActive, SIM_SCIRBC_Signal_N1_ApproachLockingActive, SIM_SCIRBC_Signal_N2_ApproachLockingActive, SIM_SCITDS_Zone_G11_OccupancyStatus, SIM_SCITDS_Zone_W1_OccupancyStatus, SIM_SCITDS_Zone_W2_OccupancyStatus, SIM_SCITDS_Zone_G12_OccupancyStatus, SIM_SCITDS_Zone_G21_OccupancyStatus, SIM_TIME);
      SIM_SCICC_Route_A_DOT_N2_MsgRequestRoute := FALSE
    END;
  Set_SCICC_Route_A_DOT_N2_MsgReleaseRoute(value) =
    BEGIN
      SIM_TIME := SIM_TIME + 150;
      SIM_SCICC_Route_A_DOT_N2_MsgReleaseRoute := value;
      BigStep(SIM_SCIP_Point_W1_DetectedEndPosition, SIM_SCIP_Point_W2_DetectedEndPosition, SIM_SCICC_Route_A_DOT_N1_MsgRequestRoute, SIM_SCICC_Route_A_DOT_N1_MsgReleaseRoute, SIM_SCICC_Route_A_DOT_N2_MsgRequestRoute, SIM_SCICC_Route_A_DOT_N2_MsgReleaseRoute, SIM_SCIRBC_Signal_A_ApproachLockingActive, SIM_SCIRBC_Signal_N1_ApproachLockingActive, SIM_SCIRBC_Signal_N2_ApproachLockingActive, SIM_SCITDS_Zone_G11_OccupancyStatus, SIM_SCITDS_Zone_W1_OccupancyStatus, SIM_SCITDS_Zone_W2_OccupancyStatus, SIM_SCITDS_Zone_G12_OccupancyStatus, SIM_SCITDS_Zone_G21_OccupancyStatus, SIM_TIME);
      SIM_SCICC_Route_A_DOT_N2_MsgReleaseRoute := FALSE
    END;
  Set_SCIRBC_Signal_A_ApproachLockingActive(value) =
    BEGIN
      SIM_TIME := SIM_TIME + 150;
      SIM_SCIRBC_Signal_A_ApproachLockingActive := value;
      BigStep(SIM_SCIP_Point_W1_DetectedEndPosition, SIM_SCIP_Point_W2_DetectedEndPosition, SIM_SCICC_Route_A_DOT_N1_MsgRequestRoute, SIM_SCICC_Route_A_DOT_N1_MsgReleaseRoute, SIM_SCICC_Route_A_DOT_N2_MsgRequestRoute, SIM_SCICC_Route_A_DOT_N2_MsgReleaseRoute, SIM_SCIRBC_Signal_A_ApproachLockingActive, SIM_SCIRBC_Signal_N1_ApproachLockingActive, SIM_SCIRBC_Signal_N2_ApproachLockingActive, SIM_SCITDS_Zone_G11_OccupancyStatus, SIM_SCITDS_Zone_W1_OccupancyStatus, SIM_SCITDS_Zone_W2_OccupancyStatus, SIM_SCITDS_Zone_G12_OccupancyStatus, SIM_SCITDS_Zone_G21_OccupancyStatus, SIM_TIME);
      SIM_SCIRBC_Signal_A_ApproachLockingActive := TRUE
    END;
  Set_SCIRBC_Signal_N1_ApproachLockingActive(value) =
    BEGIN
      SIM_TIME := SIM_TIME + 150;
      SIM_SCIRBC_Signal_N1_ApproachLockingActive := value;
      BigStep(SIM_SCIP_Point_W1_DetectedEndPosition, SIM_SCIP_Point_W2_DetectedEndPosition, SIM_SCICC_Route_A_DOT_N1_MsgRequestRoute, SIM_SCICC_Route_A_DOT_N1_MsgReleaseRoute, SIM_SCICC_Route_A_DOT_N2_MsgRequestRoute, SIM_SCICC_Route_A_DOT_N2_MsgReleaseRoute, SIM_SCIRBC_Signal_A_ApproachLockingActive, SIM_SCIRBC_Signal_N1_ApproachLockingActive, SIM_SCIRBC_Signal_N2_ApproachLockingActive, SIM_SCITDS_Zone_G11_OccupancyStatus, SIM_SCITDS_Zone_W1_OccupancyStatus, SIM_SCITDS_Zone_W2_OccupancyStatus, SIM_SCITDS_Zone_G12_OccupancyStatus, SIM_SCITDS_Zone_G21_OccupancyStatus, SIM_TIME);
      SIM_SCIRBC_Signal_N1_ApproachLockingActive := TRUE
    END;
  Set_SCIRBC_Signal_N2_ApproachLockingActive(value) =
    BEGIN
      SIM_TIME := SIM_TIME + 150;
      SIM_SCIRBC_Signal_N2_ApproachLockingActive := value;
      BigStep(SIM_SCIP_Point_W1_DetectedEndPosition, SIM_SCIP_Point_W2_DetectedEndPosition, SIM_SCICC_Route_A_DOT_N1_MsgRequestRoute, SIM_SCICC_Route_A_DOT_N1_MsgReleaseRoute, SIM_SCICC_Route_A_DOT_N2_MsgRequestRoute, SIM_SCICC_Route_A_DOT_N2_MsgReleaseRoute, SIM_SCIRBC_Signal_A_ApproachLockingActive, SIM_SCIRBC_Signal_N1_ApproachLockingActive, SIM_SCIRBC_Signal_N2_ApproachLockingActive, SIM_SCITDS_Zone_G11_OccupancyStatus, SIM_SCITDS_Zone_W1_OccupancyStatus, SIM_SCITDS_Zone_W2_OccupancyStatus, SIM_SCITDS_Zone_G12_OccupancyStatus, SIM_SCITDS_Zone_G21_OccupancyStatus, SIM_TIME);
      SIM_SCIRBC_Signal_N2_ApproachLockingActive := TRUE
    END;
  Set_SCITDS_Zone_G11_OccupancyStatus(value) =
    BEGIN
      SIM_TIME := SIM_TIME + 150;
      SIM_SCITDS_Zone_G11_OccupancyStatus := value;
      BigStep(SIM_SCIP_Point_W1_DetectedEndPosition, SIM_SCIP_Point_W2_DetectedEndPosition, SIM_SCICC_Route_A_DOT_N1_MsgRequestRoute, SIM_SCICC_Route_A_DOT_N1_MsgReleaseRoute, SIM_SCICC_Route_A_DOT_N2_MsgRequestRoute, SIM_SCICC_Route_A_DOT_N2_MsgReleaseRoute, SIM_SCIRBC_Signal_A_ApproachLockingActive, SIM_SCIRBC_Signal_N1_ApproachLockingActive, SIM_SCIRBC_Signal_N2_ApproachLockingActive, SIM_SCITDS_Zone_G11_OccupancyStatus, SIM_SCITDS_Zone_W1_OccupancyStatus, SIM_SCITDS_Zone_W2_OccupancyStatus, SIM_SCITDS_Zone_G12_OccupancyStatus, SIM_SCITDS_Zone_G21_OccupancyStatus, SIM_TIME);
      skip
    END;
  Set_SCITDS_Zone_W1_OccupancyStatus(value) =
    BEGIN
      SIM_TIME := SIM_TIME + 150;
      SIM_SCITDS_Zone_W1_OccupancyStatus := value;
      BigStep(SIM_SCIP_Point_W1_DetectedEndPosition, SIM_SCIP_Point_W2_DetectedEndPosition, SIM_SCICC_Route_A_DOT_N1_MsgRequestRoute, SIM_SCICC_Route_A_DOT_N1_MsgReleaseRoute, SIM_SCICC_Route_A_DOT_N2_MsgRequestRoute, SIM_SCICC_Route_A_DOT_N2_MsgReleaseRoute, SIM_SCIRBC_Signal_A_ApproachLockingActive, SIM_SCIRBC_Signal_N1_ApproachLockingActive, SIM_SCIRBC_Signal_N2_ApproachLockingActive, SIM_SCITDS_Zone_G11_OccupancyStatus, SIM_SCITDS_Zone_W1_OccupancyStatus, SIM_SCITDS_Zone_W2_OccupancyStatus, SIM_SCITDS_Zone_G12_OccupancyStatus, SIM_SCITDS_Zone_G21_OccupancyStatus, SIM_TIME);
      skip
    END;
  Set_SCITDS_Zone_W2_OccupancyStatus(value) =
    BEGIN
      SIM_TIME := SIM_TIME + 150;
      SIM_SCITDS_Zone_W2_OccupancyStatus := value;
      BigStep(SIM_SCIP_Point_W1_DetectedEndPosition, SIM_SCIP_Point_W2_DetectedEndPosition, SIM_SCICC_Route_A_DOT_N1_MsgRequestRoute, SIM_SCICC_Route_A_DOT_N1_MsgReleaseRoute, SIM_SCICC_Route_A_DOT_N2_MsgRequestRoute, SIM_SCICC_Route_A_DOT_N2_MsgReleaseRoute, SIM_SCIRBC_Signal_A_ApproachLockingActive, SIM_SCIRBC_Signal_N1_ApproachLockingActive, SIM_SCIRBC_Signal_N2_ApproachLockingActive, SIM_SCITDS_Zone_G11_OccupancyStatus, SIM_SCITDS_Zone_W1_OccupancyStatus, SIM_SCITDS_Zone_W2_OccupancyStatus, SIM_SCITDS_Zone_G12_OccupancyStatus, SIM_SCITDS_Zone_G21_OccupancyStatus, SIM_TIME);
      skip
    END;
  Set_SCITDS_Zone_G12_OccupancyStatus(value) =
    BEGIN
      SIM_TIME := SIM_TIME + 150;
      SIM_SCITDS_Zone_G12_OccupancyStatus := value;
      BigStep(SIM_SCIP_Point_W1_DetectedEndPosition, SIM_SCIP_Point_W2_DetectedEndPosition, SIM_SCICC_Route_A_DOT_N1_MsgRequestRoute, SIM_SCICC_Route_A_DOT_N1_MsgReleaseRoute, SIM_SCICC_Route_A_DOT_N2_MsgRequestRoute, SIM_SCICC_Route_A_DOT_N2_MsgReleaseRoute, SIM_SCIRBC_Signal_A_ApproachLockingActive, SIM_SCIRBC_Signal_N1_ApproachLockingActive, SIM_SCIRBC_Signal_N2_ApproachLockingActive, SIM_SCITDS_Zone_G11_OccupancyStatus, SIM_SCITDS_Zone_W1_OccupancyStatus, SIM_SCITDS_Zone_W2_OccupancyStatus, SIM_SCITDS_Zone_G12_OccupancyStatus, SIM_SCITDS_Zone_G21_OccupancyStatus, SIM_TIME);
      skip
    END;
  Set_SCITDS_Zone_G21_OccupancyStatus(value) =
    BEGIN
      SIM_TIME := SIM_TIME + 150;
      SIM_SCITDS_Zone_G21_OccupancyStatus := value;
      BigStep(SIM_SCIP_Point_W1_DetectedEndPosition, SIM_SCIP_Point_W2_DetectedEndPosition, SIM_SCICC_Route_A_DOT_N1_MsgRequestRoute, SIM_SCICC_Route_A_DOT_N1_MsgReleaseRoute, SIM_SCICC_Route_A_DOT_N2_MsgRequestRoute, SIM_SCICC_Route_A_DOT_N2_MsgReleaseRoute, SIM_SCIRBC_Signal_A_ApproachLockingActive, SIM_SCIRBC_Signal_N1_ApproachLockingActive, SIM_SCIRBC_Signal_N2_ApproachLockingActive, SIM_SCITDS_Zone_G11_OccupancyStatus, SIM_SCITDS_Zone_W1_OccupancyStatus, SIM_SCITDS_Zone_W2_OccupancyStatus, SIM_SCITDS_Zone_G12_OccupancyStatus, SIM_SCITDS_Zone_G21_OccupancyStatus, SIM_TIME);
      skip
    END
END//MACHINE