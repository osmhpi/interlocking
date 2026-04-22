MACHINE RouteManualRelease
SEES Enums
SETS
  STATETYPE_RouteManualRelease_root_ETCS_APPROACH_LOCKING = { STATE_RouteManualRelease_root_ETCS_APPROACH_LOCKING___initial, STATE_RouteManualRelease_root_ETCS_APPROACH_LOCKING_ETCS_APPROACH_LOCKING, STATE_RouteManualRelease_root_ETCS_APPROACH_LOCKING_ROUTE_RELEASED, STATE_RouteManualRelease_root_ETCS_APPROACH_LOCKING_MARKER_BOARD_OPEN, STATE_RouteManualRelease_root_ETCS_APPROACH_LOCKING_ROUTE_SET, STATE_RouteManualRelease_root_ETCS_APPROACH_LOCKING_MANUAL_RELEASE_ACTIVE, STATE_RouteManualRelease_root_ETCS_APPROACH_LOCKING_WITHHOLD_MA, STATE_RouteManualRelease_root_ETCS_APPROACH_LOCKING_TRAIN_APPROACHING, STATE_RouteManualRelease_root_ETCS_APPROACH_LOCKING_TRAIN_APPROACHING_ZONE, STATE_RouteManualRelease_root_ETCS_APPROACH_LOCKING_APPROACH_FREE, STATE_RouteManualRelease_root_ETCS_APPROACH_LOCKING_APPROACH_ZONE_TIMEOUT };
  STATETYPE_RouteManualRelease_root = { STATE_RouteManualRelease_root___initial, STATE_RouteManualRelease_root_ETCS_APPROACH_LOCKING, STATE_RouteManualRelease_root_ROUTE_RELEASED }
VARIABLES
  CommandReleaseRoute,
  ApproachTaken,
  ManualSignalClose,
  TimeoutWithholdMovementAuthorityExpired,
  TimeoutUnsupervisedTrainApproachExpired,
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
  GraphState_root_ETCS_APPROACH_LOCKING,
  GraphState_root
INVARIANT
  CommandReleaseRoute : BOOL &
  ApproachTaken : BOOL &
  ManualSignalClose : BOOL &
  TimeoutWithholdMovementAuthorityExpired : BOOL &
  TimeoutUnsupervisedTrainApproachExpired : BOOL &
  RouteIsSet : BOOL &
  RouteIsLocked : BOOL &
  PassageLock : BOOL &
  ApproachZoneOccupied : BOOL &
  ManualReleaseRequested : E_ActiveInactive &
  HoldApproachLocking : E_OpenCloseState &
  ManualReleaseWithholdMovementAuthority : E_ActiveInactive &
  ManualReleasePrevention : E_ActiveInactive &
  StartUnsupervisedTrainApproach : INTEGER &
  StartWithholdMovementAuthority : INTEGER &
  GraphState_root_ETCS_APPROACH_LOCKING : STATETYPE_RouteManualRelease_root_ETCS_APPROACH_LOCKING &
  GraphState_root : STATETYPE_RouteManualRelease_root
INITIALIZATION
  CommandReleaseRoute := FALSE;
  ApproachTaken := TRUE;
  ManualSignalClose := FALSE;
  TimeoutWithholdMovementAuthorityExpired := FALSE;
  TimeoutUnsupervisedTrainApproachExpired := FALSE;
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
  GraphState_root_ETCS_APPROACH_LOCKING := STATE_RouteManualRelease_root_ETCS_APPROACH_LOCKING___initial;
  GraphState_root := STATE_RouteManualRelease_root___initial
