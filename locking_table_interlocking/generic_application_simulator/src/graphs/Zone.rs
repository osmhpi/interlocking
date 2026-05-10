
    // Auto-generated Rust state machine for Zone

use web_sys;
use crate::{configuration_types::*, enums::*, eval_context::EvalContext, graph::Graph, triggerable::Triggerable, timestamp::timestamp};

#[derive(Clone)]
pub struct ZoneStateMachine {
    __state: root_State,
    pub entity: EntitiesZoneItem,
    pub State: OccupancyStatus,
    pub ZoneOccupied_value: bool,
}

impl ZoneStateMachine {
    pub fn new(entity: EntitiesZoneItem) -> Self {
        Self {
            __state: root_State::__initial,
            entity,
            State: { OccupancyStatus::OCCUPIED }
,
            ZoneOccupied_value: true
        }
    }

    pub fn ZoneOccupied(&self, ctx: &EvalContext, now: timestamp) -> bool {
        (match (Some(ctx.Zone_SCITDS.get(&self.entity.name).unwrap().OccupancyStatus), Some(Triggerable::Triggered(OccupancyStatus::VACANT))) {
    (Some(l), Some(r)) => Some(l != r),
    _ => None
  }).unwrap_or(true)
    }
}

impl Graph for ZoneStateMachine {
    fn evaluate_terms(&mut self, ctx: &EvalContext, now: timestamp) {
        self.ZoneOccupied_value = self.ZoneOccupied(ctx, now);
    }

    fn transition(&mut self, now: timestamp) {
        self.__state = self.transition_root(self.__state.clone(), now);
    }
}


#[derive(Debug, Clone, PartialEq, Eq)]
pub enum root_State {
    __initial,
    OCCUPIED,
    VACANT
}

impl ZoneStateMachine {
    fn transition_from_root___initial(&mut self, now: timestamp) -> root_State {
                    self.State = OccupancyStatus::OCCUPIED;
                    web_sys::console::log_1(&format!("Zone({})=OCCUPIED", self.entity.name).into());
        return root_State::OCCUPIED;
    }

    fn transition_from_root_OCCUPIED(&mut self, now: timestamp) -> root_State {
        if !(self.ZoneOccupied_value) {
            self.State = OccupancyStatus::VACANT;
                        web_sys::console::log_1(&format!("Zone({})=VACANT", self.entity.name).into());
            return root_State::VACANT; }
        root_State::OCCUPIED
    }

    fn transition_from_root_VACANT(&mut self, now: timestamp) -> root_State {
        if self.ZoneOccupied_value {
            self.State = OccupancyStatus::OCCUPIED;
                        web_sys::console::log_1(&format!("Zone({})=OCCUPIED", self.entity.name).into());
            return root_State::OCCUPIED; }
        root_State::VACANT
    }

    fn transition_root(&mut self, state: root_State, now: timestamp) -> root_State {
        // Performs a state transition if possible
        match state {
            root_State::__initial => { self.transition_from_root___initial(now) }
            root_State::OCCUPIED => { self.transition_from_root_OCCUPIED(now) }
            root_State::VACANT => { self.transition_from_root_VACANT(now) }
        }
    }
}
