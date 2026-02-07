
    // Auto-generated Rust state machine for RouteManualRelease

use web_sys;
use crate::{configuration_types::*, enums::*, eval_context::EvalContext, graph::Graph, triggerable::Triggerable, timestamp::timestamp};

#[derive(Clone)]
pub struct RouteManualReleaseStateMachine {
    __state: root_State,
    pub entity: EntitiesTransitItem,
    pub ManualReleaseRequested: ActiveInactive,
    pub HoldApproachLocking: OpenCloseState,
    pub ManualReleaseWithholdMovementAuthority: ActiveInactive,
    pub ManualReleasePrevention: ActiveInactive,
    pub StartUnsupervisedTrainApproach: timestamp,
    pub StartWithholdMovementAuthority: timestamp,
    pub CommandReleaseRoute_value: bool,
    pub CommandUnsetManualReleaseRestriction_value: bool,
    pub ApproachTaken_value: bool,
    pub ManualSignalClose_value: bool,
    pub TimeoutWithholdMovementAuthorityExpired_value: bool,
    pub TimeoutUnsupervisedTrainApproachExpired_value: bool,
    pub ReleasePrevention_value: bool,
    pub RouteIsSet_value: bool,
    pub RouteIsLocked_value: bool,
    pub PassageLock_value: bool,
    pub ApproachZoneOccupied_value: bool,
}

impl RouteManualReleaseStateMachine {
    pub fn new(entity: EntitiesTransitItem) -> Self {
        Self {
            __state: root_State::__initial,
            entity,
            ManualReleaseRequested: { ActiveInactive::INACTIVE },
            HoldApproachLocking: { OpenCloseState::CLOSED },
            ManualReleaseWithholdMovementAuthority: { ActiveInactive::INACTIVE },
            ManualReleasePrevention: { ActiveInactive::INACTIVE },
            StartUnsupervisedTrainApproach: { timestamp { milliseconds: None } },
            StartWithholdMovementAuthority: { timestamp { milliseconds: None } }
,
            CommandReleaseRoute_value: false,
            CommandUnsetManualReleaseRestriction_value: false,
            ApproachTaken_value: true,
            ManualSignalClose_value: false,
            TimeoutWithholdMovementAuthorityExpired_value: false,
            TimeoutUnsupervisedTrainApproachExpired_value: false,
            ReleasePrevention_value: false,
            RouteIsSet_value: false,
            RouteIsLocked_value: false,
            PassageLock_value: false,
            ApproachZoneOccupied_value: true
        }
    }

    pub fn CommandReleaseRoute(&self, ctx: &EvalContext, now: timestamp) -> bool {
        (match (Some(ctx.RouteManualReleaseDispatch.get(&self.entity.ise).unwrap().State), Some(ActiveInactive::ACTIVE)) {
    (Some(l), Some(r)) => Some(l == r),
    _ => None
  }).unwrap_or(false)
    }

    pub fn CommandUnsetManualReleaseRestriction(&self, ctx: &EvalContext, now: timestamp) -> bool {
        false
    }

    pub fn ApproachTaken(&self, ctx: &EvalContext, now: timestamp) -> bool {
        (match (self.entity.signal.as_ref().map(|x| ctx.Signal_SCIRBC.get(x).unwrap().ApproachLockingActive), Some(Triggerable::Triggered(true))) {
    (Some(l), Some(r)) => Some(l == r),
    _ => None
  }).unwrap_or(true)
    }

    pub fn ManualSignalClose(&self, ctx: &EvalContext, now: timestamp) -> bool {
        false
    }

    pub fn TimeoutWithholdMovementAuthorityExpired(&self, ctx: &EvalContext, now: timestamp) -> bool {
        (match (Some(self.StartWithholdMovementAuthority).unwrap_or(timestamp { milliseconds: None }).milliseconds, self.entity.time_delay_etcs_approach_locking) {
    (Some(t), Some(d)) => Some(now.milliseconds.unwrap_or(0) >= t + d as u64),
    _ => None
  }).unwrap_or(false)
    }