OPERATIONS
  InitialTransition(SCICC_MsgReleaseRoute, start_signal_SCIRBC_ApproachLockingActive, NOW, time_delay_etcs_approach_locking, time_delay_unsupervised_train_approach_locking, Route_State, RouteMonitoring_State, RouteAutomaticRelease_PassageLock, approach_zone_Zone_State) =
    BEGIN
      // Update Terms
      CommandReleaseRoute := bool(SCICC_MsgReleaseRoute = TRUE) ||
      ApproachTaken := bool(start_signal_SCIRBC_ApproachLockingActive = TRUE) ||
      ManualSignalClose := FALSE ||
      TimeoutWithholdMovementAuthorityExpired := bool(NOW >= StartWithholdMovementAuthority + time_delay_etcs_approach_locking) ||
      TimeoutUnsupervisedTrainApproachExpired := bool(NOW >= StartUnsupervisedTrainApproach + time_delay_unsupervised_train_approach_locking) ||
      RouteIsSet := bool(Route_State = RouteState_SET) ||
      RouteIsLocked := bool(RouteMonitoring_State = ActiveInactive_ACTIVE) ||
      PassageLock := bool(RouteAutomaticRelease_PassageLock = ActiveInactive_ACTIVE) ||
      ApproachZoneOccupied := bool(approach_zone_Zone_State = OccupancyStatus_OCCUPIED);
      // Perform transition
        ManualReleaseRequested := ActiveInactive_INACTIVE;
      HoldApproachLocking := OpenCloseState_CLOSED;
      ManualReleaseWithholdMovementAuthority := ActiveInactive_INACTIVE;
      ManualReleasePrevention := ActiveInactive_INACTIVE;
          GraphState_root := STATE_RouteManualRelease_root_ROUTE_RELEASED;
          GraphState_root_ETCS_APPROACH_LOCKING := STATE_RouteManualRelease_root_ETCS_APPROACH_LOCKING___initial
    END;
  Transition(SCICC_MsgReleaseRoute, start_signal_SCIRBC_ApproachLockingActive, NOW, time_delay_etcs_approach_locking, time_delay_unsupervised_train_approach_locking, Route_State, RouteMonitoring_State, RouteAutomaticRelease_PassageLock, approach_zone_Zone_State) =
    BEGIN
      // Update Terms
      CommandReleaseRoute := bool(SCICC_MsgReleaseRoute = TRUE) ||
      ApproachTaken := bool(start_signal_SCIRBC_ApproachLockingActive = TRUE) ||
      ManualSignalClose := FALSE ||
      TimeoutWithholdMovementAuthorityExpired := bool(NOW >= StartWithholdMovementAuthority + time_delay_etcs_approach_locking) ||
      TimeoutUnsupervisedTrainApproachExpired := bool(NOW >= StartUnsupervisedTrainApproach + time_delay_unsupervised_train_approach_locking) ||
      RouteIsSet := bool(Route_State = RouteState_SET) ||
      RouteIsLocked := bool(RouteMonitoring_State = ActiveInactive_ACTIVE) ||
      PassageLock := bool(RouteAutomaticRelease_PassageLock = ActiveInactive_ACTIVE) ||
      ApproachZoneOccupied := bool(approach_zone_Zone_State = OccupancyStatus_OCCUPIED);
      // Perform transition
      SELECT GraphState_root = STATE_RouteManualRelease_root_ROUTE_RELEASED THEN 
        IF RouteIsSet = TRUE THEN

          GraphState_root := STATE_RouteManualRelease_root_ETCS_APPROACH_LOCKING;
        IF RouteIsLocked = TRUE THEN
ManualReleaseRequested := ActiveInactive_INACTIVE;
      HoldApproachLocking := OpenCloseState_OPEN;
      ManualReleaseWithholdMovementAuthority := ActiveInactive_INACTIVE;
      ManualReleasePrevention := ActiveInactive_INACTIVE;
          GraphState_root_ETCS_APPROACH_LOCKING := STATE_RouteManualRelease_root_ETCS_APPROACH_LOCKING_MARKER_BOARD_OPEN
        ELSE
        ManualReleaseRequested := ActiveInactive_INACTIVE;
      HoldApproachLocking := OpenCloseState_CLOSED;
      ManualReleaseWithholdMovementAuthority := ActiveInactive_INACTIVE;
      ManualReleasePrevention := ActiveInactive_INACTIVE;
          GraphState_root_ETCS_APPROACH_LOCKING := STATE_RouteManualRelease_root_ETCS_APPROACH_LOCKING_ROUTE_SET
        END
        END
      END;
      SELECT GraphState_root = STATE_RouteManualRelease_root_ETCS_APPROACH_LOCKING THEN 
        IF not(RouteIsSet = TRUE) THEN
ManualReleaseRequested := ActiveInactive_INACTIVE;
      HoldApproachLocking := OpenCloseState_CLOSED;
      ManualReleaseWithholdMovementAuthority := ActiveInactive_INACTIVE;
      ManualReleasePrevention := ActiveInactive_INACTIVE;
          GraphState_root := STATE_RouteManualRelease_root_ROUTE_RELEASED;
          GraphState_root_ETCS_APPROACH_LOCKING := STATE_RouteManualRelease_root_ETCS_APPROACH_LOCKING___initial
        ELSE
SELECT GraphState_root_ETCS_APPROACH_LOCKING = STATE_RouteManualRelease_root_ETCS_APPROACH_LOCKING_MARKER_BOARD_OPEN THEN 
        IF not(ApproachTaken = TRUE) & not(ApproachZoneOccupied = TRUE) & CommandReleaseRoute = TRUE THEN
