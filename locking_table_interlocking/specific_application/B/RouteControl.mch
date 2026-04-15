MACHINE RouteControl
SEES Enums
SETS
  STATE_RouteControl_root = { STATE_RouteControl_root___initial, STATE_RouteControl_root_CLOSED, STATE_RouteControl_root_OPEN }
VARIABLES
  RouteMonitored,
  State,
  GraphState
INVARIANT
  RouteMonitored : BOOL &
  State : OpenCloseState &
  GraphState : STATE_RouteControl_root
INITIALIZATION
  RouteMonitored := FALSE;
  State := OpenCloseState_CLOSED;
  GraphState := STATE_RouteControl_root___initial
OPERATIONS
  InitialTransition =
    BEGIN
      // Update Terms
      RouteMonitored := RouteMonitoring_State = ActiveInactive_ACTIVE;
      // Perform transition
      SELECT GraphState = STATE_RouteControl_root___initial THEN
        GraphState := STATE_RouteControl_root___initial
      END;
    END
  Transition(RouteMonitoring_State) =
    BEGIN
      // Update Terms
      RouteMonitored := RouteMonitoring_State = ActiveInactive_ACTIVE;
      // Perform transition
      SELECT GraphState = STATE_RouteControl_root___initial THEN
        GraphState := STATE_RouteControl_root___initial
      END
    END
END//MACHINE
