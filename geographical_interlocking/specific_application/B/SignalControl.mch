MACHINE SignalControl
SEES Enums
SETS
  STATE_SignalControl_root = { STATE_SignalControl_root___initial, STATE_SignalControl_root_CLOSED, STATE_SignalControl_root_OPEN }
VARIABLES
  RouteOpening,
  State,
  GraphState_root
INVARIANT
  RouteOpening : BOOL &
  State : OpenCloseState &
  GraphState_root : STATE_SignalControl_root
INITIALIZATION
  RouteOpening := FALSE;
  State := OpenCloseState_CLOSED;
  GraphState_root := STATE_SignalControl_root___initial
OPERATIONS
  InitialTransition(routes_starting_here_RouteControl_State) =
    BEGIN
      // Update Terms
      RouteOpening := bool(OpenCloseState_OPEN : routes_starting_here_RouteControl_State);
      // Perform transition
        State := OpenCloseState_CLOSED;
        GraphState_root := STATE_SignalControl_root_CLOSED
    END;
  Transition(routes_starting_here_RouteControl_State) =
    BEGIN
      // Update Terms
      RouteOpening := bool(OpenCloseState_OPEN : routes_starting_here_RouteControl_State);
      // Perform transition
      SELECT GraphState_root = STATE_SignalControl_root_CLOSED THEN 
        IF RouteOpening = TRUE THEN
State := OpenCloseState_OPEN;
          GraphState_root := STATE_SignalControl_root_OPEN

        END
      END;
      SELECT GraphState_root = STATE_SignalControl_root_OPEN THEN 
        IF not(RouteOpening = TRUE) THEN
State := OpenCloseState_CLOSED;
          GraphState_root := STATE_SignalControl_root_CLOSED

        END
      END
    END
END//MACHINE
