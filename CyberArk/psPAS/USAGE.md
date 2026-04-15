# psPAS Pipeline — User Guide

> This pipeline is under construction. The guide will be written when the workflow stages are built out.

---

## What This Pipeline Will Do

The psPAS pipeline will handle CyberArk vault **changes** — account remediation, bulk updates, and other write operations using the [psPAS PowerShell module](https://pspas.pspete.dev/).

It picks up where the EVD pipeline leaves off. For example, after an EVD compliance audit identifies non-compliant accounts, this pipeline plans and executes the fixes.

## Planned Stages

1. **01_planning** — Review the remediation targets and generate a change plan
2. **02_execution** — Execute the approved changes via psPAS commands

## Prerequisites (expected)

- psPAS PowerShell module installed
- CyberArk PVWA API access with appropriate permissions
- Completed EVD pipeline output (when remediating compliance findings)

---

## Coming Soon

This guide will be fleshed out with step-by-step instructions, examples, and troubleshooting once the pipeline workflow is operational.
