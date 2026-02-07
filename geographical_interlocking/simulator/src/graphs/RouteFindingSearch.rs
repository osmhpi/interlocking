
    // Auto-generated Rust state machine for RouteFindingSearch

use web_sys;
use crate::{configuration_types::*, enums::*, eval_context::EvalContext, graph::Graph, triggerable::Triggerable, timestamp::timestamp};

#[derive(Clone)]
pub struct RouteFindingSearchStateMachine {
    __state: root_State,
    pub entity: EntitiesIseItem,
    pub Check: RouteChecking,
    pub RouteRequested_value: bool,
    pub TerminatesRouteRequested_value: bool,
    pub Checking_value: bool,
    pub SettingRoute_value: bool,
    pub CheckingFromA_value: bool,
    pub CheckingFromB_value: bool,
    pub CheckingFromC_value: bool,
    pub RouteSet_value: bool,
}

impl RouteFindingSearchStateMachine {
    pub fn new(entity: EntitiesIseItem) -> Self {
        Self {
            __state: root_State::__initial,
            entity,
            Check: { RouteChecking::INACTIVE }
,
            RouteRequested_value: false,
            TerminatesRouteRequested_value: false,
            Checking_value: false,
            SettingRoute_value: false,
            CheckingFromA_value: false,
            CheckingFromB_value: false,
            CheckingFromC_value: false,
            RouteSet_value: false
        }
    }

    pub fn RouteRequested(&self, ctx: &EvalContext, now: timestamp) -> bool {
        (Some(self.entity.is_start_of_route_admission_check.iter().any(|name| ctx.RouteCheck.get(name).unwrap().State == ActiveInactive::ACTIVE))).unwrap_or(false)
    }

    pub fn TerminatesRouteRequested(&self, ctx: &EvalContext, now: timestamp) -> bool {
        (Some(self.entity.is_end_of_route_admission_check.iter().any(|name| ctx.RouteCheck.get(name).unwrap().State == ActiveInactive::ACTIVE))).unwrap_or(false)
    }

    pub fn Checking(&self, ctx: &EvalContext, now: timestamp) -> bool {
        (match (match (match (match (match (Some(self.entity.link_a_left.iter().any(|name| ctx.LinkRTL.get(name).unwrap().State == RouteSearch::SEARCH)), Some(self.entity.link_a_right.iter().any(|name| ctx.LinkLTR.get(name).unwrap().State == RouteSearch::SEARCH))) {
    (Some(a), Some(b)) => Some(a || b),
    _ => None
  }, Some(self.entity.link_b_left.iter().any(|name| ctx.LinkRTL.get(name).unwrap().State == RouteSearch::SEARCH))) {
    (Some(a), Some(b)) => Some(a || b),
    _ => None
  }, Some(self.entity.link_b_right.iter().any(|name| ctx.LinkLTR.get(name).unwrap().State == RouteSearch::SEARCH))) {
    (Some(a), Some(b)) => Some(a || b),
    _ => None
  }, Some(self.entity.link_c_left.iter().any(|name| ctx.LinkRTL.get(name).unwrap().State == RouteSearch::SEARCH))) {
    (Some(a), Some(b)) => Some(a || b),
    _ => None
  }, Some(self.entity.link_c_right.iter().any(|name| ctx.LinkLTR.get(name).unwrap().State == RouteSearch::SEARCH))) {
    (Some(a), Some(b)) => Some(a || b),
    _ => None
  }).unwrap_or(false)
    }

    pub fn SettingRoute(&self, ctx: &EvalContext, now: timestamp) -> bool {
        (match (match (match (match (match (Some(self.entity.link_a_left.iter().any(|name| ctx.LinkRTL.get(name).unwrap().State == RouteSearch::SEARCH)), Some(self.entity.link_a_right.iter().any(|name| ctx.LinkLTR.get(name).unwrap().State == RouteSearch::ROUTE_SET))) {
    (Some(a), Some(b)) => Some(a || b),
    _ => None
  }, Some(self.entity.link_b_left.iter().any(|name| ctx.LinkRTL.get(name).unwrap().State == RouteSearch::SEARCH))) {
    (Some(a), Some(b)) => Some(a || b),
    _ => None
  }, Some(self.entity.link_b_right.iter().any(|name| ctx.LinkLTR.get(name).unwrap().State == RouteSearch::ROUTE_SET))) {
    (Some(a), Some(b)) => Some(a || b),
    _ => None
  }, Some(self.entity.link_c_left.iter().any(|name| ctx.LinkRTL.get(name).unwrap().State == RouteSearch::SEARCH))) {
    (Some(a), Some(b)) => Some(a || b),
    _ => None
  }, Some(self.entity.link_c_right.iter().any(|name| ctx.LinkLTR.get(name).unwrap().State == RouteSearch::ROUTE_SET))) {
    (Some(a), Some(b)) => Some(a || b),
    _ => None
  }).unwrap_or(false)
    }

