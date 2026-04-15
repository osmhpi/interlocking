MACHINE Route
SEES Enums
SETS
  STATE_Route_root = { STATE_Route_root___initial, STATE_Route_root_RELEASED, STATE_Route_root_SET, STATE_Route_root_PREPARING, STATE_Route_root_c }
VARIABLES
  RouteRequested,
  MatchesDiversion,
  MatchesDirection,
  PointsAvailable,
  NoIncompatibleRoutes,
  AutomaticReleaseEffective,
  ManualReleaseEffective,
  RouteBecameUnset,
  State,
  GraphState
INVARIANT
  RouteRequested : BOOL &
  MatchesDiversion : BOOL &
  MatchesDirection : BOOL &
  PointsAvailable : BOOL &
  NoIncompatibleRoutes : BOOL &
  AutomaticReleaseEffective : BOOL &
  ManualReleaseEffective : BOOL &
  RouteBecameUnset : BOOL &
  State : RouteState &
  GraphState : STATE_Route_root
INITIALIZATION
  RouteRequested := FALSE;
  MatchesDiversion := FALSE;
  MatchesDirection := FALSE;
  PointsAvailable := TRUE;
  NoIncompatibleRoutes := TRUE;
  AutomaticReleaseEffective := FALSE;
  ManualReleaseEffective := FALSE;
  RouteBecameUnset := FALSE;
  State := RouteState_RELEASED;
  GraphState := STATE_Route_root___initial
