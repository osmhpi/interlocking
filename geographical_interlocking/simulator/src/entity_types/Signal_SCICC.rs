// Auto-generated Rust interface for entity type-related interface ports

use crate::{configuration_types::*, enums::*, eval_context::EvalContext, triggerable::Triggerable};

#[derive(Clone)]
pub struct Signal_SCICCStruct {
    pub entity: EntitiesSignalItem,
    pub SignalOpen: bool, // output
}

impl Signal_SCICCStruct {
    pub fn new(entity: EntitiesSignalItem) -> Self {
        Self {
            entity,
            SignalOpen: false,
        }
    }
    pub fn complete_cycle(&mut self, ctx: &EvalContext) {
        self.SignalOpen = false;
        if (match (Some(ctx.SignalControl.get(&self.entity.name).unwrap().State), Some(OpenCloseState::OPEN)) {
    (Some(l), Some(r)) => Some(l == r),
    _ => None
  }).unwrap_or(false) {
            self.SignalOpen = true;
        }
        if (match (Some(ctx.SignalControl.get(&self.entity.name).unwrap().State), Some(OpenCloseState::OPEN)) {
    (Some(l), Some(r)) => Some(l != r),
    _ => None
  }).unwrap_or(false) {
            self.SignalOpen = false;
        }
    }
}
