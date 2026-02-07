
    // Auto-generated Rust state machine for RouteCheck

use web_sys;
use crate::{configuration_types::*, enums::*, eval_context::EvalContext, graph::Graph, triggerable::Triggerable, timestamp::timestamp};

#[derive(Clone)]
pub struct RouteCheckStateMachine {
    __state: root_State,
    pub entity: EntitiesRouteItem,
    pub Top: ActiveInactive,
    pub State: ActiveInactive,
    pub RouteRequested_value: bool,
    pub IsTop_value: bool,
}

impl RouteCheckStateMachine {
    pub fn new(entity: EntitiesRouteItem) -> Self {
        Self {
            __state: root_State::__initial,
            entity,
            Top: { ActiveInactive::ACTIVE },
            State: { ActiveInactive::INACTIVE }
,
            RouteRequested_value: false,
            IsTop_value: false
        }
    }

    pub fn RouteRequested(&self, ctx: &EvalContext, now: timestamp) -> bool {
        (match (Some(ctx.Route_SCICC.get(&self.entity.name).unwrap().MsgRequestRoute), Some(Triggerable::Triggered(true))) {
    (Some(l), Some(r)) => Some(l == r),
    _ => None
  }).unwrap_or(false)
    }

    pub fn IsTop(&self, ctx: &EvalContext, now: timestamp) -> bool {
        (Some(self.entity.all_routes.iter().all(|name| ctx.RouteCheck.get(name).unwrap().Top == ActiveInactive::ACTIVE))).unwrap_or(false)
    }
}

impl Graph for RouteCheckStateMachine {
    fn evaluate_terms(&mut self, ctx: &EvalContext, now: timestamp) {
        self.RouteRequested_value = self.RouteRequested(ctx, now);
        self.IsTop_value = self.IsTop(ctx, now);
    }

    fn transition(&mut self, now: timestamp) {
        self.__state = self.transition_root(self.__state.clone(), now);
    }
}


#[derive(Debug, Clone, PartialEq, Eq)]
pub enum root_State {
    __initial,
    INACTIVE,
    WAITING,
    CHECKING
}

impl RouteCheckStateMachine {
    fn transition_from_root___initial(&mut self, now: timestamp) -> root_State {
                    self.Top = ActiveInactive::ACTIVE;
            self.State = ActiveInactive::INACTIVE;
                    web_sys::console::log_1(&format!("RouteCheck({})=INACTIVE", self.entity.name).into());
        return root_State::INACTIVE;
    }

    fn transition_from_root_INACTIVE(&mut self, now: timestamp) -> root_State {
        if self.RouteRequested_value {

            return self.transition_from_root_c(now); }
        root_State::INACTIVE
    }

    fn transition_from_root_WAITING(&mut self, now: timestamp) -> root_State {
        if self.IsTop_value {
            self.Top = ActiveInactive::INACTIVE;
            self.State = ActiveInactive::ACTIVE;
                        web_sys::console::log_1(&format!("RouteCheck({})=CHECKING", self.entity.name).into());
            return root_State::CHECKING; }
        root_State::WAITING
    }

    fn transition_from_root_CHECKING(&mut self, now: timestamp) -> root_State {
                    self.Top = ActiveInactive::ACTIVE;
            self.State = ActiveInactive::INACTIVE;
                    web_sys::console::log_1(&format!("RouteCheck({})=INACTIVE", self.entity.name).into());
        return root_State::INACTIVE;
        root_State::CHECKING
    }

    fn transition_from_root_c(&mut self, now: timestamp) -> root_State {
        if self.IsTop_value {
            self.Top = ActiveInactive::INACTIVE;
            self.State = ActiveInactive::ACTIVE;
                        web_sys::console::log_1(&format!("RouteCheck({})=CHECKING", self.entity.name).into());
            return root_State::CHECKING; }
                    self.Top = ActiveInactive::ACTIVE;
            self.State = ActiveInactive::INACTIVE;
                    web_sys::console::log_1(&format!("RouteCheck({})=WAITING", self.entity.name).into());
        return root_State::WAITING;
    }

    fn transition_root(&mut self, state: root_State, now: timestamp) -> root_State {
        // Performs a state transition if possible
        match state {
            root_State::__initial => { self.transition_from_root___initial(now) }
            root_State::INACTIVE => { self.transition_from_root_INACTIVE(now) }
            root_State::WAITING => { self.transition_from_root_WAITING(now) }
            root_State::CHECKING => { self.transition_from_root_CHECKING(now) }
        }
    }
}
