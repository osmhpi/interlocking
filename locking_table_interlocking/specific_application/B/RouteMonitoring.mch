MACHINE RouteMonitoring
SEES Enums
SETS
  STATETYPE_RouteMonitoring_root = { STATE_RouteMonitoring_root___initial, STATE_RouteMonitoring_root_NOT_CONTROLLED, STATE_RouteMonitoring_root_CONTROLLED }
VARIABLES
  PointsControlled,
  RouteSet,
  InverseTransitsInactive,
  State,
  GraphState_root
INVARIANT
  PointsControlled : BOOL &
  RouteSet : BOOL &
  InverseTransitsInactive : BOOL &
  State : E_ActiveInactive &
  GraphState_root : STATETYPE_RouteMonitoring_root
INITIALIZATION
  PointsControlled := FALSE;
  RouteSet := FALSE;
  InverseTransitsInactive := FALSE;
  State := ActiveInactive_INACTIVE;
  GraphState_root := STATE_RouteMonitoring_root___initial
OPERATIONS
  InitialTransition(request_points_controlled_right_PointControl_Right, request_points_controlled_left_PointControl_Left, Route_State, transits_in_opposite_route_direction_Transit_State) =
    BEGIN
      // Update Terms
      PointsControlled := bool({ActiveInactive_ACTIVE} = request_points_controlled_right_PointControl_Right & {ActiveInactive_ACTIVE} = request_points_controlled_left_PointControl_Left) ||
      RouteSet := bool(Route_State = RouteState_SET) ||
      InverseTransitsInactive := bool({ActiveInactive_INACTIVE} = transits_in_opposite_route_direction_Transit_State);
      // Perform transition
        State := ActiveInactive_INACTIVE;
          GraphState_root := STATE_RouteMonitoring_root_NOT_CONTROLLED
    END;
  Transition(request_points_controlled_right_PointControl_Right, request_points_controlled_left_PointControl_Left, Route_State, transits_in_opposite_route_direction_Transit_State) =
    BEGIN
      // Update Terms
      PointsControlled := bool({ActiveInactive_ACTIVE} = request_points_controlled_right_PointControl_Right & {ActiveInactive_ACTIVE} = request_points_controlled_left_PointControl_Left) ||
      RouteSet := bool(Route_State = RouteState_SET) ||
      InverseTransitsInactive := bool({ActiveInactive_INACTIVE} = transits_in_opposite_route_direction_Transit_State);
      // Perform transition
      SELECT GraphState_root = STATE_RouteMonitoring_root_NOT_CONTROLLED THEN 
        IF PointsControlled = TRUE & RouteSet = TRUE & InverseTransitsInactive = TRUE THEN
State := ActiveInactive_ACTIVE;
          GraphState_root := STATE_RouteMonitoring_root_CONTROLLED
        END
      END;
      SELECT GraphState_root = STATE_RouteMonitoring_root_CONTROLLED THEN 
        IF not(PointsControlled = TRUE) or not(RouteSet = TRUE) or not(InverseTransitsInactive = TRUE) THEN
State := ActiveInactive_INACTIVE;
          GraphState_root := STATE_RouteMonitoring_root_NOT_CONTROLLED
        END
      END
    END
END//MACHINE
