MACHINE LinkRTL
SEES Enums
SETS
  STATETYPE_LinkRTL_root = { STATE_LinkRTL_root___initial, STATE_LinkRTL_root_IDLE, STATE_LinkRTL_root_CHECKING, STATE_LinkRTL_root_ADMIT, STATE_LinkRTL_root_ROUTE_SET, STATE_LinkRTL_root_ROUTE_MONITORED }
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
  GraphState_root : STATETYPE_LinkRTL_root
INITIALIZATION
  IsChecking := FALSE;
  IsCheckingOpposite := FALSE;
  IsAdmit := FALSE;
  IsAdmitOpposite := FALSE;
  IsRouteSet := FALSE;
  IsRouteSetDownstream := FALSE;
  State := RouteSearch_INACTIVE;
  GraphState_root := STATE_LinkRTL_root___initial
OPERATIONS
  InitialTransition(element_right_port_a_RouteFindingSearch_Check, element_right_port_b_RouteFindingSearch_Check, element_right_port_c_RouteFindingSearch_Check, element_left_port_a_RouteFindingSearch_Check, element_left_port_b_RouteFindingSearch_Check, element_left_port_c_RouteFindingSearch_Check, element_right_port_a_RouteFindingResponse_Admit, element_right_port_b_RouteFindingResponse_Admit, element_right_port_c_RouteFindingResponse_Admit, element_left_port_a_RouteFindingResponse_Admit, element_left_port_b_RouteFindingResponse_Admit, element_left_port_c_RouteFindingResponse_Admit) =
    BEGIN
      // Update Terms
      IsChecking := bool(RouteChecking_CHECK_FROM_B : element_right_port_a_RouteFindingSearch_Check or RouteChecking_CHECK_FROM_C : element_right_port_a_RouteFindingSearch_Check or RouteChecking_CHECK_FROM_A : element_right_port_b_RouteFindingSearch_Check or RouteChecking_CHECK_FROM_A : element_right_port_c_RouteFindingSearch_Check or RouteChecking_CHECK_START : element_right_port_b_RouteFindingSearch_Check) ||
      IsCheckingOpposite := bool(RouteChecking_CHECK_FROM_B : element_left_port_a_RouteFindingSearch_Check or RouteChecking_CHECK_FROM_C : element_left_port_a_RouteFindingSearch_Check or RouteChecking_CHECK_FROM_A : element_left_port_b_RouteFindingSearch_Check or RouteChecking_CHECK_FROM_A : element_left_port_c_RouteFindingSearch_Check or RouteChecking_CHECK_START : element_left_port_b_RouteFindingSearch_Check) ||
      IsAdmit := bool(RouteAdmission_ADMIT_TO_B : element_right_port_a_RouteFindingResponse_Admit or RouteAdmission_ADMIT_TO_C : element_right_port_a_RouteFindingResponse_Admit or RouteAdmission_ADMIT_END : element_right_port_a_RouteFindingResponse_Admit or RouteAdmission_ADMIT_TO_A : element_right_port_b_RouteFindingResponse_Admit or RouteAdmission_ADMIT_TO_A : element_right_port_c_RouteFindingResponse_Admit) ||
      IsAdmitOpposite := bool(RouteAdmission_ADMIT_TO_B : element_left_port_a_RouteFindingResponse_Admit or RouteAdmission_ADMIT_TO_C : element_left_port_a_RouteFindingResponse_Admit or RouteAdmission_ADMIT_END : element_left_port_a_RouteFindingResponse_Admit or RouteAdmission_ADMIT_TO_A : element_left_port_b_RouteFindingResponse_Admit or RouteAdmission_ADMIT_TO_A : element_left_port_c_RouteFindingResponse_Admit) ||
      IsRouteSet := bool(RouteChecking_ROUTE_SET_FROM_B : element_right_port_a_RouteFindingSearch_Check or RouteChecking_ROUTE_SET_FROM_C : element_right_port_a_RouteFindingSearch_Check or RouteChecking_ROUTE_SET_FROM_A : element_right_port_b_RouteFindingSearch_Check or RouteChecking_ROUTE_SET_FROM_A : element_right_port_c_RouteFindingSearch_Check or RouteChecking_ROUTE_SET_FROM_START : element_right_port_b_RouteFindingSearch_Check) ||
      IsRouteSetDownstream := bool(RouteAdmission_ROUTE_TO_B : element_right_port_a_RouteFindingResponse_Admit or RouteAdmission_ROUTE_TO_C : element_right_port_a_RouteFindingResponse_Admit or RouteAdmission_ROUTE_END : element_right_port_a_RouteFindingResponse_Admit or RouteAdmission_ROUTE_TO_A : element_right_port_b_RouteFindingResponse_Admit or RouteAdmission_ROUTE_TO_A : element_right_port_c_RouteFindingResponse_Admit);
      // Perform transition
        State := RouteSearch_INACTIVE;
          GraphState_root := STATE_LinkRTL_root_IDLE
    END;
  Transition(element_right_port_a_RouteFindingSearch_Check, element_right_port_b_RouteFindingSearch_Check, element_right_port_c_RouteFindingSearch_Check, element_left_port_a_RouteFindingSearch_Check, element_left_port_b_RouteFindingSearch_Check, element_left_port_c_RouteFindingSearch_Check, element_right_port_a_RouteFindingResponse_Admit, element_right_port_b_RouteFindingResponse_Admit, element_right_port_c_RouteFindingResponse_Admit, element_left_port_a_RouteFindingResponse_Admit, element_left_port_b_RouteFindingResponse_Admit, element_left_port_c_RouteFindingResponse_Admit) =
    BEGIN
      // Update Terms
      IsChecking := bool(RouteChecking_CHECK_FROM_B : element_right_port_a_RouteFindingSearch_Check or RouteChecking_CHECK_FROM_C : element_right_port_a_RouteFindingSearch_Check or RouteChecking_CHECK_FROM_A : element_right_port_b_RouteFindingSearch_Check or RouteChecking_CHECK_FROM_A : element_right_port_c_RouteFindingSearch_Check or RouteChecking_CHECK_START : element_right_port_b_RouteFindingSearch_Check) ||
      IsCheckingOpposite := bool(RouteChecking_CHECK_FROM_B : element_left_port_a_RouteFindingSearch_Check or RouteChecking_CHECK_FROM_C : element_left_port_a_RouteFindingSearch_Check or RouteChecking_CHECK_FROM_A : element_left_port_b_RouteFindingSearch_Check or RouteChecking_CHECK_FROM_A : element_left_port_c_RouteFindingSearch_Check or RouteChecking_CHECK_START : element_left_port_b_RouteFindingSearch_Check) ||
      IsAdmit := bool(RouteAdmission_ADMIT_TO_B : element_right_port_a_RouteFindingResponse_Admit or RouteAdmission_ADMIT_TO_C : element_right_port_a_RouteFindingResponse_Admit or RouteAdmission_ADMIT_END : element_right_port_a_RouteFindingResponse_Admit or RouteAdmission_ADMIT_TO_A : element_right_port_b_RouteFindingResponse_Admit or RouteAdmission_ADMIT_TO_A : element_right_port_c_RouteFindingResponse_Admit) ||
      IsAdmitOpposite := bool(RouteAdmission_ADMIT_TO_B : element_left_port_a_RouteFindingResponse_Admit or RouteAdmission_ADMIT_TO_C : element_left_port_a_RouteFindingResponse_Admit or RouteAdmission_ADMIT_END : element_left_port_a_RouteFindingResponse_Admit or RouteAdmission_ADMIT_TO_A : element_left_port_b_RouteFindingResponse_Admit or RouteAdmission_ADMIT_TO_A : element_left_port_c_RouteFindingResponse_Admit) ||
      IsRouteSet := bool(RouteChecking_ROUTE_SET_FROM_B : element_right_port_a_RouteFindingSearch_Check or RouteChecking_ROUTE_SET_FROM_C : element_right_port_a_RouteFindingSearch_Check or RouteChecking_ROUTE_SET_FROM_A : element_right_port_b_RouteFindingSearch_Check or RouteChecking_ROUTE_SET_FROM_A : element_right_port_c_RouteFindingSearch_Check or RouteChecking_ROUTE_SET_FROM_START : element_right_port_b_RouteFindingSearch_Check) ||
      IsRouteSetDownstream := bool(RouteAdmission_ROUTE_TO_B : element_right_port_a_RouteFindingResponse_Admit or RouteAdmission_ROUTE_TO_C : element_right_port_a_RouteFindingResponse_Admit or RouteAdmission_ROUTE_END : element_right_port_a_RouteFindingResponse_Admit or RouteAdmission_ROUTE_TO_A : element_right_port_b_RouteFindingResponse_Admit or RouteAdmission_ROUTE_TO_A : element_right_port_c_RouteFindingResponse_Admit);
      // Perform transition
      SELECT GraphState_root = STATE_LinkRTL_root_IDLE THEN 
        IF IsChecking = TRUE & not(IsCheckingOpposite = TRUE) THEN
