MACHINE Signal
SEES Enums
SETS
  STATETYPE_Signal_root = { STATE_Signal_root___initial, STATE_Signal_root_SIGNAL_NOT_START, STATE_Signal_root_SIGNAL_IS_START }
VARIABLES
  RouteIsSet,
  State,
  GraphState_root
INVARIANT
  RouteIsSet : BOOL &
  State : E_ActiveInactive &
  GraphState_root : STATETYPE_Signal_root
INITIALIZATION
  RouteIsSet := FALSE;
  State := ActiveInactive_INACTIVE;
  GraphState_root := STATE_Signal_root___initial
OPERATIONS
  InitialTransition(routes_starting_here_Route_State) =
    BEGIN
      // Update Terms
      RouteIsSet := bool(RouteState_SET : routes_starting_here_Route_State);
      // Perform transition
        State := ActiveInactive_INACTIVE;
          GraphState_root := STATE_Signal_root_SIGNAL_NOT_START
    END;
  Transition(routes_starting_here_Route_State) =
    BEGIN
      // Update Terms
      RouteIsSet := bool(RouteState_SET : routes_starting_here_Route_State);
      // Perform transition
      SELECT GraphState_root = STATE_Signal_root_SIGNAL_NOT_START THEN 
        IF RouteIsSet = TRUE THEN
State := ActiveInactive_ACTIVE;
          GraphState_root := STATE_Signal_root_SIGNAL_IS_START
        END
      WHEN GraphState_root = STATE_Signal_root_SIGNAL_IS_START THEN 
        IF not(RouteIsSet = TRUE) THEN
State := ActiveInactive_INACTIVE;
          GraphState_root := STATE_Signal_root_SIGNAL_NOT_START
        END
      END
    END
END//MACHINE
