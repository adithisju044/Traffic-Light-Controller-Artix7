# Architecture and FSM

The design is a six-state Moore FSM. North and South share one signal group; East and West share the opposing group.

```text
NS_GREEN -> NS_YELLOW -> ALL_RED_1 -> EW_GREEN
    ^                                  |
    |                                  v
ALL_RED_2 <- EW_YELLOW <----------------+
```

| State | NS R | NS Y | NS G | EW R | EW Y | EW G |
|---|---:|---:|---:|---:|---:|---:|
| NS_GREEN | 0 | 0 | 1 | 1 | 0 | 0 |
| NS_YELLOW | 0 | 1 | 0 | 1 | 0 | 0 |
| ALL_RED_1 | 1 | 0 | 0 | 1 | 0 | 0 |
| EW_GREEN | 1 | 0 | 0 | 0 | 0 | 1 |
| EW_YELLOW | 1 | 0 | 0 | 0 | 1 | 0 |
| ALL_RED_2 | 1 | 0 | 0 | 1 | 0 | 0 |

A counter measures phase duration in FPGA clock cycles. Reset is synchronous, active-high. Both-green cannot occur because only one direction has a green output in any state.
