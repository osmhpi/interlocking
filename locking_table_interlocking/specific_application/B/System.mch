MACHINE System
SEES Enums
INCLUDES
  PointLockLeft_W1.PointLockLeft, PointLockRight_W1.PointLockRight, PointMonitoring_W1.PointMonitoring, PointNominalPosition_W1.PointNominalPosition, PointOperation_W1.PointOperation, PointLockLeft_W2.PointLockLeft, PointLockRight_W2.PointLockRight, PointMonitoring_W2.PointMonitoring, PointNominalPosition_W2.PointNominalPosition, PointOperation_W2.PointOperation, RouteAutomaticRelease_A_DOT_N1.RouteAutomaticRelease, RouteManualRelease_A_DOT_N1.RouteManualRelease, RouteMonitoring_A_DOT_N1.RouteMonitoring, Route_A_DOT_N1.Route, RouteAutomaticRelease_A_DOT_N2.RouteAutomaticRelease, RouteManualRelease_A_DOT_N2.RouteManualRelease, RouteMonitoring_A_DOT_N2.RouteMonitoring, Route_A_DOT_N2.Route, SignalClaim_A.SignalClaim, Signal_A.Signal, SignalClaim_N1.SignalClaim, Signal_N1.Signal, SignalClaim_N2.SignalClaim, Signal_N2.Signal, Transit_G11_PLUS_.Transit, Transit_G11_MINUS_.Transit, Transit_W1_R_PLUS_.Transit, Transit_W1_R_MINUS_.Transit, Transit_W1_L_PLUS_.Transit, Transit_W1_L_MINUS_.Transit, Transit_W2_R_PLUS_.Transit, Transit_W2_R_MINUS_.Transit, Transit_W2_L_PLUS_.Transit, Transit_W2_L_MINUS_.Transit, Transit_G12_PLUS_.Transit, Transit_G12_MINUS_.Transit, Transit_G21_PLUS_.Transit, Transit_G21_MINUS_.Transit, Zone_G11.Zone, Zone_W1.Zone, Zone_W2.Zone, Zone_G12.Zone, Zone_G21.Zone, SCIP_Point_W1.SCIP_Point, SCICC_Point_W1.SCICC_Point, SCIP_Point_W2.SCIP_Point, SCICC_Point_W2.SCICC_Point, SCICC_Route_A_DOT_N1.SCICC_Route, SCICC_Route_A_DOT_N2.SCICC_Route, SCICC_Signal_A.SCICC_Signal, SCIRBC_Signal_A.SCIRBC_Signal, SCICC_Signal_N1.SCICC_Signal, SCIRBC_Signal_N1.SCIRBC_Signal, SCICC_Signal_N2.SCICC_Signal, SCIRBC_Signal_N2.SCIRBC_Signal, SCICC_Transit_G11_PLUS_.SCICC_Transit, SCICC_Transit_G11_MINUS_.SCICC_Transit, SCICC_Transit_W1_R_PLUS_.SCICC_Transit, SCICC_Transit_W1_R_MINUS_.SCICC_Transit, SCICC_Transit_W1_L_PLUS_.SCICC_Transit, SCICC_Transit_W1_L_MINUS_.SCICC_Transit, SCICC_Transit_W2_R_PLUS_.SCICC_Transit, SCICC_Transit_W2_R_MINUS_.SCICC_Transit, SCICC_Transit_W2_L_PLUS_.SCICC_Transit, SCICC_Transit_W2_L_MINUS_.SCICC_Transit, SCICC_Transit_G12_PLUS_.SCICC_Transit, SCICC_Transit_G12_MINUS_.SCICC_Transit, SCICC_Transit_G21_PLUS_.SCICC_Transit, SCICC_Transit_G21_MINUS_.SCICC_Transit, SCITDS_Zone_G11.SCITDS_Zone, SCICC_Zone_G11.SCICC_Zone, SCITDS_Zone_W1.SCITDS_Zone, SCICC_Zone_W1.SCICC_Zone, SCITDS_Zone_W2.SCITDS_Zone, SCICC_Zone_W2.SCICC_Zone, SCITDS_Zone_G12.SCITDS_Zone, SCICC_Zone_G12.SCICC_Zone, SCITDS_Zone_G21.SCITDS_Zone, SCICC_Zone_G21.SCICC_Zone
