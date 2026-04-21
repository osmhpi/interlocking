MACHINE Interlocking
INCLUDES PointControl_W1.PointControl, PointLockLeft_W1.PointLockLeft, PointLockRight_W1.PointLockRight, PointOperation_W1.PointOperation, Point_W1.Point, PointControl_W2.PointControl, PointLockLeft_W2.PointLockLeft, PointLockRight_W2.PointLockRight, PointOperation_W2.PointOperation, Point_W2.Point, RouteAutomaticRelease_A_DOT_N1.RouteAutomaticRelease, RouteControl_A_DOT_N1.RouteControl, RouteManualRelease_A_DOT_N1.RouteManualRelease, RouteMonitoring_A_DOT_N1.RouteMonitoring, Route_A_DOT_N1.Route, RouteAutomaticRelease_A_DOT_N2.RouteAutomaticRelease, RouteControl_A_DOT_N2.RouteControl, RouteManualRelease_A_DOT_N2.RouteManualRelease, RouteMonitoring_A_DOT_N2.RouteMonitoring, Route_A_DOT_N2.Route, SignalControl_A.SignalControl, Signal_A.Signal, SignalControl_N1.SignalControl, Signal_N1.Signal, SignalControl_N2.SignalControl, Signal_N2.Signal, Transit_G11_PLUS_.Transit, Transit_G11_MINUS_.Transit, Transit_W1_R_PLUS_.Transit, Transit_W1_R_MINUS_.Transit, Transit_W1_L_PLUS_.Transit, Transit_W1_L_MINUS_.Transit, Transit_W2_R_PLUS_.Transit, Transit_W2_R_MINUS_.Transit, Transit_W2_L_PLUS_.Transit, Transit_W2_L_MINUS_.Transit, Transit_G12_PLUS_.Transit, Transit_G12_MINUS_.Transit, Transit_G21_PLUS_.Transit, Transit_G21_MINUS_.Transit, Zone_G11.Zone, Zone_W1.Zone, Zone_W2.Zone, Zone_G12.Zone, Zone_G21.Zone
DEFINITIONS
  VISB_SVG_FILE == "trackplan.svg";
  VISB_SVG_UPDATES1== rec(`id`:"W1R",visibility: bool(W1.State = RIGHT));
  VISB_SVG_UPDATES2== rec(`id`:"W2R",visibility: bool(W2.State = RIGHT));
VARIABLES
  NOW
INVARIANT
  NOW : INT