    pub fn TimeoutUnsupervisedTrainApproachExpired(&self, ctx: &EvalContext, now: timestamp) -> bool {
        (match (Some(self.StartUnsupervisedTrainApproach).unwrap_or(timestamp { milliseconds: None }).milliseconds, self.entity.time_delay_unsupervised_train_approach_locking) {
    (Some(t), Some(d)) => Some(now.milliseconds.unwrap_or(0) >= t + d as u64),
    _ => None
  }).unwrap_or(false)
    }

    pub fn ReleasePrevention(&self, ctx: &EvalContext, now: timestamp) -> bool {
        false
    }

    pub fn RouteIsSet(&self, ctx: &EvalContext, now: timestamp) -> bool {
        (match (Some(ctx.Route.get(&self.entity.name).unwrap().State), Some(RouteState::SET)) {
    (Some(l), Some(r)) => Some(l == r),
    _ => None
  }).unwrap_or(false)
    }

    pub fn RouteIsLocked(&self, ctx: &EvalContext, now: timestamp) -> bool {
        (match (Some(ctx.RouteMonitoring.get(&self.entity.name).unwrap().State), Some(ActiveInactive::ACTIVE)) {
    (Some(l), Some(r)) => Some(l == r),
    _ => None
  }).unwrap_or(false)
    }

    pub fn PassageLock(&self, ctx: &EvalContext, now: timestamp) -> bool {
        false
    }

    pub fn ApproachZoneOccupied(&self, ctx: &EvalContext, now: timestamp) -> bool {
        (match (self.entity.approach_zone.as_ref().map(|x| ctx.Zone.get(x).unwrap().State), Some(OccupancyStatus::OCCUPIED)) {
    (Some(l), Some(r)) => Some(l == r),
    _ => None
  }).unwrap_or(true)
    }
}

impl Graph for RouteManualReleaseStateMachine {
    fn evaluate_terms(&mut self, ctx: &EvalContext, now: timestamp) {
        self.CommandReleaseRoute_value = self.CommandReleaseRoute(ctx, now);
        self.CommandUnsetManualReleaseRestriction_value = self.CommandUnsetManualReleaseRestriction(ctx, now);
        self.ApproachTaken_value = self.ApproachTaken(ctx, now);
        self.ManualSignalClose_value = self.ManualSignalClose(ctx, now);
        self.TimeoutWithholdMovementAuthorityExpired_value = self.TimeoutWithholdMovementAuthorityExpired(ctx, now);
        self.TimeoutUnsupervisedTrainApproachExpired_value = self.TimeoutUnsupervisedTrainApproachExpired(ctx, now);
        self.ReleasePrevention_value = self.ReleasePrevention(ctx, now);
        self.RouteIsSet_value = self.RouteIsSet(ctx, now);
        self.RouteIsLocked_value = self.RouteIsLocked(ctx, now);
        self.PassageLock_value = self.PassageLock(ctx, now);
        self.ApproachZoneOccupied_value = self.ApproachZoneOccupied(ctx, now);
    }

    fn transition(&mut self, now: timestamp) {
        self.__state = self.transition_root(self.__state.clone(), now);
    }
}


#[derive(Debug, Clone, PartialEq, Eq)]
pub enum root_State {
    __initial,
    ETCS_APPROACH_LOCKING(root_ETCS_APPROACH_LOCKING_State),
    ROUTE_RELEASED
}

impl RouteManualReleaseStateMachine {
    fn transition_from_root___initial(&mut self, now: timestamp) -> root_State {
                    self.ManualReleaseRequested = ActiveInactive::INACTIVE;
            self.HoldApproachLocking = OpenCloseState::CLOSED;
            self.ManualReleaseWithholdMovementAuthority = ActiveInactive::INACTIVE;
            self.ManualReleasePrevention = ActiveInactive::INACTIVE;
                    web_sys::console::log_1(&format!("RouteManualRelease({})=ROUTE_RELEASED", self.entity.name).into());
        return root_State::ROUTE_RELEASED;
    }

