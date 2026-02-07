
    // Auto-generated Rust state machine for LinkRTL

use web_sys;
use crate::{configuration_types::*, enums::*, eval_context::EvalContext, graph::Graph, triggerable::Triggerable, timestamp::timestamp};

#[derive(Clone)]
pub struct LinkRTLStateMachine {
    __state: root_State,
    pub entity: EntitiesLinkItem,
    pub State: RouteSearch,
    pub IsChecking_value: bool,
    pub IsCheckingOpposite_value: bool,
    pub IsAdmit_value: bool,
    pub IsAdmitOpposite_value: bool,
    pub IsRouteSet_value: bool,
    pub IsRouteSetDownstream_value: bool,
}

impl LinkRTLStateMachine {
    pub fn new(entity: EntitiesLinkItem) -> Self {
        Self {
            __state: root_State::__initial,
            entity,
            State: { RouteSearch::INACTIVE }
,
            IsChecking_value: false,
            IsCheckingOpposite_value: false,
            IsAdmit_value: false,
            IsAdmitOpposite_value: false,
            IsRouteSet_value: false,
            IsRouteSetDownstream_value: false
        }
    }

    pub fn IsChecking(&self, ctx: &EvalContext, now: timestamp) -> bool {
        (match (match (match (match (Some(self.entity.ise_right_port_a.iter().any(|name| ctx.RouteFindingSearch.get(name).unwrap().Check == RouteChecking::CHECK_FROM_B)), Some(self.entity.ise_right_port_a.iter().any(|name| ctx.RouteFindingSearch.get(name).unwrap().Check == RouteChecking::CHECK_FROM_C))) {
    (Some(a), Some(b)) => Some(a || b),
    _ => None
  }, Some(self.entity.ise_right_port_b.iter().any(|name| ctx.RouteFindingSearch.get(name).unwrap().Check == RouteChecking::CHECK_FROM_A))) {
    (Some(a), Some(b)) => Some(a || b),
    _ => None
  }, Some(self.entity.ise_right_port_c.iter().any(|name| ctx.RouteFindingSearch.get(name).unwrap().Check == RouteChecking::CHECK_FROM_A))) {
    (Some(a), Some(b)) => Some(a || b),
    _ => None
  }, Some(self.entity.ise_right_port_b.iter().any(|name| ctx.RouteFindingSearch.get(name).unwrap().Check == RouteChecking::CHECK_START))) {
    (Some(a), Some(b)) => Some(a || b),
    _ => None
  }).unwrap_or(false)
    }

    pub fn IsCheckingOpposite(&self, ctx: &EvalContext, now: timestamp) -> bool {
        (match (match (match (match (Some(self.entity.ise_left_port_a.iter().any(|name| ctx.RouteFindingSearch.get(name).unwrap().Check == RouteChecking::CHECK_FROM_B)), Some(self.entity.ise_left_port_a.iter().any(|name| ctx.RouteFindingSearch.get(name).unwrap().Check == RouteChecking::CHECK_FROM_C))) {
    (Some(a), Some(b)) => Some(a || b),
    _ => None
  }, Some(self.entity.ise_left_port_b.iter().any(|name| ctx.RouteFindingSearch.get(name).unwrap().Check == RouteChecking::CHECK_FROM_A))) {
    (Some(a), Some(b)) => Some(a || b),
    _ => None
  }, Some(self.entity.ise_left_port_c.iter().any(|name| ctx.RouteFindingSearch.get(name).unwrap().Check == RouteChecking::CHECK_FROM_A))) {
    (Some(a), Some(b)) => Some(a || b),
    _ => None
  }, Some(self.entity.ise_left_port_b.iter().any(|name| ctx.RouteFindingSearch.get(name).unwrap().Check == RouteChecking::CHECK_START))) {
    (Some(a), Some(b)) => Some(a || b),
    _ => None
  }).unwrap_or(false)
    }

    pub fn IsAdmit(&self, ctx: &EvalContext, now: timestamp) -> bool {
        (match (match (match (match (Some(self.entity.ise_right_port_a.iter().any(|name| ctx.RouteFindingResponse.get(name).unwrap().Admit == RouteAdmission::ADMIT_TO_B)), Some(self.entity.ise_right_port_a.iter().any(|name| ctx.RouteFindingResponse.get(name).unwrap().Admit == RouteAdmission::ADMIT_TO_C))) {
    (Some(a), Some(b)) => Some(a || b),
    _ => None
  }, Some(self.entity.ise_right_port_a.iter().any(|name| ctx.RouteFindingResponse.get(name).unwrap().Admit == RouteAdmission::ADMIT_END))) {
    (Some(a), Some(b)) => Some(a || b),
    _ => None
  }, Some(self.entity.ise_right_port_b.iter().any(|name| ctx.RouteFindingResponse.get(name).unwrap().Admit == RouteAdmission::ADMIT_TO_A))) {
    (Some(a), Some(b)) => Some(a || b),
    _ => None
  }, Some(self.entity.ise_right_port_c.iter().any(|name| ctx.RouteFindingResponse.get(name).unwrap().Admit == RouteAdmission::ADMIT_TO_A))) {
    (Some(a), Some(b)) => Some(a || b),
    _ => None
  }).unwrap_or(false)
    }

