MACHINE RouteManualRelease
SEES Enums
SETS
  STATE_RouteManualRelease_root = { STATE_RouteManualRelease_root___initial, STATE_RouteManualRelease_root_ETCS_APPROACH_LOCKING, STATE_RouteManualRelease_root_ROUTE_RELEASED }
VARIABLES
  CommandReleaseRoute,
  CommandUnsetManualReleaseRestriction,
  ApproachTaken,
  ManualSignalClose,
  TimeoutWithholdMovementAuthorityExpired,
  TimeoutUnsupervisedTrainApproachExpired,
  ReleasePrevention,
  RouteIsSet,
  RouteIsLocked,
  PassageLock,
  ApproachZoneOccupied,
  ManualReleaseRequested,
  HoldApproachLocking,
  ManualReleaseWithholdMovementAuthority,
  ManualReleasePrevention,
  StartUnsupervisedTrainApproach,
  StartWithholdMovementAuthority,
  GraphState
INVARIANT
  CommandReleaseRoute : BOOL &
  CommandUnsetManualReleaseRestriction : BOOL &
  ApproachTaken : BOOL &
  ManualSignalClose : BOOL &
  TimeoutWithholdMovementAuthorityExpired : BOOL &
  TimeoutUnsupervisedTrainApproachExpired : BOOL &
  ReleasePrevention : BOOL &
  RouteIsSet : BOOL &
  RouteIsLocked : BOOL &
  PassageLock : BOOL &
  ApproachZoneOccupied : BOOL &
  ManualReleaseRequested : ActiveInactive &
  HoldApproachLocking : OpenCloseState &
  ManualReleaseWithholdMovementAuthority : ActiveInactive &
  ManualReleasePrevention : ActiveInactive &
  StartUnsupervisedTrainApproach : timestamp &
  StartWithholdMovementAuthority : timestamp &
  GraphState : STATE_RouteManualRelease_root
INITIALIZATION
  CommandReleaseRoute := FALSE;
  CommandUnsetManualReleaseRestriction := FALSE;
  ApproachTaken := TRUE;
  ManualSignalClose := FALSE;
  TimeoutWithholdMovementAuthorityExpired := FALSE;
  TimeoutUnsupervisedTrainApproachExpired := FALSE;
  ReleasePrevention := FALSE;
  RouteIsSet := FALSE;
  RouteIsLocked := FALSE;
  PassageLock := FALSE;
  ApproachZoneOccupied := TRUE;
  ManualReleaseRequested := ActiveInactive_INACTIVE;
  HoldApproachLocking := OpenCloseState_CLOSED;
  ManualReleaseWithholdMovementAuthority := ActiveInactive_INACTIVE;
  ManualReleasePrevention := ActiveInactive_INACTIVE;
  StartUnsupervisedTrainApproach := _;
  StartWithholdMovementAuthority := _;
  GraphState := STATE_RouteManualRelease_root___initial
OPERATIONS
  InitialTransition =
    BEGIN
      // Update Terms
      CommandReleaseRoute := @ise_RouteManualReleaseDispatch_State = ActiveInactive_ACTIVE ||
      CommandUnsetManualReleaseRestriction := FALSE ||
      ApproachTaken := @signal_SCIRBC_ApproachLockingActive = TRUE ||
      ManualSignalClose := FALSE ||
      TimeoutWithholdMovementAuthorityExpired := NOW >= StartWithholdMovementAuthority + time_delay_etcs_approach_locking ||
      TimeoutUnsupervisedTrainApproachExpired := NOW >= StartUnsupervisedTrainApproach + time_delay_unsupervised_train_approach_locking ||
      ReleasePrevention := FALSE ||
      RouteIsSet := Route_State = RouteState_SET ||
      RouteIsLocked := RouteMonitoring_State = ActiveInactive_ACTIVE ||
      PassageLock := FALSE ||
      ApproachZoneOccupied := @approach_zone_Zone_State = OccupancyStatus_OCCUPIED;
      // Perform transition
      SELECT GraphState = STATE_RouteManualRelease_root___initial THEN
        GraphState := STATE_RouteManualRelease_root___initial
      END;
    END
  Transition(ise_RouteManualReleaseDispatch_State, signal_SCIRBC_ApproachLockingActive, Route_State, RouteMonitoring_State, approach_zone_Zone_State) =
    BEGIN
      // Update Terms
      CommandReleaseRoute := @ise_RouteManualReleaseDispatch_State = ActiveInactive_ACTIVE ||
      CommandUnsetManualReleaseRestriction := FALSE ||
      ApproachTaken := @signal_SCIRBC_ApproachLockingActive = TRUE ||
      ManualSignalClose := FALSE ||
      TimeoutWithholdMovementAuthorityExpired := NOW >= StartWithholdMovementAuthority + time_delay_etcs_approach_locking ||
      TimeoutUnsupervisedTrainApproachExpired := NOW >= StartUnsupervisedTrainApproach + time_delay_unsupervised_train_approach_locking ||
      ReleasePrevention := FALSE ||
      RouteIsSet := Route_State = RouteState_SET ||
      RouteIsLocked := RouteMonitoring_State = ActiveInactive_ACTIVE ||
      PassageLock := FALSE ||
      ApproachZoneOccupied := @approach_zone_Zone_State = OccupancyStatus_OCCUPIED;
      // Perform transition
      SELECT GraphState = STATE_RouteManualRelease_root___initial THEN
        GraphState := STATE_RouteManualRelease_root___initial
      END
    END
END//MACHINE
