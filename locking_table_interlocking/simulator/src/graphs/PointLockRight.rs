
    // Auto-generated Rust state machine for PointLockRight

use web_sys;
use crate::{configuration_types::*, enums::*, eval_context::EvalContext, graph::Graph, triggerable::Triggerable, timestamp::timestamp};

#[derive(Clone)]
pub struct PointLockRightStateMachine {
    __state: root_State,
    pub entity: EntitiesPointItem,
    pub State: ActiveInactive,
    pub PointInOppositePosition_value: bool,
    pub ZoneRequestsLock_value: bool,
    pub PointIsMoving_value: bool,
    pub TransitRequestsLock_value: bool,
}

impl PointLockRightStateMachine {
    pub fn new(entity: EntitiesPointItem) -> Self {
        Self {
            __state: root_State::__initial,
            entity,
            State: { ActiveInactive::INACTIVE }
,
            PointInOppositePosition_value: false,
            ZoneRequestsLock_value: false,
            PointIsMoving_value: false,
            TransitRequestsLock_value: false
        }
    }

    pub fn PointInOppositePosition(&self, ctx: &EvalContext, now: timestamp) -> bool {
        (match (Some(ctx.Point_SCIP.get(&self.entity.name).unwrap().DetectedEndPosition), Some(Triggerable::Triggered(EulynxEndPosition::LEFT))) {
    (Some(l), Some(r)) => Some(l == r),
    _ => None
  }).unwrap_or(false)
    }

    pub fn ZoneRequestsLock(&self, ctx: &EvalContext, now: timestamp) -> bool {
        (Some(self.entity.locked_right_by_zones.iter().any(|name| ctx.Zone.get(name).unwrap().State == OccupancyStatus::OCCUPIED))).unwrap_or(false)
    }

    pub fn PointIsMoving(&self, ctx: &EvalContext, now: timestamp) -> bool {
        false
    }

    pub fn TransitRequestsLock(&self, ctx: &EvalContext, now: timestamp) -> bool {
        (Some(self.entity.locked_right_by_transits.iter().any(|name| ctx.Transit.get(name).unwrap().State == ActiveInactive::ACTIVE))).unwrap_or(false)
    }
}

impl Graph for PointLockRightStateMachine {
    fn evaluate_terms(&mut self, ctx: &EvalContext, now: timestamp) {
        self.PointInOppositePosition_value = self.PointInOppositePosition(ctx, now);
        self.ZoneRequestsLock_value = self.ZoneRequestsLock(ctx, now);
        self.PointIsMoving_value = self.PointIsMoving(ctx, now);
        self.TransitRequestsLock_value = self.TransitRequestsLock(ctx, now);
    }

    fn transition(&mut self, now: timestamp) {
        self.__state = self.transition_root(self.__state.clone(), now);
    }
}


#[derive(Debug, Clone, PartialEq, Eq)]
pub enum root_State {
    __initial,
    NOT_LOCKED,
    LOCKED
}

impl PointLockRightStateMachine {
    fn transition_from_root___initial(&mut self, now: timestamp) -> root_State {
        if self.PointInOppositePosition_value {
            self.State = ActiveInactive::INACTIVE;
                        web_sys::console::log_1(&format!("PointLockRight({})=NOT_LOCKED", self.entity.name).into());
            return root_State::NOT_LOCKED; }
                    self.State = ActiveInactive::ACTIVE;
                    web_sys::console::log_1(&format!("PointLockRight({})=LOCKED", self.entity.name).into());
        return root_State::LOCKED;
    }

    fn transition_from_root_NOT_LOCKED(&mut self, now: timestamp) -> root_State {
        if self.ZoneRequestsLock_value || self.PointIsMoving_value || self.TransitRequestsLock_value {
            self.State = ActiveInactive::ACTIVE;
                        web_sys::console::log_1(&format!("PointLockRight({})=LOCKED", self.entity.name).into());
            return root_State::LOCKED; }
        root_State::NOT_LOCKED
    }

    fn transition_from_root_LOCKED(&mut self, now: timestamp) -> root_State {
        if !(self.ZoneRequestsLock_value) && !(self.PointIsMoving_value) && !(self.TransitRequestsLock_value) {
            self.State = ActiveInactive::INACTIVE;
                        web_sys::console::log_1(&format!("PointLockRight({})=NOT_LOCKED", self.entity.name).into());
            return root_State::NOT_LOCKED; }
        root_State::LOCKED
    }

    fn transition_root(&mut self, state: root_State, now: timestamp) -> root_State {
        // Performs a state transition if possible
        match state {
            root_State::__initial => { self.transition_from_root___initial(now) }
            root_State::NOT_LOCKED => { self.transition_from_root_NOT_LOCKED(now) }
            root_State::LOCKED => { self.transition_from_root_LOCKED(now) }
        }
    }
}
