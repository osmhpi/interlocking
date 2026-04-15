MACHINE RouteCheck
SEES Enums
SETS
  STATE_RouteCheck_root = { STATE_RouteCheck_root___initial, STATE_RouteCheck_root_INACTIVE, STATE_RouteCheck_root_WAITING, STATE_RouteCheck_root_CHECKING, STATE_RouteCheck_root_c }
VARIABLES
  RouteRequested,
  IsTop,
  Top,
  State,
  GraphState
INVARIANT
  RouteRequested : BOOL &
  IsTop : BOOL &
  Top : ActiveInactive &
  State : ActiveInactive &
  GraphState : STATE_RouteCheck_root
INITIALIZATION
  RouteRequested := FALSE;
  IsTop := FALSE;
  Top := ActiveInactive_ACTIVE;
  State := ActiveInactive_INACTIVE;
  GraphState := STATE_RouteCheck_root___initial
OPERATIONS
  InitialTransition =
    BEGIN
      // Update Terms
      RouteRequested := SCICC_MsgRequestRoute = TRUE ||
      IsTop := !(route).(route : dom(all_routes_RouteCheck_Top) => all_routes_RouteCheck_Top(route) = ActiveInactive_ACTIVE );
      // Perform transition
      SELECT GraphState = STATE_RouteCheck_root___initial THEN
        GraphState := STATE_RouteCheck_root___initial
      END;
    END
  Transition(SCICC_MsgRequestRoute, all_routes_RouteCheck_Top) =
    BEGIN
      // Update Terms
      RouteRequested := SCICC_MsgRequestRoute = TRUE ||
      IsTop := !(route).(route : dom(all_routes_RouteCheck_Top) => all_routes_RouteCheck_Top(route) = ActiveInactive_ACTIVE );
      // Perform transition
      SELECT GraphState = STATE_RouteCheck_root___initial THEN
        GraphState := STATE_RouteCheck_root___initial
      END
    END
END//MACHINE
