MACHINE Signal
SEES Enums
SETS
  STATE_Signal_root = { STATE_Signal_root___initial, STATE_Signal_root_SIGNAL_NOT_START, STATE_Signal_root_SIGNAL_IS_START }
VARIABLES
  RouteIsSet,
  State,
  GraphState
INVARIANT
  RouteIsSet : BOOL &
  State : ActiveInactive &
  GraphState : STATE_Signal_root
INITIALIZATION
  RouteIsSet := FALSE;
  State := ActiveInactive_INACTIVE;
  GraphState := STATE_Signal_root___initial
OPERATIONS
  InitialTransition =
    BEGIN
      // Update Terms
      RouteIsSet := RouteState_SET : routes_starting_here_Route_State;
      // Perform transition
      SELECT GraphState = STATE_Signal_root___initial THEN
        GraphState := STATE_Signal_root___initial
      END;
    END
  Transition(routes_starting_here_Route_State) =
    BEGIN
      // Update Terms
      RouteIsSet := RouteState_SET : routes_starting_here_Route_State;
      // Perform transition
      SELECT GraphState = STATE_Signal_root___initial THEN
        GraphState := STATE_Signal_root___initial
      END
    END
END//MACHINE