    pub fn CheckingFromA(&self, ctx: &EvalContext, now: timestamp) -> bool {
        (match (Some(self.entity.link_a_left.iter().any(|name| ctx.LinkRTL.get(name).unwrap().State == RouteSearch::SEARCH)), Some(self.entity.link_a_right.iter().any(|name| ctx.LinkLTR.get(name).unwrap().State == RouteSearch::SEARCH))) {
    (Some(a), Some(b)) => Some(a || b),
    _ => None
  }).unwrap_or(false)
    }

    pub fn CheckingFromB(&self, ctx: &EvalContext, now: timestamp) -> bool {
        (match (Some(self.entity.link_b_left.iter().any(|name| ctx.LinkRTL.get(name).unwrap().State == RouteSearch::SEARCH)), Some(self.entity.link_b_right.iter().any(|name| ctx.LinkLTR.get(name).unwrap().State == RouteSearch::SEARCH))) {
    (Some(a), Some(b)) => Some(a || b),
    _ => None
  }).unwrap_or(false)
    }

    pub fn CheckingFromC(&self, ctx: &EvalContext, now: timestamp) -> bool {
        (match (Some(self.entity.link_c_left.iter().any(|name| ctx.LinkRTL.get(name).unwrap().State == RouteSearch::SEARCH)), Some(self.entity.link_c_right.iter().any(|name| ctx.LinkLTR.get(name).unwrap().State == RouteSearch::SEARCH))) {
    (Some(a), Some(b)) => Some(a || b),
    _ => None
  }).unwrap_or(false)
    }

    pub fn RouteSet(&self, ctx: &EvalContext, now: timestamp) -> bool {
        (Some(self.entity.transits.iter().any(|name| ctx.Route.get(name).unwrap().State != RouteState::RELEASED))).unwrap_or(false)
    }
}

impl Graph for RouteFindingSearchStateMachine {
    fn evaluate_terms(&mut self, ctx: &EvalContext, now: timestamp) {
        self.RouteRequested_value = self.RouteRequested(ctx, now);
        self.TerminatesRouteRequested_value = self.TerminatesRouteRequested(ctx, now);
        self.Checking_value = self.Checking(ctx, now);
        self.SettingRoute_value = self.SettingRoute(ctx, now);
        self.CheckingFromA_value = self.CheckingFromA(ctx, now);
        self.CheckingFromB_value = self.CheckingFromB(ctx, now);
        self.CheckingFromC_value = self.CheckingFromC(ctx, now);
        self.RouteSet_value = self.RouteSet(ctx, now);
    }

    fn transition(&mut self, now: timestamp) {
        self.__state = self.transition_root(self.__state.clone(), now);
    }
}


#[derive(Debug, Clone, PartialEq, Eq)]
pub enum root_State {
    __initial,
    IDLE,
    CHECKING_START,
    CHECKING_FROM_A,
    CHECKING_FROM_B,
    CHECKING_FROM_C,
    ROUTE_SET_FROM_START,
    ROUTE_SET_FROM_A,
    ROUTE_SET_FROM_B,
    ROUTE_SET_FROM_C
}

impl RouteFindingSearchStateMachine {
    fn transition_from_root___initial(&mut self, now: timestamp) -> root_State {
                    self.Check = RouteChecking::INACTIVE;
                    web_sys::console::log_1(&format!("RouteFindingSearch({})=IDLE", self.entity.name).into());
        return root_State::IDLE;
    }

    fn transition_from_root_IDLE(&mut self, now: timestamp) -> root_State {
        if self.CheckingFromA_value {
            self.Check = RouteChecking::CHECK_FROM_A;
                        web_sys::console::log_1(&format!("RouteFindingSearch({})=CHECKING_FROM_A", self.entity.name).into());
            return root_State::CHECKING_FROM_A; }
        if self.CheckingFromB_value {
            self.Check = RouteChecking::CHECK_FROM_B;
                        web_sys::console::log_1(&format!("RouteFindingSearch({})=CHECKING_FROM_B", self.entity.name).into());
            return root_State::CHECKING_FROM_B; }
        if self.CheckingFromC_value {
            self.Check = RouteChecking::CHECK_FROM_C;
                        web_sys::console::log_1(&format!("RouteFindingSearch({})=CHECKING_FROM_C", self.entity.name).into());
            return root_State::CHECKING_FROM_C; }
        if self.RouteRequested_value {
            self.Check = RouteChecking::CHECK_START;
                        web_sys::console::log_1(&format!("RouteFindingSearch({})=CHECKING_START", self.entity.name).into());
            return root_State::CHECKING_START; }
        root_State::IDLE
    }

    fn transition_from_root_CHECKING_START(&mut self, now: timestamp) -> root_State {
        if self.RouteSet_value {
            self.Check = RouteChecking::ROUTE_SET_FROM_START;
                        web_sys::console::log_1(&format!("RouteFindingSearch({})=ROUTE_SET_FROM_START", self.entity.name).into());
            return root_State::ROUTE_SET_FROM_START; }
        if !(self.RouteRequested_value) {
            self.Check = RouteChecking::INACTIVE;
                        web_sys::console::log_1(&format!("RouteFindingSearch({})=IDLE", self.entity.name).into());
            return root_State::IDLE; }
        root_State::CHECKING_START
    }

