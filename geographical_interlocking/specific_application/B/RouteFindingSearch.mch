MACHINE RouteFindingSearch
SEES Enums
SETS
  STATETYPE_RouteFindingSearch_root = { STATE_RouteFindingSearch_root___initial, STATE_RouteFindingSearch_root_IDLE, STATE_RouteFindingSearch_root_CHECKING_START, STATE_RouteFindingSearch_root_CHECKING_FROM_A, STATE_RouteFindingSearch_root_CHECKING_FROM_B, STATE_RouteFindingSearch_root_CHECKING_FROM_C, STATE_RouteFindingSearch_root_ROUTE_SET_FROM_START, STATE_RouteFindingSearch_root_ROUTE_SET_FROM_A, STATE_RouteFindingSearch_root_ROUTE_SET_FROM_B, STATE_RouteFindingSearch_root_ROUTE_SET_FROM_C }
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
  GraphState_root
INVARIANT
  RouteRequested : BOOL &
  TerminatesRouteRequested : BOOL &
  Checking : BOOL &
  SettingRoute : BOOL &
  CheckingFromA : BOOL &
  CheckingFromB : BOOL &
  CheckingFromC : BOOL &
  RouteSet : BOOL &
  Check : E_RouteChecking &
  GraphState_root : STATETYPE_RouteFindingSearch_root
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
  GraphState_root := STATE_RouteFindingSearch_root___initial
OPERATIONS
  InitialTransition(is_start_of_route_admission_check_RouteCheck_State, is_end_of_route_admission_check_RouteCheck_State, link_a_left_LinkRTL_State, link_a_right_LinkLTR_State, link_b_left_LinkRTL_State, link_b_right_LinkLTR_State, link_c_left_LinkRTL_State, link_c_right_LinkLTR_State, transits_Route_State) =
    BEGIN
      // Update Terms
      RouteRequested := bool(ActiveInactive_ACTIVE : is_start_of_route_admission_check_RouteCheck_State) ||
      TerminatesRouteRequested := bool(ActiveInactive_ACTIVE : is_end_of_route_admission_check_RouteCheck_State) ||
      Checking := bool(RouteSearch_SEARCH : link_a_left_LinkRTL_State or RouteSearch_SEARCH : link_a_right_LinkLTR_State or RouteSearch_SEARCH : link_b_left_LinkRTL_State or RouteSearch_SEARCH : link_b_right_LinkLTR_State or RouteSearch_SEARCH : link_c_left_LinkRTL_State or RouteSearch_SEARCH : link_c_right_LinkLTR_State) ||
      SettingRoute := bool(RouteSearch_SEARCH : link_a_left_LinkRTL_State or RouteSearch_ROUTE_SET : link_a_right_LinkLTR_State or RouteSearch_SEARCH : link_b_left_LinkRTL_State or RouteSearch_ROUTE_SET : link_b_right_LinkLTR_State or RouteSearch_SEARCH : link_c_left_LinkRTL_State or RouteSearch_ROUTE_SET : link_c_right_LinkLTR_State) ||
      CheckingFromA := bool(RouteSearch_SEARCH : link_a_left_LinkRTL_State or RouteSearch_SEARCH : link_a_right_LinkLTR_State) ||
      CheckingFromB := bool(RouteSearch_SEARCH : link_b_left_LinkRTL_State or RouteSearch_SEARCH : link_b_right_LinkLTR_State) ||
      CheckingFromC := bool(RouteSearch_SEARCH : link_c_left_LinkRTL_State or RouteSearch_SEARCH : link_c_right_LinkLTR_State) ||
      RouteSet := bool({RouteState_RELEASED} /= transits_Route_State);
      // Perform transition
        Check := RouteChecking_INACTIVE;
          GraphState_root := STATE_RouteFindingSearch_root_IDLE
    END;
  Transition(is_start_of_route_admission_check_RouteCheck_State, is_end_of_route_admission_check_RouteCheck_State, link_a_left_LinkRTL_State, link_a_right_LinkLTR_State, link_b_left_LinkRTL_State, link_b_right_LinkLTR_State, link_c_left_LinkRTL_State, link_c_right_LinkLTR_State, transits_Route_State) =
    BEGIN
      // Update Terms
      RouteRequested := bool(ActiveInactive_ACTIVE : is_start_of_route_admission_check_RouteCheck_State) ||
      TerminatesRouteRequested := bool(ActiveInactive_ACTIVE : is_end_of_route_admission_check_RouteCheck_State) ||
      Checking := bool(RouteSearch_SEARCH : link_a_left_LinkRTL_State or RouteSearch_SEARCH : link_a_right_LinkLTR_State or RouteSearch_SEARCH : link_b_left_LinkRTL_State or RouteSearch_SEARCH : link_b_right_LinkLTR_State or RouteSearch_SEARCH : link_c_left_LinkRTL_State or RouteSearch_SEARCH : link_c_right_LinkLTR_State) ||
      SettingRoute := bool(RouteSearch_SEARCH : link_a_left_LinkRTL_State or RouteSearch_ROUTE_SET : link_a_right_LinkLTR_State or RouteSearch_SEARCH : link_b_left_LinkRTL_State or RouteSearch_ROUTE_SET : link_b_right_LinkLTR_State or RouteSearch_SEARCH : link_c_left_LinkRTL_State or RouteSearch_ROUTE_SET : link_c_right_LinkLTR_State) ||
      CheckingFromA := bool(RouteSearch_SEARCH : link_a_left_LinkRTL_State or RouteSearch_SEARCH : link_a_right_LinkLTR_State) ||
      CheckingFromB := bool(RouteSearch_SEARCH : link_b_left_LinkRTL_State or RouteSearch_SEARCH : link_b_right_LinkLTR_State) ||
      CheckingFromC := bool(RouteSearch_SEARCH : link_c_left_LinkRTL_State or RouteSearch_SEARCH : link_c_right_LinkLTR_State) ||
      RouteSet := bool({RouteState_RELEASED} /= transits_Route_State);
      // Perform transition
      SELECT GraphState_root = STATE_RouteFindingSearch_root_IDLE THEN 
        IF CheckingFromA = TRUE THEN
