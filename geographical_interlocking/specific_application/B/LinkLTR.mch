MACHINE LinkLTR
SEES Enums
SETS
  STATE_LinkLTR_root = { STATE_LinkLTR_root___initial, STATE_LinkLTR_root_IDLE, STATE_LinkLTR_root_CHECKING, STATE_LinkLTR_root_ADMIT, STATE_LinkLTR_root_ROUTE_SET, STATE_LinkLTR_root_ROUTE_MONITORED }
VARIABLES
  IsChecking,
  IsCheckingOpposite,
  IsAdmit,
  IsAdmitOpposite,
  IsRouteSet,
  IsRouteSetDownstream,
  State,
  GraphState
INVARIANT
  IsChecking : BOOL &
  IsCheckingOpposite : BOOL &
  IsAdmit : BOOL &
  IsAdmitOpposite : BOOL &
  IsRouteSet : BOOL &
  IsRouteSetDownstream : BOOL &
  State : RouteSearch &
  GraphState : STATE_LinkLTR_root
INITIALIZATION
  IsChecking := FALSE;
  IsCheckingOpposite := FALSE;
  IsAdmit := FALSE;
  IsAdmitOpposite := FALSE;
  IsRouteSet := FALSE;
  IsRouteSetDownstream := FALSE;
  State := RouteSearch_INACTIVE;
  GraphState := STATE_LinkLTR_root___initial
