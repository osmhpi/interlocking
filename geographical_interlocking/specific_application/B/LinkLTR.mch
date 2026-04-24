MACHINE LinkLTR
SEES Enums
SETS
  STATETYPE_LinkLTR_root = { STATE_LinkLTR_root___initial, STATE_LinkLTR_root_IDLE, STATE_LinkLTR_root_CHECKING, STATE_LinkLTR_root_ADMIT, STATE_LinkLTR_root_ROUTE_SET, STATE_LinkLTR_root_ROUTE_MONITORED }
VARIABLES
  IsChecking,
  IsCheckingOpposite,
  IsAdmit,
  IsAdmitOpposite,
  IsRouteSet,
  IsRouteSetDownstream,
  State,
  GraphState_root
INVARIANT
  IsChecking : BOOL &
  IsCheckingOpposite : BOOL &
  IsAdmit : BOOL &
  IsAdmitOpposite : BOOL &
  IsRouteSet : BOOL &
  IsRouteSetDownstream : BOOL &
  State : E_RouteSearch &
  GraphState_root : STATETYPE_LinkLTR_root
INITIALIZATION
  IsChecking := FALSE;
  IsCheckingOpposite := FALSE;
  IsAdmit := FALSE;
  IsAdmitOpposite := FALSE;
  IsRouteSet := FALSE;
  IsRouteSetDownstream := FALSE;
  State := RouteSearch_INACTIVE;
  GraphState_root := STATE_LinkLTR_root___initial
