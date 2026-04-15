MACHINE PointOperation
SEES Enums
SETS
  STATE_PointOperation_root = { STATE_PointOperation_root___initial, STATE_PointOperation_root_IDLE_LEFT, STATE_PointOperation_root_IDLE_RIGHT, STATE_PointOperation_root_IDLE_UNDETERMINED, STATE_PointOperation_root_WAITING_COMMAND_RIGHT, STATE_PointOperation_root_WAITING_COMMAND_LEFT, STATE_PointOperation_root_TOP_COMMAND_LEFT, STATE_PointOperation_root_TOP_COMMAND_RIGHT, STATE_PointOperation_root_DELAY_TOP }
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
  GraphState
INVARIANT
  PointTriggered : BOOL &
  PointLeft : BOOL &
  PointRight : BOOL &
  IsTop : BOOL &
  TopTimeout : BOOL &
  PreviousPointState : PointState &
  Top : ActiveInactive &
  TopStart : timestamp &
  State : EulynxCommandedEndPosition &
  GraphState : STATE_PointOperation_root
INITIALIZATION
  PointTriggered := FALSE;
  PointLeft := FALSE;
  PointRight := FALSE;
  IsTop := FALSE;
  TopTimeout := FALSE;
  PreviousPointState := PointState_UNDETERMINED;
  Top := ActiveInactive_ACTIVE;
  TopStart := _;
  State := EulynxCommandedEndPosition_NOT_COMMANDED;
  GraphState := STATE_PointOperation_root___initial
OPERATIONS
  InitialTransition =
    BEGIN
      // Update Terms
      PointTriggered := (Point_State = PointState_LEFT AND PreviousPointState /= PointState_LEFT AND SCIP_DetectedEndPosition /= EulynxEndPosition_LEFT) OR (Point_State = PointState_RIGHT AND PreviousPointState /= PointState_RIGHT AND SCIP_DetectedEndPosition /= EulynxEndPosition_RIGHT) ||
      PointLeft := Point_State = PointState_LEFT ||
      PointRight := Point_State = PointState_RIGHT ||
      IsTop := !(point).(point : dom(all_points_PointOperation_Top) => all_points_PointOperation_Top(point) = ActiveInactive_ACTIVE ) ||
      TopTimeout := NOW >= TopStart + 300ms;
      // Perform transition
      SELECT GraphState = STATE_PointOperation_root___initial THEN
        GraphState := STATE_PointOperation_root___initial
      END;
    END
  Transition(Point_State, SCIP_DetectedEndPosition, all_points_PointOperation_Top) =
    BEGIN
      // Update Terms
      PointTriggered := (Point_State = PointState_LEFT AND PreviousPointState /= PointState_LEFT AND SCIP_DetectedEndPosition /= EulynxEndPosition_LEFT) OR (Point_State = PointState_RIGHT AND PreviousPointState /= PointState_RIGHT AND SCIP_DetectedEndPosition /= EulynxEndPosition_RIGHT) ||
      PointLeft := Point_State = PointState_LEFT ||
      PointRight := Point_State = PointState_RIGHT ||
      IsTop := !(point).(point : dom(all_points_PointOperation_Top) => all_points_PointOperation_Top(point) = ActiveInactive_ACTIVE ) ||
      TopTimeout := NOW >= TopStart + 300ms;
      // Perform transition
      SELECT GraphState = STATE_PointOperation_root___initial THEN
        GraphState := STATE_PointOperation_root___initial
      END
    END
END//MACHINE
