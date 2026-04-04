Start from the data. When designing a new component, define the data structures and their invariants first, then derive the algorithms that operate on them. Don't design algorithms in the abstract and bolt data on afterward.

Associate behavior with the types that own the data. Prefer `DocumentSymbol::from_ast(&node)` over `extract_document_symbol(&node)`, and `ModuleIndex::update(file, ast)` over `update_module_index(&mut map, file, ast)`. If a function's first instinct is to reach into a struct's fields, it probably belongs on that struct.

Think carefully about abstraction layers. Each layer should have a clear responsibility and a well-defined boundary with the layers above and below it. Don't leak implementation details across layers unless there's a compelling reason — and if there is, document why. New code should slot cleanly into the existing layer structure rather than introducing ad-hoc shortcuts between them.

Prefer explicit error types over stringly-typed errors or catch-all wrappers in library code. In Rust, use `thiserror` for defining error enums and reserve `anyhow` for binary entry points and scripts where structured handling isn't needed.

Write unit tests when building new modules or when adding non-trivial logic to code that already has tests. Tests should exercise behavior and invariants, not implementation details. If a function has interesting edge cases, branching, or state transitions, it needs tests.

When building new modules or public APIs, document them from the perspective of someone trying to use the API — what it does, when to call it, what the inputs and outputs mean. Don't explain internal implementation details unless they're essential for correct usage. Keep doc comments concise; a one-liner plus a short example is usually better than a wall of text.

Don't use section headers in code comments or doc comments. Write prose, not outlines.

Use the type system to make invalid states unrepresentable. Prefer enums over boolean flags, newtypes over raw primitives for domain concepts, and builder patterns or dedicated constructors over partially-initialized structs. If a bad state can't be constructed, it doesn't need to be tested or handled.

Be conservative with dependencies. Every new dependency is a long-term maintenance commitment. Justify additions by what they bring that can't be done simply in-house. Prefer well-maintained, focused libraries over kitchen-sink frameworks.

After writing code and before presenting it, review it as a distinguished engineer would review a junior's PR. Look for unclear ownership, leaky abstractions, naming that doesn't carry its weight, unnecessary generality, or missing edge case handling. If something deserves a refactor, do it — don't flag it and leave it for later — unless I've specifically asked for the code a certain way.

When naming things, be precise and domain-specific. A name should tell you what something *is* in the problem domain, not how it's implemented. Prefer `FileOwnership` over `FileMap`, `ResolutionScope` over `LookupContext`. Avoid generic suffixes like `Manager`, `Handler`, `Helper`, or `Utils`.