INVARIANT
  (PointMonitoring_W1.Left = ActiveInactive_INACTIVE & PointMonitoring_W1.Right = ActiveInactive_INACTIVE) => SCICC_Signal_N1.signal_open = FALSE
INITIALISATION
  PointLockLeft_W1.InitialTransition(SCIP_Point_W1.DetectedEndPosition, {}, {});
  PointLockRight_W1.InitialTransition(SCIP_Point_W1.DetectedEndPosition, {}, {});
  PointMonitoring_W1.InitialTransition(SCIP_Point_W1.DetectedEndPosition, PointNominalPosition_W1.State);
  PointNominalPosition_W1.InitialTransition(SCIP_Point_W1.DetectedEndPosition, {Route_A_DOT_N2.State}, {Route_A_DOT_N1.State}, PointLockLeft_W1.State, PointLockRight_W1.State);
  PointOperation_W1.InitialTransition(PointNominalPosition_W1.State, SCIP_Point_W1.DetectedEndPosition, {PointOperation_W1.Top, PointOperation_W2.Top}, 0);
  PointLockLeft_W2.InitialTransition(SCIP_Point_W2.DetectedEndPosition, {}, {});
  PointLockRight_W2.InitialTransition(SCIP_Point_W2.DetectedEndPosition, {}, {});
  PointMonitoring_W2.InitialTransition(SCIP_Point_W2.DetectedEndPosition, PointNominalPosition_W2.State);
  PointNominalPosition_W2.InitialTransition(SCIP_Point_W2.DetectedEndPosition, {Route_A_DOT_N2.State}, {}, PointLockLeft_W2.State, PointLockRight_W2.State);
  PointOperation_W2.InitialTransition(PointNominalPosition_W2.State, SCIP_Point_W2.DetectedEndPosition, {PointOperation_W1.Top, PointOperation_W2.Top}, 0);
  RouteAutomaticRelease_A_DOT_N1.InitialTransition(Route_A_DOT_N1.State, Transit_W1_R_MINUS_.State, Zone_W1.State);
  RouteManualRelease_A_DOT_N1.InitialTransition(SCICC_Route_A_DOT_N1.MsgReleaseRoute, SCIRBC_Signal_A.ApproachLockingActive, 0, 1000, 1000, Route_A_DOT_N1.State, RouteMonitoring_A_DOT_N1.State, RouteAutomaticRelease_A_DOT_N1.PassageLock, Zone_G11.State);
  RouteMonitoring_A_DOT_N1.InitialTransition({PointMonitoring_W1.Right}, {}, Route_A_DOT_N1.State, {Transit_W1_R_MINUS_.State, Transit_G12_MINUS_.State});
  Route_A_DOT_N1.InitialTransition(SCICC_Route_A_DOT_N1.MsgRequestRoute, {PointNominalPosition_W1.State}, {}, RouteAutomaticRelease_A_DOT_N1.State, RouteManualRelease_A_DOT_N1.ManualReleaseRequested);
  RouteAutomaticRelease_A_DOT_N2.InitialTransition(Route_A_DOT_N2.State, Transit_W1_L_MINUS_.State, Zone_W1.State);
  RouteManualRelease_A_DOT_N2.InitialTransition(SCICC_Route_A_DOT_N2.MsgReleaseRoute, SCIRBC_Signal_A.ApproachLockingActive, 0, 1000, 1000, Route_A_DOT_N2.State, RouteMonitoring_A_DOT_N2.State, RouteAutomaticRelease_A_DOT_N2.PassageLock, Zone_G11.State);
  RouteMonitoring_A_DOT_N2.InitialTransition({}, {PointMonitoring_W1.Left, PointMonitoring_W2.Left}, Route_A_DOT_N2.State, {Transit_W1_L_MINUS_.State, Transit_G21_MINUS_.State});
  Route_A_DOT_N2.InitialTransition(SCICC_Route_A_DOT_N2.MsgRequestRoute, {}, {PointNominalPosition_W1.State, PointNominalPosition_W2.State}, RouteAutomaticRelease_A_DOT_N2.State, RouteManualRelease_A_DOT_N2.ManualReleaseRequested);
  SignalClaim_A.InitialTransition({Route_A_DOT_N1.State, Route_A_DOT_N2.State});
  Signal_A.InitialTransition({RouteMonitoring_A_DOT_N1.State, RouteMonitoring_A_DOT_N2.State});
  SignalClaim_N1.InitialTransition({});
  Signal_N1.InitialTransition({});
  SignalClaim_N2.InitialTransition({});
  Signal_N2.InitialTransition({});
  Transit_G11_PLUS_.InitialTransition(0, Zone_G11.State, {}, {Route_A_DOT_N1.State, Route_A_DOT_N2.State});
  Transit_G11_MINUS_.InitialTransition(0, Zone_G11.State, {Transit_W1_R_MINUS_.State, Transit_W1_L_MINUS_.State}, {});
  Transit_W1_R_PLUS_.InitialTransition(0, Zone_W1.State, {}, {Route_A_DOT_N1.State});
  Transit_W1_R_MINUS_.InitialTransition(0, Zone_W1.State, {Transit_G12_MINUS_.State}, {});
  Transit_W1_L_PLUS_.InitialTransition(0, Zone_W1.State, {}, {Route_A_DOT_N2.State});
  Transit_W1_L_MINUS_.InitialTransition(0, Zone_W1.State, {Transit_W2_L_PLUS_.State}, {});
  Transit_W2_R_PLUS_.InitialTransition(0, Zone_W2.State, {Transit_G21_MINUS_.State}, {});
  Transit_W2_R_MINUS_.InitialTransition(0, Zone_W2.State, {}, {});
  Transit_W2_L_PLUS_.InitialTransition(0, Zone_W2.State, {Transit_G21_MINUS_.State}, {});
  Transit_W2_L_MINUS_.InitialTransition(0, Zone_W2.State, {Transit_W1_L_PLUS_.State}, {Route_A_DOT_N2.State});
  Transit_G12_PLUS_.InitialTransition(0, Zone_G12.State, {Transit_W1_R_PLUS_.State}, {Route_A_DOT_N1.State});
  Transit_G12_MINUS_.InitialTransition(0, Zone_G12.State, {}, {});
  Transit_G21_PLUS_.InitialTransition(0, Zone_G21.State, {Transit_W2_R_MINUS_.State, Transit_W2_L_MINUS_.State}, {Route_A_DOT_N2.State});
  Transit_G21_MINUS_.InitialTransition(0, Zone_G21.State, {}, {});
  Zone_G11.InitialTransition(SCITDS_Zone_G11.OccupancyStatus);
  Zone_W1.InitialTransition(SCITDS_Zone_W1.OccupancyStatus);
  Zone_W2.InitialTransition(SCITDS_Zone_W2.OccupancyStatus);
  Zone_G12.InitialTransition(SCITDS_Zone_G12.OccupancyStatus);
  Zone_G21.InitialTransition(SCITDS_Zone_G21.OccupancyStatus)
