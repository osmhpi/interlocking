
    // Auto-generated Rust state machine for RouteMonitoring

use web_sys;
use crate::{configuration_types::*, enums::*, eval_context::EvalContext, graph::Graph, triggerable::Triggerable, timestamp::timestamp};

#[derive(Clone)]
pub struct RouteMonitoringStateMachine {
    __state: root_State,
    pub entity: EntitiesTransitItem,
    pub State: ActiveInactive,
    pub PointsControlled_value: bool,
    pub RouteSet_value: bool,
    pub InverseTransitInactive_value: bool,
    pub MonitoringComplete_value: bool,
}

impl RouteMonitoringStateMachine {
    pub fn new(entity: EntitiesTransitItem) -> Self {
        Self {
            __state: root_State::__initial,
            entity,
            State: { ActiveInactive::INACTIVE }
,
            PointsControlled_value: false,
            RouteSet_value: false,
            InverseTransitInactive_value: false,
            MonitoringComplete_value: false
        }
    }

    pub fn PointsControlled(&self, ctx: &EvalContext, now: timestamp) -> bool {
        (match (Some(self.entity.requires_point_right.iter().all(|name| ctx.PointControl.get(name).unwrap().Right == ActiveInactive::ACTIVE)), Some(self.entity.requires_point_left.iter().all(|name| ctx.PointControl.get(name).unwrap().Left == ActiveInactive::ACTIVE))) {
    (Some(a), Some(b)) => Some(a && b),
    _ => None
  }).unwrap_or(false)
    }

    pub fn RouteSet(&self, ctx: &EvalContext, now: timestamp) -> bool {
        (match (Some(ctx.Route.get(&self.entity.name).unwrap().State), Some(RouteState::SET)) {
    (Some(l), Some(r)) => Some(l == r),
    _ => None
  }).unwrap_or(false)
    }

    pub fn InverseTransitInactive(&self, ctx: &EvalContext, now: timestamp) -> bool {
        (match (Some(ctx.Transit.get(&self.entity.transit_in_opposite_direction).unwrap().State), Some(ActiveInactive::INACTIVE)) {
    (Some(l), Some(r)) => Some(l == r),
    _ => None
  }).unwrap_or(false)
    }

    pub fn MonitoringComplete(&self, ctx: &EvalContext, now: timestamp) -> bool {
        (match (match (match (Some(self.entity.downstream_link_right.iter().any(|name| ctx.LinkLTR.get(name).unwrap().State == RouteSearch::ROUTE_MONITORED)), Some(self.entity.downstream_link_left.iter().any(|name| ctx.LinkRTL.get(name).unwrap().State == RouteSearch::ROUTE_MONITORED))) {
    (Some(a), Some(b)) => Some(a || b),
    _ => None
  }, match (Some(ctx.RouteFindingResponse.get(&self.entity.ise).unwrap().Admit), Some(RouteAdmission::ADMIT_END)) {
    (Some(l), Some(r)) => Some(l == r),
    _ => None
  }) {
    (Some(a), Some(b)) => Some(a || b),
    _ => None
  }, match (Some(ctx.RouteFindingResponse.get(&self.entity.ise).unwrap().Admit), Some(RouteAdmission::ROUTE_END)) {
    (Some(l), Some(r)) => Some(l == r),
    _ => None
  }) {
    (Some(a), Some(b)) => Some(a || b),
    _ => None
  }).unwrap_or(false)
    }
}

impl Graph for RouteMonitoringStateMachine {
    fn evaluate_terms(&mut self, ctx: &EvalContext, now: timestamp) {
        self.PointsControlled_value = self.PointsControlled(ctx, now);
        self.RouteSet_value = self.RouteSet(ctx, now);
        self.InverseTransitInactive_value = self.InverseTransitInactive(ctx, now);
        self.MonitoringComplete_value = self.MonitoringComplete(ctx, now);
    }

    fn transition(&mut self, now: timestamp) {
        self.__state = self.transition_root(self.__state.clone(), now);
    }
}


#[derive(Debug, Clone, PartialEq, Eq)]
pub enum root_State {
    __initial,
    NOT_CONTROLLED,
    CONTROLLED
}

impl RouteMonitoringStateMachine {
    fn transition_from_root___initial(&mut self, now: timestamp) -> root_State {
                    self.State = ActiveInactive::INACTIVE;
                    web_sys::console::log_1(&format!("RouteMonitoring({})=NOT_CONTROLLED", self.entity.name).into());
        return root_State::NOT_CONTROLLED;
    }

    fn transition_from_root_NOT_CONTROLLED(&mut self, now: timestamp) -> root_State {
        if self.PointsControlled_value && self.RouteSet_value && self.InverseTransitInactive_value && self.MonitoringComplete_value {
            self.State = ActiveInactive::ACTIVE;
                        web_sys::console::log_1(&format!("RouteMonitoring({})=CONTROLLED", self.entity.name).into());
            return root_State::CONTROLLED; }
        root_State::NOT_CONTROLLED
    }

    fn transition_from_root_CONTROLLED(&mut self, now: timestamp) -> root_State {
        if !(self.PointsControlled_value) || !(self.RouteSet_value) || !(self.InverseTransitInactive_value) || !(self.MonitoringComplete_value) {
            self.State = ActiveInactive::INACTIVE;
                        web_sys::console::log_1(&format!("RouteMonitoring({})=NOT_CONTROLLED", self.entity.name).into());
            return root_State::NOT_CONTROLLED; }
        root_State::CONTROLLED
    }

    fn transition_root(&mut self, state: root_State, now: timestamp) -> root_State {
        // Performs a state transition if possible
        match state {
            root_State::__initial => { self.transition_from_root___initial(now) }
            root_State::NOT_CONTROLLED => { self.transition_from_root_NOT_CONTROLLED(now) }
            root_State::CONTROLLED => { self.transition_from_root_CONTROLLED(now) }
        }
    }
}
