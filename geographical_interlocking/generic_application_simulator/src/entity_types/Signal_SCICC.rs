// Auto-generated Rust interface for entity type-related interface ports

use crate::{configuration_types::*, enums::*, eval_context::EvalContext, triggerable::Triggerable};

#[derive(Clone)]
#[allow(non_snake_case)]
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
    #[allow(unused_variables)]
    pub fn complete_cycle(&mut self, ctx: &EvalContext) {
        self.SignalOpen = false;
        if (match (Some(ctx.Signal.get(&self.entity.name).unwrap().State), Some(OpenCloseState::OPEN)) {
    (Some(l), Some(r)) => Some(l == r),
    _ => None
  }).unwrap_or(false) {
            self.SignalOpen = true;
        }
        if (match (Some(ctx.Signal.get(&self.entity.name).unwrap().State), Some(OpenCloseState::OPEN)) {
    (Some(l), Some(r)) => Some(l != r),
    _ => None
  }).unwrap_or(false) {
            self.SignalOpen = false;
        }
    }
}
