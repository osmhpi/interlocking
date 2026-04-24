MACHINE Zone
SEES Enums
SETS
  STATETYPE_Zone_root = { STATE_Zone_root___initial, STATE_Zone_root_OCCUPIED, STATE_Zone_root_VACANT }
VARIABLES
  ZoneOccupied,
  State,
  GraphState_root
INVARIANT
  ZoneOccupied : BOOL &
  State : E_OccupancyStatus &
  GraphState_root : STATETYPE_Zone_root
INITIALIZATION
  ZoneOccupied := TRUE;
  State := OccupancyStatus_OCCUPIED;
  GraphState_root := STATE_Zone_root___initial
OPERATIONS
  InitialTransition(SCITDS_OccupancyStatus) =
    BEGIN
      // Update Terms
      ZoneOccupied := bool(SCITDS_OccupancyStatus /= OccupancyStatus_VACANT);
      // Perform transition
        State := OccupancyStatus_OCCUPIED;
          GraphState_root := STATE_Zone_root_OCCUPIED
    END;
  Transition(SCITDS_OccupancyStatus) =
    BEGIN
      // Update Terms
      ZoneOccupied := bool(SCITDS_OccupancyStatus /= OccupancyStatus_VACANT);
      // Perform transition
      SELECT GraphState_root = STATE_Zone_root_OCCUPIED THEN 
        IF not(ZoneOccupied = TRUE) THEN
State := OccupancyStatus_VACANT;
          GraphState_root := STATE_Zone_root_VACANT
        END
      WHEN GraphState_root = STATE_Zone_root_VACANT THEN 
        IF ZoneOccupied = TRUE THEN
State := OccupancyStatus_OCCUPIED;
          GraphState_root := STATE_Zone_root_OCCUPIED
        END
      END
    END
END//MACHINE
