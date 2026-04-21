MACHINE RouteManualRelease
SEES Enums
SETS
  STATE_RouteManualRelease_root_ETCS_APPROACH_LOCKING = { STATE_RouteManualRelease_root_ETCS_APPROACH_LOCKING___initial, STATE_RouteManualRelease_root_ETCS_APPROACH_LOCKING_ETCS_APPROACH_LOCKING, STATE_RouteManualRelease_root_ETCS_APPROACH_LOCKING_ROUTE_RELEASED, STATE_RouteManualRelease_root_ETCS_APPROACH_LOCKING_MARKER_BOARD_OPEN, STATE_RouteManualRelease_root_ETCS_APPROACH_LOCKING_ROUTE_SET, STATE_RouteManualRelease_root_ETCS_APPROACH_LOCKING_MANUAL_RELEASE_ACTIVE, STATE_RouteManualRelease_root_ETCS_APPROACH_LOCKING_WITHHOLD_MA, STATE_RouteManualRelease_root_ETCS_APPROACH_LOCKING_TRAIN_APPROACHING, STATE_RouteManualRelease_root_ETCS_APPROACH_LOCKING_TRAIN_APPROACHING_ZONE, STATE_RouteManualRelease_root_ETCS_APPROACH_LOCKING_APPROACH_FREE, STATE_RouteManualRelease_root_ETCS_APPROACH_LOCKING_APPROACH_ZONE_TIMEOUT };
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
  GraphState_root
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
  StartUnsupervisedTrainApproach : INT &
  StartWithholdMovementAuthority : INT &
  GraphState_root : STATE_RouteManualRelease_root
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
  StartUnsupervisedTrainApproach := 0;
  StartWithholdMovementAuthority := 0;
  GraphState_root := STATE_RouteManualRelease_root___initial
OPERATIONS
  InitialTransition(ise_RouteManualReleaseDispatch_State, signal_SCIRBC_ApproachLockingActive, Route_State, RouteMonitoring_State, approach_zone_Zone_State, NOW) =
    BEGIN
      // Update Terms
      CommandReleaseRoute := bool(ise_RouteManualReleaseDispatch_State = ActiveInactive_ACTIVE) ||
      CommandUnsetManualReleaseRestriction := FALSE ||
      ApproachTaken := bool(signal_SCIRBC_ApproachLockingActive = TRUE) ||
      ManualSignalClose := FALSE ||
      TimeoutWithholdMovementAuthorityExpired := bool(NOW >= StartWithholdMovementAuthority + time_delay_etcs_approach_locking) ||
      TimeoutUnsupervisedTrainApproachExpired := bool(NOW >= StartUnsupervisedTrainApproach + time_delay_unsupervised_train_approach_locking) ||
      ReleasePrevention := FALSE ||
      RouteIsSet := bool(Route_State = RouteState_SET) ||
      RouteIsLocked := bool(RouteMonitoring_State = ActiveInactive_ACTIVE) ||
      PassageLock := FALSE ||
      ApproachZoneOccupied := bool(approach_zone_Zone_State = OccupancyStatus_OCCUPIED);
      // Perform transition, todo
      GraphState_root := STATE_RouteManualRelease_root___initial
    END;
  Transition(ise_RouteManualReleaseDispatch_State, signal_SCIRBC_ApproachLockingActive, Route_State, RouteMonitoring_State, approach_zone_Zone_State, NOW) =
    BEGIN
      // Update Terms
      CommandReleaseRoute := bool(ise_RouteManualReleaseDispatch_State = ActiveInactive_ACTIVE) ||
      CommandUnsetManualReleaseRestriction := FALSE ||
      ApproachTaken := bool(signal_SCIRBC_ApproachLockingActive = TRUE) ||
      ManualSignalClose := FALSE ||
      TimeoutWithholdMovementAuthorityExpired := bool(NOW >= StartWithholdMovementAuthority + time_delay_etcs_approach_locking) ||
      TimeoutUnsupervisedTrainApproachExpired := bool(NOW >= StartUnsupervisedTrainApproach + time_delay_unsupervised_train_approach_locking) ||
      ReleasePrevention := FALSE ||
      RouteIsSet := bool(Route_State = RouteState_SET) ||
      RouteIsLocked := bool(RouteMonitoring_State = ActiveInactive_ACTIVE) ||
      PassageLock := FALSE ||
      ApproachZoneOccupied := bool(approach_zone_Zone_State = OccupancyStatus_OCCUPIED);
      // Perform transition
      SELECT GraphState_root = STATE_RouteManualRelease_root_ROUTE_RELEASED THEN 
        IF RouteIsSet = TRUE THEN

          GraphState_root := STATE_RouteManualRelease_root_ETCS_APPROACH_LOCKING(self.transition_from_root_ETCS_APPROACH_LOCKING___initial(now))
        END
      END;
      SELECT GraphState_root = STATE_RouteManualRelease_root_ETCS_APPROACH_LOCKING(s) THEN 
        IF not(RouteIsSet = TRUE) THEN
          ManualReleaseRequested := ActiveInactive_INACTIVE;
          HoldApproachLocking := OpenCloseState_CLOSED;
          ManualReleaseWithholdMovementAuthority := ActiveInactive_INACTIVE;
          ManualReleasePrevention := ActiveInactive_INACTIVE;
          GraphState_root := STATE_RouteManualRelease_root_ROUTE_RELEASED
        END
        root_State::ETCS_APPROACH_LOCKING(self.transition_root_ETCS_APPROACH_LOCKING(s.clone(), now))
      END
    END
END//MACHINE
