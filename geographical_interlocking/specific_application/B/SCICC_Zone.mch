MACHINE SCICC_Zone
SEES Enums
VARIABLES
  CurrentOccupancy
INVARIANT
  CurrentOccupancy : E_OccupancyStatus
INITIALIZATION
  CurrentOccupancy := OccupancyStatus_VACANT
OPERATIONS
  ComputeOutputs(Zone_State) = BEGIN
IF bool(Zone_State = OccupancyStatus_OCCUPIED) = TRUE THEN
        CurrentOccupancy := OccupancyStatus_OCCUPIED
      ELSIF bool(Zone_State = OccupancyStatus_VACANT) = TRUE THEN
        CurrentOccupancy := OccupancyStatus_VACANT
      ELSE
        CurrentOccupancy := OccupancyStatus_VACANT
      END
    END
END//MACHINE