OPERATIONS
  InitialTransition(ise_left_port_a_RouteFindingSearch_Check, ise_left_port_b_RouteFindingSearch_Check, ise_left_port_c_RouteFindingSearch_Check, ise_right_port_a_RouteFindingSearch_Check, ise_right_port_b_RouteFindingSearch_Check, ise_right_port_c_RouteFindingSearch_Check, ise_left_port_a_RouteFindingResponse_Admit, ise_left_port_b_RouteFindingResponse_Admit, ise_left_port_c_RouteFindingResponse_Admit, ise_right_port_a_RouteFindingResponse_Admit, ise_right_port_b_RouteFindingResponse_Admit, ise_right_port_c_RouteFindingResponse_Admit) =
    BEGIN
      // Update Terms
      IsChecking := bool(RouteChecking_CHECK_FROM_B : ise_left_port_a_RouteFindingSearch_Check or RouteChecking_CHECK_FROM_C : ise_left_port_a_RouteFindingSearch_Check or RouteChecking_CHECK_FROM_A : ise_left_port_b_RouteFindingSearch_Check or RouteChecking_CHECK_FROM_A : ise_left_port_c_RouteFindingSearch_Check or RouteChecking_CHECK_START : ise_left_port_b_RouteFindingSearch_Check) ||
      IsCheckingOpposite := bool(RouteChecking_CHECK_FROM_B : ise_right_port_a_RouteFindingSearch_Check or RouteChecking_CHECK_FROM_C : ise_right_port_a_RouteFindingSearch_Check or RouteChecking_CHECK_FROM_A : ise_right_port_b_RouteFindingSearch_Check or RouteChecking_CHECK_FROM_A : ise_right_port_c_RouteFindingSearch_Check or RouteChecking_CHECK_START : ise_right_port_b_RouteFindingSearch_Check) ||
      IsAdmit := bool(RouteAdmission_ADMIT_TO_B : ise_left_port_a_RouteFindingResponse_Admit or RouteAdmission_ADMIT_TO_C : ise_left_port_a_RouteFindingResponse_Admit or RouteAdmission_ADMIT_END : ise_left_port_a_RouteFindingResponse_Admit or RouteAdmission_ADMIT_TO_A : ise_left_port_b_RouteFindingResponse_Admit or RouteAdmission_ADMIT_TO_A : ise_left_port_c_RouteFindingResponse_Admit) ||
      IsAdmitOpposite := bool(RouteAdmission_ADMIT_TO_B : ise_right_port_a_RouteFindingResponse_Admit or RouteAdmission_ADMIT_TO_C : ise_right_port_a_RouteFindingResponse_Admit or RouteAdmission_ADMIT_END : ise_right_port_a_RouteFindingResponse_Admit or RouteAdmission_ADMIT_TO_A : ise_right_port_b_RouteFindingResponse_Admit or RouteAdmission_ADMIT_TO_A : ise_right_port_c_RouteFindingResponse_Admit) ||
      IsRouteSet := bool(RouteChecking_ROUTE_SET_FROM_B : ise_left_port_a_RouteFindingSearch_Check or RouteChecking_ROUTE_SET_FROM_C : ise_left_port_a_RouteFindingSearch_Check or RouteChecking_ROUTE_SET_FROM_A : ise_left_port_b_RouteFindingSearch_Check or RouteChecking_ROUTE_SET_FROM_A : ise_left_port_c_RouteFindingSearch_Check or RouteChecking_ROUTE_SET_FROM_START : ise_left_port_b_RouteFindingSearch_Check) ||
      IsRouteSetDownstream := bool(RouteAdmission_ROUTE_TO_B : ise_left_port_a_RouteFindingResponse_Admit or RouteAdmission_ROUTE_TO_C : ise_left_port_a_RouteFindingResponse_Admit or RouteAdmission_ROUTE_END : ise_left_port_a_RouteFindingResponse_Admit or RouteAdmission_ROUTE_TO_A : ise_left_port_b_RouteFindingResponse_Admit or RouteAdmission_ROUTE_TO_A : ise_left_port_c_RouteFindingResponse_Admit);
      // Perform transition
        State := RouteSearch_INACTIVE;
          GraphState_root := STATE_LinkLTR_root_IDLE
    END;
  Transition(ise_left_port_a_RouteFindingSearch_Check, ise_left_port_b_RouteFindingSearch_Check, ise_left_port_c_RouteFindingSearch_Check, ise_right_port_a_RouteFindingSearch_Check, ise_right_port_b_RouteFindingSearch_Check, ise_right_port_c_RouteFindingSearch_Check, ise_left_port_a_RouteFindingResponse_Admit, ise_left_port_b_RouteFindingResponse_Admit, ise_left_port_c_RouteFindingResponse_Admit, ise_right_port_a_RouteFindingResponse_Admit, ise_right_port_b_RouteFindingResponse_Admit, ise_right_port_c_RouteFindingResponse_Admit) =
    BEGIN
      // Update Terms
      IsChecking := bool(RouteChecking_CHECK_FROM_B : ise_left_port_a_RouteFindingSearch_Check or RouteChecking_CHECK_FROM_C : ise_left_port_a_RouteFindingSearch_Check or RouteChecking_CHECK_FROM_A : ise_left_port_b_RouteFindingSearch_Check or RouteChecking_CHECK_FROM_A : ise_left_port_c_RouteFindingSearch_Check or RouteChecking_CHECK_START : ise_left_port_b_RouteFindingSearch_Check) ||
      IsCheckingOpposite := bool(RouteChecking_CHECK_FROM_B : ise_right_port_a_RouteFindingSearch_Check or RouteChecking_CHECK_FROM_C : ise_right_port_a_RouteFindingSearch_Check or RouteChecking_CHECK_FROM_A : ise_right_port_b_RouteFindingSearch_Check or RouteChecking_CHECK_FROM_A : ise_right_port_c_RouteFindingSearch_Check or RouteChecking_CHECK_START : ise_right_port_b_RouteFindingSearch_Check) ||
      IsAdmit := bool(RouteAdmission_ADMIT_TO_B : ise_left_port_a_RouteFindingResponse_Admit or RouteAdmission_ADMIT_TO_C : ise_left_port_a_RouteFindingResponse_Admit or RouteAdmission_ADMIT_END : ise_left_port_a_RouteFindingResponse_Admit or RouteAdmission_ADMIT_TO_A : ise_left_port_b_RouteFindingResponse_Admit or RouteAdmission_ADMIT_TO_A : ise_left_port_c_RouteFindingResponse_Admit) ||
      IsAdmitOpposite := bool(RouteAdmission_ADMIT_TO_B : ise_right_port_a_RouteFindingResponse_Admit or RouteAdmission_ADMIT_TO_C : ise_right_port_a_RouteFindingResponse_Admit or RouteAdmission_ADMIT_END : ise_right_port_a_RouteFindingResponse_Admit or RouteAdmission_ADMIT_TO_A : ise_right_port_b_RouteFindingResponse_Admit or RouteAdmission_ADMIT_TO_A : ise_right_port_c_RouteFindingResponse_Admit) ||
      IsRouteSet := bool(RouteChecking_ROUTE_SET_FROM_B : ise_left_port_a_RouteFindingSearch_Check or RouteChecking_ROUTE_SET_FROM_C : ise_left_port_a_RouteFindingSearch_Check or RouteChecking_ROUTE_SET_FROM_A : ise_left_port_b_RouteFindingSearch_Check or RouteChecking_ROUTE_SET_FROM_A : ise_left_port_c_RouteFindingSearch_Check or RouteChecking_ROUTE_SET_FROM_START : ise_left_port_b_RouteFindingSearch_Check) ||
      IsRouteSetDownstream := bool(RouteAdmission_ROUTE_TO_B : ise_left_port_a_RouteFindingResponse_Admit or RouteAdmission_ROUTE_TO_C : ise_left_port_a_RouteFindingResponse_Admit or RouteAdmission_ROUTE_END : ise_left_port_a_RouteFindingResponse_Admit or RouteAdmission_ROUTE_TO_A : ise_left_port_b_RouteFindingResponse_Admit or RouteAdmission_ROUTE_TO_A : ise_left_port_c_RouteFindingResponse_Admit);
      // Perform transition
      SELECT GraphState_root = STATE_LinkLTR_root_IDLE THEN 
        IF IsChecking = TRUE & not(IsCheckingOpposite = TRUE) THEN