    fn transition_from_root_ETCS_APPROACH_LOCKING(&mut self, s: root_ETCS_APPROACH_LOCKING_State, now: timestamp) -> root_State {
        if !(self.RouteIsSet_value) {
            self.ManualReleaseRequested = ActiveInactive::INACTIVE;
            self.HoldApproachLocking = OpenCloseState::CLOSED;
            self.ManualReleaseWithholdMovementAuthority = ActiveInactive::INACTIVE;
            self.ManualReleasePrevention = ActiveInactive::INACTIVE;
                        web_sys::console::log_1(&format!("RouteManualRelease({})=ROUTE_RELEASED", self.entity.name).into());
            return root_State::ROUTE_RELEASED; }
        root_State::ETCS_APPROACH_LOCKING(self.transition_root_ETCS_APPROACH_LOCKING(s.clone(), now))
    }

    fn transition_from_root_ROUTE_RELEASED(&mut self, now: timestamp) -> root_State {
        if self.RouteIsSet_value {

                        web_sys::console::log_1(&format!("RouteManualRelease({})=ETCS_APPROACH_LOCKING", self.entity.name).into());
            return root_State::ETCS_APPROACH_LOCKING(self.transition_from_root_ETCS_APPROACH_LOCKING___initial(now)); }
        root_State::ROUTE_RELEASED
    }

    fn transition_root(&mut self, state: root_State, now: timestamp) -> root_State {
        // Performs a state transition if possible
        match state {
            root_State::__initial => { self.transition_from_root___initial(now) }
            root_State::ROUTE_RELEASED => { self.transition_from_root_ROUTE_RELEASED(now) }
            root_State::ETCS_APPROACH_LOCKING(s) => { self.transition_from_root_ETCS_APPROACH_LOCKING(s, now) }
        }
    }
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub enum root_ETCS_APPROACH_LOCKING_State {
    __initial,
    ETCS_APPROACH_LOCKING,
    ROUTE_RELEASED,
    MARKER_BOARD_OPEN,
    ROUTE_SET,
    MANUAL_RELEASE_ACTIVE,
    WITHHOLD_MA,
    TRAIN_APPROACHING,
    TRAIN_APPROACHING_ZONE,
    APPROACH_FREE,
    APPROACH_ZONE_TIMEOUT
}

impl RouteManualReleaseStateMachine {
    fn transition_from_root_ETCS_APPROACH_LOCKING___initial(&mut self, now: timestamp) -> root_ETCS_APPROACH_LOCKING_State {
        if self.RouteIsLocked_value {
            self.ManualReleaseRequested = ActiveInactive::INACTIVE;
            self.HoldApproachLocking = OpenCloseState::OPEN;
            self.ManualReleaseWithholdMovementAuthority = ActiveInactive::INACTIVE;
            self.ManualReleasePrevention = ActiveInactive::INACTIVE;
                        web_sys::console::log_1(&format!("RouteManualRelease({})=MARKER_BOARD_OPEN", self.entity.name).into());
            return root_ETCS_APPROACH_LOCKING_State::MARKER_BOARD_OPEN; }
                    self.ManualReleaseRequested = ActiveInactive::INACTIVE;
            self.HoldApproachLocking = OpenCloseState::CLOSED;
            self.ManualReleaseWithholdMovementAuthority = ActiveInactive::INACTIVE;
            self.ManualReleasePrevention = ActiveInactive::INACTIVE;
                    web_sys::console::log_1(&format!("RouteManualRelease({})=ROUTE_SET", self.entity.name).into());
        return root_ETCS_APPROACH_LOCKING_State::ROUTE_SET;
    }

    fn transition_from_root_ETCS_APPROACH_LOCKING_ETCS_APPROACH_LOCKING(&mut self, now: timestamp) -> root_ETCS_APPROACH_LOCKING_State {
        root_ETCS_APPROACH_LOCKING_State::ETCS_APPROACH_LOCKING
    }

