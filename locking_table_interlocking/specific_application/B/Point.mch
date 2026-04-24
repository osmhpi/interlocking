MACHINE Point
SEES Enums
SETS
  STATETYPE_Point_root = { STATE_Point_root___initial, STATE_Point_root_LEFT, STATE_Point_root_RIGHT, STATE_Point_root_UNDETERMINED }
VARIABLES
  PointDetectedLeft,
  PointDetectedRight,
  RouteAuthorizedMoveLeft,
  RouteAuthorizedMoveRight,
  PointLockedLeft,
  PointLockedRight,
  State,
  GraphState_root
INVARIANT
  PointDetectedLeft : BOOL &
  PointDetectedRight : BOOL &
  RouteAuthorizedMoveLeft : BOOL &
  RouteAuthorizedMoveRight : BOOL &
  PointLockedLeft : BOOL &
  PointLockedRight : BOOL &
  State : E_PointState &
  GraphState_root : STATETYPE_Point_root
INITIALIZATION
  PointDetectedLeft := FALSE;
  PointDetectedRight := FALSE;
  RouteAuthorizedMoveLeft := FALSE;
  RouteAuthorizedMoveRight := FALSE;
  PointLockedLeft := FALSE;
  PointLockedRight := FALSE;
  State := PointState_UNDETERMINED;
  GraphState_root := STATE_Point_root___initial
OPERATIONS
  InitialTransition(SCIP_DetectedEndPosition, requested_left_by_routes_Route_State, requested_right_by_routes_Route_State, PointLockLeft_State, PointLockRight_State) =
    BEGIN
      // Update Terms
      PointDetectedLeft := bool(SCIP_DetectedEndPosition = EulynxEndPosition_LEFT) ||
      PointDetectedRight := bool(SCIP_DetectedEndPosition = EulynxEndPosition_RIGHT) ||
      RouteAuthorizedMoveLeft := bool(RouteState_PREPARING : requested_left_by_routes_Route_State) ||
      RouteAuthorizedMoveRight := bool(RouteState_PREPARING : requested_right_by_routes_Route_State) ||
      PointLockedLeft := bool(PointLockLeft_State = ActiveInactive_ACTIVE) ||
      PointLockedRight := bool(PointLockRight_State = ActiveInactive_ACTIVE);
      // Perform transition
        IF PointDetectedLeft = TRUE THEN
State := PointState_LEFT;
          GraphState_root := STATE_Point_root_LEFT
        ELSIF PointDetectedRight = TRUE THEN
State := PointState_RIGHT;
          GraphState_root := STATE_Point_root_RIGHT
        ELSE
        State := PointState_UNDETERMINED;
          GraphState_root := STATE_Point_root_UNDETERMINED
        END
    END;
  Transition(SCIP_DetectedEndPosition, requested_left_by_routes_Route_State, requested_right_by_routes_Route_State, PointLockLeft_State, PointLockRight_State) =
    BEGIN
      // Update Terms
      PointDetectedLeft := bool(SCIP_DetectedEndPosition = EulynxEndPosition_LEFT) ||
      PointDetectedRight := bool(SCIP_DetectedEndPosition = EulynxEndPosition_RIGHT) ||
      RouteAuthorizedMoveLeft := bool(RouteState_PREPARING : requested_left_by_routes_Route_State) ||
      RouteAuthorizedMoveRight := bool(RouteState_PREPARING : requested_right_by_routes_Route_State) ||
      PointLockedLeft := bool(PointLockLeft_State = ActiveInactive_ACTIVE) ||
      PointLockedRight := bool(PointLockRight_State = ActiveInactive_ACTIVE);
      // Perform transition
      SELECT GraphState_root = STATE_Point_root_LEFT THEN 
        IF RouteAuthorizedMoveRight = TRUE & not((RouteAuthorizedMoveLeft = TRUE or PointLockedLeft = TRUE)) THEN
State := PointState_RIGHT;
          GraphState_root := STATE_Point_root_RIGHT
        END
      WHEN GraphState_root = STATE_Point_root_RIGHT THEN 
        IF RouteAuthorizedMoveLeft = TRUE & not((RouteAuthorizedMoveRight = TRUE or PointLockedRight = TRUE)) THEN
State := PointState_LEFT;
          GraphState_root := STATE_Point_root_LEFT
        END
      WHEN GraphState_root = STATE_Point_root_UNDETERMINED THEN 
        IF RouteAuthorizedMoveLeft = TRUE & not(RouteAuthorizedMoveRight = TRUE) THEN
State := PointState_LEFT;
          GraphState_root := STATE_Point_root_LEFT
        ELSIF RouteAuthorizedMoveRight = TRUE & not(RouteAuthorizedMoveLeft = TRUE) THEN
State := PointState_RIGHT;
          GraphState_root := STATE_Point_root_RIGHT
        END
      END
    END
END//MACHINE