State := RouteSearch_SEARCH;
          GraphState_root := STATE_LinkLTR_root_CHECKING
        ELSIF IsAdmit = TRUE THEN
State := RouteSearch_RESPONSE;
          GraphState_root := STATE_LinkLTR_root_ADMIT
        END
      WHEN GraphState_root = STATE_LinkLTR_root_CHECKING THEN 
        IF IsRouteSet = TRUE & IsAdmitOpposite = TRUE THEN
State := RouteSearch_ROUTE_SET;
          GraphState_root := STATE_LinkLTR_root_ROUTE_SET
        ELSIF not(IsChecking = TRUE) THEN
State := RouteSearch_INACTIVE;
          GraphState_root := STATE_LinkLTR_root_IDLE
        END
      WHEN GraphState_root = STATE_LinkLTR_root_ADMIT THEN 
        IF IsRouteSetDownstream = TRUE THEN
State := RouteSearch_ROUTE_MONITORED;
          GraphState_root := STATE_LinkLTR_root_ROUTE_MONITORED
        ELSIF not(IsAdmit = TRUE) THEN
State := RouteSearch_INACTIVE;
          GraphState_root := STATE_LinkLTR_root_IDLE
        END
      WHEN GraphState_root = STATE_LinkLTR_root_ROUTE_SET THEN 
        IF not(IsRouteSet = TRUE) THEN
State := RouteSearch_INACTIVE;
          GraphState_root := STATE_LinkLTR_root_IDLE
        END
      WHEN GraphState_root = STATE_LinkLTR_root_ROUTE_MONITORED THEN 
        IF not(IsRouteSetDownstream = TRUE) THEN
State := RouteSearch_RESPONSE;
          GraphState_root := STATE_LinkLTR_root_ADMIT
        END
      END
    END
END//MACHINE