    fn transition_from_root_ETCS_APPROACH_LOCKING_ROUTE_RELEASED(&mut self, now: timestamp) -> root_ETCS_APPROACH_LOCKING_State {
        root_ETCS_APPROACH_LOCKING_State::ROUTE_RELEASED
    }

    fn transition_from_root_ETCS_APPROACH_LOCKING_MARKER_BOARD_OPEN(&mut self, now: timestamp) -> root_ETCS_APPROACH_LOCKING_State {
        if self.CommandReleaseRoute_value {
            self.ManualReleaseRequested = ActiveInactive::INACTIVE;
            self.HoldApproachLocking = OpenCloseState::OPEN;
            self.ManualReleaseWithholdMovementAuthority = ActiveInactive::ACTIVE;
            self.ManualReleasePrevention = ActiveInactive::INACTIVE;
            self.StartWithholdMovementAuthority = now;
                        web_sys::console::log_1(&format!("RouteManualRelease({})=WITHHOLD_MA", self.entity.name).into());
            return root_ETCS_APPROACH_LOCKING_State::WITHHOLD_MA; }
        if self.ApproachTaken_value && self.ManualSignalClose_value && ((self.CommandUnsetManualReleaseRestriction_value && self.ReleasePrevention_value) || (self.CommandReleaseRoute_value && !(self.ReleasePrevention_value))) {
            self.ManualReleaseRequested = ActiveInactive::INACTIVE;
            self.HoldApproachLocking = OpenCloseState::OPEN;
            self.ManualReleaseWithholdMovementAuthority = ActiveInactive::INACTIVE;
            self.ManualReleasePrevention = ActiveInactive::ACTIVE;
                        web_sys::console::log_1(&format!("RouteManualRelease({})=TRAIN_APPROACHING", self.entity.name).into());
            return root_ETCS_APPROACH_LOCKING_State::TRAIN_APPROACHING; }
        if !(self.ApproachTaken_value) && self.ApproachZoneOccupied_value && self.ManualSignalClose_value && ((self.CommandUnsetManualReleaseRestriction_value && self.ReleasePrevention_value) || (self.CommandReleaseRoute_value && !(self.ReleasePrevention_value))) {
            self.ManualReleaseRequested = ActiveInactive::INACTIVE;
            self.HoldApproachLocking = OpenCloseState::OPEN;
            self.ManualReleaseWithholdMovementAuthority = ActiveInactive::INACTIVE;
            self.ManualReleasePrevention = ActiveInactive::INACTIVE;
            self.StartUnsupervisedTrainApproach = now;
                        web_sys::console::log_1(&format!("RouteManualRelease({})=TRAIN_APPROACHING_ZONE", self.entity.name).into());
            return root_ETCS_APPROACH_LOCKING_State::TRAIN_APPROACHING_ZONE; }
        if !(self.ApproachTaken_value) && self.PassageLock_value && self.CommandReleaseRoute_value && self.ReleasePrevention_value {
            self.ManualReleaseRequested = ActiveInactive::ACTIVE;
            self.HoldApproachLocking = OpenCloseState::CLOSED;
            self.ManualReleaseWithholdMovementAuthority = ActiveInactive::INACTIVE;
            self.ManualReleasePrevention = ActiveInactive::INACTIVE;
                        web_sys::console::log_1(&format!("RouteManualRelease({})=MANUAL_RELEASE_ACTIVE", self.entity.name).into());
            return root_ETCS_APPROACH_LOCKING_State::MANUAL_RELEASE_ACTIVE; }
        root_ETCS_APPROACH_LOCKING_State::MARKER_BOARD_OPEN
    }

