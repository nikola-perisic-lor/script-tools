# Local automation & code quality scripts

This repository contains several Bash scripts designed to maintain high code quality standards and automate boilerplate code generation.

## Quick overview

These scripts help developers audit their code locally for common issues (like 'any' types, console logs, or oversized files) and speed up the creation of new features by generating a standardized folder structure.

---

## Script details 🛠

| Script file | Purpose |
| :--- | :--- |
| `check-any-typescript-usages.sh` | Scans the `src` directory for the use of the `any` type in TypeScript |
| `check-console-logs.sh` | Scans for `console.log` statements (excluding commented-out lines) |
| `check-empty-files.sh` | Identifies any empty files within the source directory |
| `check-file-length.sh` | Warns if any `.ts` or `.tsx` file exceeds **400 lines** |
| `generate-feature.sh` | Scaffolds a complete feature directory (API, components, hooks, types, etc.) |
| `runner.sh` | Orchestrates all health checks and provides a formatted summary |


### Local GIT privacy
The following script is intended to be executed **only once** upon setup. It ensures your local automation tools remain private to your machine.

`ignore-scripts-folder.sh` | Uses `.git/info/exclude` to stop Git from tracking the `scripts/` folder locally

---

## Setup and usage ⚙️

### 1. Add scripts to package.json
Open your `package.json` and add the following to the `scripts` object:

```json
"scripts": {
  "checks": "bash scripts/runner.sh",
  "gen:feature": "bash scripts/generate-feature.sh"
}
```

### 2. Move scripts folder from repository to the root of the frontend project

### 3. Usage

####  TO RUN CHECKS:

```sh
npm run checks
```

#### TO GENERATE A NEW FEATURE:

```sh
npm run gen:feature YourEntityName
```

---

## Permissions

If you encounter a "permission denied" error when running the scripts, grant execution rights using:

```sh
chmod +x scripts/*.sh
```

### Additional note: Do not push `package.json` file!