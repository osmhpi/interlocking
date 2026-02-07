
    // Auto-generated Rust state machine for SignalControl

use web_sys;
use crate::{configuration_types::*, enums::*, eval_context::EvalContext, graph::Graph, triggerable::Triggerable, timestamp::timestamp};

#[derive(Clone)]
pub struct SignalControlStateMachine {
    __state: root_State,
    pub entity: EntitiesSignalItem,
    pub State: OpenCloseState,
    pub RouteOpening_value: bool,
}

impl SignalControlStateMachine {
    pub fn new(entity: EntitiesSignalItem) -> Self {
        Self {
            __state: root_State::__initial,
            entity,
            State: { OpenCloseState::CLOSED }
,
            RouteOpening_value: false
        }
    }

    pub fn RouteOpening(&self, ctx: &EvalContext, now: timestamp) -> bool {
        (Some(self.entity.routes_starting_here.iter().any(|name| ctx.RouteControl.get(name).unwrap().State == OpenCloseState::OPEN))).unwrap_or(false)
    }
}

impl Graph for SignalControlStateMachine {
    fn evaluate_terms(&mut self, ctx: &EvalContext, now: timestamp) {
        self.RouteOpening_value = self.RouteOpening(ctx, now);
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

impl SignalControlStateMachine {
    fn transition_from_root___initial(&mut self, now: timestamp) -> root_State {
                    self.State = OpenCloseState::CLOSED;
                    web_sys::console::log_1(&format!("SignalControl({})=CLOSED", self.entity.name).into());
        return root_State::CLOSED;
    }

    fn transition_from_root_CLOSED(&mut self, now: timestamp) -> root_State {
        if self.RouteOpening_value {
            self.State = OpenCloseState::OPEN;
                        web_sys::console::log_1(&format!("SignalControl({})=OPEN", self.entity.name).into());
            return root_State::OPEN; }
        root_State::CLOSED
    }

    fn transition_from_root_OPEN(&mut self, now: timestamp) -> root_State {
        if !(self.RouteOpening_value) {
            self.State = OpenCloseState::CLOSED;
                        web_sys::console::log_1(&format!("SignalControl({})=CLOSED", self.entity.name).into());
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
