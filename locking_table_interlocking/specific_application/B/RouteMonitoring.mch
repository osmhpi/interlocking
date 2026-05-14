MACHINE RouteMonitoring
SEES Enums
SETS
  STATETYPE_RouteMonitoring_root = { STATE_RouteMonitoring_root___initial, STATE_RouteMonitoring_root_NOT_MONITORED, STATE_RouteMonitoring_root_MONITORED }
VARIABLES
  PointsMonitored,
  RouteSet,
  InverseTransitsInactive,
  State,
  GraphState_root
INVARIANT
  PointsMonitored : BOOL &
  RouteSet : BOOL &
  InverseTransitsInactive : BOOL &
  State : E_ActiveInactive &
  GraphState_root : STATETYPE_RouteMonitoring_root
INITIALIZATION
  PointsMonitored := FALSE;
  RouteSet := FALSE;
  InverseTransitsInactive := FALSE;
  State := ActiveInactive_INACTIVE;
  GraphState_root := STATE_RouteMonitoring_root___initial
OPERATIONS
  InitialTransition(request_points_right_PointMonitoring_Right, request_points_left_PointMonitoring_Left, Route_State, transits_in_opposite_route_direction_Transit_State) =
    BEGIN
      // Update Terms
      PointsMonitored := bool(({ActiveInactive_ACTIVE} = request_points_right_PointMonitoring_Right or {} = request_points_right_PointMonitoring_Right) & ({ActiveInactive_ACTIVE} = request_points_left_PointMonitoring_Left or {} = request_points_left_PointMonitoring_Left)) ||
      RouteSet := bool(Route_State = RouteState_SET) ||
      InverseTransitsInactive := bool(({ActiveInactive_INACTIVE} = transits_in_opposite_route_direction_Transit_State or {} = transits_in_opposite_route_direction_Transit_State));
      // Perform transition
        State := ActiveInactive_INACTIVE;
          GraphState_root := STATE_RouteMonitoring_root_NOT_MONITORED
    END;
  Transition(request_points_right_PointMonitoring_Right, request_points_left_PointMonitoring_Left, Route_State, transits_in_opposite_route_direction_Transit_State) =
    BEGIN
      // Update Terms
      PointsMonitored := bool(({ActiveInactive_ACTIVE} = request_points_right_PointMonitoring_Right or {} = request_points_right_PointMonitoring_Right) & ({ActiveInactive_ACTIVE} = request_points_left_PointMonitoring_Left or {} = request_points_left_PointMonitoring_Left)) ||
      RouteSet := bool(Route_State = RouteState_SET) ||
      InverseTransitsInactive := bool(({ActiveInactive_INACTIVE} = transits_in_opposite_route_direction_Transit_State or {} = transits_in_opposite_route_direction_Transit_State));
      // Perform transition
      SELECT GraphState_root = STATE_RouteMonitoring_root_NOT_MONITORED THEN 
        IF PointsMonitored = TRUE & RouteSet = TRUE & InverseTransitsInactive = TRUE THEN
State := ActiveInactive_ACTIVE;
          GraphState_root := STATE_RouteMonitoring_root_MONITORED
        END
      WHEN GraphState_root = STATE_RouteMonitoring_root_MONITORED THEN 
        IF not(PointsMonitored = TRUE) or not(RouteSet = TRUE) or not(InverseTransitsInactive = TRUE) THEN
State := ActiveInactive_INACTIVE;
          GraphState_root := STATE_RouteMonitoring_root_NOT_MONITORED
        END
      END
    END
END//MACHINE