ManualReleaseRequested := ActiveInactive_INACTIVE;
      HoldApproachLocking := OpenCloseState_OPEN;
      ManualReleaseWithholdMovementAuthority := ActiveInactive_ACTIVE;
      ManualReleasePrevention := ActiveInactive_INACTIVE;
      StartWithholdMovementAuthority := NOW;
          GraphState_root_ETCS_APPROACH_LOCKING := STATE_RouteManualRelease_root_ETCS_APPROACH_LOCKING_WITHHOLD_MA
        ELSIF ApproachTaken = TRUE & ManualSignalClose = TRUE & CommandReleaseRoute = TRUE THEN
ManualReleaseRequested := ActiveInactive_INACTIVE;
      HoldApproachLocking := OpenCloseState_OPEN;
      ManualReleaseWithholdMovementAuthority := ActiveInactive_INACTIVE;
      ManualReleasePrevention := ActiveInactive_ACTIVE;
          GraphState_root_ETCS_APPROACH_LOCKING := STATE_RouteManualRelease_root_ETCS_APPROACH_LOCKING_TRAIN_APPROACHING
        ELSIF not(ApproachTaken = TRUE) & ApproachZoneOccupied = TRUE & ManualSignalClose = TRUE & CommandReleaseRoute = TRUE THEN
ManualReleaseRequested := ActiveInactive_INACTIVE;
      HoldApproachLocking := OpenCloseState_OPEN;
      ManualReleaseWithholdMovementAuthority := ActiveInactive_INACTIVE;
      ManualReleasePrevention := ActiveInactive_INACTIVE;
      StartUnsupervisedTrainApproach := NOW;
          GraphState_root_ETCS_APPROACH_LOCKING := STATE_RouteManualRelease_root_ETCS_APPROACH_LOCKING_TRAIN_APPROACHING_ZONE
        END
      END;
      SELECT GraphState_root_ETCS_APPROACH_LOCKING = STATE_RouteManualRelease_root_ETCS_APPROACH_LOCKING_ROUTE_SET THEN 
        IF RouteIsLocked = TRUE THEN
ManualReleaseRequested := ActiveInactive_INACTIVE;
      HoldApproachLocking := OpenCloseState_OPEN;
      ManualReleaseWithholdMovementAuthority := ActiveInactive_INACTIVE;
      ManualReleasePrevention := ActiveInactive_INACTIVE;
          GraphState_root_ETCS_APPROACH_LOCKING := STATE_RouteManualRelease_root_ETCS_APPROACH_LOCKING_MARKER_BOARD_OPEN
        ELSIF CommandReleaseRoute = TRUE THEN
ManualReleaseRequested := ActiveInactive_ACTIVE;
      HoldApproachLocking := OpenCloseState_CLOSED;
      ManualReleaseWithholdMovementAuthority := ActiveInactive_INACTIVE;
      ManualReleasePrevention := ActiveInactive_INACTIVE;
          GraphState_root_ETCS_APPROACH_LOCKING := STATE_RouteManualRelease_root_ETCS_APPROACH_LOCKING_MANUAL_RELEASE_ACTIVE
        END
      END;
      SELECT GraphState_root_ETCS_APPROACH_LOCKING = STATE_RouteManualRelease_root_ETCS_APPROACH_LOCKING_WITHHOLD_MA THEN 
        IF ApproachTaken = TRUE or ApproachZoneOccupied = TRUE THEN
ManualReleaseRequested := ActiveInactive_INACTIVE;
      HoldApproachLocking := OpenCloseState_OPEN;
      ManualReleaseWithholdMovementAuthority := ActiveInactive_INACTIVE;
      ManualReleasePrevention := ActiveInactive_INACTIVE;
          GraphState_root_ETCS_APPROACH_LOCKING := STATE_RouteManualRelease_root_ETCS_APPROACH_LOCKING_MARKER_BOARD_OPEN
        ELSIF TimeoutWithholdMovementAuthorityExpired = TRUE THEN
ManualReleaseRequested := ActiveInactive_ACTIVE;
      HoldApproachLocking := OpenCloseState_CLOSED;
      ManualReleaseWithholdMovementAuthority := ActiveInactive_INACTIVE;
      ManualReleasePrevention := ActiveInactive_INACTIVE;
          GraphState_root_ETCS_APPROACH_LOCKING := STATE_RouteManualRelease_root_ETCS_APPROACH_LOCKING_MANUAL_RELEASE_ACTIVE
        END
      END;
      SELECT GraphState_root_ETCS_APPROACH_LOCKING = STATE_RouteManualRelease_root_ETCS_APPROACH_LOCKING_TRAIN_APPROACHING THEN 
        IF not(ManualSignalClose = TRUE) THEN