Check := RouteChecking_CHECK_FROM_A;
          GraphState_root := STATE_RouteFindingSearch_root_CHECKING_FROM_A
        ELSIF CheckingFromB = TRUE THEN
Check := RouteChecking_CHECK_FROM_B;
          GraphState_root := STATE_RouteFindingSearch_root_CHECKING_FROM_B
        ELSIF CheckingFromC = TRUE THEN
Check := RouteChecking_CHECK_FROM_C;
          GraphState_root := STATE_RouteFindingSearch_root_CHECKING_FROM_C
        ELSIF RouteRequested = TRUE THEN
Check := RouteChecking_CHECK_START;
          GraphState_root := STATE_RouteFindingSearch_root_CHECKING_START
        END
      END;
      SELECT GraphState_root = STATE_RouteFindingSearch_root_CHECKING_START THEN 
        IF RouteSet = TRUE THEN
Check := RouteChecking_ROUTE_SET_FROM_START;
          GraphState_root := STATE_RouteFindingSearch_root_ROUTE_SET_FROM_START
        ELSIF not(RouteRequested = TRUE) THEN
Check := RouteChecking_INACTIVE;
          GraphState_root := STATE_RouteFindingSearch_root_IDLE
        END
      END;
      SELECT GraphState_root = STATE_RouteFindingSearch_root_CHECKING_FROM_A THEN 
        IF RouteSet = TRUE THEN
Check := RouteChecking_ROUTE_SET_FROM_A;
          GraphState_root := STATE_RouteFindingSearch_root_ROUTE_SET_FROM_A
        ELSIF not(Checking = TRUE) & not(SettingRoute = TRUE) THEN
Check := RouteChecking_INACTIVE;
          GraphState_root := STATE_RouteFindingSearch_root_IDLE
        END
      END;
      SELECT GraphState_root = STATE_RouteFindingSearch_root_CHECKING_FROM_B THEN 
        IF RouteSet = TRUE THEN
Check := RouteChecking_ROUTE_SET_FROM_B;
          GraphState_root := STATE_RouteFindingSearch_root_ROUTE_SET_FROM_B
        ELSIF not(Checking = TRUE) & not(SettingRoute = TRUE) THEN
Check := RouteChecking_INACTIVE;
          GraphState_root := STATE_RouteFindingSearch_root_IDLE
        END
      END;
      SELECT GraphState_root = STATE_RouteFindingSearch_root_CHECKING_FROM_C THEN 
        IF RouteSet = TRUE THEN
Check := RouteChecking_ROUTE_SET_FROM_C;
          GraphState_root := STATE_RouteFindingSearch_root_ROUTE_SET_FROM_C
        ELSIF not(Checking = TRUE) & not(SettingRoute = TRUE) THEN
Check := RouteChecking_INACTIVE;
          GraphState_root := STATE_RouteFindingSearch_root_IDLE
        END
      END;
      SELECT GraphState_root = STATE_RouteFindingSearch_root_ROUTE_SET_FROM_START THEN 
        IF not(RouteSet = TRUE) THEN
Check := RouteChecking_INACTIVE;
          GraphState_root := STATE_RouteFindingSearch_root_IDLE
        END
      END;
      SELECT GraphState_root = STATE_RouteFindingSearch_root_ROUTE_SET_FROM_A THEN 
        IF not(RouteSet = TRUE) THEN
Check := RouteChecking_INACTIVE;
          GraphState_root := STATE_RouteFindingSearch_root_IDLE
        END
      END;
      SELECT GraphState_root = STATE_RouteFindingSearch_root_ROUTE_SET_FROM_B THEN 
        IF not(RouteSet = TRUE) THEN
Check := RouteChecking_INACTIVE;
          GraphState_root := STATE_RouteFindingSearch_root_IDLE
        END
      END;
      SELECT GraphState_root = STATE_RouteFindingSearch_root_ROUTE_SET_FROM_C THEN 
        IF not(RouteSet = TRUE) THEN
Check := RouteChecking_INACTIVE;
          GraphState_root := STATE_RouteFindingSearch_root_IDLE
        END
      END
    END
END//MACHINE
