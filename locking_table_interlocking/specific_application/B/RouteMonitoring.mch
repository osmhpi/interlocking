MACHINE RouteMonitoring
SEES Enums
SETS
  STATE_RouteMonitoring_root = { STATE_RouteMonitoring_root___initial, STATE_RouteMonitoring_root_NOT_CONTROLLED, STATE_RouteMonitoring_root_CONTROLLED }
VARIABLES
  PointsControlled,
  RouteSet,
  InverseTransitsInactive,
  State,
  GraphState
INVARIANT
  PointsControlled : BOOL &
  RouteSet : BOOL &
  InverseTransitsInactive : BOOL &
  State : ActiveInactive &
  GraphState : STATE_RouteMonitoring_root
INITIALIZATION
  PointsControlled := FALSE;
  RouteSet := FALSE;
  InverseTransitsInactive := FALSE;
  State := ActiveInactive_INACTIVE;
  GraphState := STATE_RouteMonitoring_root___initial
OPERATIONS
  InitialTransition =
    BEGIN
      // Update Terms
      PointsControlled := !(point).(point : dom(request_points_controlled_right_PointControl_Right) => request_points_controlled_right_PointControl_Right(point) = ActiveInactive_ACTIVE ) AND !(point).(point : dom(request_points_controlled_left_PointControl_Left) => request_points_controlled_left_PointControl_Left(point) = ActiveInactive_ACTIVE ) ||
      RouteSet := Route_State = RouteState_SET ||
      InverseTransitsInactive := !(transit).(transit : dom(transits_in_opposite_route_direction_Transit_State) => transits_in_opposite_route_direction_Transit_State(transit) = ActiveInactive_INACTIVE );
      // Perform transition
      SELECT GraphState = STATE_RouteMonitoring_root___initial THEN
        GraphState := STATE_RouteMonitoring_root___initial
      END;
    END
  Transition(request_points_controlled_right_PointControl_Right, request_points_controlled_left_PointControl_Left, Route_State, transits_in_opposite_route_direction_Transit_State) =
    BEGIN
      // Update Terms
      PointsControlled := !(point).(point : dom(request_points_controlled_right_PointControl_Right) => request_points_controlled_right_PointControl_Right(point) = ActiveInactive_ACTIVE ) AND !(point).(point : dom(request_points_controlled_left_PointControl_Left) => request_points_controlled_left_PointControl_Left(point) = ActiveInactive_ACTIVE ) ||
      RouteSet := Route_State = RouteState_SET ||
      InverseTransitsInactive := !(transit).(transit : dom(transits_in_opposite_route_direction_Transit_State) => transits_in_opposite_route_direction_Transit_State(transit) = ActiveInactive_INACTIVE );
      // Perform transition
      SELECT GraphState = STATE_RouteMonitoring_root___initial THEN
        GraphState := STATE_RouteMonitoring_root___initial
      END
    END
END//MACHINE