    pub fn IsAdmitOpposite(&self, ctx: &EvalContext, now: timestamp) -> bool {
        (match (match (match (match (Some(self.entity.ise_left_port_a.iter().any(|name| ctx.RouteFindingResponse.get(name).unwrap().Admit == RouteAdmission::ADMIT_TO_B)), Some(self.entity.ise_left_port_a.iter().any(|name| ctx.RouteFindingResponse.get(name).unwrap().Admit == RouteAdmission::ADMIT_TO_C))) {
    (Some(a), Some(b)) => Some(a || b),
    _ => None
  }, Some(self.entity.ise_left_port_a.iter().any(|name| ctx.RouteFindingResponse.get(name).unwrap().Admit == RouteAdmission::ADMIT_END))) {
    (Some(a), Some(b)) => Some(a || b),
    _ => None
  }, Some(self.entity.ise_left_port_b.iter().any(|name| ctx.RouteFindingResponse.get(name).unwrap().Admit == RouteAdmission::ADMIT_TO_A))) {
    (Some(a), Some(b)) => Some(a || b),
    _ => None
  }, Some(self.entity.ise_left_port_c.iter().any(|name| ctx.RouteFindingResponse.get(name).unwrap().Admit == RouteAdmission::ADMIT_TO_A))) {
    (Some(a), Some(b)) => Some(a || b),
    _ => None
  }).unwrap_or(false)
    }

    pub fn IsRouteSet(&self, ctx: &EvalContext, now: timestamp) -> bool {
        (match (match (match (match (Some(self.entity.ise_right_port_a.iter().any(|name| ctx.RouteFindingSearch.get(name).unwrap().Check == RouteChecking::ROUTE_SET_FROM_B)), Some(self.entity.ise_right_port_a.iter().any(|name| ctx.RouteFindingSearch.get(name).unwrap().Check == RouteChecking::ROUTE_SET_FROM_C))) {
    (Some(a), Some(b)) => Some(a || b),
    _ => None
  }, Some(self.entity.ise_right_port_b.iter().any(|name| ctx.RouteFindingSearch.get(name).unwrap().Check == RouteChecking::ROUTE_SET_FROM_A))) {
    (Some(a), Some(b)) => Some(a || b),
    _ => None
  }, Some(self.entity.ise_right_port_c.iter().any(|name| ctx.RouteFindingSearch.get(name).unwrap().Check == RouteChecking::ROUTE_SET_FROM_A))) {
    (Some(a), Some(b)) => Some(a || b),
    _ => None
  }, Some(self.entity.ise_right_port_b.iter().any(|name| ctx.RouteFindingSearch.get(name).unwrap().Check == RouteChecking::ROUTE_SET_FROM_START))) {
    (Some(a), Some(b)) => Some(a || b),
    _ => None
  }).unwrap_or(false)
    }

    pub fn IsRouteSetDownstream(&self, ctx: &EvalContext, now: timestamp) -> bool {
        (match (match (match (match (Some(self.entity.ise_right_port_a.iter().any(|name| ctx.RouteFindingResponse.get(name).unwrap().Admit == RouteAdmission::ROUTE_TO_B)), Some(self.entity.ise_right_port_a.iter().any(|name| ctx.RouteFindingResponse.get(name).unwrap().Admit == RouteAdmission::ROUTE_TO_C))) {
    (Some(a), Some(b)) => Some(a || b),
    _ => None
  }, Some(self.entity.ise_right_port_a.iter().any(|name| ctx.RouteFindingResponse.get(name).unwrap().Admit == RouteAdmission::ROUTE_END))) {
    (Some(a), Some(b)) => Some(a || b),
    _ => None
  }, Some(self.entity.ise_right_port_b.iter().any(|name| ctx.RouteFindingResponse.get(name).unwrap().Admit == RouteAdmission::ROUTE_TO_A))) {
    (Some(a), Some(b)) => Some(a || b),
    _ => None
  }, Some(self.entity.ise_right_port_c.iter().any(|name| ctx.RouteFindingResponse.get(name).unwrap().Admit == RouteAdmission::ROUTE_TO_A))) {
    (Some(a), Some(b)) => Some(a || b),
    _ => None
  }).unwrap_or(false)
    }
}

