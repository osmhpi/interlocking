MACHINE Interlocking
INCLUDES PointControl_W1.PointControl, PointLockLeft_W1.PointLockLeft, PointLockRight_W1.PointLockRight, PointOperation_W1.PointOperation, Point_W1.Point, PointControl_W2.PointControl, PointLockLeft_W2.PointLockLeft, PointLockRight_W2.PointLockRight, PointOperation_W2.PointOperation, Point_W2.Point, RouteAutomaticRelease_A_DOT_N1.RouteAutomaticRelease, RouteControl_A_DOT_N1.RouteControl, RouteManualRelease_A_DOT_N1.RouteManualRelease, RouteMonitoring_A_DOT_N1.RouteMonitoring, Route_A_DOT_N1.Route, RouteAutomaticRelease_A_DOT_N2.RouteAutomaticRelease, RouteControl_A_DOT_N2.RouteControl, RouteManualRelease_A_DOT_N2.RouteManualRelease, RouteMonitoring_A_DOT_N2.RouteMonitoring, Route_A_DOT_N2.Route, SignalControl_A.SignalControl, Signal_A.Signal, SignalControl_N1.SignalControl, Signal_N1.Signal, SignalControl_N2.SignalControl, Signal_N2.Signal, Transit_G11_PLUS_.Transit, Transit_G11_MINUS_.Transit, Transit_W1_R_PLUS_.Transit, Transit_W1_R_MINUS_.Transit, Transit_W1_L_PLUS_.Transit, Transit_W1_L_MINUS_.Transit, Transit_W2_R_PLUS_.Transit, Transit_W2_R_MINUS_.Transit, Transit_W2_L_PLUS_.Transit, Transit_W2_L_MINUS_.Transit, Transit_G12_PLUS_.Transit, Transit_G12_MINUS_.Transit, Transit_G21_PLUS_.Transit, Transit_G21_MINUS_.Transit, Zone_G11.Zone, Zone_W1.Zone, Zone_W2.Zone, Zone_G12.Zone, Zone_G21.Zone
DEFINITIONS
  VISB_SVG_FILE == "trackplan.svg";
  VISB_SVG_UPDATES1== rec(`id`:"W1R",visibility: bool(W1.State = RIGHT));
  VISB_SVG_UPDATES2== rec(`id`:"W2R",visibility: bool(W2.State = RIGHT));
INITIALISATION
  PointControl_W1.InitialTransition ||
  PointLockLeft_W1.InitialTransition ||
  PointLockRight_W1.InitialTransition ||
  PointOperation_W1.InitialTransition ||
  Point_W1.InitialTransition ||
  PointControl_W2.InitialTransition ||
  PointLockLeft_W2.InitialTransition ||
  PointLockRight_W2.InitialTransition ||
  PointOperation_W2.InitialTransition ||
  Point_W2.InitialTransition ||
  RouteAutomaticRelease_A_DOT_N1.InitialTransition ||
  RouteControl_A_DOT_N1.InitialTransition ||
  RouteManualRelease_A_DOT_N1.InitialTransition ||
  RouteMonitoring_A_DOT_N1.InitialTransition ||
  Route_A_DOT_N1.InitialTransition ||
  RouteAutomaticRelease_A_DOT_N2.InitialTransition ||
  RouteControl_A_DOT_N2.InitialTransition ||
  RouteManualRelease_A_DOT_N2.InitialTransition ||
  RouteMonitoring_A_DOT_N2.InitialTransition ||
  Route_A_DOT_N2.InitialTransition ||
  SignalControl_A.InitialTransition ||
  Signal_A.InitialTransition ||
  SignalControl_N1.InitialTransition ||
  Signal_N1.InitialTransition ||
  SignalControl_N2.InitialTransition ||
  Signal_N2.InitialTransition ||
  Transit_G11_PLUS_.InitialTransition ||
  Transit_G11_MINUS_.InitialTransition ||
  Transit_W1_R_PLUS_.InitialTransition ||
  Transit_W1_R_MINUS_.InitialTransition ||
  Transit_W1_L_PLUS_.InitialTransition ||
  Transit_W1_L_MINUS_.InitialTransition ||
  Transit_W2_R_PLUS_.InitialTransition ||
  Transit_W2_R_MINUS_.InitialTransition ||
  Transit_W2_L_PLUS_.InitialTransition ||
  Transit_W2_L_MINUS_.InitialTransition ||
  Transit_G12_PLUS_.InitialTransition ||
  Transit_G12_MINUS_.InitialTransition ||
  Transit_G21_PLUS_.InitialTransition ||
  Transit_G21_MINUS_.InitialTransition ||
  Zone_G11.InitialTransition ||
  Zone_W1.InitialTransition ||
  Zone_W2.InitialTransition ||
  Zone_G12.InitialTransition ||
  Zone_G21.InitialTransition
OPERATIONS
  BigStep =
    BEGIN
      Zone_G11.Transition;
      Zone_W1.Transition;
      Zone_W2.Transition;
      Zone_G12.Transition;
      Zone_G21.Transition;
      RouteAutomaticRelease_A_DOT_N1.Transition;
      RouteAutomaticRelease_A_DOT_N2.Transition;
      RouteManualRelease_A_DOT_N1.Transition;
      RouteManualRelease_A_DOT_N2.Transition;
      Route_A_DOT_N1.Transition;
      Route_A_DOT_N2.Transition;
      Transit_G11_PLUS_.Transition;
      Transit_G11_MINUS_.Transition;
      Transit_W1_R_PLUS_.Transition;
      Transit_W1_R_MINUS_.Transition;
      Transit_W1_L_PLUS_.Transition;
      Transit_W1_L_MINUS_.Transition;
      Transit_W2_R_PLUS_.Transition;
      Transit_W2_R_MINUS_.Transition;
      Transit_W2_L_PLUS_.Transition;
      Transit_W2_L_MINUS_.Transition;
      Transit_G12_PLUS_.Transition;
      Transit_G12_MINUS_.Transition;
      Transit_G21_PLUS_.Transition;
      Transit_G21_MINUS_.Transition;
      PointLockLeft_W1.Transition;
      PointLockRight_W1.Transition;
      Point_W1.Transition;
      PointControl_W1.Transition;
      PointOperation_W1.Transition;
      PointLockLeft_W2.Transition;
      PointLockRight_W2.Transition;
      Point_W2.Transition;
      PointControl_W2.Transition;
      PointOperation_W2.Transition;
      RouteMonitoring_A_DOT_N1.Transition;
      RouteMonitoring_A_DOT_N2.Transition;
      RouteControl_A_DOT_N1.Transition;
      RouteControl_A_DOT_N2.Transition;
      Signal_A.Transition;
      Signal_N1.Transition;
      Signal_N2.Transition;
      SignalControl_A.Transition;
      SignalControl_N1.Transition;
      SignalControl_N2.Transition
    END
END//MACHINE