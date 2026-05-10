
    // Auto-generated Rust state machine for RouteFindingResponse

use web_sys;
use crate::{configuration_types::*, enums::*, eval_context::EvalContext, graph::Graph, triggerable::Triggerable, timestamp::timestamp};

#[derive(Clone)]
pub struct RouteFindingResponseStateMachine {
    __state: root_State,
    pub entity: EntitiesIseItem,
    pub Admit: RouteAdmission,
    pub Checking_value: bool,
    pub CheckingFromA_value: bool,
    pub TerminatesRouteRequested_value: bool,
    pub AdmittingToA_value: bool,
    pub AdmittingToB_value: bool,
    pub AdmittingToC_value: bool,
    pub RouteMonitored_value: bool,
}

impl RouteFindingResponseStateMachine {
    pub fn new(entity: EntitiesIseItem) -> Self {
        Self {
            __state: root_State::__initial,
            entity,
            Admit: { RouteAdmission::INACTIVE }
,
            Checking_value: false,
            CheckingFromA_value: false,
            TerminatesRouteRequested_value: false,
            AdmittingToA_value: false,
            AdmittingToB_value: false,
            AdmittingToC_value: false,
            RouteMonitored_value: false
        }
    }

    pub fn Checking(&self, ctx: &EvalContext, now: timestamp) -> bool {
        (match (Some(ctx.RouteFindingSearch.get(&self.entity.name).unwrap().Check), Some(RouteChecking::INACTIVE)) {
    (Some(l), Some(r)) => Some(l != r),
    _ => None
  }).unwrap_or(false)
    }

    pub fn CheckingFromA(&self, ctx: &EvalContext, now: timestamp) -> bool {
        (match (Some(ctx.RouteFindingSearch.get(&self.entity.name).unwrap().Check), Some(RouteChecking::CHECK_FROM_A)) {
    (Some(l), Some(r)) => Some(l == r),
    _ => None
  }).unwrap_or(false)
    }

    pub fn TerminatesRouteRequested(&self, ctx: &EvalContext, now: timestamp) -> bool {
        (Some(self.entity.is_end_of_route_admission_check.iter().any(|name| ctx.RouteCheck.get(name).unwrap().State == ActiveInactive::ACTIVE))).unwrap_or(false)
    }

    pub fn AdmittingToA(&self, ctx: &EvalContext, now: timestamp) -> bool {
        (match (Some(self.entity.link_a_left.iter().any(|name| ctx.LinkRTL.get(name).unwrap().State == RouteSearch::RESPONSE)), Some(self.entity.link_a_right.iter().any(|name| ctx.LinkLTR.get(name).unwrap().State == RouteSearch::RESPONSE))) {
    (Some(a), Some(b)) => Some(a || b),
    _ => None
  }).unwrap_or(false)
    }

    pub fn AdmittingToB(&self, ctx: &EvalContext, now: timestamp) -> bool {
        (match (Some(self.entity.link_b_left.iter().any(|name| ctx.LinkRTL.get(name).unwrap().State == RouteSearch::RESPONSE)), Some(self.entity.link_b_right.iter().any(|name| ctx.LinkLTR.get(name).unwrap().State == RouteSearch::RESPONSE))) {
    (Some(a), Some(b)) => Some(a || b),
    _ => None
  }).unwrap_or(false)
    }

    pub fn AdmittingToC(&self, ctx: &EvalContext, now: timestamp) -> bool {
        (match (Some(self.entity.link_c_left.iter().any(|name| ctx.LinkRTL.get(name).unwrap().State == RouteSearch::RESPONSE)), Some(self.entity.link_c_right.iter().any(|name| ctx.LinkLTR.get(name).unwrap().State == RouteSearch::RESPONSE))) {
    (Some(a), Some(b)) => Some(a || b),
    _ => None
  }).unwrap_or(false)
    }

    pub fn RouteMonitored(&self, ctx: &EvalContext, now: timestamp) -> bool {
        (Some(self.entity.transits.iter().any(|name| ctx.RouteMonitoring.get(name).unwrap().State == ActiveInactive::ACTIVE))).unwrap_or(false)
    }
}

