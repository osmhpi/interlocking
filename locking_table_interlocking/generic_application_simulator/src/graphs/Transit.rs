
    // Auto-generated Rust state machine for Transit

use web_sys;
use crate::{configuration_types::*, enums::*, eval_context::EvalContext, graph::Graph, triggerable::Triggerable, timestamp::timestamp};

#[derive(Clone)]
pub struct TransitStateMachine {
    __state: root_State,
    pub entity: EntitiesTransitItem,
    pub State: ActiveInactive,
    pub StartInitialization: timestamp,
    pub InitializationTimeoutExpired_value: bool,
    pub ZoneFree_value: bool,
    pub UpstreamTransitsIdle_value: bool,
    pub RequestedByRoute_value: bool,
}

impl TransitStateMachine {
    pub fn new(entity: EntitiesTransitItem) -> Self {
        Self {
            __state: root_State::__initial,
            entity,
            State: { ActiveInactive::INACTIVE },
            StartInitialization: { timestamp { milliseconds: None } }
,
            InitializationTimeoutExpired_value: false,
            ZoneFree_value: false,
            UpstreamTransitsIdle_value: false,
            RequestedByRoute_value: false
        }
    }

    pub fn InitializationTimeoutExpired(&self, ctx: &EvalContext, now: timestamp) -> bool {
        (match (Some(self.StartInitialization).unwrap_or(timestamp { milliseconds: None }).milliseconds, Some(1000)) {
    (Some(t), Some(d)) => Some(now.milliseconds.unwrap_or(0) >= t + d as u64),
    _ => None
  }).unwrap_or(false)
    }

    pub fn ZoneFree(&self, ctx: &EvalContext, now: timestamp) -> bool {
        (match (Some(ctx.Zone.get(&self.entity.underlying_zone).unwrap().State), Some(OccupancyStatus::VACANT)) {
    (Some(l), Some(r)) => Some(l == r),
    _ => None
  }).unwrap_or(false)
    }

    pub fn UpstreamTransitsIdle(&self, ctx: &EvalContext, now: timestamp) -> bool {
        (Some(self.entity.upstream_transits.iter().all(|name| ctx.Transit.get(name).unwrap().State == ActiveInactive::INACTIVE))).unwrap_or(false)
    }

    pub fn RequestedByRoute(&self, ctx: &EvalContext, now: timestamp) -> bool {
        (Some(self.entity.activating_routes.iter().any(|name| ctx.Route.get(name).unwrap().State == RouteState::SET))).unwrap_or(false)
    }
}

impl Graph for TransitStateMachine {
    fn evaluate_terms(&mut self, ctx: &EvalContext, now: timestamp) {
        self.InitializationTimeoutExpired_value = self.InitializationTimeoutExpired(ctx, now);
        self.ZoneFree_value = self.ZoneFree(ctx, now);
        self.UpstreamTransitsIdle_value = self.UpstreamTransitsIdle(ctx, now);
        self.RequestedByRoute_value = self.RequestedByRoute(ctx, now);
    }

    fn transition(&mut self, now: timestamp) {
        self.__state = self.transition_root(self.__state.clone(), now);
    }
}


#[derive(Debug, Clone, PartialEq, Eq)]
pub enum root_State {
    __initial,
    INITIALIZING,
    IDLE,
    ACTIVE
}

impl TransitStateMachine {
    fn transition_from_root___initial(&mut self, now: timestamp) -> root_State {
                    self.State = ActiveInactive::ACTIVE;
            self.StartInitialization = now;
                    web_sys::console::log_1(&format!("Transit({})=INITIALIZING", self.entity.name).into());
        return root_State::INITIALIZING;
    }

    fn transition_from_root_INITIALIZING(&mut self, now: timestamp) -> root_State {
        if self.InitializationTimeoutExpired_value && self.UpstreamTransitsIdle_value && self.ZoneFree_value && !(self.RequestedByRoute_value) {
            self.State = ActiveInactive::INACTIVE;
                        web_sys::console::log_1(&format!("Transit({})=IDLE", self.entity.name).into());
            return root_State::IDLE; }
        root_State::INITIALIZING
    }

    fn transition_from_root_IDLE(&mut self, now: timestamp) -> root_State {
        if self.RequestedByRoute_value {
            self.State = ActiveInactive::ACTIVE;
                        web_sys::console::log_1(&format!("Transit({})=ACTIVE", self.entity.name).into());
            return root_State::ACTIVE; }
        root_State::IDLE
    }

    fn transition_from_root_ACTIVE(&mut self, now: timestamp) -> root_State {
        if self.UpstreamTransitsIdle_value && self.ZoneFree_value && !(self.RequestedByRoute_value) {
            self.State = ActiveInactive::INACTIVE;
                        web_sys::console::log_1(&format!("Transit({})=IDLE", self.entity.name).into());
            return root_State::IDLE; }
        root_State::ACTIVE
    }

    fn transition_root(&mut self, state: root_State, now: timestamp) -> root_State {
        // Performs a state transition if possible
        match state {
            root_State::__initial => { self.transition_from_root___initial(now) }
            root_State::INITIALIZING => { self.transition_from_root_INITIALIZING(now) }
            root_State::IDLE => { self.transition_from_root_IDLE(now) }
            root_State::ACTIVE => { self.transition_from_root_ACTIVE(now) }
        }
    }
}