    fn transition_from_root_CHECKING_FROM_A(&mut self, now: timestamp) -> root_State {
        if self.RouteSet_value {
            self.Check = RouteChecking::ROUTE_SET_FROM_A;
                        web_sys::console::log_1(&format!("RouteFindingSearch({})=ROUTE_SET_FROM_A", self.entity.name).into());
            return root_State::ROUTE_SET_FROM_A; }
        if !(self.Checking_value) && !(self.SettingRoute_value) {
            self.Check = RouteChecking::INACTIVE;
                        web_sys::console::log_1(&format!("RouteFindingSearch({})=IDLE", self.entity.name).into());
            return root_State::IDLE; }
        root_State::CHECKING_FROM_A
    }

    fn transition_from_root_CHECKING_FROM_B(&mut self, now: timestamp) -> root_State {
        if self.RouteSet_value {
            self.Check = RouteChecking::ROUTE_SET_FROM_B;
                        web_sys::console::log_1(&format!("RouteFindingSearch({})=ROUTE_SET_FROM_B", self.entity.name).into());
            return root_State::ROUTE_SET_FROM_B; }
        if !(self.Checking_value) && !(self.SettingRoute_value) {
            self.Check = RouteChecking::INACTIVE;
                        web_sys::console::log_1(&format!("RouteFindingSearch({})=IDLE", self.entity.name).into());
            return root_State::IDLE; }
        root_State::CHECKING_FROM_B
    }

    fn transition_from_root_CHECKING_FROM_C(&mut self, now: timestamp) -> root_State {
        if self.RouteSet_value {
            self.Check = RouteChecking::ROUTE_SET_FROM_C;
                        web_sys::console::log_1(&format!("RouteFindingSearch({})=ROUTE_SET_FROM_C", self.entity.name).into());
            return root_State::ROUTE_SET_FROM_C; }
        if !(self.Checking_value) && !(self.SettingRoute_value) {
            self.Check = RouteChecking::INACTIVE;
                        web_sys::console::log_1(&format!("RouteFindingSearch({})=IDLE", self.entity.name).into());
            return root_State::IDLE; }
        root_State::CHECKING_FROM_C
    }

    fn transition_from_root_ROUTE_SET_FROM_START(&mut self, now: timestamp) -> root_State {
        if !(self.RouteSet_value) {
            self.Check = RouteChecking::INACTIVE;
                        web_sys::console::log_1(&format!("RouteFindingSearch({})=IDLE", self.entity.name).into());
            return root_State::IDLE; }
        root_State::ROUTE_SET_FROM_START
    }

    fn transition_from_root_ROUTE_SET_FROM_A(&mut self, now: timestamp) -> root_State {
        if !(self.RouteSet_value) {
            self.Check = RouteChecking::INACTIVE;
                        web_sys::console::log_1(&format!("RouteFindingSearch({})=IDLE", self.entity.name).into());
            return root_State::IDLE; }
        root_State::ROUTE_SET_FROM_A
    }

    fn transition_from_root_ROUTE_SET_FROM_B(&mut self, now: timestamp) -> root_State {
        if !(self.RouteSet_value) {
            self.Check = RouteChecking::INACTIVE;
                        web_sys::console::log_1(&format!("RouteFindingSearch({})=IDLE", self.entity.name).into());
            return root_State::IDLE; }
        root_State::ROUTE_SET_FROM_B
    }

    fn transition_from_root_ROUTE_SET_FROM_C(&mut self, now: timestamp) -> root_State {
        if !(self.RouteSet_value) {
            self.Check = RouteChecking::INACTIVE;
                        web_sys::console::log_1(&format!("RouteFindingSearch({})=IDLE", self.entity.name).into());
            return root_State::IDLE; }
        root_State::ROUTE_SET_FROM_C
    }

    fn transition_root(&mut self, state: root_State, now: timestamp) -> root_State {
        // Performs a state transition if possible
        match state {
            root_State::__initial => { self.transition_from_root___initial(now) }
            root_State::IDLE => { self.transition_from_root_IDLE(now) }
            root_State::CHECKING_START => { self.transition_from_root_CHECKING_START(now) }
            root_State::CHECKING_FROM_A => { self.transition_from_root_CHECKING_FROM_A(now) }
            root_State::CHECKING_FROM_B => { self.transition_from_root_CHECKING_FROM_B(now) }
            root_State::CHECKING_FROM_C => { self.transition_from_root_CHECKING_FROM_C(now) }
            root_State::ROUTE_SET_FROM_START => { self.transition_from_root_ROUTE_SET_FROM_START(now) }
            root_State::ROUTE_SET_FROM_A => { self.transition_from_root_ROUTE_SET_FROM_A(now) }
            root_State::ROUTE_SET_FROM_B => { self.transition_from_root_ROUTE_SET_FROM_B(now) }
            root_State::ROUTE_SET_FROM_C => { self.transition_from_root_ROUTE_SET_FROM_C(now) }
        }
    }
}
