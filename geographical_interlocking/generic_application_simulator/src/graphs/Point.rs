
    // Auto-generated Rust state machine for Point

use web_sys;
use crate::{configuration_types::*, enums::*, eval_context::EvalContext, graph::Graph, triggerable::Triggerable, timestamp::timestamp};

#[derive(Clone)]
pub struct PointStateMachine {
    __state: root_State,
    pub entity: EntitiesPointItem,
    pub State: PointState,
    pub PointDetectedLeft_value: bool,
    pub PointDetectedRight_value: bool,
    pub RouteAuthorizedMoveLeft_value: bool,
    pub RouteAuthorizedMoveRight_value: bool,
    pub PointLockedLeft_value: bool,
    pub PointLockedRight_value: bool,
}

impl PointStateMachine {
    pub fn new(entity: EntitiesPointItem) -> Self {
        Self {
            __state: root_State::__initial,
            entity,
            State: { PointState::UNDETERMINED }
,
            PointDetectedLeft_value: false,
            PointDetectedRight_value: false,
            RouteAuthorizedMoveLeft_value: false,
            RouteAuthorizedMoveRight_value: false,
            PointLockedLeft_value: false,
            PointLockedRight_value: false
        }
    }

    pub fn PointDetectedLeft(&self, ctx: &EvalContext, now: timestamp) -> bool {
        (match (Some(ctx.Point_SCIP.get(&self.entity.name).unwrap().DetectedEndPosition), Some(Triggerable::Triggered(EulynxEndPosition::LEFT))) {
    (Some(l), Some(r)) => Some(l == r),
    _ => None
  }).unwrap_or(false)
    }

    pub fn PointDetectedRight(&self, ctx: &EvalContext, now: timestamp) -> bool {
        (match (Some(ctx.Point_SCIP.get(&self.entity.name).unwrap().DetectedEndPosition), Some(Triggerable::Triggered(EulynxEndPosition::RIGHT))) {
    (Some(l), Some(r)) => Some(l == r),
    _ => None
  }).unwrap_or(false)
    }

    pub fn RouteAuthorizedMoveLeft(&self, ctx: &EvalContext, now: timestamp) -> bool {
        (Some(self.entity.locked_left_by_transits.iter().any(|name| ctx.Route.get(name).unwrap().State == RouteState::PREPARING))).unwrap_or(false)
    }

    pub fn RouteAuthorizedMoveRight(&self, ctx: &EvalContext, now: timestamp) -> bool {
        (Some(self.entity.locked_right_by_transits.iter().any(|name| ctx.Route.get(name).unwrap().State == RouteState::PREPARING))).unwrap_or(false)
    }

    pub fn PointLockedLeft(&self, ctx: &EvalContext, now: timestamp) -> bool {
        (match (Some(ctx.PointLockLeft.get(&self.entity.name).unwrap().State), Some(ActiveInactive::ACTIVE)) {
    (Some(l), Some(r)) => Some(l == r),
    _ => None
  }).unwrap_or(false)
    }

    pub fn PointLockedRight(&self, ctx: &EvalContext, now: timestamp) -> bool {
        (match (Some(ctx.PointLockRight.get(&self.entity.name).unwrap().State), Some(ActiveInactive::ACTIVE)) {
    (Some(l), Some(r)) => Some(l == r),
    _ => None
  }).unwrap_or(false)
    }
}

impl Graph for PointStateMachine {
    fn evaluate_terms(&mut self, ctx: &EvalContext, now: timestamp) {
        self.PointDetectedLeft_value = self.PointDetectedLeft(ctx, now);
        self.PointDetectedRight_value = self.PointDetectedRight(ctx, now);
        self.RouteAuthorizedMoveLeft_value = self.RouteAuthorizedMoveLeft(ctx, now);
        self.RouteAuthorizedMoveRight_value = self.RouteAuthorizedMoveRight(ctx, now);
        self.PointLockedLeft_value = self.PointLockedLeft(ctx, now);
        self.PointLockedRight_value = self.PointLockedRight(ctx, now);
    }

    fn transition(&mut self, now: timestamp) {
        self.__state = self.transition_root(self.__state.clone(), now);
    }
}


#[derive(Debug, Clone, PartialEq, Eq)]
pub enum root_State {
    __initial,
    LEFT,
    RIGHT,
    UNDETERMINED
}

impl PointStateMachine {
    fn transition_from_root___initial(&mut self, now: timestamp) -> root_State {
        if self.PointDetectedLeft_value {
            self.State = PointState::LEFT;
                        web_sys::console::log_1(&format!("Point({})=LEFT", self.entity.name).into());
            return root_State::LEFT; }
        if self.PointDetectedRight_value {
            self.State = PointState::RIGHT;
                        web_sys::console::log_1(&format!("Point({})=RIGHT", self.entity.name).into());
            return root_State::RIGHT; }
                    self.State = PointState::UNDETERMINED;
                    web_sys::console::log_1(&format!("Point({})=UNDETERMINED", self.entity.name).into());
        return root_State::UNDETERMINED;
    }

    fn transition_from_root_LEFT(&mut self, now: timestamp) -> root_State {
        if self.RouteAuthorizedMoveRight_value && !((self.RouteAuthorizedMoveLeft_value || self.PointLockedLeft_value)) {
            self.State = PointState::RIGHT;
                        web_sys::console::log_1(&format!("Point({})=RIGHT", self.entity.name).into());
            return root_State::RIGHT; }
        root_State::LEFT
    }

    fn transition_from_root_RIGHT(&mut self, now: timestamp) -> root_State {
        if self.RouteAuthorizedMoveLeft_value && !((self.RouteAuthorizedMoveRight_value || self.PointLockedRight_value)) {
            self.State = PointState::LEFT;
                        web_sys::console::log_1(&format!("Point({})=LEFT", self.entity.name).into());
            return root_State::LEFT; }
        root_State::RIGHT
    }

    fn transition_from_root_UNDETERMINED(&mut self, now: timestamp) -> root_State {
        if self.RouteAuthorizedMoveLeft_value && !(self.RouteAuthorizedMoveRight_value) {
            self.State = PointState::LEFT;
                        web_sys::console::log_1(&format!("Point({})=LEFT", self.entity.name).into());
            return root_State::LEFT; }
        if self.RouteAuthorizedMoveRight_value && !(self.RouteAuthorizedMoveLeft_value) {
            self.State = PointState::RIGHT;
                        web_sys::console::log_1(&format!("Point({})=RIGHT", self.entity.name).into());
            return root_State::RIGHT; }
        root_State::UNDETERMINED
    }

    fn transition_root(&mut self, state: root_State, now: timestamp) -> root_State {
        // Performs a state transition if possible
        match state {
            root_State::__initial => { self.transition_from_root___initial(now) }
            root_State::LEFT => { self.transition_from_root_LEFT(now) }
            root_State::RIGHT => { self.transition_from_root_RIGHT(now) }
            root_State::UNDETERMINED => { self.transition_from_root_UNDETERMINED(now) }
        }
    }
}
