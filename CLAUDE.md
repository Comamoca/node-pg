# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

`node_pg` is a Gleam wrapper around the Node.js `pg` (node-postgres) library, providing PostgreSQL database access for Gleam applications targeting JavaScript runtime. The project uses Bun as the JavaScript runtime.

## Development Commands

### Running and Testing
```sh
gleam run          # Run the project
gleam test         # Run all tests (mock-based only, no database required)
gleam build        # Build the project
```

**Important:** All tests use mock-based FFI helpers in `src/ffi.mjs`. No real PostgreSQL connection is required. Tests are fast, deterministic, and run entirely within gleeunit.

### Nix Development Environment
This project uses Nix with devenv for development environment management:
```sh
nix develop        # Enter the development shell
direnv allow       # If using direnv (recommended)
```

The flake provides:
- Gleam (latest version via gleam-overlay)
- Erlang runtime
- gleam2nix for dependency management
- Pre-commit hooks (treefmt, gitleaks, gitlint)

## Architecture

### FFI Integration Pattern
This project bridges Gleam with JavaScript using Gleam's Foreign Function Interface (FFI). The main pattern is:
- Gleam functions in `src/node_pg.gleam` declare external JavaScript implementations
- JavaScript implementations interact with the `pg` npm package
- Type mappings between Gleam and JavaScript/TypeScript types

### PostgreSQL Client Design
The wrapper models the node-postgres Client API:
- `Client` instances are created via `new Client(config: Config)`
- `Config` type contains connection parameters (user, password, host, port, database, etc.)
- Environment variables are used as defaults (PGUSER, PGPASSWORD, PGHOST, PGPORT, PGDATABASE)
- Supports connection strings, SSL configuration, timeouts, and custom type parsers

Reference: https://node-postgres.com/apis/client

### Testing Strategy
- **Mock-based tests** (Gleam): Use `gleeunit` framework with FFI mock helpers
  - Test files must end with `_test.gleam` suffix
  - Entry point: `test/node_pg_test.gleam`
  - Test coverage:
    - Type safety and FFI boundary correctness (`client_test.gleam`, `types_test.gleam`, `conversion_test.gleam`, `ffi_helpers_test.gleam`)
    - Query execution logic with mock responses (`query_execution_test.gleam`)
    - Error handling with mock exceptions (`error_handling_test.gleam`)
    - DML operations with mock results (`dml_operations_test.gleam`)
    - Async operations with mock Promise resolution (`async_operations_test.gleam`)
  - All tests use mock functions in `src/ffi.mjs` - no real database connection required
  - Fast, deterministic, and suitable for CI/CD environments

## Key Dependencies
- `gleam_stdlib`: Core Gleam standard library
- `pg` (npm): Node.js PostgreSQL client (^8.16.3)
- `gleeunit`: Testing framework (dev dependency)

## Important Notes
- Target runtime is JavaScript (Bun), not Erlang/BEAM
- The project is in early development - main implementation is minimal
- Follow Gleam's external function guidelines: https://gleam.run/documentation/externals/


# AI-DLC and Spec-Driven Development

Kiro-style Spec Driven Development implementation on AI-DLC (AI Development Life Cycle)

## Project Context

### Paths
- Steering: `.kiro/steering/`
- Specs: `.kiro/specs/`

### Steering vs Specification

**Steering** (`.kiro/steering/`) - Guide AI with project-wide rules and context
**Specs** (`.kiro/specs/`) - Formalize development process for individual features

### Active Specifications
- Check `.kiro/specs/` for active specifications
- Use `/kiro:spec-status [feature-name]` to check progress

## Development Guidelines
- Think in English, generate responses in Japanese. All Markdown content written to project files (e.g., requirements.md, design.md, tasks.md, research.md, validation reports) MUST be written in the target language configured for this specification (see spec.json.language).

## Minimal Workflow
- Phase 0 (optional): `/kiro:steering`, `/kiro:steering-custom`
- Phase 1 (Specification):
  - `/kiro:spec-init "description"`
  - `/kiro:spec-requirements {feature}`
  - `/kiro:validate-gap {feature}` (optional: for existing codebase)
  - `/kiro:spec-design {feature} [-y]`
  - `/kiro:validate-design {feature}` (optional: design review)
  - `/kiro:spec-tasks {feature} [-y]`
- Phase 2 (Implementation): `/kiro:spec-impl {feature} [tasks]`
  - `/kiro:validate-impl {feature}` (optional: after implementation)
- Progress check: `/kiro:spec-status {feature}` (use anytime)

## Development Rules
- 3-phase approval workflow: Requirements → Design → Tasks → Implementation
- Human review required each phase; use `-y` only for intentional fast-track
- Keep steering current and verify alignment with `/kiro:spec-status`
- Follow the user's instructions precisely, and within that scope act autonomously: gather the necessary context and complete the requested work end-to-end in this run, asking questions only when essential information is missing or the instructions are critically ambiguous.

## Steering Configuration
- Load entire `.kiro/steering/` as project memory
- Default files: `product.md`, `tech.md`, `structure.md`
- Custom files are supported (managed via `/kiro:steering-custom`)