OPERATIONS
  BigStep(SCIP_Point_W1_DetectedEndPosition, SCIP_Point_W2_DetectedEndPosition, SCICC_Route_A_DOT_N1_MsgRequestRoute, SCICC_Route_A_DOT_N1_MsgReleaseRoute, SCICC_Route_A_DOT_N2_MsgRequestRoute, SCICC_Route_A_DOT_N2_MsgReleaseRoute, SCIRBC_Signal_A_ApproachLockingActive, SCIRBC_Signal_N1_ApproachLockingActive, SCIRBC_Signal_N2_ApproachLockingActive, SCITDS_Zone_G11_OccupancyStatus, SCITDS_Zone_W1_OccupancyStatus, SCITDS_Zone_W2_OccupancyStatus, SCITDS_Zone_G12_OccupancyStatus, SCITDS_Zone_G21_OccupancyStatus, SYS_NOW) =
    BEGIN
      SCIP_Point_W1.Set_DetectedEndPosition(SCIP_Point_W1_DetectedEndPosition);
      SCIP_Point_W2.Set_DetectedEndPosition(SCIP_Point_W2_DetectedEndPosition);
      SCICC_Route_A_DOT_N1.Set_MsgRequestRoute(SCICC_Route_A_DOT_N1_MsgRequestRoute);
      SCICC_Route_A_DOT_N1.Set_MsgReleaseRoute(SCICC_Route_A_DOT_N1_MsgReleaseRoute);
      SCICC_Route_A_DOT_N2.Set_MsgRequestRoute(SCICC_Route_A_DOT_N2_MsgRequestRoute);
      SCICC_Route_A_DOT_N2.Set_MsgReleaseRoute(SCICC_Route_A_DOT_N2_MsgReleaseRoute);
      SCIRBC_Signal_A.Set_ApproachLockingActive(SCIRBC_Signal_A_ApproachLockingActive);
      SCIRBC_Signal_N1.Set_ApproachLockingActive(SCIRBC_Signal_N1_ApproachLockingActive);
      SCIRBC_Signal_N2.Set_ApproachLockingActive(SCIRBC_Signal_N2_ApproachLockingActive);
      SCITDS_Zone_G11.Set_OccupancyStatus(SCITDS_Zone_G11_OccupancyStatus);
      SCITDS_Zone_W1.Set_OccupancyStatus(SCITDS_Zone_W1_OccupancyStatus);
      SCITDS_Zone_W2.Set_OccupancyStatus(SCITDS_Zone_W2_OccupancyStatus);
      SCITDS_Zone_G12.Set_OccupancyStatus(SCITDS_Zone_G12_OccupancyStatus);
      SCITDS_Zone_G21.Set_OccupancyStatus(SCITDS_Zone_G21_OccupancyStatus);
      Zone_G11.Transition(SCITDS_Zone_G11.OccupancyStatus);
      Zone_W1.Transition(SCITDS_Zone_W1.OccupancyStatus);
      Zone_W2.Transition(SCITDS_Zone_W2.OccupancyStatus);
      Zone_G12.Transition(SCITDS_Zone_G12.OccupancyStatus);
      Zone_G21.Transition(SCITDS_Zone_G21.OccupancyStatus);
      RouteAutomaticRelease_A_DOT_N1.Transition(Route_A_DOT_N1.State, Transit_W1_R_MINUS_.State, Zone_W1.State);
      RouteAutomaticRelease_A_DOT_N2.Transition(Route_A_DOT_N2.State, Transit_W1_L_MINUS_.State, Zone_W1.State);
      RouteManualRelease_A_DOT_N1.Transition(SCICC_Route_A_DOT_N1.MsgReleaseRoute, SCIRBC_Signal_A.ApproachLockingActive, SYS_NOW, 1000, 1000, Route_A_DOT_N1.State, RouteMonitoring_A_DOT_N1.State, RouteAutomaticRelease_A_DOT_N1.PassageLock, Zone_G11.State);
      RouteManualRelease_A_DOT_N2.Transition(SCICC_Route_A_DOT_N2.MsgReleaseRoute, SCIRBC_Signal_A.ApproachLockingActive, SYS_NOW, 1000, 1000, Route_A_DOT_N2.State, RouteMonitoring_A_DOT_N2.State, RouteAutomaticRelease_A_DOT_N2.PassageLock, Zone_G11.State);
      Route_A_DOT_N1.Transition(SCICC_Route_A_DOT_N1.MsgRequestRoute, {PointNominalPosition_W1.State}, {}, RouteAutomaticRelease_A_DOT_N1.State, RouteManualRelease_A_DOT_N1.ManualReleaseRequested);
      Route_A_DOT_N2.Transition(SCICC_Route_A_DOT_N2.MsgRequestRoute, {}, {PointNominalPosition_W1.State, PointNominalPosition_W2.State}, RouteAutomaticRelease_A_DOT_N2.State, RouteManualRelease_A_DOT_N2.ManualReleaseRequested);
      Transit_G11_PLUS_.Transition(SYS_NOW, Zone_G11.State, {}, {Route_A_DOT_N1.State, Route_A_DOT_N2.State});
      Transit_G11_MINUS_.Transition(SYS_NOW, Zone_G11.State, {Transit_W1_R_MINUS_.State, Transit_W1_L_MINUS_.State}, {});
      Transit_W1_R_PLUS_.Transition(SYS_NOW, Zone_W1.State, {}, {Route_A_DOT_N1.State});
      Transit_W1_R_MINUS_.Transition(SYS_NOW, Zone_W1.State, {Transit_G12_MINUS_.State}, {});
      Transit_W1_L_PLUS_.Transition(SYS_NOW, Zone_W1.State, {}, {Route_A_DOT_N2.State});
      Transit_W1_L_MINUS_.Transition(SYS_NOW, Zone_W1.State, {Transit_W2_L_PLUS_.State}, {});
      Transit_W2_R_PLUS_.Transition(SYS_NOW, Zone_W2.State, {Transit_G21_MINUS_.State}, {});
      Transit_W2_R_MINUS_.Transition(SYS_NOW, Zone_W2.State, {}, {});
      Transit_W2_L_PLUS_.Transition(SYS_NOW, Zone_W2.State, {Transit_G21_MINUS_.State}, {});
      Transit_W2_L_MINUS_.Transition(SYS_NOW, Zone_W2.State, {Transit_W1_L_PLUS_.State}, {Route_A_DOT_N2.State});
      Transit_G12_PLUS_.Transition(SYS_NOW, Zone_G12.State, {Transit_W1_R_PLUS_.State}, {Route_A_DOT_N1.State});
      Transit_G12_MINUS_.Transition(SYS_NOW, Zone_G12.State, {}, {});
      Transit_G21_PLUS_.Transition(SYS_NOW, Zone_G21.State, {Transit_W2_R_MINUS_.State, Transit_W2_L_MINUS_.State}, {Route_A_DOT_N2.State});
      Transit_G21_MINUS_.Transition(SYS_NOW, Zone_G21.State, {}, {});
      PointLockLeft_W1.Transition(SCIP_Point_W1.DetectedEndPosition, {}, {});
      PointLockRight_W1.Transition(SCIP_Point_W1.DetectedEndPosition, {}, {});
      PointNominalPosition_W1.Transition(SCIP_Point_W1.DetectedEndPosition, {Route_A_DOT_N2.State}, {Route_A_DOT_N1.State}, PointLockLeft_W1.State, PointLockRight_W1.State);
      PointMonitoring_W1.Transition(SCIP_Point_W1.DetectedEndPosition, PointNominalPosition_W1.State);
      PointOperation_W1.Transition(PointNominalPosition_W1.State, SCIP_Point_W1.DetectedEndPosition, {PointOperation_W1.Top, PointOperation_W2.Top}, SYS_NOW);
      PointLockLeft_W2.Transition(SCIP_Point_W2.DetectedEndPosition, {}, {});
      PointLockRight_W2.Transition(SCIP_Point_W2.DetectedEndPosition, {}, {});
      PointNominalPosition_W2.Transition(SCIP_Point_W2.DetectedEndPosition, {Route_A_DOT_N2.State}, {}, PointLockLeft_W2.State, PointLockRight_W2.State);
      PointMonitoring_W2.Transition(SCIP_Point_W2.DetectedEndPosition, PointNominalPosition_W2.State);
      PointOperation_W2.Transition(PointNominalPosition_W2.State, SCIP_Point_W2.DetectedEndPosition, {PointOperation_W1.Top, PointOperation_W2.Top}, SYS_NOW);
      RouteMonitoring_A_DOT_N1.Transition({PointMonitoring_W1.Right}, {}, Route_A_DOT_N1.State, {Transit_W1_R_MINUS_.State, Transit_G12_MINUS_.State});
      RouteMonitoring_A_DOT_N2.Transition({}, {PointMonitoring_W1.Left, PointMonitoring_W2.Left}, Route_A_DOT_N2.State, {Transit_W1_L_MINUS_.State, Transit_G21_MINUS_.State});
      SignalClaim_A.Transition({Route_A_DOT_N1.State, Route_A_DOT_N2.State});
      SignalClaim_N1.Transition({});
      SignalClaim_N2.Transition({});
      Signal_A.Transition({RouteMonitoring_A_DOT_N1.State, RouteMonitoring_A_DOT_N2.State});
      Signal_N1.Transition({});
      Signal_N2.Transition({});
      SCIP_Point_W1.ComputeOutputs(PointOperation_W1.State) ||
      SCICC_Point_W1.ComputeOutputs(SCIP_Point_W1.DetectedEndPosition) ||
      SCIP_Point_W2.ComputeOutputs(PointOperation_W2.State) ||
      SCICC_Point_W2.ComputeOutputs(SCIP_Point_W2.DetectedEndPosition) ||
      SCICC_Route_A_DOT_N1.ComputeOutputs ||
      SCICC_Route_A_DOT_N2.ComputeOutputs ||
      SCICC_Signal_A.ComputeOutputs(Signal_A.State) ||
      SCIRBC_Signal_A.ComputeOutputs({RouteManualRelease_A_DOT_N1.ManualReleaseWithholdMovementAuthority, RouteManualRelease_A_DOT_N2.ManualReleaseWithholdMovementAuthority}) ||
      SCICC_Signal_N1.ComputeOutputs(Signal_N1.State) ||
      SCIRBC_Signal_N1.ComputeOutputs({}) ||
      SCICC_Signal_N2.ComputeOutputs(Signal_N2.State) ||
      SCIRBC_Signal_N2.ComputeOutputs({}) ||
      SCICC_Transit_G11_PLUS_.ComputeOutputs(Transit_G11_PLUS_.State) ||
      SCICC_Transit_G11_MINUS_.ComputeOutputs(Transit_G11_MINUS_.State) ||
      SCICC_Transit_W1_R_PLUS_.ComputeOutputs(Transit_W1_R_PLUS_.State) ||
      SCICC_Transit_W1_R_MINUS_.ComputeOutputs(Transit_W1_R_MINUS_.State) ||
      SCICC_Transit_W1_L_PLUS_.ComputeOutputs(Transit_W1_L_PLUS_.State) ||
      SCICC_Transit_W1_L_MINUS_.ComputeOutputs(Transit_W1_L_MINUS_.State) ||
      SCICC_Transit_W2_R_PLUS_.ComputeOutputs(Transit_W2_R_PLUS_.State) ||
      SCICC_Transit_W2_R_MINUS_.ComputeOutputs(Transit_W2_R_MINUS_.State) ||
      SCICC_Transit_W2_L_PLUS_.ComputeOutputs(Transit_W2_L_PLUS_.State) ||
      SCICC_Transit_W2_L_MINUS_.ComputeOutputs(Transit_W2_L_MINUS_.State) ||
      SCICC_Transit_G12_PLUS_.ComputeOutputs(Transit_G12_PLUS_.State) ||
      SCICC_Transit_G12_MINUS_.ComputeOutputs(Transit_G12_MINUS_.State) ||
      SCICC_Transit_G21_PLUS_.ComputeOutputs(Transit_G21_PLUS_.State) ||
      SCICC_Transit_G21_MINUS_.ComputeOutputs(Transit_G21_MINUS_.State) ||
      SCITDS_Zone_G11.ComputeOutputs(Zone_G11.State) ||
      SCICC_Zone_G11.ComputeOutputs(Zone_G11.State) ||
      SCITDS_Zone_W1.ComputeOutputs(Zone_W1.State) ||
      SCICC_Zone_W1.ComputeOutputs(Zone_W1.State) ||
      SCITDS_Zone_W2.ComputeOutputs(Zone_W2.State) ||
      SCICC_Zone_W2.ComputeOutputs(Zone_W2.State) ||
      SCITDS_Zone_G12.ComputeOutputs(Zone_G12.State) ||
      SCICC_Zone_G12.ComputeOutputs(Zone_G12.State) ||
      SCITDS_Zone_G21.ComputeOutputs(Zone_G21.State) ||
      SCICC_Zone_G21.ComputeOutputs(Zone_G21.State)
    END
END//MACHINE
