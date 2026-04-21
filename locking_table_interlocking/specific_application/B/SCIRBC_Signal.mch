MACHINE SCIRBC_Signal
SEES Enums
VARIABLES
  ApproachLockingActive,
  ApproachStatusRequested
INVARIANT
  ApproachLockingActive : BOOL &
  ApproachStatusRequested : BOOL
INITIALIZATION
  ApproachLockingActive := TRUE;
  ApproachStatusRequested := FALSE
OPERATIONS
  ComputeOutputs(routes_starting_here_RouteManualRelease_ManualReleaseWithholdMovementAuthority) =
    BEGIN
      IF bool(ActiveInactive_ACTIVE : routes_starting_here_RouteManualRelease_ManualReleaseWithholdMovementAuthority) = TRUE THEN
        ApproachStatusRequested := TRUE
      ELSIF bool({ActiveInactive_INACTIVE} = routes_starting_here_RouteManualRelease_ManualReleaseWithholdMovementAuthority) = TRUE THEN
        ApproachStatusRequested := FALSE
      ELSE
        ApproachStatusRequested := FALSE
      END
    END
END//MACHINE
