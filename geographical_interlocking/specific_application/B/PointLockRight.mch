MACHINE PointLockRight
SEES Enums
SETS
  STATE_PointLockRight_root = { STATE_PointLockRight_root___initial, STATE_PointLockRight_root_NOT_LOCKED, STATE_PointLockRight_root_LOCKED }
VARIABLES
  PointInOppositePosition,
  ZoneRequestsLock,
  PointIsMoving,
  TransitRequestsLock,
  State,
  GraphState
INVARIANT
  PointInOppositePosition : BOOL &
  ZoneRequestsLock : BOOL &
  PointIsMoving : BOOL &
  TransitRequestsLock : BOOL &
  State : ActiveInactive &
  GraphState : STATE_PointLockRight_root
INITIALIZATION
  PointInOppositePosition := FALSE;
  ZoneRequestsLock := FALSE;
  PointIsMoving := FALSE;
  TransitRequestsLock := FALSE;
  State := ActiveInactive_INACTIVE;
  GraphState := STATE_PointLockRight_root___initial
OPERATIONS
  InitialTransition =
    BEGIN
      // Update Terms
      PointInOppositePosition := SCIP_DetectedEndPosition = EulynxEndPosition_RIGHT ||
      ZoneRequestsLock := OccupancyStatus_OCCUPIED : locked_right_by_zones_Zone_State ||
      PointIsMoving := FALSE ||
      TransitRequestsLock := ActiveInactive_ACTIVE : locked_right_by_transits_Transit_State;
      // Perform transition
      SELECT GraphState = STATE_PointLockRight_root___initial THEN
        GraphState := STATE_PointLockRight_root___initial
      END;
    END
  Transition(SCIP_DetectedEndPosition, locked_right_by_zones_Zone_State, locked_right_by_transits_Transit_State) =
    BEGIN
      // Update Terms
      PointInOppositePosition := SCIP_DetectedEndPosition = EulynxEndPosition_RIGHT ||
      ZoneRequestsLock := OccupancyStatus_OCCUPIED : locked_right_by_zones_Zone_State ||
      PointIsMoving := FALSE ||
      TransitRequestsLock := ActiveInactive_ACTIVE : locked_right_by_transits_Transit_State;
      // Perform transition
      SELECT GraphState = STATE_PointLockRight_root___initial THEN
        GraphState := STATE_PointLockRight_root___initial
      END
    END
END//MACHINE