INITIALISATION
  NOW := 0;
  PointControl_W1.InitialTransition(SCIP_W1.DetectedEndPosition, Point_W1.State) ||
  PointLockLeft_W1.InitialTransition(SCIP_W1.DetectedEndPosition, {}, {}) ||
  PointLockRight_W1.InitialTransition(SCIP_W1.DetectedEndPosition, {}, {}) ||
  PointOperation_W1.InitialTransition(Point_W1.State, SCIP_W1.DetectedEndPosition, {PointOperation_W1.Top, PointOperation_W2.Top}, NOW) ||
  Point_W1.InitialTransition(SCIP_W1.DetectedEndPosition, {Route_A_DOT_N2.State}, {Route_A_DOT_N1.State}, PointLockLeft_W1.State, PointLockRight_W1.State) ||
  PointControl_W2.InitialTransition(SCIP_W2.DetectedEndPosition, Point_W2.State) ||
  PointLockLeft_W2.InitialTransition(SCIP_W2.DetectedEndPosition, {}, {}) ||
  PointLockRight_W2.InitialTransition(SCIP_W2.DetectedEndPosition, {}, {}) ||
  PointOperation_W2.InitialTransition(Point_W2.State, SCIP_W2.DetectedEndPosition, {PointOperation_W1.Top, PointOperation_W2.Top}, NOW) ||
  Point_W2.InitialTransition(SCIP_W2.DetectedEndPosition, {Route_A_DOT_N2.State}, {}, PointLockLeft_W2.State, PointLockRight_W2.State) ||
  RouteAutomaticRelease_A_DOT_N1.InitialTransition(Route_A_DOT_N1.State, Transit_W1_R_MINUS_.State, Zone_W1.State) ||
  RouteControl_A_DOT_N1.InitialTransition(RouteMonitoring_A_DOT_N1.State) ||
  RouteManualRelease_A_DOT_N1.InitialTransition(SCICC_A_DOT_N1.MsgReleaseRoute, SCIRBC_A.ApproachLockingActive, Route_A_DOT_N1.State, RouteMonitoring_A_DOT_N1.State, RouteAutomaticRelease_A_DOT_N1.PassageLock, Zone_G11.State, NOW) ||
  RouteMonitoring_A_DOT_N1.InitialTransition({PointControl_W1.Right}, {}, Route_A_DOT_N1.State, {Transit_W1_R_MINUS_.State, Transit_G12_MINUS_.State}) ||
  Route_A_DOT_N1.InitialTransition(SCICC_A_DOT_N1.MsgRequestRoute, {Point_W1.State}, {}, RouteAutomaticRelease_A_DOT_N1.State, RouteManualRelease_A_DOT_N1.ManualReleaseRequested) ||
  RouteAutomaticRelease_A_DOT_N2.InitialTransition(Route_A_DOT_N2.State, Transit_W1_L_MINUS_.State, Zone_W1.State) ||
  RouteControl_A_DOT_N2.InitialTransition(RouteMonitoring_A_DOT_N2.State) ||
  RouteManualRelease_A_DOT_N2.InitialTransition(SCICC_A_DOT_N2.MsgReleaseRoute, SCIRBC_A.ApproachLockingActive, Route_A_DOT_N2.State, RouteMonitoring_A_DOT_N2.State, RouteAutomaticRelease_A_DOT_N2.PassageLock, Zone_G11.State, NOW) ||
  RouteMonitoring_A_DOT_N2.InitialTransition({}, {PointControl_W1.Left, PointControl_W2.Left}, Route_A_DOT_N2.State, {Transit_W1_L_MINUS_.State, Transit_G21_MINUS_.State}) ||
  Route_A_DOT_N2.InitialTransition(SCICC_A_DOT_N2.MsgRequestRoute, {}, {Point_W1.State, Point_W2.State}, RouteAutomaticRelease_A_DOT_N2.State, RouteManualRelease_A_DOT_N2.ManualReleaseRequested) ||
  SignalControl_A.InitialTransition({RouteControl_A_DOT_N1.State, RouteControl_A_DOT_N2.State}) ||
  Signal_A.InitialTransition({Route_A_DOT_N1.State, Route_A_DOT_N2.State}) ||
  SignalControl_N1.InitialTransition({}) ||
  Signal_N1.InitialTransition({}) ||
  SignalControl_N2.InitialTransition({}) ||
  Signal_N2.InitialTransition({}) ||
  Transit_G11_PLUS_.InitialTransition(Zone_G11.State, {}, {Route_A_DOT_N1.State, Route_A_DOT_N2.State}, NOW) ||
  Transit_G11_MINUS_.InitialTransition(Zone_G11.State, {Transit_W1_R_MINUS_.State, Transit_W1_L_MINUS_.State}, {}, NOW) ||
  Transit_W1_R_PLUS_.InitialTransition(Zone_W1.State, {}, {Route_A_DOT_N1.State}, NOW) ||
  Transit_W1_R_MINUS_.InitialTransition(Zone_W1.State, {Transit_G12_MINUS_.State}, {}, NOW) ||
  Transit_W1_L_PLUS_.InitialTransition(Zone_W1.State, {}, {Route_A_DOT_N2.State}, NOW) ||
  Transit_W1_L_MINUS_.InitialTransition(Zone_W1.State, {Transit_W2_L_PLUS_.State}, {}, NOW) ||
  Transit_W2_R_PLUS_.InitialTransition(Zone_W2.State, {Transit_G21_MINUS_.State}, {}, NOW) ||
  Transit_W2_R_MINUS_.InitialTransition(Zone_W2.State, {}, {}, NOW) ||
  Transit_W2_L_PLUS_.InitialTransition(Zone_W2.State, {Transit_G21_MINUS_.State}, {}, NOW) ||
  Transit_W2_L_MINUS_.InitialTransition(Zone_W2.State, {Transit_W1_L_PLUS_.State}, {Route_A_DOT_N2.State}, NOW) ||
  Transit_G12_PLUS_.InitialTransition(Zone_G12.State, {Transit_W1_R_PLUS_.State}, {Route_A_DOT_N1.State}, NOW) ||
  Transit_G12_MINUS_.InitialTransition(Zone_G12.State, {}, {}, NOW) ||
  Transit_G21_PLUS_.InitialTransition(Zone_G21.State, {Transit_W2_R_MINUS_.State, Transit_W2_L_MINUS_.State}, {Route_A_DOT_N2.State}, NOW) ||
  Transit_G21_MINUS_.InitialTransition(Zone_G21.State, {}, {}, NOW) ||
  Zone_G11.InitialTransition(SCITDS_G11.OccupancyStatus) ||
  Zone_W1.InitialTransition(SCITDS_W1.OccupancyStatus) ||
  Zone_W2.InitialTransition(SCITDS_W2.OccupancyStatus) ||
  Zone_G12.InitialTransition(SCITDS_G12.OccupancyStatus) ||
  Zone_G21.InitialTransition(SCITDS_G21.OccupancyStatus)
