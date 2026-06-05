# 🚀 Sprint 1: macMLX Support + DevOps Foundations

**Sprint Duration:** 2026-06-05 → 2026-06-19 (10 business days)  
**Sprint Capacity:** 20-25 story points  
**Stories Planned:** 6 user stories (19 points total)

---

## 🎯 Sprint Goal

Enable **macMLX support** for Apple Silicon users and establish **DevOps foundations** (configuration management, Makefile orchestration, script naming conventions).

### Success Criteria

At the end of this sprint, a Mac M1/M2/M3 user can:
- ✅ Start macMLX + LiteLLM with a single command: `make macmlx-start`
- ✅ Bootstrap configuration with `make config` (generates env.sh, env.docker, env.mk from .env)
- ✅ Use standardized script naming following ADR-601 pattern `{object}-{action}.sh`

**Target Outcome:** Seamless local development experience on Apple Silicon with proper DevOps patterns.

---

## 📋 Sprint Backlog

### Epic 1: macMLX Support (7 points)

#### ✅ US-101: Document macMLX installation and configuration (2 pts)
**Status:** ✅ Completed (2026-06-05)

- [x] Create documentation in `docs/litellm-ollama.md`
- [x] Comparison table Ollama vs macMLX
- [x] LiteLLM configuration for port 8080
- [x] Benchmark results (M2 Max: 2x speedup)
- [x] Update `docs/architecture.md`

**Commit:** `b4b5ed9`

#### 🚧 US-102: Create macMLX startup script (3 pts)
**Status:** 🚧 In Progress

- [ ] Create `scripts/macmlx-start.sh`
- [ ] Implement options: `--model`, `--port`, `--verbose`
- [ ] Error handling (macMLX not installed, port occupied)
- [ ] Test with different MLX models

**Dependencies:** None  
**Blockers:** None

#### 📋 US-103: Add Makefile target for macMLX (2 pts)
**Status:** 📋 To Do

- [ ] Add `macmlx-start` target in Makefile
- [ ] Add `macmlx-stop` target
- [ ] Add `macmlx-status` target for health check
- [ ] Update `make help` documentation

**Dependencies:** US-102 (requires `macmlx-start.sh`)  
**ADR:** [ADR-602](docs/adr/602-DEVOPS-makefile-orchestrateur.md) (Makefile patterns)

---

### Epic 2: DevOps Patterns (12 points)

#### 📋 US-201: Implement multi-format configuration bootstrap (5 pts)
**Status:** 📋 To Do

- [ ] Create `scripts/config-bootstrap.sh`
- [ ] Parse `.env` and generate:
  - `env.sh` (Bash source)
  - `env.docker` (Docker Compose format)
  - `env.mk` (Makefile include)
- [ ] Support `.env.user` for local overrides
- [ ] Validation and error messages
- [ ] Tests with various .env files

**ADR:** [ADR-600](docs/adr/600-DEVOPS-bootstrap-configuration-management.md) (Configuration management)

#### 📋 US-202: Create main orchestrator Makefile (5 pts)
**Status:** 📋 To Do

- [ ] Create root `Makefile` with standard targets
- [ ] Implement targets:
  - `setup` (install deps, create venv)
  - `config` (bootstrap configuration)
  - `start` (start all services)
  - `stop` (stop all services)
  - `test` (run tests)
  - `clean` (cleanup temp files)
- [ ] Dependency management (`start` → `config`)
- [ ] Integrated help: `make help`
- [ ] ANSI colors (ADR-605)

**ADR:** [ADR-602](docs/adr/602-DEVOPS-makefile-orchestrateur.md) (3-line rule, colored output)

#### 📋 US-203: Standardize script naming conventions (3 pts)
**Status:** 📋 To Do

- [ ] Audit current scripts in `scripts/`
- [ ] Rename scripts to `{object}-{action}.sh` pattern:
  - `start-ollama.sh` → `ollama-start.sh`
  - `start-litellm.sh` → `litellm-start.sh`
  - `start-local-agent.sh` → `local-agent-start.sh`
  - `check-local-endpoint.sh` → `local-endpoint-check.sh`
  - `check-public-endpoint.sh` → `public-endpoint-check.sh`
- [ ] Update references in Makefile and documentation
- [ ] Post-rename testing
- [ ] Create `scripts/README.md` with script inventory

**ADR:** [ADR-601](docs/adr/601-DEVOPS-nomenclature-scripts.md) (Script naming convention)  
**Dependencies:** US-202 (Makefile will reference renamed scripts)

---

## ✅ Definition of Done

A User Story is considered "Done" when:

- [ ] Code implemented and tested
- [ ] Unit/integration tests pass
- [ ] Documentation updated
- [ ] **ADR compliance verified** (check [`docs/adr/`](docs/adr/) for applicable decisions)
- [ ] Code reviewed and approved
- [ ] Commit follows Conventional Commits (`feat:`, `fix:`, etc.)
- [ ] Deployable to test environment

---

## 📊 Sprint Metrics

| Metric | Target | Current |
|--------|--------|---------|
| **Total Points** | 19 pts | 19 pts |
| **Completed** | 19 pts | 2 pts (10%) |
| **Velocity** | ~2 pts/day | 2 pts/day |
| **Stories Done** | 6/6 (100%) | 1/6 (17%) |

**Burndown Chart:** Track daily in [`docs/scrum/sprints/current-sprint.md`](docs/scrum/sprints/current-sprint.md)

---

## 🔗 References

- **Sprint Planning:** [`docs/scrum/sprints/current-sprint.md`](docs/scrum/sprints/current-sprint.md)
- **Product Backlog:** [`docs/scrum/README.md`](docs/scrum/README.md)
- **Epics:**
  - [EPOP-001: macMLX Support](docs/scrum/backlog/Épopées/EPOP-001-support-macmlx.md)
  - [EPOP-002: DevOps Patterns](docs/scrum/backlog/Épopées/EPOP-002-patterns-devops.md)
- **ADRs:**
  - [ADR-600: Configuration Management](docs/adr/600-DEVOPS-bootstrap-configuration-management.md)
  - [ADR-601: Script Naming Convention](docs/adr/601-DEVOPS-nomenclature-scripts.md)
  - [ADR-602: Makefile Orchestrator](docs/adr/602-DEVOPS-makefile-orchestrateur.md)

---

## ⚠️ Important Principles

> **Respect ADR (Architecture Decision Records)**
> 
> All implementations MUST respect architectural decisions documented in [`docs/adr/`](docs/adr/):
> - Consult relevant ADRs **before** coding
> - Ensure traceability (User Stories reference ADRs in Dependencies section)
> - Create new ADR if needed for new decisions

---

## 📝 Daily Standup Notes

Updates tracked daily in [`docs/scrum/sprints/current-sprint.md`](docs/scrum/sprints/current-sprint.md) under "Daily Notes" section.

---

## 🏁 Sprint Review & Retrospective

**Sprint Review:** 2026-06-19 (demo to stakeholders)  
**Sprint Retrospective:** 2026-06-19 (team reflection)

**Review Checklist:**
- [ ] Demo macMLX startup workflow (`make macmlx-start`)
- [ ] Demo configuration bootstrap (`make config`)
- [ ] Show standardized script naming
- [ ] Review documentation updates
- [ ] Collect feedback for Sprint 2

---

**Labels:** `sprint-1`, `epic-1-macmlx`, `epic-2-devops`, `in-progress`  
**Milestone:** Sprint 1 (2026-06-05 → 2026-06-19)  
**Assignees:** @michel-heon (or team members)
