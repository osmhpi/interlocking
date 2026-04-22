MACHINE RouteMonitoring
SEES Enums
SETS
  STATETYPE_RouteMonitoring_root = { STATE_RouteMonitoring_root___initial, STATE_RouteMonitoring_root_NOT_CONTROLLED, STATE_RouteMonitoring_root_CONTROLLED }
VARIABLES
  PointsControlled,
  RouteSet,
  InverseTransitInactive,
  MonitoringComplete,
  State,
  GraphState_root
INVARIANT
  PointsControlled : BOOL &
  RouteSet : BOOL &
  InverseTransitInactive : BOOL &
  MonitoringComplete : BOOL &
  State : E_ActiveInactive &
  GraphState_root : STATETYPE_RouteMonitoring_root
INITIALIZATION
  PointsControlled := FALSE;
  RouteSet := FALSE;
  InverseTransitInactive := FALSE;
  MonitoringComplete := FALSE;
  State := ActiveInactive_INACTIVE;
  GraphState_root := STATE_RouteMonitoring_root___initial
OPERATIONS
  InitialTransition(requires_point_right_PointControl_Right, requires_point_left_PointControl_Left, Route_State, transit_in_opposite_direction_Transit_State, downstream_link_right_LinkLTR_State, downstream_link_left_LinkRTL_State, ise_RouteFindingResponse_Admit) =
    BEGIN
      // Update Terms
      PointsControlled := bool({ActiveInactive_ACTIVE} = requires_point_right_PointControl_Right & {ActiveInactive_ACTIVE} = requires_point_left_PointControl_Left) ||
      RouteSet := bool(Route_State = RouteState_SET) ||
      InverseTransitInactive := bool(transit_in_opposite_direction_Transit_State = ActiveInactive_INACTIVE) ||
      MonitoringComplete := bool(RouteSearch_ROUTE_MONITORED : downstream_link_right_LinkLTR_State or RouteSearch_ROUTE_MONITORED : downstream_link_left_LinkRTL_State or ise_RouteFindingResponse_Admit = RouteAdmission_ADMIT_END or ise_RouteFindingResponse_Admit = RouteAdmission_ROUTE_END);
      // Perform transition
        State := ActiveInactive_INACTIVE;
          GraphState_root := STATE_RouteMonitoring_root_NOT_CONTROLLED
    END;
  Transition(requires_point_right_PointControl_Right, requires_point_left_PointControl_Left, Route_State, transit_in_opposite_direction_Transit_State, downstream_link_right_LinkLTR_State, downstream_link_left_LinkRTL_State, ise_RouteFindingResponse_Admit) =
    BEGIN
      // Update Terms
      PointsControlled := bool({ActiveInactive_ACTIVE} = requires_point_right_PointControl_Right & {ActiveInactive_ACTIVE} = requires_point_left_PointControl_Left) ||
      RouteSet := bool(Route_State = RouteState_SET) ||
      InverseTransitInactive := bool(transit_in_opposite_direction_Transit_State = ActiveInactive_INACTIVE) ||
      MonitoringComplete := bool(RouteSearch_ROUTE_MONITORED : downstream_link_right_LinkLTR_State or RouteSearch_ROUTE_MONITORED : downstream_link_left_LinkRTL_State or ise_RouteFindingResponse_Admit = RouteAdmission_ADMIT_END or ise_RouteFindingResponse_Admit = RouteAdmission_ROUTE_END);
      // Perform transition
      SELECT GraphState_root = STATE_RouteMonitoring_root_NOT_CONTROLLED THEN 
        IF PointsControlled = TRUE & RouteSet = TRUE & InverseTransitInactive = TRUE & MonitoringComplete = TRUE THEN
State := ActiveInactive_ACTIVE;
          GraphState_root := STATE_RouteMonitoring_root_CONTROLLED
        END
      END;
      SELECT GraphState_root = STATE_RouteMonitoring_root_CONTROLLED THEN 
        IF not(PointsControlled = TRUE) or not(RouteSet = TRUE) or not(InverseTransitInactive = TRUE) or not(MonitoringComplete = TRUE) THEN
State := ActiveInactive_INACTIVE;
          GraphState_root := STATE_RouteMonitoring_root_NOT_CONTROLLED
        END
      END
    END
END//MACHINE
