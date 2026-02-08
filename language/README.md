# Interlocking Software Design Language

In this framework, the software behavior of railway interlocking logic is encoded in a collection of interpretation-free state machine diagrams.
The syntax and semantics of the builtin boolean expression language is well-defined and the order in which transitions are evaluated is explicitly specified.
Moreover, state machine instances can exchange information by using variables.
The evaluation order of state machines is given by an evaluation schedule.
This uniquely defines the semantics of possible circular references between state machines.

A powerful system exists to parameterize the generic state machine logic for specific railway interlocking systems.
Entity types, system interfaces and enumeration data types build the framework for parameterization.

## State Machine Graphs

The following image shows a graphical representation of the [point](../locking_table_interlocking/generic_application/graphs/point.puml) graph.

![Point State Machine Graph](../locking_table_interlocking/generic_application/graphs/point.svg)

A graph has a single initial state.
Transitions are checked in the order that is given by the transition priority (`[1]`, `[2]`, `[3]`, etc.), from lowest to highest.
A transition without a guard condition must always have the highest priority number.
Within a transition guard condition, terms may be connected using `&&` (conjunction), `||` (disjunction) and `!` (negation) operators.
State machine graphs may use nested state machine graphs.
The evaluation order of nested state machine graphs is inside-out.
Each nested state machine graph again has a single initial state.
In each invocation of a state machine by the scheduler, only a single transition (or none) is taken on a given state machine level (cf. Execution Model).
The use of choice pseudo-states is allowed and presents an exception to this rule.
When taking a transition, the state machine enters the target state, and any provided variable assignment statements are executed top to bottom.

Each graph is accompanied by a [terms definition file](../locking_table_interlocking/generic_application/graphs/point.terms.yaml), which provides a boolean expression for each of the identifiers that are used as part of the transition guards.
As part of boolean expressions, quantifier expressions (`All`, `Any`) allow operating with value sets.
The `All` expression evaluates to true, iff all elements within the set equal to the provided expression value.
`All` evaluates to false if the set is empty.
The `Any` expression evaluates to true, iff any element within the set equals the provided expression value.
`Any` evaluates to true if the set is empty.
If an expression references an optional value (e.g., property with min/max cardinality 0/1) that is not set, the entire term is not computed further and the specified default value is used instead.

## Execution Model

The overall application assumes a sequential, deterministic, cyclic execution model with *synchronous* semantics.
This means that the system does not respond asynchronously to external events.
Instead, inputs from the environment are synchronized and stored at the beginning of an execution cycle (including the system time) and do not change during the evaluation of one cycle.
Similarly, any outputs of the system are only propagated to the environment at the end of an execution cycle.
The simulators contained in this repository assume a cycle period of 150 milliseconds.

```
 |                                                                    |
 |  +----------+   +-------+   +--------+   +--------+   +----------+ |  +----------+
 |  |Get Input |-->|Read   |-->|IXL     |...|IXL     |-->|Propagate | |  |Get Input |
 |  |Data      |   |Clock  |   |Graph #1|   |Graph #N|   |Outputs   | |  |Data      |
 |  +----------+   +-------+   +--------+   +--------+   +----------+ |  +----------+
-+--------------------------------------------------------------------+----------------> Time
 | Start                                                              | Start
   Cycle 1                                                              Cycle 2
```

