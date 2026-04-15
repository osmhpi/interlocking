MACHINE RouteFindingResponse
SEES Enums
SETS
  STATE_RouteFindingResponse_root = { STATE_RouteFindingResponse_root___initial, STATE_RouteFindingResponse_root_IDLE, STATE_RouteFindingResponse_root_ADMIT_END, STATE_RouteFindingResponse_root_ADMIT_TO_A, STATE_RouteFindingResponse_root_ADMIT_TO_B, STATE_RouteFindingResponse_root_ADMIT_TO_C, STATE_RouteFindingResponse_root_ROUTE_TO_END, STATE_RouteFindingResponse_root_ROUTE_TO_A, STATE_RouteFindingResponse_root_ROUTE_TO_B, STATE_RouteFindingResponse_root_ROUTE_TO_C }
VARIABLES
  Checking,
  CheckingFromA,
  TerminatesRouteRequested,
  AdmittingToA,
  AdmittingToB,
  AdmittingToC,
  RouteMonitored,
  Admit,
  GraphState
INVARIANT
  Checking : BOOL &
  CheckingFromA : BOOL &
  TerminatesRouteRequested : BOOL &
  AdmittingToA : BOOL &
  AdmittingToB : BOOL &
  AdmittingToC : BOOL &
  RouteMonitored : BOOL &
  Admit : RouteAdmission &
  GraphState : STATE_RouteFindingResponse_root
INITIALIZATION
  Checking := FALSE;
  CheckingFromA := FALSE;
  TerminatesRouteRequested := FALSE;
  AdmittingToA := FALSE;
  AdmittingToB := FALSE;
  AdmittingToC := FALSE;
  RouteMonitored := FALSE;
  Admit := RouteAdmission_INACTIVE;
  GraphState := STATE_RouteFindingResponse_root___initial
OPERATIONS
  InitialTransition =
    BEGIN
      // Update Terms
      Checking := RouteFindingSearch_Check /= RouteChecking_INACTIVE ||
      CheckingFromA := RouteFindingSearch_Check = RouteChecking_CHECK_FROM_A ||
      TerminatesRouteRequested := ActiveInactive_ACTIVE : is_end_of_route_admission_check_RouteCheck_State ||
      AdmittingToA := RouteSearch_RESPONSE : link_a_left_LinkRTL_State OR RouteSearch_RESPONSE : link_a_right_LinkLTR_State ||
      AdmittingToB := RouteSearch_RESPONSE : link_b_left_LinkRTL_State OR RouteSearch_RESPONSE : link_b_right_LinkLTR_State ||
      AdmittingToC := RouteSearch_RESPONSE : link_c_left_LinkRTL_State OR RouteSearch_RESPONSE : link_c_right_LinkLTR_State ||
      RouteMonitored := ActiveInactive_ACTIVE : transits_RouteMonitoring_State;
      // Perform transition
      SELECT GraphState = STATE_RouteFindingResponse_root___initial THEN
        GraphState := STATE_RouteFindingResponse_root___initial
      END;
    END
  Transition(RouteFindingSearch_Check, is_end_of_route_admission_check_RouteCheck_State, link_a_left_LinkRTL_State, link_a_right_LinkLTR_State, link_b_left_LinkRTL_State, link_b_right_LinkLTR_State, link_c_left_LinkRTL_State, link_c_right_LinkLTR_State, transits_RouteMonitoring_State) =
    BEGIN
      // Update Terms
      Checking := RouteFindingSearch_Check /= RouteChecking_INACTIVE ||
      CheckingFromA := RouteFindingSearch_Check = RouteChecking_CHECK_FROM_A ||
      TerminatesRouteRequested := ActiveInactive_ACTIVE : is_end_of_route_admission_check_RouteCheck_State ||
      AdmittingToA := RouteSearch_RESPONSE : link_a_left_LinkRTL_State OR RouteSearch_RESPONSE : link_a_right_LinkLTR_State ||
      AdmittingToB := RouteSearch_RESPONSE : link_b_left_LinkRTL_State OR RouteSearch_RESPONSE : link_b_right_LinkLTR_State ||
      AdmittingToC := RouteSearch_RESPONSE : link_c_left_LinkRTL_State OR RouteSearch_RESPONSE : link_c_right_LinkLTR_State ||
      RouteMonitored := ActiveInactive_ACTIVE : transits_RouteMonitoring_State;
      // Perform transition
      SELECT GraphState = STATE_RouteFindingResponse_root___initial THEN
        GraphState := STATE_RouteFindingResponse_root___initial
      END
    END
END//MACHINE
