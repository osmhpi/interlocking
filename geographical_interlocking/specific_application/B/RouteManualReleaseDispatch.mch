MACHINE RouteManualReleaseDispatch
SEES Enums
SETS
  STATETYPE_RouteManualReleaseDispatch_root = { STATE_RouteManualReleaseDispatch_root___initial, STATE_RouteManualReleaseDispatch_root_IDLE, STATE_RouteManualReleaseDispatch_root_ACTIVE }
VARIABLES
  RouteReleaseRequested,
  State,
  GraphState_root
INVARIANT
  RouteReleaseRequested : BOOL &
  State : E_ActiveInactive &
  GraphState_root : STATETYPE_RouteManualReleaseDispatch_root
INITIALIZATION
  RouteReleaseRequested := FALSE;
  State := ActiveInactive_INACTIVE;
  GraphState_root := STATE_RouteManualReleaseDispatch_root___initial
OPERATIONS
  InitialTransition(is_start_of_route_admission_check_SCICC_MsgReleaseRoute) =
    BEGIN
      // Update Terms
      RouteReleaseRequested := bool(TRUE : is_start_of_route_admission_check_SCICC_MsgReleaseRoute);
      // Perform transition
        State := ActiveInactive_INACTIVE;
          GraphState_root := STATE_RouteManualReleaseDispatch_root_IDLE
    END;
  Transition(is_start_of_route_admission_check_SCICC_MsgReleaseRoute) =
    BEGIN
      // Update Terms
      RouteReleaseRequested := bool(TRUE : is_start_of_route_admission_check_SCICC_MsgReleaseRoute);
      // Perform transition
      SELECT GraphState_root = STATE_RouteManualReleaseDispatch_root_IDLE THEN 
        IF RouteReleaseRequested = TRUE THEN
State := ActiveInactive_ACTIVE;
          GraphState_root := STATE_RouteManualReleaseDispatch_root_ACTIVE
        END
      WHEN GraphState_root = STATE_RouteManualReleaseDispatch_root_ACTIVE THEN 
        IF not(RouteReleaseRequested = TRUE) THEN
State := ActiveInactive_INACTIVE;
          GraphState_root := STATE_RouteManualReleaseDispatch_root_IDLE
        END
      END
    END
END//MACHINE