impl Graph for RouteFindingResponseStateMachine {
    fn evaluate_terms(&mut self, ctx: &EvalContext, now: timestamp) {
        self.Checking_value = self.Checking(ctx, now);
        self.CheckingFromA_value = self.CheckingFromA(ctx, now);
        self.TerminatesRouteRequested_value = self.TerminatesRouteRequested(ctx, now);
        self.AdmittingToA_value = self.AdmittingToA(ctx, now);
        self.AdmittingToB_value = self.AdmittingToB(ctx, now);
        self.AdmittingToC_value = self.AdmittingToC(ctx, now);
        self.RouteMonitored_value = self.RouteMonitored(ctx, now);
    }

    fn transition(&mut self, now: timestamp) {
        self.__state = self.transition_root(self.__state.clone(), now);
    }
}


#[derive(Debug, Clone, PartialEq, Eq)]
pub enum root_State {
    __initial,
    IDLE,
    ADMIT_END,
    ADMIT_TO_A,
    ADMIT_TO_B,
    ADMIT_TO_C,
    ROUTE_TO_END,
    ROUTE_TO_A,
    ROUTE_TO_B,
    ROUTE_TO_C
}

impl RouteFindingResponseStateMachine {
    fn transition_from_root___initial(&mut self, now: timestamp) -> root_State {
                    self.Admit = RouteAdmission::INACTIVE;
                    web_sys::console::log_1(&format!("RouteFindingResponse({})=IDLE", self.entity.name).into());
        return root_State::IDLE;
    }

    fn transition_from_root_IDLE(&mut self, now: timestamp) -> root_State {
        if self.CheckingFromA_value && self.TerminatesRouteRequested_value {
            self.Admit = RouteAdmission::ADMIT_END;
                        web_sys::console::log_1(&format!("RouteFindingResponse({})=ADMIT_END", self.entity.name).into());
            return root_State::ADMIT_END; }
        if self.Checking_value && self.AdmittingToA_value {
            self.Admit = RouteAdmission::ADMIT_TO_A;
                        web_sys::console::log_1(&format!("RouteFindingResponse({})=ADMIT_TO_A", self.entity.name).into());
            return root_State::ADMIT_TO_A; }
        if self.Checking_value && self.AdmittingToB_value {
            self.Admit = RouteAdmission::ADMIT_TO_B;
                        web_sys::console::log_1(&format!("RouteFindingResponse({})=ADMIT_TO_B", self.entity.name).into());
            return root_State::ADMIT_TO_B; }
        if self.Checking_value && self.AdmittingToC_value {
            self.Admit = RouteAdmission::ADMIT_TO_C;
                        web_sys::console::log_1(&format!("RouteFindingResponse({})=ADMIT_TO_C", self.entity.name).into());
            return root_State::ADMIT_TO_C; }
        root_State::IDLE
    }

    fn transition_from_root_ADMIT_END(&mut self, now: timestamp) -> root_State {
        if self.RouteMonitored_value {
            self.Admit = RouteAdmission::ROUTE_END;
                        web_sys::console::log_1(&format!("RouteFindingResponse({})=ROUTE_TO_END", self.entity.name).into());
            return root_State::ROUTE_TO_END; }
        if !(self.Checking_value) {
            self.Admit = RouteAdmission::INACTIVE;
                        web_sys::console::log_1(&format!("RouteFindingResponse({})=IDLE", self.entity.name).into());
            return root_State::IDLE; }
        root_State::ADMIT_END
    }

    fn transition_from_root_ADMIT_TO_A(&mut self, now: timestamp) -> root_State {
        if self.RouteMonitored_value {
            self.Admit = RouteAdmission::ROUTE_TO_A;
                        web_sys::console::log_1(&format!("RouteFindingResponse({})=ROUTE_TO_A", self.entity.name).into());
            return root_State::ROUTE_TO_A; }
        if !(self.Checking_value) {
            self.Admit = RouteAdmission::INACTIVE;
                        web_sys::console::log_1(&format!("RouteFindingResponse({})=IDLE", self.entity.name).into());
            return root_State::IDLE; }
        root_State::ADMIT_TO_A
    }

