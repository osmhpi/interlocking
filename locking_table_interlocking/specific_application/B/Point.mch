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
      RouteAuthorizedMoveLeft := RouteState_PREPARING : requested_left_by_routes_Route_State ||
      RouteAuthorizedMoveRight := RouteState_PREPARING : requested_right_by_routes_Route_State ||
      PointLockedLeft := PointLockLeft_State = ActiveInactive_ACTIVE ||
      PointLockedRight := PointLockRight_State = ActiveInactive_ACTIVE;
      // Perform transition
      SELECT GraphState = STATE_Point_root___initial THEN
        GraphState := STATE_Point_root___initial
      END;
    END
  Transition(SCIP_DetectedEndPosition, requested_left_by_routes_Route_State, requested_right_by_routes_Route_State, PointLockLeft_State, PointLockRight_State) =
    BEGIN
      // Update Terms
      PointDetectedLeft := SCIP_DetectedEndPosition = EulynxEndPosition_LEFT ||
      PointDetectedRight := SCIP_DetectedEndPosition = EulynxEndPosition_RIGHT ||
      RouteAuthorizedMoveLeft := RouteState_PREPARING : requested_left_by_routes_Route_State ||
      RouteAuthorizedMoveRight := RouteState_PREPARING : requested_right_by_routes_Route_State ||
      PointLockedLeft := PointLockLeft_State = ActiveInactive_ACTIVE ||
      PointLockedRight := PointLockRight_State = ActiveInactive_ACTIVE;
      // Perform transition
      SELECT GraphState = STATE_Point_root___initial THEN
        GraphState := STATE_Point_root___initial
      END
    END
END//MACHINE