OPERATIONS
  InitialTransition =
    BEGIN
      // Update Terms
      IsChecking := RouteChecking_CHECK_FROM_B : ise_left_port_a_RouteFindingSearch_Check OR RouteChecking_CHECK_FROM_C : ise_left_port_a_RouteFindingSearch_Check OR RouteChecking_CHECK_FROM_A : ise_left_port_b_RouteFindingSearch_Check OR RouteChecking_CHECK_FROM_A : ise_left_port_c_RouteFindingSearch_Check OR RouteChecking_CHECK_START : ise_left_port_b_RouteFindingSearch_Check ||
      IsCheckingOpposite := RouteChecking_CHECK_FROM_B : ise_right_port_a_RouteFindingSearch_Check OR RouteChecking_CHECK_FROM_C : ise_right_port_a_RouteFindingSearch_Check OR RouteChecking_CHECK_FROM_A : ise_right_port_b_RouteFindingSearch_Check OR RouteChecking_CHECK_FROM_A : ise_right_port_c_RouteFindingSearch_Check OR RouteChecking_CHECK_START : ise_right_port_b_RouteFindingSearch_Check ||
      IsAdmit := RouteAdmission_ADMIT_TO_B : ise_left_port_a_RouteFindingResponse_Admit OR RouteAdmission_ADMIT_TO_C : ise_left_port_a_RouteFindingResponse_Admit OR RouteAdmission_ADMIT_END : ise_left_port_a_RouteFindingResponse_Admit OR RouteAdmission_ADMIT_TO_A : ise_left_port_b_RouteFindingResponse_Admit OR RouteAdmission_ADMIT_TO_A : ise_left_port_c_RouteFindingResponse_Admit ||
      IsAdmitOpposite := RouteAdmission_ADMIT_TO_B : ise_right_port_a_RouteFindingResponse_Admit OR RouteAdmission_ADMIT_TO_C : ise_right_port_a_RouteFindingResponse_Admit OR RouteAdmission_ADMIT_END : ise_right_port_a_RouteFindingResponse_Admit OR RouteAdmission_ADMIT_TO_A : ise_right_port_b_RouteFindingResponse_Admit OR RouteAdmission_ADMIT_TO_A : ise_right_port_c_RouteFindingResponse_Admit ||
      IsRouteSet := RouteChecking_ROUTE_SET_FROM_B : ise_left_port_a_RouteFindingSearch_Check OR RouteChecking_ROUTE_SET_FROM_C : ise_left_port_a_RouteFindingSearch_Check OR RouteChecking_ROUTE_SET_FROM_A : ise_left_port_b_RouteFindingSearch_Check OR RouteChecking_ROUTE_SET_FROM_A : ise_left_port_c_RouteFindingSearch_Check OR RouteChecking_ROUTE_SET_FROM_START : ise_left_port_b_RouteFindingSearch_Check ||
      IsRouteSetDownstream := RouteAdmission_ROUTE_TO_B : ise_left_port_a_RouteFindingResponse_Admit OR RouteAdmission_ROUTE_TO_C : ise_left_port_a_RouteFindingResponse_Admit OR RouteAdmission_ROUTE_END : ise_left_port_a_RouteFindingResponse_Admit OR RouteAdmission_ROUTE_TO_A : ise_left_port_b_RouteFindingResponse_Admit OR RouteAdmission_ROUTE_TO_A : ise_left_port_c_RouteFindingResponse_Admit;
      // Perform transition
      SELECT GraphState = STATE_LinkLTR_root___initial THEN
        GraphState := STATE_LinkLTR_root___initial
      END;
    END
  Transition(ise_left_port_a_RouteFindingSearch_Check, ise_left_port_b_RouteFindingSearch_Check, ise_left_port_c_RouteFindingSearch_Check, ise_right_port_a_RouteFindingSearch_Check, ise_right_port_b_RouteFindingSearch_Check, ise_right_port_c_RouteFindingSearch_Check, ise_left_port_a_RouteFindingResponse_Admit, ise_left_port_b_RouteFindingResponse_Admit, ise_left_port_c_RouteFindingResponse_Admit, ise_right_port_a_RouteFindingResponse_Admit, ise_right_port_b_RouteFindingResponse_Admit, ise_right_port_c_RouteFindingResponse_Admit) =
    BEGIN
      // Update Terms
      IsChecking := RouteChecking_CHECK_FROM_B : ise_left_port_a_RouteFindingSearch_Check OR RouteChecking_CHECK_FROM_C : ise_left_port_a_RouteFindingSearch_Check OR RouteChecking_CHECK_FROM_A : ise_left_port_b_RouteFindingSearch_Check OR RouteChecking_CHECK_FROM_A : ise_left_port_c_RouteFindingSearch_Check OR RouteChecking_CHECK_START : ise_left_port_b_RouteFindingSearch_Check ||
      IsCheckingOpposite := RouteChecking_CHECK_FROM_B : ise_right_port_a_RouteFindingSearch_Check OR RouteChecking_CHECK_FROM_C : ise_right_port_a_RouteFindingSearch_Check OR RouteChecking_CHECK_FROM_A : ise_right_port_b_RouteFindingSearch_Check OR RouteChecking_CHECK_FROM_A : ise_right_port_c_RouteFindingSearch_Check OR RouteChecking_CHECK_START : ise_right_port_b_RouteFindingSearch_Check ||
      IsAdmit := RouteAdmission_ADMIT_TO_B : ise_left_port_a_RouteFindingResponse_Admit OR RouteAdmission_ADMIT_TO_C : ise_left_port_a_RouteFindingResponse_Admit OR RouteAdmission_ADMIT_END : ise_left_port_a_RouteFindingResponse_Admit OR RouteAdmission_ADMIT_TO_A : ise_left_port_b_RouteFindingResponse_Admit OR RouteAdmission_ADMIT_TO_A : ise_left_port_c_RouteFindingResponse_Admit ||
      IsAdmitOpposite := RouteAdmission_ADMIT_TO_B : ise_right_port_a_RouteFindingResponse_Admit OR RouteAdmission_ADMIT_TO_C : ise_right_port_a_RouteFindingResponse_Admit OR RouteAdmission_ADMIT_END : ise_right_port_a_RouteFindingResponse_Admit OR RouteAdmission_ADMIT_TO_A : ise_right_port_b_RouteFindingResponse_Admit OR RouteAdmission_ADMIT_TO_A : ise_right_port_c_RouteFindingResponse_Admit ||
      IsRouteSet := RouteChecking_ROUTE_SET_FROM_B : ise_left_port_a_RouteFindingSearch_Check OR RouteChecking_ROUTE_SET_FROM_C : ise_left_port_a_RouteFindingSearch_Check OR RouteChecking_ROUTE_SET_FROM_A : ise_left_port_b_RouteFindingSearch_Check OR RouteChecking_ROUTE_SET_FROM_A : ise_left_port_c_RouteFindingSearch_Check OR RouteChecking_ROUTE_SET_FROM_START : ise_left_port_b_RouteFindingSearch_Check ||
      IsRouteSetDownstream := RouteAdmission_ROUTE_TO_B : ise_left_port_a_RouteFindingResponse_Admit OR RouteAdmission_ROUTE_TO_C : ise_left_port_a_RouteFindingResponse_Admit OR RouteAdmission_ROUTE_END : ise_left_port_a_RouteFindingResponse_Admit OR RouteAdmission_ROUTE_TO_A : ise_left_port_b_RouteFindingResponse_Admit OR RouteAdmission_ROUTE_TO_A : ise_left_port_c_RouteFindingResponse_Admit;
      // Perform transition
      SELECT GraphState = STATE_LinkLTR_root___initial THEN
        GraphState := STATE_LinkLTR_root___initial
      END
    END
END//MACHINE
