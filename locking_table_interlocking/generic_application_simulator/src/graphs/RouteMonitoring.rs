
    // Auto-generated Rust state machine for RouteMonitoring

use web_sys;
use crate::{configuration_types::*, enums::*, eval_context::EvalContext, graph::Graph, triggerable::Triggerable, timestamp::timestamp};

#[derive(Clone)]
pub struct RouteMonitoringStateMachine {
    __state: root_State,
    pub entity: EntitiesRouteItem,
    pub State: ActiveInactive,
    pub PointsMonitored_value: bool,
    pub RouteSet_value: bool,
    pub InverseTransitsInactive_value: bool,
}

impl RouteMonitoringStateMachine {
    pub fn new(entity: EntitiesRouteItem) -> Self {
        Self {
            __state: root_State::__initial,
            entity,
            State: { ActiveInactive::INACTIVE }
,
            PointsMonitored_value: false,
            RouteSet_value: false,
            InverseTransitsInactive_value: false
        }
    }

    #[allow(unused_variables)]
    pub fn PointsMonitored(&self, ctx: &EvalContext, now: timestamp) -> bool {
        (match (Some(self.entity.request_points_right.iter().all(|name| ctx.PointMonitoring.get(name).unwrap().Right == ActiveInactive::ACTIVE)), Some(self.entity.request_points_left.iter().all(|name| ctx.PointMonitoring.get(name).unwrap().Left == ActiveInactive::ACTIVE))) {
    (Some(a), Some(b)) => Some(a && b),
    _ => None
  }).unwrap_or(false)
    }

    #[allow(unused_variables)]
    pub fn RouteSet(&self, ctx: &EvalContext, now: timestamp) -> bool {
        (match (Some(ctx.Route.get(&self.entity.name).unwrap().State), Some(RouteState::SET)) {
    (Some(l), Some(r)) => Some(l == r),
    _ => None
  }).unwrap_or(false)
    }

    #[allow(unused_variables)]
    pub fn InverseTransitsInactive(&self, ctx: &EvalContext, now: timestamp) -> bool {
        (Some(self.entity.transits_in_opposite_route_direction.iter().all(|name| ctx.Transit.get(name).unwrap().State == ActiveInactive::INACTIVE))).unwrap_or(false)
    }
}

impl Graph for RouteMonitoringStateMachine {
    fn evaluate_terms(&mut self, ctx: &EvalContext, now: timestamp) {
        self.PointsMonitored_value = self.PointsMonitored(ctx, now);
        self.RouteSet_value = self.RouteSet(ctx, now);
        self.InverseTransitsInactive_value = self.InverseTransitsInactive(ctx, now);
    }

    fn transition(&mut self, now: timestamp) {
        self.__state = self.transition_root(self.__state.clone(), now);
    }
}


#[derive(Debug, Clone, PartialEq, Eq)]
pub enum root_State {
    __initial,
    NOT_MONITORED,
    MONITORED
}

impl RouteMonitoringStateMachine {
    #[allow(unused_variables)]
    fn transition_from_root___initial(&mut self, now: timestamp) -> root_State {
                    self.State = ActiveInactive::INACTIVE;
                    web_sys::console::log_1(&format!("RouteMonitoring({})=NOT_MONITORED", self.entity.name).into());
        return root_State::NOT_MONITORED;
    }

    #[allow(unused_variables)]
    fn transition_from_root_NOT_MONITORED(&mut self, now: timestamp) -> root_State {
        if self.PointsMonitored_value && self.RouteSet_value && self.InverseTransitsInactive_value {
            self.State = ActiveInactive::ACTIVE;
                        web_sys::console::log_1(&format!("RouteMonitoring({})=MONITORED", self.entity.name).into());
            return root_State::MONITORED; }
        root_State::NOT_MONITORED
    }

    #[allow(unused_variables)]
    fn transition_from_root_MONITORED(&mut self, now: timestamp) -> root_State {
        if !(self.PointsMonitored_value) || !(self.RouteSet_value) || !(self.InverseTransitsInactive_value) {
            self.State = ActiveInactive::INACTIVE;
                        web_sys::console::log_1(&format!("RouteMonitoring({})=NOT_MONITORED", self.entity.name).into());
            return root_State::NOT_MONITORED; }
        root_State::MONITORED
    }

    fn transition_root(&mut self, state: root_State, now: timestamp) -> root_State {
        // Performs a state transition if possible
        match state {
            root_State::__initial => { self.transition_from_root___initial(now) }
            root_State::NOT_MONITORED => { self.transition_from_root_NOT_MONITORED(now) }
            root_State::MONITORED => { self.transition_from_root_MONITORED(now) }
        }
    }
}
