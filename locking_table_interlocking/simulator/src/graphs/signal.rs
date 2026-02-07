
    // Auto-generated Rust state machine for Signal

use web_sys;
use crate::{configuration_types::*, enums::*, eval_context::EvalContext, graph::Graph, triggerable::Triggerable, timestamp::timestamp};

#[derive(Clone)]
pub struct SignalStateMachine {
    __state: root_State,
    pub entity: EntitiesSignalItem,
    pub State: ActiveInactive,
    pub RouteIsSet_value: bool,
}

impl SignalStateMachine {
    pub fn new(entity: EntitiesSignalItem) -> Self {
        Self {
            __state: root_State::__initial,
            entity,
            State: { ActiveInactive::INACTIVE }
,
            RouteIsSet_value: false
        }
    }

    pub fn RouteIsSet(&self, ctx: &EvalContext, now: timestamp) -> bool {
        (Some(self.entity.routes_starting_here.iter().any(|name| ctx.Route.get(name).unwrap().State == RouteState::SET))).unwrap_or(false)
    }
}

impl Graph for SignalStateMachine {
    fn evaluate_terms(&mut self, ctx: &EvalContext, now: timestamp) {
        self.RouteIsSet_value = self.RouteIsSet(ctx, now);
    }

    fn transition(&mut self, now: timestamp) {
        self.__state = self.transition_root(self.__state.clone(), now);
    }
}


#[derive(Debug, Clone, PartialEq, Eq)]
pub enum root_State {
    __initial,
    SIGNAL_NOT_START,
    SIGNAL_IS_START
}

impl SignalStateMachine {
    fn transition_from_root___initial(&mut self, now: timestamp) -> root_State {
                    self.State = ActiveInactive::INACTIVE;
                    web_sys::console::log_1(&format!("Signal({})=SIGNAL_NOT_START", self.entity.name).into());
        return root_State::SIGNAL_NOT_START;
    }

    fn transition_from_root_SIGNAL_NOT_START(&mut self, now: timestamp) -> root_State {
        if self.RouteIsSet_value {
            self.State = ActiveInactive::ACTIVE;
                        web_sys::console::log_1(&format!("Signal({})=SIGNAL_IS_START", self.entity.name).into());
            return root_State::SIGNAL_IS_START; }
        root_State::SIGNAL_NOT_START
    }

    fn transition_from_root_SIGNAL_IS_START(&mut self, now: timestamp) -> root_State {
        if !(self.RouteIsSet_value) {
            self.State = ActiveInactive::INACTIVE;
                        web_sys::console::log_1(&format!("Signal({})=SIGNAL_NOT_START", self.entity.name).into());
            return root_State::SIGNAL_NOT_START; }
        root_State::SIGNAL_IS_START
    }

    fn transition_root(&mut self, state: root_State, now: timestamp) -> root_State {
        // Performs a state transition if possible
        match state {
            root_State::__initial => { self.transition_from_root___initial(now) }
            root_State::SIGNAL_NOT_START => { self.transition_from_root_SIGNAL_NOT_START(now) }
            root_State::SIGNAL_IS_START => { self.transition_from_root_SIGNAL_IS_START(now) }
        }
    }
}
