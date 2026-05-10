
    // Auto-generated Rust state machine for PointOperation

use web_sys;
use crate::{configuration_types::*, enums::*, eval_context::EvalContext, graph::Graph, triggerable::Triggerable, timestamp::timestamp};

#[derive(Clone)]
pub struct PointOperationStateMachine {
    __state: root_State,
    pub entity: EntitiesPointItem,
    pub PreviousPointState: PointState,
    pub Top: ActiveInactive,
    pub TopStart: timestamp,
    pub State: EulynxCommandedEndPosition,
    pub PointTriggered_value: bool,
    pub PointLeft_value: bool,
    pub PointRight_value: bool,
    pub IsTop_value: bool,
    pub TopTimeout_value: bool,
}

impl PointOperationStateMachine {
    pub fn new(entity: EntitiesPointItem) -> Self {
        Self {
            __state: root_State::__initial,
            entity,
            PreviousPointState: { PointState::UNDETERMINED },
            Top: { ActiveInactive::ACTIVE },
            TopStart: { timestamp { milliseconds: None } },
            State: { EulynxCommandedEndPosition::NOT_COMMANDED }
,
            PointTriggered_value: false,
            PointLeft_value: false,
            PointRight_value: false,
            IsTop_value: false,
            TopTimeout_value: false
        }
    }

    pub fn PointTriggered(&self, ctx: &EvalContext, now: timestamp) -> bool {
        (match ((match (match (match (Some(ctx.Point.get(&self.entity.name).unwrap().State), Some(PointState::LEFT)) {
    (Some(l), Some(r)) => Some(l == r),
    _ => None
  }, match (Some(self.PreviousPointState), Some(PointState::LEFT)) {
    (Some(l), Some(r)) => Some(l != r),
    _ => None
  }) {
    (Some(a), Some(b)) => Some(a && b),
    _ => None
  }, match (Some(ctx.Point_SCIP.get(&self.entity.name).unwrap().DetectedEndPosition), Some(Triggerable::Triggered(EulynxEndPosition::LEFT))) {
    (Some(l), Some(r)) => Some(l != r),
    _ => None
  }) {
    (Some(a), Some(b)) => Some(a && b),
    _ => None
  }), (match (match (match (Some(ctx.Point.get(&self.entity.name).unwrap().State), Some(PointState::RIGHT)) {
    (Some(l), Some(r)) => Some(l == r),
    _ => None
  }, match (Some(self.PreviousPointState), Some(PointState::RIGHT)) {
    (Some(l), Some(r)) => Some(l != r),
    _ => None
  }) {
    (Some(a), Some(b)) => Some(a && b),
    _ => None
  }, match (Some(ctx.Point_SCIP.get(&self.entity.name).unwrap().DetectedEndPosition), Some(Triggerable::Triggered(EulynxEndPosition::RIGHT))) {
    (Some(l), Some(r)) => Some(l != r),
    _ => None
  }) {
    (Some(a), Some(b)) => Some(a && b),
    _ => None
  })) {
    (Some(a), Some(b)) => Some(a || b),
    _ => None
  }).unwrap_or(false)
    }

    pub fn PointLeft(&self, ctx: &EvalContext, now: timestamp) -> bool {
        (match (Some(ctx.Point.get(&self.entity.name).unwrap().State), Some(PointState::LEFT)) {
    (Some(l), Some(r)) => Some(l == r),
    _ => None
  }).unwrap_or(false)
    }

    pub fn PointRight(&self, ctx: &EvalContext, now: timestamp) -> bool {
        (match (Some(ctx.Point.get(&self.entity.name).unwrap().State), Some(PointState::RIGHT)) {
    (Some(l), Some(r)) => Some(l == r),
    _ => None
  }).unwrap_or(false)
    }

    pub fn IsTop(&self, ctx: &EvalContext, now: timestamp) -> bool {
        (Some(self.entity.all_points.iter().all(|name| ctx.PointOperation.get(name).unwrap().Top == ActiveInactive::ACTIVE))).unwrap_or(false)
    }

    pub fn TopTimeout(&self, ctx: &EvalContext, now: timestamp) -> bool {
        (match (Some(self.TopStart).unwrap_or(timestamp { milliseconds: None }).milliseconds, Some(300)) {
    (Some(t), Some(d)) => Some(now.milliseconds.unwrap_or(0) >= t + d as u64),
    _ => None
  }).unwrap_or(false)
    }
}

