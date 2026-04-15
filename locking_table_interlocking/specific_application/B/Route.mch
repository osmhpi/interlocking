MACHINE Route
SEES Enums
SETS
  STATE_Route_root = { STATE_Route_root___initial, STATE_Route_root_RELEASED, STATE_Route_root_SET, STATE_Route_root_PREPARING, STATE_Route_root_c }
VARIABLES
  RouteRequested,
  PointsAvailable,
  NoIncompatibleRoutes,
  AutomaticReleaseEffective,
  ManualReleaseEffective,
  State,
  GraphState
INVARIANT
  RouteRequested : BOOL &
  PointsAvailable : BOOL &
  NoIncompatibleRoutes : BOOL &
  AutomaticReleaseEffective : BOOL &
  ManualReleaseEffective : BOOL &
  State : RouteState &
  GraphState : STATE_Route_root
INITIALIZATION
  RouteRequested := FALSE;
  PointsAvailable := FALSE;
  NoIncompatibleRoutes := TRUE;
  AutomaticReleaseEffective := FALSE;
  ManualReleaseEffective := FALSE;
  State := RouteState_RELEASED;
  GraphState := STATE_Route_root___initial
OPERATIONS
  InitialTransition =
    BEGIN
      // Update Terms
      RouteRequested := SCICC_MsgRequestRoute = TRUE ||
      PointsAvailable := !(point).(point : dom(request_points_right_Point_State) => request_points_right_Point_State(point) = PointState_RIGHT ) AND !(point).(point : dom(request_points_left_Point_State) => request_points_left_Point_State(point) = PointState_LEFT ) ||
      NoIncompatibleRoutes := TRUE ||
      AutomaticReleaseEffective := RouteAutomaticRelease_State = ActiveInactive_ACTIVE ||
      ManualReleaseEffective := RouteManualRelease_ManualReleaseRequested = ActiveInactive_ACTIVE;
      // Perform transition
      SELECT GraphState = STATE_Route_root___initial THEN
        GraphState := STATE_Route_root___initial
      END;
    END
  Transition(SCICC_MsgRequestRoute, request_points_right_Point_State, request_points_left_Point_State, RouteAutomaticRelease_State, RouteManualRelease_ManualReleaseRequested) =
    BEGIN
      // Update Terms
      RouteRequested := SCICC_MsgRequestRoute = TRUE ||
      PointsAvailable := !(point).(point : dom(request_points_right_Point_State) => request_points_right_Point_State(point) = PointState_RIGHT ) AND !(point).(point : dom(request_points_left_Point_State) => request_points_left_Point_State(point) = PointState_LEFT ) ||
      NoIncompatibleRoutes := TRUE ||
      AutomaticReleaseEffective := RouteAutomaticRelease_State = ActiveInactive_ACTIVE ||
      ManualReleaseEffective := RouteManualRelease_ManualReleaseRequested = ActiveInactive_ACTIVE;
      // Perform transition
      SELECT GraphState = STATE_Route_root___initial THEN
        GraphState := STATE_Route_root___initial
      END
    END
END//MACHINE