    fn transition_from_root_ETCS_APPROACH_LOCKING_ROUTE_SET(&mut self, now: timestamp) -> root_ETCS_APPROACH_LOCKING_State {
        if self.RouteIsLocked_value {
            self.ManualReleaseRequested = ActiveInactive::INACTIVE;
            self.HoldApproachLocking = OpenCloseState::OPEN;
            self.ManualReleaseWithholdMovementAuthority = ActiveInactive::INACTIVE;
            self.ManualReleasePrevention = ActiveInactive::INACTIVE;
                        web_sys::console::log_1(&format!("RouteManualRelease({})=MARKER_BOARD_OPEN", self.entity.name).into());
            return root_ETCS_APPROACH_LOCKING_State::MARKER_BOARD_OPEN; }
        if (self.CommandUnsetManualReleaseRestriction_value && self.ReleasePrevention_value) || (self.CommandReleaseRoute_value && !(self.ReleasePrevention_value)) {
            self.ManualReleaseRequested = ActiveInactive::ACTIVE;
            self.HoldApproachLocking = OpenCloseState::CLOSED;
            self.ManualReleaseWithholdMovementAuthority = ActiveInactive::INACTIVE;
            self.ManualReleasePrevention = ActiveInactive::INACTIVE;
                        web_sys::console::log_1(&format!("RouteManualRelease({})=MANUAL_RELEASE_ACTIVE", self.entity.name).into());
            return root_ETCS_APPROACH_LOCKING_State::MANUAL_RELEASE_ACTIVE; }
        root_ETCS_APPROACH_LOCKING_State::ROUTE_SET
    }

    fn transition_from_root_ETCS_APPROACH_LOCKING_MANUAL_RELEASE_ACTIVE(&mut self, now: timestamp) -> root_ETCS_APPROACH_LOCKING_State {
        root_ETCS_APPROACH_LOCKING_State::MANUAL_RELEASE_ACTIVE
    }

    fn transition_from_root_ETCS_APPROACH_LOCKING_WITHHOLD_MA(&mut self, now: timestamp) -> root_ETCS_APPROACH_LOCKING_State {
        if self.ApproachTaken_value || self.ApproachZoneOccupied_value {
            self.ManualReleaseRequested = ActiveInactive::INACTIVE;
            self.HoldApproachLocking = OpenCloseState::OPEN;
            self.ManualReleaseWithholdMovementAuthority = ActiveInactive::INACTIVE;
            self.ManualReleasePrevention = ActiveInactive::INACTIVE;
                        web_sys::console::log_1(&format!("RouteManualRelease({})=MARKER_BOARD_OPEN", self.entity.name).into());
            return root_ETCS_APPROACH_LOCKING_State::MARKER_BOARD_OPEN; }
        if self.TimeoutWithholdMovementAuthorityExpired_value {
            self.ManualReleaseRequested = ActiveInactive::ACTIVE;
            self.HoldApproachLocking = OpenCloseState::CLOSED;
            self.ManualReleaseWithholdMovementAuthority = ActiveInactive::INACTIVE;
            self.ManualReleasePrevention = ActiveInactive::INACTIVE;
                        web_sys::console::log_1(&format!("RouteManualRelease({})=MANUAL_RELEASE_ACTIVE", self.entity.name).into());
            return root_ETCS_APPROACH_LOCKING_State::MANUAL_RELEASE_ACTIVE; }
        root_ETCS_APPROACH_LOCKING_State::WITHHOLD_MA
    }

    fn transition_from_root_ETCS_APPROACH_LOCKING_TRAIN_APPROACHING(&mut self, now: timestamp) -> root_ETCS_APPROACH_LOCKING_State {
        if !(self.ManualSignalClose_value) {
            self.ManualReleaseRequested = ActiveInactive::INACTIVE;
            self.HoldApproachLocking = OpenCloseState::OPEN;
            self.ManualReleaseWithholdMovementAuthority = ActiveInactive::INACTIVE;
            self.ManualReleasePrevention = ActiveInactive::INACTIVE;
                        web_sys::console::log_1(&format!("RouteManualRelease({})=MARKER_BOARD_OPEN", self.entity.name).into());
            return root_ETCS_APPROACH_LOCKING_State::MARKER_BOARD_OPEN; }
        if !(self.ApproachTaken_value) {
            self.ManualReleaseRequested = ActiveInactive::INACTIVE;
            self.HoldApproachLocking = OpenCloseState::CLOSED;
            self.ManualReleaseWithholdMovementAuthority = ActiveInactive::INACTIVE;
            self.ManualReleasePrevention = ActiveInactive::ACTIVE;
                        web_sys::console::log_1(&format!("RouteManualRelease({})=APPROACH_FREE", self.entity.name).into());
            return root_ETCS_APPROACH_LOCKING_State::APPROACH_FREE; }
        root_ETCS_APPROACH_LOCKING_State::TRAIN_APPROACHING
    }

