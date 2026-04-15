MACHINE Zone
SEES Enums
SETS
  STATE_Zone_root = { STATE_Zone_root___initial, STATE_Zone_root_OCCUPIED, STATE_Zone_root_VACANT }
VARIABLES
  ZoneOccupied,
  State,
  GraphState
INVARIANT
  ZoneOccupied : BOOL &
  State : OccupancyStatus &
  GraphState : STATE_Zone_root
INITIALIZATION
  ZoneOccupied := TRUE;
  State := OccupancyStatus_OCCUPIED;
  GraphState := STATE_Zone_root___initial
OPERATIONS
  InitialTransition =
    BEGIN
      // Update Terms
      ZoneOccupied := SCITDS_OccupancyStatus /= OccupancyStatus_VACANT;
      // Perform transition
      SELECT GraphState = STATE_Zone_root___initial THEN
        GraphState := STATE_Zone_root___initial
      END;
    END
  Transition(SCITDS_OccupancyStatus) =
    BEGIN
      // Update Terms
      ZoneOccupied := SCITDS_OccupancyStatus /= OccupancyStatus_VACANT;
      // Perform transition
      SELECT GraphState = STATE_Zone_root___initial THEN
        GraphState := STATE_Zone_root___initial
      END
    END
END//MACHINE
