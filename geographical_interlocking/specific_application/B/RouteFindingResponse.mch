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
  GraphState_root
INVARIANT
  Checking : BOOL &
  CheckingFromA : BOOL &
  TerminatesRouteRequested : BOOL &
  AdmittingToA : BOOL &
  AdmittingToB : BOOL &
  AdmittingToC : BOOL &
  RouteMonitored : BOOL &
  Admit : RouteAdmission &
  GraphState_root : STATE_RouteFindingResponse_root
INITIALIZATION
  Checking := FALSE;
  CheckingFromA := FALSE;
  TerminatesRouteRequested := FALSE;
  AdmittingToA := FALSE;
  AdmittingToB := FALSE;
  AdmittingToC := FALSE;
  RouteMonitored := FALSE;
  Admit := RouteAdmission_INACTIVE;
  GraphState_root := STATE_RouteFindingResponse_root___initial
OPERATIONS
  InitialTransition(RouteFindingSearch_Check, is_end_of_route_admission_check_RouteCheck_State, link_a_left_LinkRTL_State, link_a_right_LinkLTR_State, link_b_left_LinkRTL_State, link_b_right_LinkLTR_State, link_c_left_LinkRTL_State, link_c_right_LinkLTR_State, transits_RouteMonitoring_State) =
    BEGIN
      // Update Terms
      Checking := bool(RouteFindingSearch_Check /= RouteChecking_INACTIVE) ||
      CheckingFromA := bool(RouteFindingSearch_Check = RouteChecking_CHECK_FROM_A) ||
      TerminatesRouteRequested := bool(ActiveInactive_ACTIVE : is_end_of_route_admission_check_RouteCheck_State) ||
      AdmittingToA := bool(RouteSearch_RESPONSE : link_a_left_LinkRTL_State or RouteSearch_RESPONSE : link_a_right_LinkLTR_State) ||
      AdmittingToB := bool(RouteSearch_RESPONSE : link_b_left_LinkRTL_State or RouteSearch_RESPONSE : link_b_right_LinkLTR_State) ||
      AdmittingToC := bool(RouteSearch_RESPONSE : link_c_left_LinkRTL_State or RouteSearch_RESPONSE : link_c_right_LinkLTR_State) ||
      RouteMonitored := bool(ActiveInactive_ACTIVE : transits_RouteMonitoring_State);
      // Perform transition
        Admit := RouteAdmission_INACTIVE;
        GraphState_root := STATE_RouteFindingResponse_root_IDLE
    END;
  Transition(RouteFindingSearch_Check, is_end_of_route_admission_check_RouteCheck_State, link_a_left_LinkRTL_State, link_a_right_LinkLTR_State, link_b_left_LinkRTL_State, link_b_right_LinkLTR_State, link_c_left_LinkRTL_State, link_c_right_LinkLTR_State, transits_RouteMonitoring_State) =
    BEGIN
      // Update Terms
      Checking := bool(RouteFindingSearch_Check /= RouteChecking_INACTIVE) ||
      CheckingFromA := bool(RouteFindingSearch_Check = RouteChecking_CHECK_FROM_A) ||
      TerminatesRouteRequested := bool(ActiveInactive_ACTIVE : is_end_of_route_admission_check_RouteCheck_State) ||
      AdmittingToA := bool(RouteSearch_RESPONSE : link_a_left_LinkRTL_State or RouteSearch_RESPONSE : link_a_right_LinkLTR_State) ||
      AdmittingToB := bool(RouteSearch_RESPONSE : link_b_left_LinkRTL_State or RouteSearch_RESPONSE : link_b_right_LinkLTR_State) ||
      AdmittingToC := bool(RouteSearch_RESPONSE : link_c_left_LinkRTL_State or RouteSearch_RESPONSE : link_c_right_LinkLTR_State) ||
      RouteMonitored := bool(ActiveInactive_ACTIVE : transits_RouteMonitoring_State);
      // Perform transition
      SELECT GraphState_root = STATE_RouteFindingResponse_root_IDLE THEN 
        IF CheckingFromA = TRUE & TerminatesRouteRequested = TRUE THEN
