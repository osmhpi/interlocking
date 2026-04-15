MACHINE SignalControl
SEES Enums
SETS
  STATE_SignalControl_root = { STATE_SignalControl_root___initial, STATE_SignalControl_root_CLOSED, STATE_SignalControl_root_OPEN }
VARIABLES
  RouteOpening,
  State,
  GraphState
INVARIANT
  RouteOpening : BOOL &
  State : OpenCloseState &
  GraphState : STATE_SignalControl_root
INITIALIZATION
  RouteOpening := FALSE;
  State := OpenCloseState_CLOSED;
  GraphState := STATE_SignalControl_root___initial
OPERATIONS
  InitialTransition =
    BEGIN
      // Update Terms
      RouteOpening := OpenCloseState_OPEN : routes_starting_here_RouteControl_State;
      // Perform transition
      SELECT GraphState = STATE_SignalControl_root___initial THEN
        GraphState := STATE_SignalControl_root___initial
      END;
    END
  Transition(routes_starting_here_RouteControl_State) =
    BEGIN
      // Update Terms
      RouteOpening := OpenCloseState_OPEN : routes_starting_here_RouteControl_State;
      // Perform transition
      SELECT GraphState = STATE_SignalControl_root___initial THEN
        GraphState := STATE_SignalControl_root___initial
      END
    END
END//MACHINE
