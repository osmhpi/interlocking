
    // Auto-generated Rust state machine for PointControl

use web_sys;
use crate::{configuration_types::*, enums::*, eval_context::EvalContext, graph::Graph, triggerable::Triggerable, timestamp::timestamp};

#[derive(Clone)]
pub struct PointControlStateMachine {
    __state: root_State,
    pub entity: EntitiesPointItem,
    pub Left: ActiveInactive,
    pub Right: ActiveInactive,
    pub EndPositionLeftDetected_value: bool,
    pub EndPositionRightDetected_value: bool,
    pub CommandedLeft_value: bool,
    pub CommandedRight_value: bool,
}

impl PointControlStateMachine {
    pub fn new(entity: EntitiesPointItem) -> Self {
        Self {
            __state: root_State::__initial,
            entity,
            Left: { ActiveInactive::INACTIVE },
            Right: { ActiveInactive::INACTIVE }
,
            EndPositionLeftDetected_value: false,
            EndPositionRightDetected_value: false,
            CommandedLeft_value: false,
            CommandedRight_value: false
        }
    }

    pub fn EndPositionLeftDetected(&self, ctx: &EvalContext, now: timestamp) -> bool {
        (match (Some(ctx.Point_SCIP.get(&self.entity.name).unwrap().DetectedEndPosition), Some(Triggerable::Triggered(EulynxEndPosition::LEFT))) {
    (Some(l), Some(r)) => Some(l == r),
    _ => None
  }).unwrap_or(false)
    }

    pub fn EndPositionRightDetected(&self, ctx: &EvalContext, now: timestamp) -> bool {
        (match (Some(ctx.Point_SCIP.get(&self.entity.name).unwrap().DetectedEndPosition), Some(Triggerable::Triggered(EulynxEndPosition::RIGHT))) {
    (Some(l), Some(r)) => Some(l == r),
    _ => None
  }).unwrap_or(false)
    }

    pub fn CommandedLeft(&self, ctx: &EvalContext, now: timestamp) -> bool {
        (match (Some(ctx.Point.get(&self.entity.name).unwrap().State), Some(PointState::LEFT)) {
    (Some(l), Some(r)) => Some(l == r),
    _ => None
  }).unwrap_or(false)
    }

    pub fn CommandedRight(&self, ctx: &EvalContext, now: timestamp) -> bool {
        (match (Some(ctx.Point.get(&self.entity.name).unwrap().State), Some(PointState::RIGHT)) {
    (Some(l), Some(r)) => Some(l == r),
    _ => None
  }).unwrap_or(false)
    }
}

impl Graph for PointControlStateMachine {
    fn evaluate_terms(&mut self, ctx: &EvalContext, now: timestamp) {
        self.EndPositionLeftDetected_value = self.EndPositionLeftDetected(ctx, now);
        self.EndPositionRightDetected_value = self.EndPositionRightDetected(ctx, now);
        self.CommandedLeft_value = self.CommandedLeft(ctx, now);
        self.CommandedRight_value = self.CommandedRight(ctx, now);
    }

    fn transition(&mut self, now: timestamp) {
        self.__state = self.transition_root(self.__state.clone(), now);
    }
}


#[derive(Debug, Clone, PartialEq, Eq)]
pub enum root_State {
    __initial,
    CONTROLLED_LEFT,
    CONTROLLED_RIGHT,
    NOT_CONTROLLED
}

impl PointControlStateMachine {
    fn transition_from_root___initial(&mut self, now: timestamp) -> root_State {
        if self.EndPositionLeftDetected_value {
            self.Left = ActiveInactive::ACTIVE;
            self.Right = ActiveInactive::INACTIVE;
                        web_sys::console::log_1(&format!("PointControl({})=CONTROLLED_LEFT", self.entity.name).into());
            return root_State::CONTROLLED_LEFT; }
        if self.EndPositionRightDetected_value {
            self.Right = ActiveInactive::ACTIVE;
            self.Left = ActiveInactive::INACTIVE;
                        web_sys::console::log_1(&format!("PointControl({})=CONTROLLED_RIGHT", self.entity.name).into());
            return root_State::CONTROLLED_RIGHT; }
                    self.Left = ActiveInactive::INACTIVE;
            self.Right = ActiveInactive::INACTIVE;
                    web_sys::console::log_1(&format!("PointControl({})=NOT_CONTROLLED", self.entity.name).into());
        return root_State::NOT_CONTROLLED;
    }

    fn transition_from_root_CONTROLLED_LEFT(&mut self, now: timestamp) -> root_State {
        if !(self.EndPositionLeftDetected_value) || !(self.CommandedLeft_value) {
            self.Left = ActiveInactive::INACTIVE;
            self.Right = ActiveInactive::INACTIVE;
                        web_sys::console::log_1(&format!("PointControl({})=NOT_CONTROLLED", self.entity.name).into());
            return root_State::NOT_CONTROLLED; }
        root_State::CONTROLLED_LEFT
    }

    fn transition_from_root_CONTROLLED_RIGHT(&mut self, now: timestamp) -> root_State {
        if !(self.EndPositionRightDetected_value) || !(self.CommandedRight_value) {
            self.Left = ActiveInactive::INACTIVE;
            self.Right = ActiveInactive::INACTIVE;
                        web_sys::console::log_1(&format!("PointControl({})=NOT_CONTROLLED", self.entity.name).into());
            return root_State::NOT_CONTROLLED; }
        root_State::CONTROLLED_RIGHT
    }

    fn transition_from_root_NOT_CONTROLLED(&mut self, now: timestamp) -> root_State {
        if self.EndPositionLeftDetected_value && self.CommandedLeft_value {
            self.Left = ActiveInactive::ACTIVE;
            self.Right = ActiveInactive::INACTIVE;
                        web_sys::console::log_1(&format!("PointControl({})=CONTROLLED_LEFT", self.entity.name).into());
            return root_State::CONTROLLED_LEFT; }
        if self.EndPositionRightDetected_value && self.CommandedRight_value {
            self.Right = ActiveInactive::ACTIVE;
            self.Left = ActiveInactive::INACTIVE;
                        web_sys::console::log_1(&format!("PointControl({})=CONTROLLED_RIGHT", self.entity.name).into());
            return root_State::CONTROLLED_RIGHT; }
        root_State::NOT_CONTROLLED
    }

    fn transition_root(&mut self, state: root_State, now: timestamp) -> root_State {
        // Performs a state transition if possible
        match state {
            root_State::__initial => { self.transition_from_root___initial(now) }
            root_State::CONTROLLED_LEFT => { self.transition_from_root_CONTROLLED_LEFT(now) }
            root_State::CONTROLLED_RIGHT => { self.transition_from_root_CONTROLLED_RIGHT(now) }
            root_State::NOT_CONTROLLED => { self.transition_from_root_NOT_CONTROLLED(now) }
        }
    }
}
