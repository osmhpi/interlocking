MACHINE RouteFindingSearch
SEES Enums
SETS
  STATE_RouteFindingSearch_root = { STATE_RouteFindingSearch_root___initial, STATE_RouteFindingSearch_root_IDLE, STATE_RouteFindingSearch_root_CHECKING_START, STATE_RouteFindingSearch_root_CHECKING_FROM_A, STATE_RouteFindingSearch_root_CHECKING_FROM_B, STATE_RouteFindingSearch_root_CHECKING_FROM_C, STATE_RouteFindingSearch_root_ROUTE_SET_FROM_START, STATE_RouteFindingSearch_root_ROUTE_SET_FROM_A, STATE_RouteFindingSearch_root_ROUTE_SET_FROM_B, STATE_RouteFindingSearch_root_ROUTE_SET_FROM_C }
VARIABLES
  RouteRequested,
  TerminatesRouteRequested,
  Checking,
  SettingRoute,
  CheckingFromA,
  CheckingFromB,
  CheckingFromC,
  RouteSet,
  Check,
  GraphState
INVARIANT
  RouteRequested : BOOL &
  TerminatesRouteRequested : BOOL &
  Checking : BOOL &
  SettingRoute : BOOL &
  CheckingFromA : BOOL &
  CheckingFromB : BOOL &
  CheckingFromC : BOOL &
  RouteSet : BOOL &
  Check : RouteChecking &
  GraphState : STATE_RouteFindingSearch_root
INITIALIZATION
  RouteRequested := FALSE;
  TerminatesRouteRequested := FALSE;
  Checking := FALSE;
  SettingRoute := FALSE;
  CheckingFromA := FALSE;
  CheckingFromB := FALSE;
  CheckingFromC := FALSE;
  RouteSet := FALSE;
  Check := RouteChecking_INACTIVE;
  GraphState := STATE_RouteFindingSearch_root___initial
OPERATIONS
  InitialTransition =
    BEGIN
      // Update Terms
      RouteRequested := ActiveInactive_ACTIVE : is_start_of_route_admission_check_RouteCheck_State ||
      TerminatesRouteRequested := ActiveInactive_ACTIVE : is_end_of_route_admission_check_RouteCheck_State ||
      Checking := RouteSearch_SEARCH : link_a_left_LinkRTL_State OR RouteSearch_SEARCH : link_a_right_LinkLTR_State OR RouteSearch_SEARCH : link_b_left_LinkRTL_State OR RouteSearch_SEARCH : link_b_right_LinkLTR_State OR RouteSearch_SEARCH : link_c_left_LinkRTL_State OR RouteSearch_SEARCH : link_c_right_LinkLTR_State ||
      SettingRoute := RouteSearch_SEARCH : link_a_left_LinkRTL_State OR RouteSearch_ROUTE_SET : link_a_right_LinkLTR_State OR RouteSearch_SEARCH : link_b_left_LinkRTL_State OR RouteSearch_ROUTE_SET : link_b_right_LinkLTR_State OR RouteSearch_SEARCH : link_c_left_LinkRTL_State OR RouteSearch_ROUTE_SET : link_c_right_LinkLTR_State ||
      CheckingFromA := RouteSearch_SEARCH : link_a_left_LinkRTL_State OR RouteSearch_SEARCH : link_a_right_LinkLTR_State ||
      CheckingFromB := RouteSearch_SEARCH : link_b_left_LinkRTL_State OR RouteSearch_SEARCH : link_b_right_LinkLTR_State ||
      CheckingFromC := RouteSearch_SEARCH : link_c_left_LinkRTL_State OR RouteSearch_SEARCH : link_c_right_LinkLTR_State ||
      RouteSet := RouteState_RELEASED : transits_Route_State;
      // Perform transition
      SELECT GraphState = STATE_RouteFindingSearch_root___initial THEN
        GraphState := STATE_RouteFindingSearch_root___initial
      END;
    END
  Transition(is_start_of_route_admission_check_RouteCheck_State, is_end_of_route_admission_check_RouteCheck_State, link_a_left_LinkRTL_State, link_a_right_LinkLTR_State, link_b_left_LinkRTL_State, link_b_right_LinkLTR_State, link_c_left_LinkRTL_State, link_c_right_LinkLTR_State, transits_Route_State) =
    BEGIN
      // Update Terms
      RouteRequested := ActiveInactive_ACTIVE : is_start_of_route_admission_check_RouteCheck_State ||
      TerminatesRouteRequested := ActiveInactive_ACTIVE : is_end_of_route_admission_check_RouteCheck_State ||
      Checking := RouteSearch_SEARCH : link_a_left_LinkRTL_State OR RouteSearch_SEARCH : link_a_right_LinkLTR_State OR RouteSearch_SEARCH : link_b_left_LinkRTL_State OR RouteSearch_SEARCH : link_b_right_LinkLTR_State OR RouteSearch_SEARCH : link_c_left_LinkRTL_State OR RouteSearch_SEARCH : link_c_right_LinkLTR_State ||
      SettingRoute := RouteSearch_SEARCH : link_a_left_LinkRTL_State OR RouteSearch_ROUTE_SET : link_a_right_LinkLTR_State OR RouteSearch_SEARCH : link_b_left_LinkRTL_State OR RouteSearch_ROUTE_SET : link_b_right_LinkLTR_State OR RouteSearch_SEARCH : link_c_left_LinkRTL_State OR RouteSearch_ROUTE_SET : link_c_right_LinkLTR_State ||
      CheckingFromA := RouteSearch_SEARCH : link_a_left_LinkRTL_State OR RouteSearch_SEARCH : link_a_right_LinkLTR_State ||
      CheckingFromB := RouteSearch_SEARCH : link_b_left_LinkRTL_State OR RouteSearch_SEARCH : link_b_right_LinkLTR_State ||
      CheckingFromC := RouteSearch_SEARCH : link_c_left_LinkRTL_State OR RouteSearch_SEARCH : link_c_right_LinkLTR_State ||
      RouteSet := RouteState_RELEASED : transits_Route_State;
      // Perform transition
      SELECT GraphState = STATE_RouteFindingSearch_root___initial THEN
        GraphState := STATE_RouteFindingSearch_root___initial
      END
    END
END//MACHINE
