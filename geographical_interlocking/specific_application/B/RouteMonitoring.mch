MACHINE RouteMonitoring
SEES Enums
SETS
  STATE_RouteMonitoring_root = { STATE_RouteMonitoring_root___initial, STATE_RouteMonitoring_root_NOT_CONTROLLED, STATE_RouteMonitoring_root_CONTROLLED }
VARIABLES
  PointsControlled,
  RouteSet,
  InverseTransitInactive,
  MonitoringComplete,
  State,
  GraphState
INVARIANT
  PointsControlled : BOOL &
  RouteSet : BOOL &
  InverseTransitInactive : BOOL &
  MonitoringComplete : BOOL &
  State : ActiveInactive &
  GraphState : STATE_RouteMonitoring_root
INITIALIZATION
  PointsControlled := FALSE;
  RouteSet := FALSE;
  InverseTransitInactive := FALSE;
  MonitoringComplete := FALSE;
  State := ActiveInactive_INACTIVE;
  GraphState := STATE_RouteMonitoring_root___initial
OPERATIONS
  InitialTransition =
    BEGIN
      // Update Terms
      PointsControlled := !(point).(point : dom(requires_point_right_PointControl_Right) => requires_point_right_PointControl_Right(point) = ActiveInactive_ACTIVE ) AND !(point).(point : dom(requires_point_left_PointControl_Left) => requires_point_left_PointControl_Left(point) = ActiveInactive_ACTIVE ) ||
      RouteSet := Route_State = RouteState_SET ||
      InverseTransitInactive := @transit_in_opposite_direction_Transit_State = ActiveInactive_INACTIVE ||
      MonitoringComplete := RouteSearch_ROUTE_MONITORED : downstream_link_right_LinkLTR_State OR RouteSearch_ROUTE_MONITORED : downstream_link_left_LinkRTL_State OR @ise_RouteFindingResponse_Admit = RouteAdmission_ADMIT_END OR @ise_RouteFindingResponse_Admit = RouteAdmission_ROUTE_END;
      // Perform transition
      SELECT GraphState = STATE_RouteMonitoring_root___initial THEN
        GraphState := STATE_RouteMonitoring_root___initial
      END;
    END
  Transition(requires_point_right_PointControl_Right, requires_point_left_PointControl_Left, Route_State, transit_in_opposite_direction_Transit_State, downstream_link_right_LinkLTR_State, downstream_link_left_LinkRTL_State, ise_RouteFindingResponse_Admit) =
    BEGIN
      // Update Terms
      PointsControlled := !(point).(point : dom(requires_point_right_PointControl_Right) => requires_point_right_PointControl_Right(point) = ActiveInactive_ACTIVE ) AND !(point).(point : dom(requires_point_left_PointControl_Left) => requires_point_left_PointControl_Left(point) = ActiveInactive_ACTIVE ) ||
      RouteSet := Route_State = RouteState_SET ||
      InverseTransitInactive := @transit_in_opposite_direction_Transit_State = ActiveInactive_INACTIVE ||
      MonitoringComplete := RouteSearch_ROUTE_MONITORED : downstream_link_right_LinkLTR_State OR RouteSearch_ROUTE_MONITORED : downstream_link_left_LinkRTL_State OR @ise_RouteFindingResponse_Admit = RouteAdmission_ADMIT_END OR @ise_RouteFindingResponse_Admit = RouteAdmission_ROUTE_END;
      // Perform transition
      SELECT GraphState = STATE_RouteMonitoring_root___initial THEN
        GraphState := STATE_RouteMonitoring_root___initial
      END
    END
END//MACHINE