impl Graph for LinkRTLStateMachine {
    fn evaluate_terms(&mut self, ctx: &EvalContext, now: timestamp) {
        self.IsChecking_value = self.IsChecking(ctx, now);
        self.IsCheckingOpposite_value = self.IsCheckingOpposite(ctx, now);
        self.IsAdmit_value = self.IsAdmit(ctx, now);
        self.IsAdmitOpposite_value = self.IsAdmitOpposite(ctx, now);
        self.IsRouteSet_value = self.IsRouteSet(ctx, now);
        self.IsRouteSetDownstream_value = self.IsRouteSetDownstream(ctx, now);
    }

    fn transition(&mut self, now: timestamp) {
        self.__state = self.transition_root(self.__state.clone(), now);
    }
}


#[derive(Debug, Clone, PartialEq, Eq)]
pub enum root_State {
    __initial,
    IDLE,
    CHECKING,
    ADMIT,
    ROUTE_SET,
    ROUTE_MONITORED
}

impl LinkRTLStateMachine {
    fn transition_from_root___initial(&mut self, now: timestamp) -> root_State {
                    self.State = RouteSearch::INACTIVE;
                    web_sys::console::log_1(&format!("LinkRTL({})=IDLE", self.entity.name).into());
        return root_State::IDLE;
    }

    fn transition_from_root_IDLE(&mut self, now: timestamp) -> root_State {
        if self.IsChecking_value && !(self.IsCheckingOpposite_value) {
            self.State = RouteSearch::SEARCH;
                        web_sys::console::log_1(&format!("LinkRTL({})=CHECKING", self.entity.name).into());
            return root_State::CHECKING; }
        if self.IsAdmit_value {
            self.State = RouteSearch::RESPONSE;
                        web_sys::console::log_1(&format!("LinkRTL({})=ADMIT", self.entity.name).into());
            return root_State::ADMIT; }
        root_State::IDLE
    }

    fn transition_from_root_CHECKING(&mut self, now: timestamp) -> root_State {
        if self.IsRouteSet_value && self.IsAdmitOpposite_value {
            self.State = RouteSearch::ROUTE_SET;
                        web_sys::console::log_1(&format!("LinkRTL({})=ROUTE_SET", self.entity.name).into());
            return root_State::ROUTE_SET; }
        if !(self.IsChecking_value) {
            self.State = RouteSearch::INACTIVE;
                        web_sys::console::log_1(&format!("LinkRTL({})=IDLE", self.entity.name).into());
            return root_State::IDLE; }
        root_State::CHECKING
    }

    fn transition_from_root_ADMIT(&mut self, now: timestamp) -> root_State {
        if self.IsRouteSetDownstream_value {
            self.State = RouteSearch::ROUTE_MONITORED;
                        web_sys::console::log_1(&format!("LinkRTL({})=ROUTE_MONITORED", self.entity.name).into());
            return root_State::ROUTE_MONITORED; }
        if !(self.IsAdmit_value) {
            self.State = RouteSearch::INACTIVE;
                        web_sys::console::log_1(&format!("LinkRTL({})=IDLE", self.entity.name).into());
            return root_State::IDLE; }
        root_State::ADMIT
    }

    fn transition_from_root_ROUTE_SET(&mut self, now: timestamp) -> root_State {
        if !(self.IsRouteSet_value) {
            self.State = RouteSearch::INACTIVE;
                        web_sys::console::log_1(&format!("LinkRTL({})=IDLE", self.entity.name).into());
            return root_State::IDLE; }
        root_State::ROUTE_SET
    }

    fn transition_from_root_ROUTE_MONITORED(&mut self, now: timestamp) -> root_State {
        if !(self.IsRouteSetDownstream_value) {
            self.State = RouteSearch::RESPONSE;
                        web_sys::console::log_1(&format!("LinkRTL({})=ADMIT", self.entity.name).into());
            return root_State::ADMIT; }
        root_State::ROUTE_MONITORED
    }

    fn transition_root(&mut self, state: root_State, now: timestamp) -> root_State {
        // Performs a state transition if possible
        match state {
            root_State::__initial => { self.transition_from_root___initial(now) }
            root_State::IDLE => { self.transition_from_root_IDLE(now) }
            root_State::CHECKING => { self.transition_from_root_CHECKING(now) }
            root_State::ADMIT => { self.transition_from_root_ADMIT(now) }
            root_State::ROUTE_SET => { self.transition_from_root_ROUTE_SET(now) }
            root_State::ROUTE_MONITORED => { self.transition_from_root_ROUTE_MONITORED(now) }
        }
    }
}
