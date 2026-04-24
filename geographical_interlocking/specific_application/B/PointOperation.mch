MACHINE PointOperation
SEES Enums
SETS
  STATETYPE_PointOperation_root = { STATE_PointOperation_root___initial, STATE_PointOperation_root_IDLE_LEFT, STATE_PointOperation_root_IDLE_RIGHT, STATE_PointOperation_root_IDLE_UNDETERMINED, STATE_PointOperation_root_WAITING_COMMAND_RIGHT, STATE_PointOperation_root_WAITING_COMMAND_LEFT, STATE_PointOperation_root_TOP_COMMAND_LEFT, STATE_PointOperation_root_TOP_COMMAND_RIGHT, STATE_PointOperation_root_DELAY_TOP }
VARIABLES
  PointTriggered,
  PointLeft,
  PointRight,
  IsTop,
  TopTimeout,
  PreviousPointState,
  Top,
  TopStart,
  State,
  GraphState_root
INVARIANT
  PointTriggered : BOOL &
  PointLeft : BOOL &
  PointRight : BOOL &
  IsTop : BOOL &
  TopTimeout : BOOL &
  PreviousPointState : E_PointState &
  Top : E_ActiveInactive &
  TopStart : INTEGER &
  State : E_EulynxCommandedEndPosition &
  GraphState_root : STATETYPE_PointOperation_root
INITIALIZATION
  PointTriggered := FALSE;
  PointLeft := FALSE;
  PointRight := FALSE;
  IsTop := FALSE;
  TopTimeout := FALSE;
  PreviousPointState := PointState_UNDETERMINED;
  Top := ActiveInactive_ACTIVE;
  TopStart := 0;
  State := EulynxCommandedEndPosition_NOT_COMMANDED;
  GraphState_root := STATE_PointOperation_root___initial
OPERATIONS
  InitialTransition(Point_State, SCIP_DetectedEndPosition, all_points_PointOperation_Top, NOW) =
    BEGIN
      // Update Terms
      PointTriggered := bool((Point_State = PointState_LEFT & PreviousPointState /= PointState_LEFT & SCIP_DetectedEndPosition /= EulynxEndPosition_LEFT) or (Point_State = PointState_RIGHT & PreviousPointState /= PointState_RIGHT & SCIP_DetectedEndPosition /= EulynxEndPosition_RIGHT)) ||
      PointLeft := bool(Point_State = PointState_LEFT) ||
      PointRight := bool(Point_State = PointState_RIGHT) ||
      IsTop := bool(({ActiveInactive_ACTIVE} = all_points_PointOperation_Top or {} = all_points_PointOperation_Top)) ||
      TopTimeout := bool(NOW >= TopStart + 300);
      // Perform transition
        IF PointLeft = TRUE THEN
PreviousPointState := PointState_LEFT;
      Top := ActiveInactive_ACTIVE;
      State := EulynxCommandedEndPosition_NOT_COMMANDED;
          GraphState_root := STATE_PointOperation_root_IDLE_LEFT
        ELSIF PointRight = TRUE THEN
PreviousPointState := PointState_RIGHT;
      Top := ActiveInactive_ACTIVE;
      State := EulynxCommandedEndPosition_NOT_COMMANDED;
          GraphState_root := STATE_PointOperation_root_IDLE_RIGHT
        ELSE
        PreviousPointState := PointState_UNDETERMINED;
      Top := ActiveInactive_ACTIVE;
      State := EulynxCommandedEndPosition_NOT_COMMANDED;
          GraphState_root := STATE_PointOperation_root_IDLE_UNDETERMINED
        END
    END;
  Transition(Point_State, SCIP_DetectedEndPosition, all_points_PointOperation_Top, NOW) =
    BEGIN
      // Update Terms
      PointTriggered := bool((Point_State = PointState_LEFT & PreviousPointState /= PointState_LEFT & SCIP_DetectedEndPosition /= EulynxEndPosition_LEFT) or (Point_State = PointState_RIGHT & PreviousPointState /= PointState_RIGHT & SCIP_DetectedEndPosition /= EulynxEndPosition_RIGHT)) ||
      PointLeft := bool(Point_State = PointState_LEFT) ||
      PointRight := bool(Point_State = PointState_RIGHT) ||
      IsTop := bool(({ActiveInactive_ACTIVE} = all_points_PointOperation_Top or {} = all_points_PointOperation_Top)) ||
      TopTimeout := bool(NOW >= TopStart + 300);
      // Perform transition
      SELECT GraphState_root = STATE_PointOperation_root_IDLE_LEFT THEN 
        IF PointTriggered = TRUE THEN