    fn transition_from_root_ETCS_APPROACH_LOCKING_TRAIN_APPROACHING_ZONE(&mut self, now: timestamp) -> root_ETCS_APPROACH_LOCKING_State {
        if !(self.ManualSignalClose_value) {
            self.ManualReleaseRequested = ActiveInactive::INACTIVE;
            self.HoldApproachLocking = OpenCloseState::OPEN;
            self.ManualReleaseWithholdMovementAuthority = ActiveInactive::INACTIVE;
            self.ManualReleasePrevention = ActiveInactive::INACTIVE;
                        web_sys::console::log_1(&format!("RouteManualRelease({})=MARKER_BOARD_OPEN", self.entity.name).into());
            return root_ETCS_APPROACH_LOCKING_State::MARKER_BOARD_OPEN; }
        if self.TimeoutUnsupervisedTrainApproachExpired_value {
            self.ManualReleaseRequested = ActiveInactive::INACTIVE;
            self.HoldApproachLocking = OpenCloseState::OPEN;
            self.ManualReleaseWithholdMovementAuthority = ActiveInactive::INACTIVE;
            self.ManualReleasePrevention = ActiveInactive::INACTIVE;
                        web_sys::console::log_1(&format!("RouteManualRelease({})=APPROACH_ZONE_TIMEOUT", self.entity.name).into());
            return root_ETCS_APPROACH_LOCKING_State::APPROACH_ZONE_TIMEOUT; }
        root_ETCS_APPROACH_LOCKING_State::TRAIN_APPROACHING_ZONE
    }

    fn transition_from_root_ETCS_APPROACH_LOCKING_APPROACH_FREE(&mut self, now: timestamp) -> root_ETCS_APPROACH_LOCKING_State {
        if self.RouteIsLocked_value {
            self.ManualReleaseRequested = ActiveInactive::INACTIVE;
            self.HoldApproachLocking = OpenCloseState::OPEN;
            self.ManualReleaseWithholdMovementAuthority = ActiveInactive::INACTIVE;
            self.ManualReleasePrevention = ActiveInactive::INACTIVE;
                        web_sys::console::log_1(&format!("RouteManualRelease({})=MARKER_BOARD_OPEN", self.entity.name).into());
            return root_ETCS_APPROACH_LOCKING_State::MARKER_BOARD_OPEN; }
        if !(self.ApproachTaken_value) && ((self.CommandUnsetManualReleaseRestriction_value && self.ReleasePrevention_value) || (self.CommandReleaseRoute_value && !(self.ReleasePrevention_value))) {
            self.ManualReleaseRequested = ActiveInactive::ACTIVE;
            self.HoldApproachLocking = OpenCloseState::CLOSED;
            self.ManualReleaseWithholdMovementAuthority = ActiveInactive::INACTIVE;
            self.ManualReleasePrevention = ActiveInactive::INACTIVE;
                        web_sys::console::log_1(&format!("RouteManualRelease({})=MANUAL_RELEASE_ACTIVE", self.entity.name).into());
            return root_ETCS_APPROACH_LOCKING_State::MANUAL_RELEASE_ACTIVE; }
        root_ETCS_APPROACH_LOCKING_State::APPROACH_FREE
    }

