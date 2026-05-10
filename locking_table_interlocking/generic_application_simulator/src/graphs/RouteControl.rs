
    // Auto-generated Rust state machine for RouteControl

use web_sys;
use crate::{configuration_types::*, enums::*, eval_context::EvalContext, graph::Graph, triggerable::Triggerable, timestamp::timestamp};

#[derive(Clone)]
pub struct RouteControlStateMachine {
    __state: root_State,
    pub entity: EntitiesRouteItem,
    pub State: OpenCloseState,
    pub RouteMonitored_value: bool,
}

impl RouteControlStateMachine {
    pub fn new(entity: EntitiesRouteItem) -> Self {
        Self {
            __state: root_State::__initial,
            entity,
            State: { OpenCloseState::CLOSED }
,
            RouteMonitored_value: false
        }
    }

    pub fn RouteMonitored(&self, ctx: &EvalContext, now: timestamp) -> bool {
        (match (Some(ctx.RouteMonitoring.get(&self.entity.name).unwrap().State), Some(ActiveInactive::ACTIVE)) {
    (Some(l), Some(r)) => Some(l == r),
    _ => None
  }).unwrap_or(false)
    }
}

impl Graph for RouteControlStateMachine {
    fn evaluate_terms(&mut self, ctx: &EvalContext, now: timestamp) {
        self.RouteMonitored_value = self.RouteMonitored(ctx, now);
    }

    fn transition(&mut self, now: timestamp) {
        self.__state = self.transition_root(self.__state.clone(), now);
    }
}


#[derive(Debug, Clone, PartialEq, Eq)]
pub enum root_State {
    __initial,
    CLOSED,
    OPEN
}

impl RouteControlStateMachine {
    fn transition_from_root___initial(&mut self, now: timestamp) -> root_State {
                    self.State = OpenCloseState::CLOSED;
                    web_sys::console::log_1(&format!("RouteControl({})=CLOSED", self.entity.name).into());
        return root_State::CLOSED;
    }

    fn transition_from_root_CLOSED(&mut self, now: timestamp) -> root_State {
        if self.RouteMonitored_value {
            self.State = OpenCloseState::OPEN;
                        web_sys::console::log_1(&format!("RouteControl({})=OPEN", self.entity.name).into());
            return root_State::OPEN; }
        root_State::CLOSED
    }

    fn transition_from_root_OPEN(&mut self, now: timestamp) -> root_State {
        if !(self.RouteMonitored_value) {
            self.State = OpenCloseState::CLOSED;
                        web_sys::console::log_1(&format!("RouteControl({})=CLOSED", self.entity.name).into());
            return root_State::CLOSED; }
        root_State::OPEN
    }

    fn transition_root(&mut self, state: root_State, now: timestamp) -> root_State {
        // Performs a state transition if possible
        match state {
            root_State::__initial => { self.transition_from_root___initial(now) }
            root_State::CLOSED => { self.transition_from_root_CLOSED(now) }
            root_State::OPEN => { self.transition_from_root_OPEN(now) }
        }
    }
}