PreviousPointState := PointState_RIGHT;
      Top := ActiveInactive_ACTIVE;
          GraphState_root := STATE_PointOperation_root_WAITING_COMMAND_RIGHT
        END
      WHEN GraphState_root = STATE_PointOperation_root_IDLE_RIGHT THEN 
        IF PointTriggered = TRUE THEN
PreviousPointState := PointState_LEFT;
      Top := ActiveInactive_ACTIVE;
          GraphState_root := STATE_PointOperation_root_WAITING_COMMAND_LEFT
        END
      WHEN GraphState_root = STATE_PointOperation_root_IDLE_UNDETERMINED THEN 
        IF PointTriggered = TRUE & PointRight = TRUE THEN
PreviousPointState := PointState_RIGHT;
      Top := ActiveInactive_ACTIVE;
          GraphState_root := STATE_PointOperation_root_WAITING_COMMAND_RIGHT
        ELSIF PointTriggered = TRUE & PointLeft = TRUE THEN
PreviousPointState := PointState_LEFT;
      Top := ActiveInactive_ACTIVE;
          GraphState_root := STATE_PointOperation_root_WAITING_COMMAND_LEFT
        END
      WHEN GraphState_root = STATE_PointOperation_root_WAITING_COMMAND_RIGHT THEN 
        IF IsTop = TRUE THEN
Top := ActiveInactive_INACTIVE;
      TopStart := NOW;
      State := EulynxCommandedEndPosition_RIGHT;
          GraphState_root := STATE_PointOperation_root_TOP_COMMAND_RIGHT
        ELSIF PointTriggered = TRUE THEN
PreviousPointState := PointState_LEFT;
      Top := ActiveInactive_ACTIVE;
      State := EulynxCommandedEndPosition_NOT_COMMANDED;
          GraphState_root := STATE_PointOperation_root_IDLE_LEFT
        END
      WHEN GraphState_root = STATE_PointOperation_root_WAITING_COMMAND_LEFT THEN 
        IF IsTop = TRUE THEN
Top := ActiveInactive_INACTIVE;
      TopStart := NOW;
      State := EulynxCommandedEndPosition_LEFT;
          GraphState_root := STATE_PointOperation_root_TOP_COMMAND_LEFT
        ELSIF PointTriggered = TRUE THEN
PreviousPointState := PointState_RIGHT;
      Top := ActiveInactive_ACTIVE;
      State := EulynxCommandedEndPosition_NOT_COMMANDED;
          GraphState_root := STATE_PointOperation_root_IDLE_RIGHT
        END
      WHEN GraphState_root = STATE_PointOperation_root_TOP_COMMAND_RIGHT THEN 
        Top := ActiveInactive_INACTIVE;
      State := EulynxCommandedEndPosition_NOT_COMMANDED;
          GraphState_root := STATE_PointOperation_root_DELAY_TOP
      WHEN GraphState_root = STATE_PointOperation_root_TOP_COMMAND_LEFT THEN 
        Top := ActiveInactive_INACTIVE;
      State := EulynxCommandedEndPosition_NOT_COMMANDED;
          GraphState_root := STATE_PointOperation_root_DELAY_TOP
      WHEN GraphState_root = STATE_PointOperation_root_DELAY_TOP THEN 
        IF TopTimeout = TRUE & PointLeft = TRUE THEN
PreviousPointState := PointState_LEFT;
      Top := ActiveInactive_ACTIVE;
      State := EulynxCommandedEndPosition_NOT_COMMANDED;
          GraphState_root := STATE_PointOperation_root_IDLE_LEFT
        ELSIF TopTimeout = TRUE & PointRight = TRUE THEN
PreviousPointState := PointState_RIGHT;
      Top := ActiveInactive_ACTIVE;
      State := EulynxCommandedEndPosition_NOT_COMMANDED;
          GraphState_root := STATE_PointOperation_root_IDLE_RIGHT
        ELSIF TopTimeout = TRUE THEN
PreviousPointState := PointState_UNDETERMINED;
      Top := ActiveInactive_ACTIVE;
      State := EulynxCommandedEndPosition_NOT_COMMANDED;
          GraphState_root := STATE_PointOperation_root_IDLE_UNDETERMINED
        END
      END
    END
END//MACHINE
