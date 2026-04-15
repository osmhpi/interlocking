MACHINE Transit
SEES Enums
SETS
  STATE_Transit_root = { STATE_Transit_root___initial, STATE_Transit_root_INITIALIZING, STATE_Transit_root_IDLE, STATE_Transit_root_ACTIVE }
VARIABLES
  InitializationTimeoutExpired,
  ZoneFree,
  UpstreamTransitsIdle,
  RequestedByRoute,
  State,
  StartInitialization,
  GraphState
INVARIANT
  InitializationTimeoutExpired : BOOL &
  ZoneFree : BOOL &
  UpstreamTransitsIdle : BOOL &
  RequestedByRoute : BOOL &
  State : ActiveInactive &
  StartInitialization : timestamp &
  GraphState : STATE_Transit_root
INITIALIZATION
  InitializationTimeoutExpired := FALSE;
  ZoneFree := FALSE;
  UpstreamTransitsIdle := FALSE;
  RequestedByRoute := FALSE;
  State := ActiveInactive_INACTIVE;
  StartInitialization := _;
  GraphState := STATE_Transit_root___initial
OPERATIONS
  InitialTransition =
    BEGIN
      // Update Terms
      InitializationTimeoutExpired := NOW >= StartInitialization + 1000ms ||
      ZoneFree := @underlying_zone_Zone_State = OccupancyStatus_VACANT ||
      UpstreamTransitsIdle := !(transit).(transit : dom(upstream_transits_Transit_State) => upstream_transits_Transit_State(transit) = ActiveInactive_INACTIVE ) ||
      RequestedByRoute := RouteState_SET : activating_routes_Route_State;
      // Perform transition
      SELECT GraphState = STATE_Transit_root___initial THEN
        GraphState := STATE_Transit_root___initial
      END;
    END
  Transition(underlying_zone_Zone_State, upstream_transits_Transit_State, activating_routes_Route_State) =
    BEGIN
      // Update Terms
      InitializationTimeoutExpired := NOW >= StartInitialization + 1000ms ||
      ZoneFree := @underlying_zone_Zone_State = OccupancyStatus_VACANT ||
      UpstreamTransitsIdle := !(transit).(transit : dom(upstream_transits_Transit_State) => upstream_transits_Transit_State(transit) = ActiveInactive_INACTIVE ) ||
      RequestedByRoute := RouteState_SET : activating_routes_Route_State;
      // Perform transition
      SELECT GraphState = STATE_Transit_root___initial THEN
        GraphState := STATE_Transit_root___initial
      END
    END
END//MACHINE
