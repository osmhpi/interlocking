// Auto-generated Rust interface for entity type-related interface ports

use crate::{configuration_types::*, enums::*, eval_context::EvalContext, triggerable::Triggerable};

#[derive(Clone)]
pub struct Transit_SCICCStruct {
    pub entity: EntitiesTransitItem,
    pub Active: bool, // output
}

impl Transit_SCICCStruct {
    pub fn new(entity: EntitiesTransitItem) -> Self {
        Self {
            entity,
            Active: false,
        }
    }
    pub fn complete_cycle(&mut self, ctx: &EvalContext) {
        self.Active = false;
        if (match (Some(ctx.Transit.get(&self.entity.name).unwrap().State), Some(ActiveInactive::ACTIVE)) {
    (Some(l), Some(r)) => Some(l == r),
    _ => None
  }).unwrap_or(false) {
            self.Active = true;
        }
        if (match (Some(ctx.Transit.get(&self.entity.name).unwrap().State), Some(ActiveInactive::ACTIVE)) {
    (Some(l), Some(r)) => Some(l != r),
    _ => None
  }).unwrap_or(false) {
            self.Active = false;
        }
    }
}
