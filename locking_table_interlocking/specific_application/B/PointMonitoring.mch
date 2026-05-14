MACHINE PointMonitoring
SEES Enums
SETS
  STATETYPE_PointMonitoring_root = { STATE_PointMonitoring_root___initial, STATE_PointMonitoring_root_MONITORED_LEFT, STATE_PointMonitoring_root_MONITORED_RIGHT, STATE_PointMonitoring_root_NOT_MONITORED }
VARIABLES
  EndPositionLeftDetected,
  EndPositionRightDetected,
  CommandedLeft,
  CommandedRight,
  Left,
  Right,
  GraphState_root
INVARIANT
  EndPositionLeftDetected : BOOL &
  EndPositionRightDetected : BOOL &
  CommandedLeft : BOOL &
  CommandedRight : BOOL &
  Left : E_ActiveInactive &
  Right : E_ActiveInactive &
  GraphState_root : STATETYPE_PointMonitoring_root
INITIALIZATION
  EndPositionLeftDetected := FALSE;
  EndPositionRightDetected := FALSE;
  CommandedLeft := FALSE;
  CommandedRight := FALSE;
  Left := ActiveInactive_INACTIVE;
  Right := ActiveInactive_INACTIVE;
  GraphState_root := STATE_PointMonitoring_root___initial
OPERATIONS
  InitialTransition(SCIP_DetectedEndPosition, PointNominalPosition_State) =
    BEGIN
      // Update Terms
      EndPositionLeftDetected := bool(SCIP_DetectedEndPosition = EulynxEndPosition_LEFT) ||
      EndPositionRightDetected := bool(SCIP_DetectedEndPosition = EulynxEndPosition_RIGHT) ||
      CommandedLeft := bool(PointNominalPosition_State = PointState_LEFT) ||
      CommandedRight := bool(PointNominalPosition_State = PointState_RIGHT);
      // Perform transition
        IF EndPositionLeftDetected = TRUE THEN
Left := ActiveInactive_ACTIVE;
      Right := ActiveInactive_INACTIVE;
          GraphState_root := STATE_PointMonitoring_root_MONITORED_LEFT
        ELSIF EndPositionRightDetected = TRUE THEN
Right := ActiveInactive_ACTIVE;
      Left := ActiveInactive_INACTIVE;
          GraphState_root := STATE_PointMonitoring_root_MONITORED_RIGHT
        ELSE
        Left := ActiveInactive_INACTIVE;
      Right := ActiveInactive_INACTIVE;
          GraphState_root := STATE_PointMonitoring_root_NOT_MONITORED
        END
    END;
  Transition(SCIP_DetectedEndPosition, PointNominalPosition_State) =
    BEGIN
      // Update Terms
      EndPositionLeftDetected := bool(SCIP_DetectedEndPosition = EulynxEndPosition_LEFT) ||
      EndPositionRightDetected := bool(SCIP_DetectedEndPosition = EulynxEndPosition_RIGHT) ||
      CommandedLeft := bool(PointNominalPosition_State = PointState_LEFT) ||
      CommandedRight := bool(PointNominalPosition_State = PointState_RIGHT);
      // Perform transition
      SELECT GraphState_root = STATE_PointMonitoring_root_MONITORED_LEFT THEN 
        IF not(EndPositionLeftDetected = TRUE) or not(CommandedLeft = TRUE) THEN
Left := ActiveInactive_INACTIVE;
      Right := ActiveInactive_INACTIVE;
          GraphState_root := STATE_PointMonitoring_root_NOT_MONITORED
        END
      WHEN GraphState_root = STATE_PointMonitoring_root_MONITORED_RIGHT THEN 
        IF not(EndPositionRightDetected = TRUE) or not(CommandedRight = TRUE) THEN
Left := ActiveInactive_INACTIVE;
      Right := ActiveInactive_INACTIVE;
          GraphState_root := STATE_PointMonitoring_root_NOT_MONITORED
        END
      WHEN GraphState_root = STATE_PointMonitoring_root_NOT_MONITORED THEN 
        IF EndPositionLeftDetected = TRUE & CommandedLeft = TRUE THEN
Left := ActiveInactive_ACTIVE;
      Right := ActiveInactive_INACTIVE;
          GraphState_root := STATE_PointMonitoring_root_MONITORED_LEFT
        ELSIF EndPositionRightDetected = TRUE & CommandedRight = TRUE THEN
Right := ActiveInactive_ACTIVE;
      Left := ActiveInactive_INACTIVE;
          GraphState_root := STATE_PointMonitoring_root_MONITORED_RIGHT
        END
      END
    END
END//MACHINE
