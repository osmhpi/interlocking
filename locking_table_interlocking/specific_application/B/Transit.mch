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
  GraphState_root
INVARIANT
  InitializationTimeoutExpired : BOOL &
  ZoneFree : BOOL &
  UpstreamTransitsIdle : BOOL &
  RequestedByRoute : BOOL &
  State : ActiveInactive &
  StartInitialization : INT &
  GraphState_root : STATE_Transit_root
INITIALIZATION
  InitializationTimeoutExpired := FALSE;
  ZoneFree := FALSE;
  UpstreamTransitsIdle := FALSE;
  RequestedByRoute := FALSE;
  State := ActiveInactive_INACTIVE;
  StartInitialization := 0;
  GraphState_root := STATE_Transit_root___initial
OPERATIONS
  InitialTransition(underlying_zone_Zone_State, upstream_transits_Transit_State, activating_routes_Route_State, NOW) =
    BEGIN
      // Update Terms
      InitializationTimeoutExpired := bool(NOW >= StartInitialization + 1000) ||
      ZoneFree := bool(underlying_zone_Zone_State = OccupancyStatus_VACANT) ||
      UpstreamTransitsIdle := bool({ActiveInactive_INACTIVE} = upstream_transits_Transit_State) ||
      RequestedByRoute := bool(RouteState_SET : activating_routes_Route_State);
      // Perform transition, todo
      GraphState_root := STATE_Transit_root___initial
    END;
  Transition(underlying_zone_Zone_State, upstream_transits_Transit_State, activating_routes_Route_State, NOW) =
    BEGIN
      // Update Terms
      InitializationTimeoutExpired := bool(NOW >= StartInitialization + 1000) ||
      ZoneFree := bool(underlying_zone_Zone_State = OccupancyStatus_VACANT) ||
      UpstreamTransitsIdle := bool({ActiveInactive_INACTIVE} = upstream_transits_Transit_State) ||
      RequestedByRoute := bool(RouteState_SET : activating_routes_Route_State);
      // Perform transition
      SELECT GraphState_root = STATE_Transit_root_INITIALIZING THEN 
        IF InitializationTimeoutExpired = TRUE & UpstreamTransitsIdle = TRUE & ZoneFree = TRUE & not(RequestedByRoute = TRUE) THEN
          State := ActiveInactive_INACTIVE;
          GraphState_root := STATE_Transit_root_IDLE
        END
      END;
      SELECT GraphState_root = STATE_Transit_root_IDLE THEN 
        IF RequestedByRoute = TRUE THEN
          State := ActiveInactive_ACTIVE;
          GraphState_root := STATE_Transit_root_ACTIVE
        END
      END;
      SELECT GraphState_root = STATE_Transit_root_ACTIVE THEN 
        IF UpstreamTransitsIdle = TRUE & ZoneFree = TRUE & not(RequestedByRoute = TRUE) THEN
          State := ActiveInactive_INACTIVE;
          GraphState_root := STATE_Transit_root_IDLE
        END
      END
    END
END//MACHINE
