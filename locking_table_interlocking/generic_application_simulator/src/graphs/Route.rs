
    // Auto-generated Rust state machine for Route

use web_sys;
use crate::{configuration_types::*, enums::*, eval_context::EvalContext, graph::Graph, triggerable::Triggerable, timestamp::timestamp};

#[derive(Clone)]
pub struct RouteStateMachine {
    __state: root_State,
    pub entity: EntitiesRouteItem,
    pub State: RouteState,
    pub RouteRequested_value: bool,
    pub PointsAvailable_value: bool,
    pub NoIncompatibleRoutes_value: bool,
    pub AutomaticReleaseEffective_value: bool,
    pub ManualReleaseEffective_value: bool,
}

impl RouteStateMachine {
    pub fn new(entity: EntitiesRouteItem) -> Self {
        Self {
            __state: root_State::__initial,
            entity,
            State: { RouteState::RELEASED }
,
            RouteRequested_value: false,
            PointsAvailable_value: false,
            NoIncompatibleRoutes_value: true,
            AutomaticReleaseEffective_value: false,
            ManualReleaseEffective_value: false
        }
    }

    pub fn RouteRequested(&self, ctx: &EvalContext, now: timestamp) -> bool {
        (match (Some(ctx.Route_SCICC.get(&self.entity.name).unwrap().MsgRequestRoute), Some(Triggerable::Triggered(true))) {
    (Some(l), Some(r)) => Some(l == r),
    _ => None
  }).unwrap_or(false)
    }

    pub fn PointsAvailable(&self, ctx: &EvalContext, now: timestamp) -> bool {
        (match (Some(self.entity.request_points_right.iter().all(|name| ctx.Point.get(name).unwrap().State == PointState::RIGHT)), Some(self.entity.request_points_left.iter().all(|name| ctx.Point.get(name).unwrap().State == PointState::LEFT))) {
    (Some(a), Some(b)) => Some(a && b),
    _ => None
  }).unwrap_or(false)
    }

    pub fn NoIncompatibleRoutes(&self, ctx: &EvalContext, now: timestamp) -> bool {
        true
    }

    pub fn AutomaticReleaseEffective(&self, ctx: &EvalContext, now: timestamp) -> bool {
        (match (Some(ctx.RouteAutomaticRelease.get(&self.entity.name).unwrap().State), Some(ActiveInactive::ACTIVE)) {
    (Some(l), Some(r)) => Some(l == r),
    _ => None
  }).unwrap_or(false)
    }

    pub fn ManualReleaseEffective(&self, ctx: &EvalContext, now: timestamp) -> bool {
        (match (Some(ctx.RouteManualRelease.get(&self.entity.name).unwrap().ManualReleaseRequested), Some(ActiveInactive::ACTIVE)) {
    (Some(l), Some(r)) => Some(l == r),
    _ => None
  }).unwrap_or(false)
    }
}

impl Graph for RouteStateMachine {
    fn evaluate_terms(&mut self, ctx: &EvalContext, now: timestamp) {
        self.RouteRequested_value = self.RouteRequested(ctx, now);
        self.PointsAvailable_value = self.PointsAvailable(ctx, now);
        self.NoIncompatibleRoutes_value = self.NoIncompatibleRoutes(ctx, now);
        self.AutomaticReleaseEffective_value = self.AutomaticReleaseEffective(ctx, now);
        self.ManualReleaseEffective_value = self.ManualReleaseEffective(ctx, now);
    }

    fn transition(&mut self, now: timestamp) {
        self.__state = self.transition_root(self.__state.clone(), now);
    }
}


#[derive(Debug, Clone, PartialEq, Eq)]
pub enum root_State {
    __initial,
    RELEASED,
    SET,
    PREPARING
}

impl RouteStateMachine {
    fn transition_from_root___initial(&mut self, now: timestamp) -> root_State {
                    self.State = RouteState::RELEASED;
                    web_sys::console::log_1(&format!("Route({})=RELEASED", self.entity.name).into());
        return root_State::RELEASED;
    }

    fn transition_from_root_RELEASED(&mut self, now: timestamp) -> root_State {
        if self.RouteRequested_value {

            return self.transition_from_root_c(now); }
        root_State::RELEASED
    }

    fn transition_from_root_SET(&mut self, now: timestamp) -> root_State {
        if self.AutomaticReleaseEffective_value || self.ManualReleaseEffective_value {
            self.State = RouteState::RELEASED;
                        web_sys::console::log_1(&format!("Route({})=RELEASED", self.entity.name).into());
            return root_State::RELEASED; }
        root_State::SET
    }

    fn transition_from_root_PREPARING(&mut self, now: timestamp) -> root_State {
        if self.PointsAvailable_value && self.NoIncompatibleRoutes_value {
            self.State = RouteState::SET;
                        web_sys::console::log_1(&format!("Route({})=SET", self.entity.name).into());
            return root_State::SET; }
        root_State::PREPARING
    }

    fn transition_from_root_c(&mut self, now: timestamp) -> root_State {
        if self.PointsAvailable_value && self.NoIncompatibleRoutes_value {
            self.State = RouteState::SET;
                        web_sys::console::log_1(&format!("Route({})=SET", self.entity.name).into());
            return root_State::SET; }
                    self.State = RouteState::PREPARING;
                    web_sys::console::log_1(&format!("Route({})=PREPARING", self.entity.name).into());
        return root_State::PREPARING;
    }

    fn transition_root(&mut self, state: root_State, now: timestamp) -> root_State {
        // Performs a state transition if possible
        match state {
            root_State::__initial => { self.transition_from_root___initial(now) }
            root_State::RELEASED => { self.transition_from_root_RELEASED(now) }
            root_State::SET => { self.transition_from_root_SET(now) }
            root_State::PREPARING => { self.transition_from_root_PREPARING(now) }
        }
    }
}
