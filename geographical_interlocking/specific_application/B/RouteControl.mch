MACHINE RouteControl
SEES Enums
SETS
  STATETYPE_RouteControl_root = { STATE_RouteControl_root___initial, STATE_RouteControl_root_CLOSED, STATE_RouteControl_root_OPEN }
VARIABLES
  RouteMonitored,
  State,
  GraphState_root
INVARIANT
  RouteMonitored : BOOL &
  State : E_OpenCloseState &
  GraphState_root : STATETYPE_RouteControl_root
INITIALIZATION
  RouteMonitored := FALSE;
  State := OpenCloseState_CLOSED;
  GraphState_root := STATE_RouteControl_root___initial
OPERATIONS
  InitialTransition(RouteMonitoring_State) =
    BEGIN
      // Update Terms
      RouteMonitored := bool(RouteMonitoring_State = ActiveInactive_ACTIVE);
      // Perform transition
        State := OpenCloseState_CLOSED;
          GraphState_root := STATE_RouteControl_root_CLOSED
    END;
  Transition(RouteMonitoring_State) =
    BEGIN
      // Update Terms
      RouteMonitored := bool(RouteMonitoring_State = ActiveInactive_ACTIVE);
      // Perform transition
      SELECT GraphState_root = STATE_RouteControl_root_CLOSED THEN 
        IF RouteMonitored = TRUE THEN
State := OpenCloseState_OPEN;
          GraphState_root := STATE_RouteControl_root_OPEN
        END
      END;
      SELECT GraphState_root = STATE_RouteControl_root_OPEN THEN 
        IF not(RouteMonitored = TRUE) THEN
State := OpenCloseState_CLOSED;
          GraphState_root := STATE_RouteControl_root_CLOSED
        END
      END
    END
END//MACHINE
