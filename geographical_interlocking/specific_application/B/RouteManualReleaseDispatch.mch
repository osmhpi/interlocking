MACHINE RouteManualReleaseDispatch
SEES Enums
SETS
  STATE_RouteManualReleaseDispatch_root = { STATE_RouteManualReleaseDispatch_root___initial, STATE_RouteManualReleaseDispatch_root_IDLE, STATE_RouteManualReleaseDispatch_root_ACTIVE }
VARIABLES
  RouteReleaseRequested,
  State,
  GraphState
INVARIANT
  RouteReleaseRequested : BOOL &
  State : ActiveInactive &
  GraphState : STATE_RouteManualReleaseDispatch_root
INITIALIZATION
  RouteReleaseRequested := FALSE;
  State := ActiveInactive_INACTIVE;
  GraphState := STATE_RouteManualReleaseDispatch_root___initial
OPERATIONS
  InitialTransition =
    BEGIN
      // Update Terms
      RouteReleaseRequested := TRUE : is_start_of_route_admission_check_SCICC_MsgReleaseRoute;
      // Perform transition
      SELECT GraphState = STATE_RouteManualReleaseDispatch_root___initial THEN
        GraphState := STATE_RouteManualReleaseDispatch_root___initial
      END;
    END
  Transition(is_start_of_route_admission_check_SCICC_MsgReleaseRoute) =
    BEGIN
      // Update Terms
      RouteReleaseRequested := TRUE : is_start_of_route_admission_check_SCICC_MsgReleaseRoute;
      // Perform transition
      SELECT GraphState = STATE_RouteManualReleaseDispatch_root___initial THEN
        GraphState := STATE_RouteManualReleaseDispatch_root___initial
      END
    END
END//MACHINE
