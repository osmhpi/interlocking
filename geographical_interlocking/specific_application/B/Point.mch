MACHINE Point
SEES Enums
SETS
  STATE_Point_root = { STATE_Point_root___initial, STATE_Point_root_LEFT, STATE_Point_root_RIGHT, STATE_Point_root_UNDETERMINED }
VARIABLES
  PointDetectedLeft,
  PointDetectedRight,
  RouteAuthorizedMoveLeft,
  RouteAuthorizedMoveRight,
  PointLockedLeft,
  PointLockedRight,
  State,
  GraphState
INVARIANT
  PointDetectedLeft : BOOL &
  PointDetectedRight : BOOL &
  RouteAuthorizedMoveLeft : BOOL &
  RouteAuthorizedMoveRight : BOOL &
  PointLockedLeft : BOOL &
  PointLockedRight : BOOL &
  State : PointState &
  GraphState : STATE_Point_root
INITIALIZATION
  PointDetectedLeft := FALSE;
  PointDetectedRight := FALSE;
  RouteAuthorizedMoveLeft := FALSE;
  RouteAuthorizedMoveRight := FALSE;
  PointLockedLeft := FALSE;
  PointLockedRight := FALSE;
  State := PointState_UNDETERMINED;
  GraphState := STATE_Point_root___initial
OPERATIONS
  InitialTransition =
    BEGIN
      // Update Terms
      PointDetectedLeft := SCIP_DetectedEndPosition = EulynxEndPosition_LEFT ||
      PointDetectedRight := SCIP_DetectedEndPosition = EulynxEndPosition_RIGHT ||
      RouteAuthorizedMoveLeft := RouteState_PREPARING : locked_left_by_transits_Route_State ||
      RouteAuthorizedMoveRight := RouteState_PREPARING : locked_right_by_transits_Route_State ||
      PointLockedLeft := PointLockLeft_State = ActiveInactive_ACTIVE ||
      PointLockedRight := PointLockRight_State = ActiveInactive_ACTIVE;
      // Perform transition
      SELECT GraphState = STATE_Point_root___initial THEN
        GraphState := STATE_Point_root___initial
      END;
    END
  Transition(SCIP_DetectedEndPosition, locked_left_by_transits_Route_State, locked_right_by_transits_Route_State, PointLockLeft_State, PointLockRight_State) =
    BEGIN
      // Update Terms
      PointDetectedLeft := SCIP_DetectedEndPosition = EulynxEndPosition_LEFT ||
      PointDetectedRight := SCIP_DetectedEndPosition = EulynxEndPosition_RIGHT ||
      RouteAuthorizedMoveLeft := RouteState_PREPARING : locked_left_by_transits_Route_State ||
      RouteAuthorizedMoveRight := RouteState_PREPARING : locked_right_by_transits_Route_State ||
      PointLockedLeft := PointLockLeft_State = ActiveInactive_ACTIVE ||
      PointLockedRight := PointLockRight_State = ActiveInactive_ACTIVE;
      // Perform transition
      SELECT GraphState = STATE_Point_root___initial THEN
        GraphState := STATE_Point_root___initial
      END
    END
END//MACHINE
