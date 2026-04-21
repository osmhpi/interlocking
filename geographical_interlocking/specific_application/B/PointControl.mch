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
  GraphState_root
INVARIANT
  EndPositionLeftDetected : BOOL &
  EndPositionRightDetected : BOOL &
  CommandedLeft : BOOL &
  CommandedRight : BOOL &
  Left : ActiveInactive &
  Right : ActiveInactive &
  GraphState_root : STATE_PointControl_root
INITIALIZATION
  EndPositionLeftDetected := FALSE;
  EndPositionRightDetected := FALSE;
  CommandedLeft := FALSE;
  CommandedRight := FALSE;
  Left := ActiveInactive_INACTIVE;
  Right := ActiveInactive_INACTIVE;
  GraphState_root := STATE_PointControl_root___initial
OPERATIONS
  InitialTransition(SCIP_DetectedEndPosition, Point_State) =
    BEGIN
      // Update Terms
      EndPositionLeftDetected := bool(SCIP_DetectedEndPosition = EulynxEndPosition_LEFT) ||
      EndPositionRightDetected := bool(SCIP_DetectedEndPosition = EulynxEndPosition_RIGHT) ||
      CommandedLeft := bool(Point_State = PointState_LEFT) ||
      CommandedRight := bool(Point_State = PointState_RIGHT);
      // Perform transition, todo
      GraphState_root := STATE_PointControl_root___initial
    END;
  Transition(SCIP_DetectedEndPosition, Point_State) =
    BEGIN
      // Update Terms
      EndPositionLeftDetected := bool(SCIP_DetectedEndPosition = EulynxEndPosition_LEFT) ||
      EndPositionRightDetected := bool(SCIP_DetectedEndPosition = EulynxEndPosition_RIGHT) ||
      CommandedLeft := bool(Point_State = PointState_LEFT) ||
      CommandedRight := bool(Point_State = PointState_RIGHT);
      // Perform transition
      SELECT GraphState_root = STATE_PointControl_root_CONTROLLED_LEFT THEN 
        IF not(EndPositionLeftDetected = TRUE) or not(CommandedLeft = TRUE) THEN
          Left := ActiveInactive_INACTIVE;
          Right := ActiveInactive_INACTIVE;
          GraphState_root := STATE_PointControl_root_NOT_CONTROLLED
        END
      END;
      SELECT GraphState_root = STATE_PointControl_root_CONTROLLED_RIGHT THEN 
        IF not(EndPositionRightDetected = TRUE) or not(CommandedRight = TRUE) THEN
          Left := ActiveInactive_INACTIVE;
          Right := ActiveInactive_INACTIVE;
          GraphState_root := STATE_PointControl_root_NOT_CONTROLLED
        END
      END;
      SELECT GraphState_root = STATE_PointControl_root_NOT_CONTROLLED THEN 
        IF EndPositionLeftDetected = TRUE & CommandedLeft = TRUE THEN
          Left := ActiveInactive_ACTIVE;
          Right := ActiveInactive_INACTIVE;
          GraphState_root := STATE_PointControl_root_CONTROLLED_LEFT
        END
        IF EndPositionRightDetected = TRUE & CommandedRight = TRUE THEN
          Right := ActiveInactive_ACTIVE;
          Left := ActiveInactive_INACTIVE;
          GraphState_root := STATE_PointControl_root_CONTROLLED_RIGHT
        END
      END
    END
END//MACHINE