OPERATIONS
  BigStep =
    BEGIN
      NOW := NOW + 150;
      Zone_G11.Transition(SCITDS_G11.OccupancyStatus);
      Zone_W1.Transition(SCITDS_W1.OccupancyStatus);
      Zone_W2.Transition(SCITDS_W2.OccupancyStatus);
      Zone_G12.Transition(SCITDS_G12.OccupancyStatus);
      Zone_G21.Transition(SCITDS_G21.OccupancyStatus);
      RouteAutomaticRelease_A_DOT_N1.Transition(Route_A_DOT_N1.State, Transit_W1_R_MINUS_.State, Zone_W1.State);
      RouteAutomaticRelease_A_DOT_N2.Transition(Route_A_DOT_N2.State, Transit_W1_L_MINUS_.State, Zone_W1.State);
      RouteManualRelease_A_DOT_N1.Transition(SCICC_A_DOT_N1.MsgReleaseRoute, SCIRBC_A.ApproachLockingActive, Route_A_DOT_N1.State, RouteMonitoring_A_DOT_N1.State, RouteAutomaticRelease_A_DOT_N1.PassageLock, Zone_G11.State, NOW);
      RouteManualRelease_A_DOT_N2.Transition(SCICC_A_DOT_N2.MsgReleaseRoute, SCIRBC_A.ApproachLockingActive, Route_A_DOT_N2.State, RouteMonitoring_A_DOT_N2.State, RouteAutomaticRelease_A_DOT_N2.PassageLock, Zone_G11.State, NOW);
      Route_A_DOT_N1.Transition(SCICC_A_DOT_N1.MsgRequestRoute, {Point_W1.State}, {}, RouteAutomaticRelease_A_DOT_N1.State, RouteManualRelease_A_DOT_N1.ManualReleaseRequested);
      Route_A_DOT_N2.Transition(SCICC_A_DOT_N2.MsgRequestRoute, {}, {Point_W1.State, Point_W2.State}, RouteAutomaticRelease_A_DOT_N2.State, RouteManualRelease_A_DOT_N2.ManualReleaseRequested);
      Transit_G11_PLUS_.Transition(Zone_G11.State, {}, {Route_A_DOT_N1.State, Route_A_DOT_N2.State}, NOW);
      Transit_G11_MINUS_.Transition(Zone_G11.State, {Transit_W1_R_MINUS_.State, Transit_W1_L_MINUS_.State}, {}, NOW);
      Transit_W1_R_PLUS_.Transition(Zone_W1.State, {}, {Route_A_DOT_N1.State}, NOW);
      Transit_W1_R_MINUS_.Transition(Zone_W1.State, {Transit_G12_MINUS_.State}, {}, NOW);
      Transit_W1_L_PLUS_.Transition(Zone_W1.State, {}, {Route_A_DOT_N2.State}, NOW);
      Transit_W1_L_MINUS_.Transition(Zone_W1.State, {Transit_W2_L_PLUS_.State}, {}, NOW);
      Transit_W2_R_PLUS_.Transition(Zone_W2.State, {Transit_G21_MINUS_.State}, {}, NOW);
      Transit_W2_R_MINUS_.Transition(Zone_W2.State, {}, {}, NOW);
      Transit_W2_L_PLUS_.Transition(Zone_W2.State, {Transit_G21_MINUS_.State}, {}, NOW);
      Transit_W2_L_MINUS_.Transition(Zone_W2.State, {Transit_W1_L_PLUS_.State}, {Route_A_DOT_N2.State}, NOW);
      Transit_G12_PLUS_.Transition(Zone_G12.State, {Transit_W1_R_PLUS_.State}, {Route_A_DOT_N1.State}, NOW);
      Transit_G12_MINUS_.Transition(Zone_G12.State, {}, {}, NOW);
      Transit_G21_PLUS_.Transition(Zone_G21.State, {Transit_W2_R_MINUS_.State, Transit_W2_L_MINUS_.State}, {Route_A_DOT_N2.State}, NOW);
      Transit_G21_MINUS_.Transition(Zone_G21.State, {}, {}, NOW);
      PointLockLeft_W1.Transition(SCIP_W1.DetectedEndPosition, {}, {});
      PointLockRight_W1.Transition(SCIP_W1.DetectedEndPosition, {}, {});
      Point_W1.Transition(SCIP_W1.DetectedEndPosition, {Route_A_DOT_N2.State}, {Route_A_DOT_N1.State}, PointLockLeft_W1.State, PointLockRight_W1.State);
      PointControl_W1.Transition(SCIP_W1.DetectedEndPosition, Point_W1.State);
      PointOperation_W1.Transition(Point_W1.State, SCIP_W1.DetectedEndPosition, {PointOperation_W1.Top, PointOperation_W2.Top}, NOW);
      PointLockLeft_W2.Transition(SCIP_W2.DetectedEndPosition, {}, {});
      PointLockRight_W2.Transition(SCIP_W2.DetectedEndPosition, {}, {});
      Point_W2.Transition(SCIP_W2.DetectedEndPosition, {Route_A_DOT_N2.State}, {}, PointLockLeft_W2.State, PointLockRight_W2.State);
      PointControl_W2.Transition(SCIP_W2.DetectedEndPosition, Point_W2.State);
      PointOperation_W2.Transition(Point_W2.State, SCIP_W2.DetectedEndPosition, {PointOperation_W1.Top, PointOperation_W2.Top}, NOW);
      RouteMonitoring_A_DOT_N1.Transition({PointControl_W1.Right}, {}, Route_A_DOT_N1.State, {Transit_W1_R_MINUS_.State, Transit_G12_MINUS_.State});
      RouteMonitoring_A_DOT_N2.Transition({}, {PointControl_W1.Left, PointControl_W2.Left}, Route_A_DOT_N2.State, {Transit_W1_L_MINUS_.State, Transit_G21_MINUS_.State});
      RouteControl_A_DOT_N1.Transition(RouteMonitoring_A_DOT_N1.State);
      RouteControl_A_DOT_N2.Transition(RouteMonitoring_A_DOT_N2.State);
      Signal_A.Transition({Route_A_DOT_N1.State, Route_A_DOT_N2.State});
      Signal_N1.Transition({});
      Signal_N2.Transition({});
      SignalControl_A.Transition({RouteControl_A_DOT_N1.State, RouteControl_A_DOT_N2.State});
      SignalControl_N1.Transition({});
      SignalControl_N2.Transition({})
    END
END//MACHINE
