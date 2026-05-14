MACHINE Route
SEES Enums
SETS
  STATETYPE_Route_root = { STATE_Route_root___initial, STATE_Route_root_RELEASED, STATE_Route_root_SET, STATE_Route_root_PREPARING, STATE_Route_root_c }
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
  GraphState_root
INVARIANT
  RouteRequested : BOOL &
  MatchesDiversion : BOOL &
  MatchesDirection : BOOL &
  PointsAvailable : BOOL &
  NoIncompatibleRoutes : BOOL &
  AutomaticReleaseEffective : BOOL &
  ManualReleaseEffective : BOOL &
  RouteBecameUnset : BOOL &
  State : E_RouteState &
  GraphState_root : STATETYPE_Route_root
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
  GraphState_root := STATE_Route_root___initial
OPERATIONS
  InitialTransition(infrastructure_element_RouteFindingSearch_Check, infrastructure_element_RouteFindingResponse_Admit, upstream_link_right_LinkLTR_State, upstream_link_left_LinkRTL_State, requires_point_left_PointNominalPosition_State, downstream_link_left_LinkRTL_State, downstream_link_right_LinkLTR_State, requires_point_right_PointNominalPosition_State, RouteAutomaticRelease_State, RouteManualRelease_ManualReleaseRequested) =
    BEGIN
      // Update Terms
      RouteRequested := bool((infrastructure_element_RouteFindingSearch_Check = RouteChecking_CHECK_START & infrastructure_element_RouteFindingResponse_Admit /= RouteAdmission_INACTIVE) or (RouteSearch_ROUTE_SET : upstream_link_right_LinkLTR_State or RouteSearch_ROUTE_SET : upstream_link_left_LinkRTL_State)) ||
      MatchesDiversion := bool((((infrastructure_element_RouteFindingSearch_Check = RouteChecking_CHECK_FROM_B & infrastructure_element_RouteFindingResponse_Admit = RouteAdmission_ADMIT_TO_A) or ((infrastructure_element_RouteFindingSearch_Check = RouteChecking_CHECK_START or infrastructure_element_RouteFindingSearch_Check = RouteChecking_CHECK_FROM_A) & (infrastructure_element_RouteFindingResponse_Admit = RouteAdmission_ADMIT_TO_B or infrastructure_element_RouteFindingResponse_Admit = RouteAdmission_ADMIT_END))) & (PointState_LEFT /: requires_point_left_PointNominalPosition_State & PointState_RIGHT /: requires_point_left_PointNominalPosition_State & PointState_UNDETERMINED /: requires_point_left_PointNominalPosition_State)) or (((infrastructure_element_RouteFindingSearch_Check = RouteChecking_CHECK_FROM_A & infrastructure_element_RouteFindingResponse_Admit = RouteAdmission_ADMIT_TO_C) or (infrastructure_element_RouteFindingSearch_Check = RouteChecking_CHECK_FROM_C & infrastructure_element_RouteFindingResponse_Admit = RouteAdmission_ADMIT_TO_A)) & (PointState_LEFT : requires_point_left_PointNominalPosition_State or PointState_RIGHT : requires_point_left_PointNominalPosition_State or PointState_UNDETERMINED : requires_point_left_PointNominalPosition_State))) ||
      MatchesDirection := bool(RouteSearch_ROUTE_SET : upstream_link_left_LinkRTL_State or RouteSearch_ROUTE_SET : upstream_link_right_LinkLTR_State or RouteSearch_RESPONSE : downstream_link_left_LinkRTL_State or RouteSearch_RESPONSE : downstream_link_right_LinkLTR_State) ||
      PointsAvailable := bool(({PointState_RIGHT} = requires_point_right_PointNominalPosition_State or {} = requires_point_right_PointNominalPosition_State) & ({PointState_LEFT} = requires_point_left_PointNominalPosition_State or {} = requires_point_left_PointNominalPosition_State)) ||
      NoIncompatibleRoutes := TRUE ||
      AutomaticReleaseEffective := bool(RouteAutomaticRelease_State = ActiveInactive_ACTIVE) ||
      ManualReleaseEffective := bool(RouteManualRelease_ManualReleaseRequested = ActiveInactive_ACTIVE) ||
      RouteBecameUnset := bool(RouteSearch_INACTIVE : upstream_link_right_LinkLTR_State or RouteSearch_INACTIVE : upstream_link_left_LinkRTL_State);
      // Perform transition
        State := RouteState_RELEASED;
          GraphState_root := STATE_Route_root_RELEASED
    END;
  Transition(infrastructure_element_RouteFindingSearch_Check, infrastructure_element_RouteFindingResponse_Admit, upstream_link_right_LinkLTR_State, upstream_link_left_LinkRTL_State, requires_point_left_PointNominalPosition_State, downstream_link_left_LinkRTL_State, downstream_link_right_LinkLTR_State, requires_point_right_PointNominalPosition_State, RouteAutomaticRelease_State, RouteManualRelease_ManualReleaseRequested) =
    BEGIN
      // Update Terms
      RouteRequested := bool((infrastructure_element_RouteFindingSearch_Check = RouteChecking_CHECK_START & infrastructure_element_RouteFindingResponse_Admit /= RouteAdmission_INACTIVE) or (RouteSearch_ROUTE_SET : upstream_link_right_LinkLTR_State or RouteSearch_ROUTE_SET : upstream_link_left_LinkRTL_State)) ||
      MatchesDiversion := bool((((infrastructure_element_RouteFindingSearch_Check = RouteChecking_CHECK_FROM_B & infrastructure_element_RouteFindingResponse_Admit = RouteAdmission_ADMIT_TO_A) or ((infrastructure_element_RouteFindingSearch_Check = RouteChecking_CHECK_START or infrastructure_element_RouteFindingSearch_Check = RouteChecking_CHECK_FROM_A) & (infrastructure_element_RouteFindingResponse_Admit = RouteAdmission_ADMIT_TO_B or infrastructure_element_RouteFindingResponse_Admit = RouteAdmission_ADMIT_END))) & (PointState_LEFT /: requires_point_left_PointNominalPosition_State & PointState_RIGHT /: requires_point_left_PointNominalPosition_State & PointState_UNDETERMINED /: requires_point_left_PointNominalPosition_State)) or (((infrastructure_element_RouteFindingSearch_Check = RouteChecking_CHECK_FROM_A & infrastructure_element_RouteFindingResponse_Admit = RouteAdmission_ADMIT_TO_C) or (infrastructure_element_RouteFindingSearch_Check = RouteChecking_CHECK_FROM_C & infrastructure_element_RouteFindingResponse_Admit = RouteAdmission_ADMIT_TO_A)) & (PointState_LEFT : requires_point_left_PointNominalPosition_State or PointState_RIGHT : requires_point_left_PointNominalPosition_State or PointState_UNDETERMINED : requires_point_left_PointNominalPosition_State))) ||
      MatchesDirection := bool(RouteSearch_ROUTE_SET : upstream_link_left_LinkRTL_State or RouteSearch_ROUTE_SET : upstream_link_right_LinkLTR_State or RouteSearch_RESPONSE : downstream_link_left_LinkRTL_State or RouteSearch_RESPONSE : downstream_link_right_LinkLTR_State) ||
      PointsAvailable := bool(({PointState_RIGHT} = requires_point_right_PointNominalPosition_State or {} = requires_point_right_PointNominalPosition_State) & ({PointState_LEFT} = requires_point_left_PointNominalPosition_State or {} = requires_point_left_PointNominalPosition_State)) ||
      NoIncompatibleRoutes := TRUE ||
      AutomaticReleaseEffective := bool(RouteAutomaticRelease_State = ActiveInactive_ACTIVE) ||
      ManualReleaseEffective := bool(RouteManualRelease_ManualReleaseRequested = ActiveInactive_ACTIVE) ||
      RouteBecameUnset := bool(RouteSearch_INACTIVE : upstream_link_right_LinkLTR_State or RouteSearch_INACTIVE : upstream_link_left_LinkRTL_State);
      // Perform transition
      SELECT GraphState_root = STATE_Route_root_RELEASED THEN 
        IF RouteRequested = TRUE & MatchesDiversion = TRUE & MatchesDirection = TRUE THEN

        IF PointsAvailable = TRUE & NoIncompatibleRoutes = TRUE THEN
State := RouteState_SET;
          GraphState_root := STATE_Route_root_SET
        ELSE
        State := RouteState_PREPARING;
          GraphState_root := STATE_Route_root_PREPARING
        END

        END
      WHEN GraphState_root = STATE_Route_root_SET THEN 
        IF AutomaticReleaseEffective = TRUE or ManualReleaseEffective = TRUE or RouteBecameUnset = TRUE THEN
State := RouteState_RELEASED;
          GraphState_root := STATE_Route_root_RELEASED
        END
      WHEN GraphState_root = STATE_Route_root_PREPARING THEN 
        IF PointsAvailable = TRUE & NoIncompatibleRoutes = TRUE THEN
State := RouteState_SET;
          GraphState_root := STATE_Route_root_SET
        END
      END
    END
END//MACHINE
