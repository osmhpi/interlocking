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
  State : RouteState &
  GraphState_root : STATE_Route_root
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
  InitialTransition(ise_RouteFindingSearch_Check, ise_RouteFindingResponse_Admit, upstream_link_right_LinkLTR_State, upstream_link_left_LinkRTL_State, requires_point_left_Point_State, downstream_link_left_LinkRTL_State, downstream_link_right_LinkLTR_State, requires_point_right_Point_State, RouteAutomaticRelease_State, RouteManualRelease_ManualReleaseRequested) =
    BEGIN
      // Update Terms
      RouteRequested := bool((bool(ise_RouteFindingSearch_Check = RouteChecking_CHECK_START & ise_RouteFindingResponse_Admit /= RouteAdmission_INACTIVE)) or (bool(RouteSearch_ROUTE_SET : upstream_link_right_LinkLTR_State or RouteSearch_ROUTE_SET : upstream_link_left_LinkRTL_State))) ||
      MatchesDiversion := bool((bool((bool((bool(ise_RouteFindingSearch_Check = RouteChecking_CHECK_FROM_B & ise_RouteFindingResponse_Admit = RouteAdmission_ADMIT_TO_A)) or (bool((bool(ise_RouteFindingSearch_Check = RouteChecking_CHECK_START or ise_RouteFindingSearch_Check = RouteChecking_CHECK_FROM_A)) & (bool(ise_RouteFindingResponse_Admit = RouteAdmission_ADMIT_TO_B or ise_RouteFindingResponse_Admit = RouteAdmission_ADMIT_END)))))) & (bool(PointState_LEFT /: requires_point_left_Point_State & PointState_RIGHT /: requires_point_left_Point_State & PointState_UNDETERMINED /: requires_point_left_Point_State)))) or (bool((bool((bool(ise_RouteFindingSearch_Check = RouteChecking_CHECK_FROM_A & ise_RouteFindingResponse_Admit = RouteAdmission_ADMIT_TO_C)) or (bool(ise_RouteFindingSearch_Check = RouteChecking_CHECK_FROM_C & ise_RouteFindingResponse_Admit = RouteAdmission_ADMIT_TO_A)))) & (bool(PointState_LEFT : requires_point_left_Point_State or PointState_RIGHT : requires_point_left_Point_State or PointState_UNDETERMINED : requires_point_left_Point_State))))) ||
      MatchesDirection := bool(RouteSearch_ROUTE_SET : upstream_link_left_LinkRTL_State or RouteSearch_ROUTE_SET : upstream_link_right_LinkLTR_State or RouteSearch_RESPONSE : downstream_link_left_LinkRTL_State or RouteSearch_RESPONSE : downstream_link_right_LinkLTR_State) ||
      PointsAvailable := bool({PointState_RIGHT} = requires_point_right_Point_State & {PointState_LEFT} = requires_point_left_Point_State) ||
      NoIncompatibleRoutes := TRUE ||
      AutomaticReleaseEffective := bool(RouteAutomaticRelease_State = ActiveInactive_ACTIVE) ||
      ManualReleaseEffective := bool(RouteManualRelease_ManualReleaseRequested = ActiveInactive_ACTIVE) ||
      RouteBecameUnset := bool(RouteSearch_INACTIVE : upstream_link_right_LinkLTR_State or RouteSearch_INACTIVE : upstream_link_left_LinkRTL_State);
      // Perform transition
        State := RouteState_RELEASED;
        GraphState_root := STATE_Route_root_RELEASED
    END;
  Transition(ise_RouteFindingSearch_Check, ise_RouteFindingResponse_Admit, upstream_link_right_LinkLTR_State, upstream_link_left_LinkRTL_State, requires_point_left_Point_State, downstream_link_left_LinkRTL_State, downstream_link_right_LinkLTR_State, requires_point_right_Point_State, RouteAutomaticRelease_State, RouteManualRelease_ManualReleaseRequested) =
    BEGIN
      // Update Terms
      RouteRequested := bool((bool(ise_RouteFindingSearch_Check = RouteChecking_CHECK_START & ise_RouteFindingResponse_Admit /= RouteAdmission_INACTIVE)) or (bool(RouteSearch_ROUTE_SET : upstream_link_right_LinkLTR_State or RouteSearch_ROUTE_SET : upstream_link_left_LinkRTL_State))) ||
      MatchesDiversion := bool((bool((bool((bool(ise_RouteFindingSearch_Check = RouteChecking_CHECK_FROM_B & ise_RouteFindingResponse_Admit = RouteAdmission_ADMIT_TO_A)) or (bool((bool(ise_RouteFindingSearch_Check = RouteChecking_CHECK_START or ise_RouteFindingSearch_Check = RouteChecking_CHECK_FROM_A)) & (bool(ise_RouteFindingResponse_Admit = RouteAdmission_ADMIT_TO_B or ise_RouteFindingResponse_Admit = RouteAdmission_ADMIT_END)))))) & (bool(PointState_LEFT /: requires_point_left_Point_State & PointState_RIGHT /: requires_point_left_Point_State & PointState_UNDETERMINED /: requires_point_left_Point_State)))) or (bool((bool((bool(ise_RouteFindingSearch_Check = RouteChecking_CHECK_FROM_A & ise_RouteFindingResponse_Admit = RouteAdmission_ADMIT_TO_C)) or (bool(ise_RouteFindingSearch_Check = RouteChecking_CHECK_FROM_C & ise_RouteFindingResponse_Admit = RouteAdmission_ADMIT_TO_A)))) & (bool(PointState_LEFT : requires_point_left_Point_State or PointState_RIGHT : requires_point_left_Point_State or PointState_UNDETERMINED : requires_point_left_Point_State))))) ||
      MatchesDirection := bool(RouteSearch_ROUTE_SET : upstream_link_left_LinkRTL_State or RouteSearch_ROUTE_SET : upstream_link_right_LinkLTR_State or RouteSearch_RESPONSE : downstream_link_left_LinkRTL_State or RouteSearch_RESPONSE : downstream_link_right_LinkLTR_State) ||
      PointsAvailable := bool({PointState_RIGHT} = requires_point_right_Point_State & {PointState_LEFT} = requires_point_left_Point_State) ||
      NoIncompatibleRoutes := TRUE ||
      AutomaticReleaseEffective := bool(RouteAutomaticRelease_State = ActiveInactive_ACTIVE) ||
      ManualReleaseEffective := bool(RouteManualRelease_ManualReleaseRequested = ActiveInactive_ACTIVE) ||
      RouteBecameUnset := bool(RouteSearch_INACTIVE : upstream_link_right_LinkLTR_State or RouteSearch_INACTIVE : upstream_link_left_LinkRTL_State);
      // Perform transition
      SELECT GraphState_root = STATE_Route_root_RELEASED THEN 
        IF RouteRequested = TRUE & MatchesDiversion = TRUE & MatchesDirection = TRUE THEN

            return self.transition_from_root_c(now)

        END
      END;
      SELECT GraphState_root = STATE_Route_root_SET THEN 
        IF AutomaticReleaseEffective = TRUE or ManualReleaseEffective = TRUE or RouteBecameUnset = TRUE THEN
State := RouteState_RELEASED;
          GraphState_root := STATE_Route_root_RELEASED

        END
      END;
      SELECT GraphState_root = STATE_Route_root_PREPARING THEN 
        IF PointsAvailable = TRUE & NoIncompatibleRoutes = TRUE THEN
State := RouteState_SET;
          GraphState_root := STATE_Route_root_SET

        END
      END
    END
END//MACHINE
