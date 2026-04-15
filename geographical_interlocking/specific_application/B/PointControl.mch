MACHINE PointControl
SEES Enums
SETS
  STATE_PointControl_root = { STATE_PointControl_root___initial, STATE_PointControl_root_CONTROLLED_LEFT, STATE_PointControl_root_CONTROLLED_RIGHT, STATE_PointControl_root_NOT_CONTROLLED }
VARIABLES
  EndPositionLeftDetected,
  EndPositionRightDetected,
  CommandedLeft,
  CommandedRight,
  Left,
  Right,
  GraphState
INVARIANT
  EndPositionLeftDetected : BOOL &
  EndPositionRightDetected : BOOL &
  CommandedLeft : BOOL &
  CommandedRight : BOOL &
  Left : ActiveInactive &
  Right : ActiveInactive &
  GraphState : STATE_PointControl_root
INITIALIZATION
  EndPositionLeftDetected := FALSE;
  EndPositionRightDetected := FALSE;
  CommandedLeft := FALSE;
  CommandedRight := FALSE;
  Left := ActiveInactive_INACTIVE;
  Right := ActiveInactive_INACTIVE;
  GraphState := STATE_PointControl_root___initial
OPERATIONS
  InitialTransition =
    BEGIN
      // Update Terms
      EndPositionLeftDetected := SCIP_DetectedEndPosition = EulynxEndPosition_LEFT ||
      EndPositionRightDetected := SCIP_DetectedEndPosition = EulynxEndPosition_RIGHT ||
      CommandedLeft := Point_State = PointState_LEFT ||
      CommandedRight := Point_State = PointState_RIGHT;
      // Perform transition
      SELECT GraphState = STATE_PointControl_root___initial THEN
        GraphState := STATE_PointControl_root___initial
      END;
    END
  Transition(SCIP_DetectedEndPosition, Point_State) =
    BEGIN
      // Update Terms
      EndPositionLeftDetected := SCIP_DetectedEndPosition = EulynxEndPosition_LEFT ||
      EndPositionRightDetected := SCIP_DetectedEndPosition = EulynxEndPosition_RIGHT ||
      CommandedLeft := Point_State = PointState_LEFT ||
      CommandedRight := Point_State = PointState_RIGHT;
      // Perform transition
      SELECT GraphState = STATE_PointControl_root___initial THEN
        GraphState := STATE_PointControl_root___initial
      END
    END
END//MACHINE