OPERATIONS
  InitialTransition =
    BEGIN
      // Update Terms
      RouteRequested := (@ise_RouteFindingSearch_Check = RouteChecking_CHECK_START AND @ise_RouteFindingResponse_Admit /= RouteAdmission_INACTIVE) OR (RouteSearch_ROUTE_SET : upstream_link_right_LinkLTR_State OR RouteSearch_ROUTE_SET : upstream_link_left_LinkRTL_State) ||
      MatchesDiversion := (((@ise_RouteFindingSearch_Check = RouteChecking_CHECK_FROM_B AND @ise_RouteFindingResponse_Admit = RouteAdmission_ADMIT_TO_A) OR ((@ise_RouteFindingSearch_Check = RouteChecking_CHECK_START OR @ise_RouteFindingSearch_Check = RouteChecking_CHECK_FROM_A) AND (@ise_RouteFindingResponse_Admit = RouteAdmission_ADMIT_TO_B OR @ise_RouteFindingResponse_Admit = RouteAdmission_ADMIT_END))) AND (!(point).(point : dom(requires_point_left_Point_State) => requires_point_left_Point_State(point) = PointState_LEFT ) AND !(point).(point : dom(requires_point_left_Point_State) => requires_point_left_Point_State(point) = PointState_RIGHT ) AND !(point).(point : dom(requires_point_left_Point_State) => requires_point_left_Point_State(point) = PointState_UNDETERMINED ))) OR (((@ise_RouteFindingSearch_Check = RouteChecking_CHECK_FROM_A AND @ise_RouteFindingResponse_Admit = RouteAdmission_ADMIT_TO_C) OR (@ise_RouteFindingSearch_Check = RouteChecking_CHECK_FROM_C AND @ise_RouteFindingResponse_Admit = RouteAdmission_ADMIT_TO_A)) AND (PointState_LEFT : requires_point_left_Point_State OR PointState_RIGHT : requires_point_left_Point_State OR PointState_UNDETERMINED : requires_point_left_Point_State)) ||
      MatchesDirection := RouteSearch_ROUTE_SET : upstream_link_left_LinkRTL_State OR RouteSearch_ROUTE_SET : upstream_link_right_LinkLTR_State OR RouteSearch_RESPONSE : downstream_link_left_LinkRTL_State OR RouteSearch_RESPONSE : downstream_link_right_LinkLTR_State ||
      PointsAvailable := !(point).(point : dom(requires_point_right_Point_State) => requires_point_right_Point_State(point) = PointState_RIGHT ) AND !(point).(point : dom(requires_point_left_Point_State) => requires_point_left_Point_State(point) = PointState_LEFT ) ||
      NoIncompatibleRoutes := TRUE ||
      AutomaticReleaseEffective := RouteAutomaticRelease_State = ActiveInactive_ACTIVE ||
      ManualReleaseEffective := RouteManualRelease_ManualReleaseRequested = ActiveInactive_ACTIVE ||
      RouteBecameUnset := RouteSearch_INACTIVE : upstream_link_right_LinkLTR_State OR RouteSearch_INACTIVE : upstream_link_left_LinkRTL_State;
      // Perform transition
      SELECT GraphState = STATE_Route_root___initial THEN
        GraphState := STATE_Route_root___initial
      END;
    END
  Transition(ise_RouteFindingSearch_Check, ise_RouteFindingResponse_Admit, upstream_link_right_LinkLTR_State, upstream_link_left_LinkRTL_State, requires_point_left_Point_State, downstream_link_left_LinkRTL_State, downstream_link_right_LinkLTR_State, requires_point_right_Point_State, RouteAutomaticRelease_State, RouteManualRelease_ManualReleaseRequested) =
    BEGIN
      // Update Terms
      RouteRequested := (@ise_RouteFindingSearch_Check = RouteChecking_CHECK_START AND @ise_RouteFindingResponse_Admit /= RouteAdmission_INACTIVE) OR (RouteSearch_ROUTE_SET : upstream_link_right_LinkLTR_State OR RouteSearch_ROUTE_SET : upstream_link_left_LinkRTL_State) ||
      MatchesDiversion := (((@ise_RouteFindingSearch_Check = RouteChecking_CHECK_FROM_B AND @ise_RouteFindingResponse_Admit = RouteAdmission_ADMIT_TO_A) OR ((@ise_RouteFindingSearch_Check = RouteChecking_CHECK_START OR @ise_RouteFindingSearch_Check = RouteChecking_CHECK_FROM_A) AND (@ise_RouteFindingResponse_Admit = RouteAdmission_ADMIT_TO_B OR @ise_RouteFindingResponse_Admit = RouteAdmission_ADMIT_END))) AND (!(point).(point : dom(requires_point_left_Point_State) => requires_point_left_Point_State(point) = PointState_LEFT ) AND !(point).(point : dom(requires_point_left_Point_State) => requires_point_left_Point_State(point) = PointState_RIGHT ) AND !(point).(point : dom(requires_point_left_Point_State) => requires_point_left_Point_State(point) = PointState_UNDETERMINED ))) OR (((@ise_RouteFindingSearch_Check = RouteChecking_CHECK_FROM_A AND @ise_RouteFindingResponse_Admit = RouteAdmission_ADMIT_TO_C) OR (@ise_RouteFindingSearch_Check = RouteChecking_CHECK_FROM_C AND @ise_RouteFindingResponse_Admit = RouteAdmission_ADMIT_TO_A)) AND (PointState_LEFT : requires_point_left_Point_State OR PointState_RIGHT : requires_point_left_Point_State OR PointState_UNDETERMINED : requires_point_left_Point_State)) ||
      MatchesDirection := RouteSearch_ROUTE_SET : upstream_link_left_LinkRTL_State OR RouteSearch_ROUTE_SET : upstream_link_right_LinkLTR_State OR RouteSearch_RESPONSE : downstream_link_left_LinkRTL_State OR RouteSearch_RESPONSE : downstream_link_right_LinkLTR_State ||
      PointsAvailable := !(point).(point : dom(requires_point_right_Point_State) => requires_point_right_Point_State(point) = PointState_RIGHT ) AND !(point).(point : dom(requires_point_left_Point_State) => requires_point_left_Point_State(point) = PointState_LEFT ) ||
      NoIncompatibleRoutes := TRUE ||
      AutomaticReleaseEffective := RouteAutomaticRelease_State = ActiveInactive_ACTIVE ||
      ManualReleaseEffective := RouteManualRelease_ManualReleaseRequested = ActiveInactive_ACTIVE ||
      RouteBecameUnset := RouteSearch_INACTIVE : upstream_link_right_LinkLTR_State OR RouteSearch_INACTIVE : upstream_link_left_LinkRTL_State;
      // Perform transition
      SELECT GraphState = STATE_Route_root___initial THEN
        GraphState := STATE_Route_root___initial
      END
    END
END//MACHINE
