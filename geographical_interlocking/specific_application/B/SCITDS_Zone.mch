MACHINE SCITDS_Zone
SEES Enums
VARIABLES
  OccupancyStatus,
  ResetSection
INVARIANT
  OccupancyStatus : OccupancyStatus &
  ResetSection : BOOL
INITIALIZATION
  OccupancyStatus := OccupancyStatus_OCCUPIED;
  ResetSection := FALSE
OPERATIONS
  ComputeOutputs(Zone_State) =
    BEGIN
      IF bool(Zone_State = OccupancyStatus_VACANT) = TRUE THEN
        ResetSection := TRUE
      ELSIF bool(Zone_State /= OccupancyStatus_VACANT) = TRUE THEN
        ResetSection := FALSE
      ELSE
        ResetSection := FALSE
      END
    END
END//MACHINE