    fn transition_from_root_ADMIT_TO_B(&mut self, now: timestamp) -> root_State {
        if self.RouteMonitored_value {
            self.Admit = RouteAdmission::ROUTE_TO_B;
                        web_sys::console::log_1(&format!("RouteFindingResponse({})=ROUTE_TO_B", self.entity.name).into());
            return root_State::ROUTE_TO_B; }
        if !(self.Checking_value) {
            self.Admit = RouteAdmission::INACTIVE;
                        web_sys::console::log_1(&format!("RouteFindingResponse({})=IDLE", self.entity.name).into());
            return root_State::IDLE; }
        root_State::ADMIT_TO_B
    }

    fn transition_from_root_ADMIT_TO_C(&mut self, now: timestamp) -> root_State {
        if self.RouteMonitored_value {
            self.Admit = RouteAdmission::ROUTE_TO_C;
                        web_sys::console::log_1(&format!("RouteFindingResponse({})=ROUTE_TO_C", self.entity.name).into());
            return root_State::ROUTE_TO_C; }
        if !(self.Checking_value) {
            self.Admit = RouteAdmission::INACTIVE;
                        web_sys::console::log_1(&format!("RouteFindingResponse({})=IDLE", self.entity.name).into());
            return root_State::IDLE; }
        root_State::ADMIT_TO_C
    }

    fn transition_from_root_ROUTE_TO_END(&mut self, now: timestamp) -> root_State {
        if !(self.RouteMonitored_value) {
            self.Admit = RouteAdmission::INACTIVE;
                        web_sys::console::log_1(&format!("RouteFindingResponse({})=IDLE", self.entity.name).into());
            return root_State::IDLE; }
        root_State::ROUTE_TO_END
    }

    fn transition_from_root_ROUTE_TO_A(&mut self, now: timestamp) -> root_State {
        if !(self.RouteMonitored_value) {
            self.Admit = RouteAdmission::INACTIVE;
                        web_sys::console::log_1(&format!("RouteFindingResponse({})=IDLE", self.entity.name).into());
            return root_State::IDLE; }
        root_State::ROUTE_TO_A
    }

    fn transition_from_root_ROUTE_TO_B(&mut self, now: timestamp) -> root_State {
        if !(self.RouteMonitored_value) {
            self.Admit = RouteAdmission::INACTIVE;
                        web_sys::console::log_1(&format!("RouteFindingResponse({})=IDLE", self.entity.name).into());
            return root_State::IDLE; }
        root_State::ROUTE_TO_B
    }

    fn transition_from_root_ROUTE_TO_C(&mut self, now: timestamp) -> root_State {
        if !(self.RouteMonitored_value) {
            self.Admit = RouteAdmission::INACTIVE;
                        web_sys::console::log_1(&format!("RouteFindingResponse({})=IDLE", self.entity.name).into());
            return root_State::IDLE; }
        root_State::ROUTE_TO_C
    }

    fn transition_root(&mut self, state: root_State, now: timestamp) -> root_State {
        // Performs a state transition if possible
        match state {
            root_State::__initial => { self.transition_from_root___initial(now) }
            root_State::IDLE => { self.transition_from_root_IDLE(now) }
            root_State::ADMIT_END => { self.transition_from_root_ADMIT_END(now) }
            root_State::ADMIT_TO_A => { self.transition_from_root_ADMIT_TO_A(now) }
            root_State::ADMIT_TO_B => { self.transition_from_root_ADMIT_TO_B(now) }
            root_State::ADMIT_TO_C => { self.transition_from_root_ADMIT_TO_C(now) }
            root_State::ROUTE_TO_END => { self.transition_from_root_ROUTE_TO_END(now) }
            root_State::ROUTE_TO_A => { self.transition_from_root_ROUTE_TO_A(now) }
            root_State::ROUTE_TO_B => { self.transition_from_root_ROUTE_TO_B(now) }
            root_State::ROUTE_TO_C => { self.transition_from_root_ROUTE_TO_C(now) }
        }
    }
}
