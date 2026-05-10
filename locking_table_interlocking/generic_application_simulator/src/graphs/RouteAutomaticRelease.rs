
    // Auto-generated Rust state machine for RouteAutomaticRelease

use web_sys;
use crate::{configuration_types::*, enums::*, eval_context::EvalContext, graph::Graph, triggerable::Triggerable, timestamp::timestamp};

#[derive(Clone)]
pub struct RouteAutomaticReleaseStateMachine {
    __state: root_State,
    pub entity: EntitiesRouteItem,
    pub State: ActiveInactive,
    pub PassageLock: ActiveInactive,
    pub RouteIsSet_value: bool,
    pub OppositeTransitsInactive_value: bool,
    pub TriggerZoneFree_value: bool,
}

impl RouteAutomaticReleaseStateMachine {
    pub fn new(entity: EntitiesRouteItem) -> Self {
        Self {
            __state: root_State::__initial,
            entity,
            State: { ActiveInactive::INACTIVE },
            PassageLock: { ActiveInactive::INACTIVE }
,
            RouteIsSet_value: false,
            OppositeTransitsInactive_value: false,
            TriggerZoneFree_value: false
        }
    }

    pub fn RouteIsSet(&self, ctx: &EvalContext, now: timestamp) -> bool {
        (match (Some(ctx.Route.get(&self.entity.name).unwrap().State), Some(RouteState::SET)) {
    (Some(l), Some(r)) => Some(l == r),
    _ => None
  }).unwrap_or(false)
    }

    pub fn OppositeTransitsInactive(&self, ctx: &EvalContext, now: timestamp) -> bool {
        (match (Some(ctx.Transit.get(&self.entity.trigger_zone_opposite_transit).unwrap().State), Some(ActiveInactive::INACTIVE)) {
    (Some(l), Some(r)) => Some(l == r),
    _ => None
  }).unwrap_or(false)
    }

    pub fn TriggerZoneFree(&self, ctx: &EvalContext, now: timestamp) -> bool {
        (match (Some(ctx.Zone.get(&self.entity.trigger_zone).unwrap().State), Some(OccupancyStatus::VACANT)) {
    (Some(l), Some(r)) => Some(l == r),
    _ => None
  }).unwrap_or(false)
    }
}

impl Graph for RouteAutomaticReleaseStateMachine {
    fn evaluate_terms(&mut self, ctx: &EvalContext, now: timestamp) {
        self.RouteIsSet_value = self.RouteIsSet(ctx, now);
        self.OppositeTransitsInactive_value = self.OppositeTransitsInactive(ctx, now);
        self.TriggerZoneFree_value = self.TriggerZoneFree(ctx, now);
    }

    fn transition(&mut self, now: timestamp) {
        self.__state = self.transition_root(self.__state.clone(), now);
    }
}


#[derive(Debug, Clone, PartialEq, Eq)]
pub enum root_State {
    __initial,
    INACTIVE,
    ACTIVE,
    EFFECTIVE
}

impl RouteAutomaticReleaseStateMachine {
    fn transition_from_root___initial(&mut self, now: timestamp) -> root_State {
                    self.State = ActiveInactive::INACTIVE;
            self.PassageLock = ActiveInactive::INACTIVE;
                    web_sys::console::log_1(&format!("RouteAutomaticRelease({})=INACTIVE", self.entity.name).into());
        return root_State::INACTIVE;
    }

    fn transition_from_root_INACTIVE(&mut self, now: timestamp) -> root_State {
        if self.RouteIsSet_value && self.OppositeTransitsInactive_value && !(self.TriggerZoneFree_value) {
            self.State = ActiveInactive::INACTIVE;
            self.PassageLock = ActiveInactive::ACTIVE;
                        web_sys::console::log_1(&format!("RouteAutomaticRelease({})=ACTIVE", self.entity.name).into());
            return root_State::ACTIVE; }
        root_State::INACTIVE
    }

    fn transition_from_root_ACTIVE(&mut self, now: timestamp) -> root_State {
        if !(self.RouteIsSet_value) {
            self.State = ActiveInactive::INACTIVE;
            self.PassageLock = ActiveInactive::INACTIVE;
                        web_sys::console::log_1(&format!("RouteAutomaticRelease({})=INACTIVE", self.entity.name).into());
            return root_State::INACTIVE; }
        if self.TriggerZoneFree_value {
            self.State = ActiveInactive::ACTIVE;
            self.PassageLock = ActiveInactive::ACTIVE;
                        web_sys::console::log_1(&format!("RouteAutomaticRelease({})=EFFECTIVE", self.entity.name).into());
            return root_State::EFFECTIVE; }
        root_State::ACTIVE
    }

    fn transition_from_root_EFFECTIVE(&mut self, now: timestamp) -> root_State {
        if !(self.RouteIsSet_value) {
            self.State = ActiveInactive::INACTIVE;
            self.PassageLock = ActiveInactive::INACTIVE;
                        web_sys::console::log_1(&format!("RouteAutomaticRelease({})=INACTIVE", self.entity.name).into());
            return root_State::INACTIVE; }
        root_State::EFFECTIVE
    }

    fn transition_root(&mut self, state: root_State, now: timestamp) -> root_State {
        // Performs a state transition if possible
        match state {
            root_State::__initial => { self.transition_from_root___initial(now) }
            root_State::INACTIVE => { self.transition_from_root_INACTIVE(now) }
            root_State::ACTIVE => { self.transition_from_root_ACTIVE(now) }
            root_State::EFFECTIVE => { self.transition_from_root_EFFECTIVE(now) }
        }
    }
}