impl Graph for PointOperationStateMachine {
    fn evaluate_terms(&mut self, ctx: &EvalContext, now: timestamp) {
        self.PointTriggered_value = self.PointTriggered(ctx, now);
        self.PointLeft_value = self.PointLeft(ctx, now);
        self.PointRight_value = self.PointRight(ctx, now);
        self.IsTop_value = self.IsTop(ctx, now);
        self.TopTimeout_value = self.TopTimeout(ctx, now);
    }

    fn transition(&mut self, now: timestamp) {
        self.__state = self.transition_root(self.__state.clone(), now);
    }
}


#[derive(Debug, Clone, PartialEq, Eq)]
pub enum root_State {
    __initial,
    IDLE_LEFT,
    IDLE_RIGHT,
    IDLE_UNDETERMINED,
    WAITING_COMMAND_RIGHT,
    WAITING_COMMAND_LEFT,
    TOP_COMMAND_LEFT,
    TOP_COMMAND_RIGHT,
    DELAY_TOP
}

impl PointOperationStateMachine {
    fn transition_from_root___initial(&mut self, now: timestamp) -> root_State {
        if self.PointLeft_value {
            self.PreviousPointState = PointState::LEFT;
            self.Top = ActiveInactive::ACTIVE;
            self.State = EulynxCommandedEndPosition::NOT_COMMANDED;
                        web_sys::console::log_1(&format!("PointOperation({})=IDLE_LEFT", self.entity.name).into());
            return root_State::IDLE_LEFT; }
        if self.PointRight_value {
            self.PreviousPointState = PointState::RIGHT;
            self.Top = ActiveInactive::ACTIVE;
            self.State = EulynxCommandedEndPosition::NOT_COMMANDED;
                        web_sys::console::log_1(&format!("PointOperation({})=IDLE_RIGHT", self.entity.name).into());
            return root_State::IDLE_RIGHT; }
                    self.PreviousPointState = PointState::UNDETERMINED;
            self.Top = ActiveInactive::ACTIVE;
            self.State = EulynxCommandedEndPosition::NOT_COMMANDED;
                    web_sys::console::log_1(&format!("PointOperation({})=IDLE_UNDETERMINED", self.entity.name).into());
        return root_State::IDLE_UNDETERMINED;
    }

    fn transition_from_root_IDLE_LEFT(&mut self, now: timestamp) -> root_State {
        if self.PointTriggered_value {
            self.PreviousPointState = PointState::RIGHT;
            self.Top = ActiveInactive::ACTIVE;
                        web_sys::console::log_1(&format!("PointOperation({})=WAITING_COMMAND_RIGHT", self.entity.name).into());
            return root_State::WAITING_COMMAND_RIGHT; }
        root_State::IDLE_LEFT
    }

    fn transition_from_root_IDLE_RIGHT(&mut self, now: timestamp) -> root_State {
        if self.PointTriggered_value {
            self.PreviousPointState = PointState::LEFT;
            self.Top = ActiveInactive::ACTIVE;
                        web_sys::console::log_1(&format!("PointOperation({})=WAITING_COMMAND_LEFT", self.entity.name).into());
            return root_State::WAITING_COMMAND_LEFT; }
        root_State::IDLE_RIGHT
    }

    fn transition_from_root_IDLE_UNDETERMINED(&mut self, now: timestamp) -> root_State {
        if self.PointTriggered_value && self.PointRight_value {
            self.PreviousPointState = PointState::RIGHT;
            self.Top = ActiveInactive::ACTIVE;
                        web_sys::console::log_1(&format!("PointOperation({})=WAITING_COMMAND_RIGHT", self.entity.name).into());
            return root_State::WAITING_COMMAND_RIGHT; }
        if self.PointTriggered_value && self.PointLeft_value {
            self.PreviousPointState = PointState::LEFT;
            self.Top = ActiveInactive::ACTIVE;
                        web_sys::console::log_1(&format!("PointOperation({})=WAITING_COMMAND_LEFT", self.entity.name).into());
            return root_State::WAITING_COMMAND_LEFT; }
        root_State::IDLE_UNDETERMINED
    }

    fn transition_from_root_WAITING_COMMAND_RIGHT(&mut self, now: timestamp) -> root_State {
        if self.IsTop_value {
            self.Top = ActiveInactive::INACTIVE;
            self.TopStart = now;
            self.State = EulynxCommandedEndPosition::RIGHT;
                        web_sys::console::log_1(&format!("PointOperation({})=TOP_COMMAND_RIGHT", self.entity.name).into());
            return root_State::TOP_COMMAND_RIGHT; }
        if self.PointTriggered_value {
            self.PreviousPointState = PointState::LEFT;
            self.Top = ActiveInactive::ACTIVE;
            self.State = EulynxCommandedEndPosition::NOT_COMMANDED;
                        web_sys::console::log_1(&format!("PointOperation({})=IDLE_LEFT", self.entity.name).into());
            return root_State::IDLE_LEFT; }
        root_State::WAITING_COMMAND_RIGHT
    }