    fn transition_from_root_ETCS_APPROACH_LOCKING_APPROACH_ZONE_TIMEOUT(&mut self, now: timestamp) -> root_ETCS_APPROACH_LOCKING_State {
        if self.RouteIsLocked_value {
            self.ManualReleaseRequested = ActiveInactive::INACTIVE;
            self.HoldApproachLocking = OpenCloseState::OPEN;
            self.ManualReleaseWithholdMovementAuthority = ActiveInactive::INACTIVE;
            self.ManualReleasePrevention = ActiveInactive::INACTIVE;
                        web_sys::console::log_1(&format!("RouteManualRelease({})=MARKER_BOARD_OPEN", self.entity.name).into());
            return root_ETCS_APPROACH_LOCKING_State::MARKER_BOARD_OPEN; }
        if (self.CommandUnsetManualReleaseRestriction_value && self.ReleasePrevention_value) || (self.CommandReleaseRoute_value && !(self.ReleasePrevention_value)) {
            self.ManualReleaseRequested = ActiveInactive::ACTIVE;
            self.HoldApproachLocking = OpenCloseState::CLOSED;
            self.ManualReleaseWithholdMovementAuthority = ActiveInactive::INACTIVE;
            self.ManualReleasePrevention = ActiveInactive::INACTIVE;
                        web_sys::console::log_1(&format!("RouteManualRelease({})=MANUAL_RELEASE_ACTIVE", self.entity.name).into());
            return root_ETCS_APPROACH_LOCKING_State::MANUAL_RELEASE_ACTIVE; }
        root_ETCS_APPROACH_LOCKING_State::APPROACH_ZONE_TIMEOUT
    }

    fn transition_root_ETCS_APPROACH_LOCKING(&mut self, state: root_ETCS_APPROACH_LOCKING_State, now: timestamp) -> root_ETCS_APPROACH_LOCKING_State {
        // Performs a state transition if possible
        match state {
            root_ETCS_APPROACH_LOCKING_State::__initial => { self.transition_from_root_ETCS_APPROACH_LOCKING___initial(now) }
            root_ETCS_APPROACH_LOCKING_State::ETCS_APPROACH_LOCKING => { self.transition_from_root_ETCS_APPROACH_LOCKING_ETCS_APPROACH_LOCKING(now) }
            root_ETCS_APPROACH_LOCKING_State::ROUTE_RELEASED => { self.transition_from_root_ETCS_APPROACH_LOCKING_ROUTE_RELEASED(now) }
            root_ETCS_APPROACH_LOCKING_State::MARKER_BOARD_OPEN => { self.transition_from_root_ETCS_APPROACH_LOCKING_MARKER_BOARD_OPEN(now) }
            root_ETCS_APPROACH_LOCKING_State::ROUTE_SET => { self.transition_from_root_ETCS_APPROACH_LOCKING_ROUTE_SET(now) }
            root_ETCS_APPROACH_LOCKING_State::MANUAL_RELEASE_ACTIVE => { self.transition_from_root_ETCS_APPROACH_LOCKING_MANUAL_RELEASE_ACTIVE(now) }
            root_ETCS_APPROACH_LOCKING_State::WITHHOLD_MA => { self.transition_from_root_ETCS_APPROACH_LOCKING_WITHHOLD_MA(now) }
            root_ETCS_APPROACH_LOCKING_State::TRAIN_APPROACHING => { self.transition_from_root_ETCS_APPROACH_LOCKING_TRAIN_APPROACHING(now) }
            root_ETCS_APPROACH_LOCKING_State::TRAIN_APPROACHING_ZONE => { self.transition_from_root_ETCS_APPROACH_LOCKING_TRAIN_APPROACHING_ZONE(now) }
            root_ETCS_APPROACH_LOCKING_State::APPROACH_FREE => { self.transition_from_root_ETCS_APPROACH_LOCKING_APPROACH_FREE(now) }
            root_ETCS_APPROACH_LOCKING_State::APPROACH_ZONE_TIMEOUT => { self.transition_from_root_ETCS_APPROACH_LOCKING_APPROACH_ZONE_TIMEOUT(now) }
        }
    }
}
