
    // Auto-generated Rust state machine for RouteManualReleaseDispatch

use web_sys;
use crate::{configuration_types::*, enums::*, eval_context::EvalContext, graph::Graph, triggerable::Triggerable, timestamp::timestamp};

#[derive(Clone)]
pub struct RouteManualReleaseDispatchStateMachine {
    __state: root_State,
    pub entity: EntitiesIseItem,
    pub State: ActiveInactive,
    pub RouteReleaseRequested_value: bool,
}

impl RouteManualReleaseDispatchStateMachine {
    pub fn new(entity: EntitiesIseItem) -> Self {
        Self {
            __state: root_State::__initial,
            entity,
            State: { ActiveInactive::INACTIVE }
,
            RouteReleaseRequested_value: false
        }
    }

    pub fn RouteReleaseRequested(&self, ctx: &EvalContext, now: timestamp) -> bool {
        (Some(self.entity.is_start_of_route_admission_check.iter().any(|name| ctx.Route_SCICC.get(name).unwrap().MsgReleaseRoute == Triggerable::Triggered(true)))).unwrap_or(false)
    }
}

impl Graph for RouteManualReleaseDispatchStateMachine {
    fn evaluate_terms(&mut self, ctx: &EvalContext, now: timestamp) {
        self.RouteReleaseRequested_value = self.RouteReleaseRequested(ctx, now);
    }

    fn transition(&mut self, now: timestamp) {
        self.__state = self.transition_root(self.__state.clone(), now);
    }
}


#[derive(Debug, Clone, PartialEq, Eq)]
pub enum root_State {
    __initial,
    IDLE,
    ACTIVE
}

impl RouteManualReleaseDispatchStateMachine {
    fn transition_from_root___initial(&mut self, now: timestamp) -> root_State {
                    self.State = ActiveInactive::INACTIVE;
                    web_sys::console::log_1(&format!("RouteManualReleaseDispatch({})=IDLE", self.entity.name).into());
        return root_State::IDLE;
    }

    fn transition_from_root_IDLE(&mut self, now: timestamp) -> root_State {
        if self.RouteReleaseRequested_value {
            self.State = ActiveInactive::ACTIVE;
                        web_sys::console::log_1(&format!("RouteManualReleaseDispatch({})=ACTIVE", self.entity.name).into());
            return root_State::ACTIVE; }
        root_State::IDLE
    }

    fn transition_from_root_ACTIVE(&mut self, now: timestamp) -> root_State {
        if !(self.RouteReleaseRequested_value) {
            self.State = ActiveInactive::INACTIVE;
                        web_sys::console::log_1(&format!("RouteManualReleaseDispatch({})=IDLE", self.entity.name).into());
            return root_State::IDLE; }
        root_State::ACTIVE
    }

    fn transition_root(&mut self, state: root_State, now: timestamp) -> root_State {
        // Performs a state transition if possible
        match state {
            root_State::__initial => { self.transition_from_root___initial(now) }
            root_State::IDLE => { self.transition_from_root_IDLE(now) }
            root_State::ACTIVE => { self.transition_from_root_ACTIVE(now) }
        }
    }
}