    fn transition_from_root_WAITING_COMMAND_LEFT(&mut self, now: timestamp) -> root_State {
        if self.IsTop_value {
            self.Top = ActiveInactive::INACTIVE;
            self.TopStart = now;
            self.State = EulynxCommandedEndPosition::LEFT;
                        web_sys::console::log_1(&format!("PointOperation({})=TOP_COMMAND_LEFT", self.entity.name).into());
            return root_State::TOP_COMMAND_LEFT; }
        if self.PointTriggered_value {
            self.PreviousPointState = PointState::RIGHT;
            self.Top = ActiveInactive::ACTIVE;
            self.State = EulynxCommandedEndPosition::NOT_COMMANDED;
                        web_sys::console::log_1(&format!("PointOperation({})=IDLE_RIGHT", self.entity.name).into());
            return root_State::IDLE_RIGHT; }
        root_State::WAITING_COMMAND_LEFT
    }

    fn transition_from_root_TOP_COMMAND_LEFT(&mut self, now: timestamp) -> root_State {
                    self.Top = ActiveInactive::INACTIVE;
            self.State = EulynxCommandedEndPosition::NOT_COMMANDED;
                    web_sys::console::log_1(&format!("PointOperation({})=DELAY_TOP", self.entity.name).into());
        return root_State::DELAY_TOP;
        root_State::TOP_COMMAND_LEFT
    }

    fn transition_from_root_TOP_COMMAND_RIGHT(&mut self, now: timestamp) -> root_State {
                    self.Top = ActiveInactive::INACTIVE;
            self.State = EulynxCommandedEndPosition::NOT_COMMANDED;
                    web_sys::console::log_1(&format!("PointOperation({})=DELAY_TOP", self.entity.name).into());
        return root_State::DELAY_TOP;
        root_State::TOP_COMMAND_RIGHT
    }

    fn transition_from_root_DELAY_TOP(&mut self, now: timestamp) -> root_State {
        if self.TopTimeout_value && self.PointLeft_value {
            self.PreviousPointState = PointState::LEFT;
            self.Top = ActiveInactive::ACTIVE;
            self.State = EulynxCommandedEndPosition::NOT_COMMANDED;
                        web_sys::console::log_1(&format!("PointOperation({})=IDLE_LEFT", self.entity.name).into());
            return root_State::IDLE_LEFT; }
        if self.TopTimeout_value && self.PointRight_value {
            self.PreviousPointState = PointState::RIGHT;
            self.Top = ActiveInactive::ACTIVE;
            self.State = EulynxCommandedEndPosition::NOT_COMMANDED;
                        web_sys::console::log_1(&format!("PointOperation({})=IDLE_RIGHT", self.entity.name).into());
            return root_State::IDLE_RIGHT; }
        if self.TopTimeout_value {
            self.PreviousPointState = PointState::UNDETERMINED;
            self.Top = ActiveInactive::ACTIVE;
            self.State = EulynxCommandedEndPosition::NOT_COMMANDED;
                        web_sys::console::log_1(&format!("PointOperation({})=IDLE_UNDETERMINED", self.entity.name).into());
            return root_State::IDLE_UNDETERMINED; }
        root_State::DELAY_TOP
    }

    fn transition_root(&mut self, state: root_State, now: timestamp) -> root_State {
        // Performs a state transition if possible
        match state {
            root_State::__initial => { self.transition_from_root___initial(now) }
            root_State::IDLE_LEFT => { self.transition_from_root_IDLE_LEFT(now) }
            root_State::IDLE_RIGHT => { self.transition_from_root_IDLE_RIGHT(now) }
            root_State::IDLE_UNDETERMINED => { self.transition_from_root_IDLE_UNDETERMINED(now) }
            root_State::WAITING_COMMAND_RIGHT => { self.transition_from_root_WAITING_COMMAND_RIGHT(now) }
            root_State::WAITING_COMMAND_LEFT => { self.transition_from_root_WAITING_COMMAND_LEFT(now) }
            root_State::TOP_COMMAND_LEFT => { self.transition_from_root_TOP_COMMAND_LEFT(now) }
            root_State::TOP_COMMAND_RIGHT => { self.transition_from_root_TOP_COMMAND_RIGHT(now) }
            root_State::DELAY_TOP => { self.transition_from_root_DELAY_TOP(now) }
        }
    }
}