Admit := RouteAdmission_ADMIT_END;
          GraphState_root := STATE_RouteFindingResponse_root_ADMIT_END

        ELSIF Checking = TRUE & AdmittingToA = TRUE THEN
Admit := RouteAdmission_ADMIT_TO_A;
          GraphState_root := STATE_RouteFindingResponse_root_ADMIT_TO_A

        ELSIF Checking = TRUE & AdmittingToB = TRUE THEN
Admit := RouteAdmission_ADMIT_TO_B;
          GraphState_root := STATE_RouteFindingResponse_root_ADMIT_TO_B

        ELSIF Checking = TRUE & AdmittingToC = TRUE THEN
Admit := RouteAdmission_ADMIT_TO_C;
          GraphState_root := STATE_RouteFindingResponse_root_ADMIT_TO_C

        END
      END;
      SELECT GraphState_root = STATE_RouteFindingResponse_root_ADMIT_END THEN 
        IF RouteMonitored = TRUE THEN
Admit := RouteAdmission_ROUTE_END;
          GraphState_root := STATE_RouteFindingResponse_root_ROUTE_TO_END

        ELSIF not(Checking = TRUE) THEN
Admit := RouteAdmission_INACTIVE;
          GraphState_root := STATE_RouteFindingResponse_root_IDLE

        END
      END;
      SELECT GraphState_root = STATE_RouteFindingResponse_root_ADMIT_TO_A THEN 
        IF RouteMonitored = TRUE THEN
Admit := RouteAdmission_ROUTE_TO_A;
          GraphState_root := STATE_RouteFindingResponse_root_ROUTE_TO_A

        ELSIF not(Checking = TRUE) THEN
Admit := RouteAdmission_INACTIVE;
          GraphState_root := STATE_RouteFindingResponse_root_IDLE

        END
      END;
      SELECT GraphState_root = STATE_RouteFindingResponse_root_ADMIT_TO_B THEN 
        IF RouteMonitored = TRUE THEN
Admit := RouteAdmission_ROUTE_TO_B;
          GraphState_root := STATE_RouteFindingResponse_root_ROUTE_TO_B

        ELSIF not(Checking = TRUE) THEN
Admit := RouteAdmission_INACTIVE;
          GraphState_root := STATE_RouteFindingResponse_root_IDLE

        END
      END;
      SELECT GraphState_root = STATE_RouteFindingResponse_root_ADMIT_TO_C THEN 
        IF RouteMonitored = TRUE THEN
Admit := RouteAdmission_ROUTE_TO_C;
          GraphState_root := STATE_RouteFindingResponse_root_ROUTE_TO_C

        ELSIF not(Checking = TRUE) THEN
Admit := RouteAdmission_INACTIVE;
          GraphState_root := STATE_RouteFindingResponse_root_IDLE

        END
      END;
      SELECT GraphState_root = STATE_RouteFindingResponse_root_ROUTE_TO_END THEN 
        IF not(RouteMonitored = TRUE) THEN
Admit := RouteAdmission_INACTIVE;
          GraphState_root := STATE_RouteFindingResponse_root_IDLE

        END
      END;
      SELECT GraphState_root = STATE_RouteFindingResponse_root_ROUTE_TO_A THEN 
        IF not(RouteMonitored = TRUE) THEN
Admit := RouteAdmission_INACTIVE;
          GraphState_root := STATE_RouteFindingResponse_root_IDLE

        END
      END;
      SELECT GraphState_root = STATE_RouteFindingResponse_root_ROUTE_TO_B THEN 
        IF not(RouteMonitored = TRUE) THEN
Admit := RouteAdmission_INACTIVE;
          GraphState_root := STATE_RouteFindingResponse_root_IDLE

        END
      END;
      SELECT GraphState_root = STATE_RouteFindingResponse_root_ROUTE_TO_C THEN 
        IF not(RouteMonitored = TRUE) THEN
Admit := RouteAdmission_INACTIVE;
          GraphState_root := STATE_RouteFindingResponse_root_IDLE

        END
      END
    END
END//MACHINE
