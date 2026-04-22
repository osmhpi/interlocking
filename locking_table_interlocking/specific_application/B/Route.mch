MACHINE Route
SEES Enums
SETS
  STATETYPE_Route_root = { STATE_Route_root___initial, STATE_Route_root_RELEASED, STATE_Route_root_SET, STATE_Route_root_PREPARING, STATE_Route_root_c }
VARIABLES
  RouteRequested,
  PointsAvailable,
  NoIncompatibleRoutes,
  AutomaticReleaseEffective,
  ManualReleaseEffective,
  State,
  GraphState_root
INVARIANT
  RouteRequested : BOOL &
  PointsAvailable : BOOL &
  NoIncompatibleRoutes : BOOL &
  AutomaticReleaseEffective : BOOL &
  ManualReleaseEffective : BOOL &
  State : E_RouteState &
  GraphState_root : STATETYPE_Route_root
INITIALIZATION
  RouteRequested := FALSE;
  PointsAvailable := FALSE;
  NoIncompatibleRoutes := TRUE;
  AutomaticReleaseEffective := FALSE;
  ManualReleaseEffective := FALSE;
  State := RouteState_RELEASED;
  GraphState_root := STATE_Route_root___initial
OPERATIONS
  InitialTransition(SCICC_MsgRequestRoute, request_points_right_Point_State, request_points_left_Point_State, RouteAutomaticRelease_State, RouteManualRelease_ManualReleaseRequested) =
    BEGIN
      // Update Terms
      RouteRequested := bool(SCICC_MsgRequestRoute = TRUE) ||
      PointsAvailable := bool({PointState_RIGHT} = request_points_right_Point_State & {PointState_LEFT} = request_points_left_Point_State) ||
      NoIncompatibleRoutes := TRUE ||
      AutomaticReleaseEffective := bool(RouteAutomaticRelease_State = ActiveInactive_ACTIVE) ||
      ManualReleaseEffective := bool(RouteManualRelease_ManualReleaseRequested = ActiveInactive_ACTIVE);
      // Perform transition
        State := RouteState_RELEASED;
          GraphState_root := STATE_Route_root_RELEASED
    END;
  Transition(SCICC_MsgRequestRoute, request_points_right_Point_State, request_points_left_Point_State, RouteAutomaticRelease_State, RouteManualRelease_ManualReleaseRequested) =
    BEGIN
      // Update Terms
      RouteRequested := bool(SCICC_MsgRequestRoute = TRUE) ||
      PointsAvailable := bool({PointState_RIGHT} = request_points_right_Point_State & {PointState_LEFT} = request_points_left_Point_State) ||
      NoIncompatibleRoutes := TRUE ||
      AutomaticReleaseEffective := bool(RouteAutomaticRelease_State = ActiveInactive_ACTIVE) ||
      ManualReleaseEffective := bool(RouteManualRelease_ManualReleaseRequested = ActiveInactive_ACTIVE);
      // Perform transition
      SELECT GraphState_root = STATE_Route_root_RELEASED THEN 
        IF RouteRequested = TRUE THEN

        IF PointsAvailable = TRUE & NoIncompatibleRoutes = TRUE THEN
State := RouteState_SET;
          GraphState_root := STATE_Route_root_SET
        ELSE
        State := RouteState_PREPARING;
          GraphState_root := STATE_Route_root_PREPARING
        END

        END
      END;
      SELECT GraphState_root = STATE_Route_root_SET THEN 
        IF AutomaticReleaseEffective = TRUE or ManualReleaseEffective = TRUE THEN
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