ManualReleaseRequested := ActiveInactive_INACTIVE;
      HoldApproachLocking := OpenCloseState_OPEN;
      ManualReleaseWithholdMovementAuthority := ActiveInactive_INACTIVE;
      ManualReleasePrevention := ActiveInactive_INACTIVE;
          GraphState_root_ETCS_APPROACH_LOCKING := STATE_RouteManualRelease_root_ETCS_APPROACH_LOCKING_MARKER_BOARD_OPEN
        ELSIF not(ApproachTaken = TRUE) THEN
ManualReleaseRequested := ActiveInactive_INACTIVE;
      HoldApproachLocking := OpenCloseState_CLOSED;
      ManualReleaseWithholdMovementAuthority := ActiveInactive_INACTIVE;
      ManualReleasePrevention := ActiveInactive_ACTIVE;
          GraphState_root_ETCS_APPROACH_LOCKING := STATE_RouteManualRelease_root_ETCS_APPROACH_LOCKING_APPROACH_FREE
        END
      END;
      SELECT GraphState_root_ETCS_APPROACH_LOCKING = STATE_RouteManualRelease_root_ETCS_APPROACH_LOCKING_TRAIN_APPROACHING_ZONE THEN 
        IF not(ManualSignalClose = TRUE) THEN
ManualReleaseRequested := ActiveInactive_INACTIVE;
      HoldApproachLocking := OpenCloseState_OPEN;
      ManualReleaseWithholdMovementAuthority := ActiveInactive_INACTIVE;
      ManualReleasePrevention := ActiveInactive_INACTIVE;
          GraphState_root_ETCS_APPROACH_LOCKING := STATE_RouteManualRelease_root_ETCS_APPROACH_LOCKING_MARKER_BOARD_OPEN
        ELSIF TimeoutUnsupervisedTrainApproachExpired = TRUE THEN
ManualReleaseRequested := ActiveInactive_INACTIVE;
      HoldApproachLocking := OpenCloseState_OPEN;
      ManualReleaseWithholdMovementAuthority := ActiveInactive_INACTIVE;
      ManualReleasePrevention := ActiveInactive_INACTIVE;
          GraphState_root_ETCS_APPROACH_LOCKING := STATE_RouteManualRelease_root_ETCS_APPROACH_LOCKING_APPROACH_ZONE_TIMEOUT
        END
      END;
      SELECT GraphState_root_ETCS_APPROACH_LOCKING = STATE_RouteManualRelease_root_ETCS_APPROACH_LOCKING_APPROACH_FREE THEN 
        IF RouteIsLocked = TRUE THEN
ManualReleaseRequested := ActiveInactive_INACTIVE;
      HoldApproachLocking := OpenCloseState_OPEN;
      ManualReleaseWithholdMovementAuthority := ActiveInactive_INACTIVE;
      ManualReleasePrevention := ActiveInactive_INACTIVE;
          GraphState_root_ETCS_APPROACH_LOCKING := STATE_RouteManualRelease_root_ETCS_APPROACH_LOCKING_MARKER_BOARD_OPEN
        ELSIF not(ApproachTaken = TRUE) & CommandReleaseRoute = TRUE THEN
ManualReleaseRequested := ActiveInactive_ACTIVE;
      HoldApproachLocking := OpenCloseState_CLOSED;
      ManualReleaseWithholdMovementAuthority := ActiveInactive_INACTIVE;
      ManualReleasePrevention := ActiveInactive_INACTIVE;
          GraphState_root_ETCS_APPROACH_LOCKING := STATE_RouteManualRelease_root_ETCS_APPROACH_LOCKING_MANUAL_RELEASE_ACTIVE
        END
      END;
      SELECT GraphState_root_ETCS_APPROACH_LOCKING = STATE_RouteManualRelease_root_ETCS_APPROACH_LOCKING_APPROACH_ZONE_TIMEOUT THEN 
        IF RouteIsLocked = TRUE THEN
ManualReleaseRequested := ActiveInactive_INACTIVE;
      HoldApproachLocking := OpenCloseState_OPEN;
      ManualReleaseWithholdMovementAuthority := ActiveInactive_INACTIVE;
      ManualReleasePrevention := ActiveInactive_INACTIVE;
          GraphState_root_ETCS_APPROACH_LOCKING := STATE_RouteManualRelease_root_ETCS_APPROACH_LOCKING_MARKER_BOARD_OPEN
        ELSIF CommandReleaseRoute = TRUE THEN
ManualReleaseRequested := ActiveInactive_ACTIVE;
      HoldApproachLocking := OpenCloseState_CLOSED;
      ManualReleaseWithholdMovementAuthority := ActiveInactive_INACTIVE;
      ManualReleasePrevention := ActiveInactive_INACTIVE;
          GraphState_root_ETCS_APPROACH_LOCKING := STATE_RouteManualRelease_root_ETCS_APPROACH_LOCKING_MANUAL_RELEASE_ACTIVE
        END
      END
        END
      END
    END
END//MACHINE
