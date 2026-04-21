MACHINE PointLockLeft
SEES Enums
SETS
  STATE_PointLockLeft_root = { STATE_PointLockLeft_root___initial, STATE_PointLockLeft_root_NOT_LOCKED, STATE_PointLockLeft_root_LOCKED }
VARIABLES
  PointInOppositePosition,
  ZoneRequestsLock,
  PointIsMoving,
  TransitRequestsLock,
  State,
  GraphState_root
INVARIANT
  PointInOppositePosition : BOOL &
  ZoneRequestsLock : BOOL &
  PointIsMoving : BOOL &
  TransitRequestsLock : BOOL &
  State : ActiveInactive &
  GraphState_root : STATE_PointLockLeft_root
INITIALIZATION
  PointInOppositePosition := FALSE;
  ZoneRequestsLock := FALSE;
  PointIsMoving := FALSE;
  TransitRequestsLock := FALSE;
  State := ActiveInactive_INACTIVE;
  GraphState_root := STATE_PointLockLeft_root___initial
OPERATIONS
  InitialTransition(SCIP_DetectedEndPosition, locked_left_by_zones_Zone_State, locked_left_by_transits_Transit_State) =
    BEGIN
      // Update Terms
      PointInOppositePosition := bool(SCIP_DetectedEndPosition = EulynxEndPosition_RIGHT) ||
      ZoneRequestsLock := bool(OccupancyStatus_OCCUPIED : locked_left_by_zones_Zone_State) ||
      PointIsMoving := FALSE ||
      TransitRequestsLock := bool(ActiveInactive_ACTIVE : locked_left_by_transits_Transit_State);
      // Perform transition, todo
      GraphState_root := STATE_PointLockLeft_root___initial
    END;
  Transition(SCIP_DetectedEndPosition, locked_left_by_zones_Zone_State, locked_left_by_transits_Transit_State) =
    BEGIN
      // Update Terms
      PointInOppositePosition := bool(SCIP_DetectedEndPosition = EulynxEndPosition_RIGHT) ||
      ZoneRequestsLock := bool(OccupancyStatus_OCCUPIED : locked_left_by_zones_Zone_State) ||
      PointIsMoving := FALSE ||
      TransitRequestsLock := bool(ActiveInactive_ACTIVE : locked_left_by_transits_Transit_State);
      // Perform transition
      SELECT GraphState_root = STATE_PointLockLeft_root_NOT_LOCKED THEN 
        IF ZoneRequestsLock = TRUE or PointIsMoving = TRUE or TransitRequestsLock = TRUE THEN
          State := ActiveInactive_ACTIVE;
          GraphState_root := STATE_PointLockLeft_root_LOCKED
        END
      END;
      SELECT GraphState_root = STATE_PointLockLeft_root_LOCKED THEN 
        IF not(ZoneRequestsLock = TRUE) & not(PointIsMoving = TRUE) & not(TransitRequestsLock = TRUE) THEN
          State := ActiveInactive_INACTIVE;
          GraphState_root := STATE_PointLockLeft_root_NOT_LOCKED
        END
      END
    END
END//MACHINE
