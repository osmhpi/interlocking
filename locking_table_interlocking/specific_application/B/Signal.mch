MACHINE Signal
SEES Enums
SETS
  STATETYPE_Signal_root = { STATE_Signal_root___initial, STATE_Signal_root_CLOSED, STATE_Signal_root_OPEN }
VARIABLES
  RouteOpening,
  State,
  GraphState_root
INVARIANT
  RouteOpening : BOOL &
  State : E_OpenCloseState &
  GraphState_root : STATETYPE_Signal_root
INITIALIZATION
  RouteOpening := FALSE;
  State := OpenCloseState_CLOSED;
  GraphState_root := STATE_Signal_root___initial
OPERATIONS
  InitialTransition(routes_starting_here_RouteMonitoring_State) =
    BEGIN
      // Update Terms
      RouteOpening := bool(ActiveInactive_ACTIVE : routes_starting_here_RouteMonitoring_State);
      // Perform transition
        State := OpenCloseState_CLOSED;
          GraphState_root := STATE_Signal_root_CLOSED
    END;
  Transition(routes_starting_here_RouteMonitoring_State) =
    BEGIN
      // Update Terms
      RouteOpening := bool(ActiveInactive_ACTIVE : routes_starting_here_RouteMonitoring_State);
      // Perform transition
      SELECT GraphState_root = STATE_Signal_root_CLOSED THEN 
        IF RouteOpening = TRUE THEN
State := OpenCloseState_OPEN;
          GraphState_root := STATE_Signal_root_OPEN
        END
      WHEN GraphState_root = STATE_Signal_root_OPEN THEN 
        IF not(RouteOpening = TRUE) THEN
State := OpenCloseState_CLOSED;
          GraphState_root := STATE_Signal_root_CLOSED
        END
      END
    END
END//MACHINE