State := RouteSearch_SEARCH;
          GraphState_root := STATE_LinkRTL_root_CHECKING
        ELSIF IsAdmit = TRUE THEN
State := RouteSearch_RESPONSE;
          GraphState_root := STATE_LinkRTL_root_ADMIT
        END
      WHEN GraphState_root = STATE_LinkRTL_root_CHECKING THEN 
        IF IsRouteSet = TRUE & IsAdmitOpposite = TRUE THEN
State := RouteSearch_ROUTE_SET;
          GraphState_root := STATE_LinkRTL_root_ROUTE_SET
        ELSIF not(IsChecking = TRUE) THEN
State := RouteSearch_INACTIVE;
          GraphState_root := STATE_LinkRTL_root_IDLE
        END
      WHEN GraphState_root = STATE_LinkRTL_root_ADMIT THEN 
        IF IsRouteSetDownstream = TRUE THEN
State := RouteSearch_ROUTE_MONITORED;
          GraphState_root := STATE_LinkRTL_root_ROUTE_MONITORED
        ELSIF not(IsAdmit = TRUE) THEN
State := RouteSearch_INACTIVE;
          GraphState_root := STATE_LinkRTL_root_IDLE
        END
      WHEN GraphState_root = STATE_LinkRTL_root_ROUTE_SET THEN 
        IF not(IsRouteSet = TRUE) THEN
State := RouteSearch_INACTIVE;
          GraphState_root := STATE_LinkRTL_root_IDLE
        END
      WHEN GraphState_root = STATE_LinkRTL_root_ROUTE_MONITORED THEN 
        IF not(IsRouteSetDownstream = TRUE) THEN
State := RouteSearch_RESPONSE;
          GraphState_root := STATE_LinkRTL_root_ADMIT
        END
      END
    END
END//MACHINE
