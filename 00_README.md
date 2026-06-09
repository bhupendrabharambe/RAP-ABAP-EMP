# ZEMPLOYEE RAP Stack — Deployment Guide

## Object Creation Order

Create objects in ADT (Eclipse) in this exact sequence to avoid activation errors:

| # | File | Object Type | Name |
|---|------|-------------|------|
| 1 | `01_ZEMPLOYEE_table.ddls.asddls` | Database Table | `ZEMPLOYEE` |
| 2 | `02_ZI_EMPLOYEE.ddls.asddls` | CDS View Entity | `ZI_EMPLOYEE` |
| 3 | `03_ZI_EMPLOYEE.behavior.asbdef` | Behavior Definition | `ZI_EMPLOYEE` (managed) |
| 4 | `04_ZBP_I_EMPLOYEE.clas.abap` | Behavior Implementation | `ZBP_I_EMPLOYEE` |
| 5 | `05_ZC_EMPLOYEE.ddls.asddls` | CDS View Entity | `ZC_EMPLOYEE` |
| 6 | `06_ZC_EMPLOYEE.behavior.asbdef` | Behavior Definition | `ZC_EMPLOYEE` (projection) |
| 7 | `07_ZSD_EMPLOYEE.srvd.asrvd` | Service Definition | `ZSD_EMPLOYEE` |
| 8 | Service Binding (via UI) | Service Binding | `ZSB_EMPLOYEE` |

---

## Step-by-step in ADT

### 1. Database Table
- Right-click package → New → Other ABAP Repository Object → Dictionary → Database Table
- Name: `ZEMPLOYEE`
- Paste content from file 01

### 2. Interface CDS View
- New → Other → Core Data Services → Data Definition
- Name: `ZI_EMPLOYEE`, Template: **Define Root View Entity**
- Paste content from file 02

### 3. Behavior Definition (Interface)
- New → Other → Core Data Services → Behavior Definition
- Source view: `ZI_EMPLOYEE`, Type: **Managed**
- Paste content from file 03

### 4. Behavior Implementation
- The behavior definition will prompt to create the class `ZBP_I_EMPLOYEE`
- In the generated class, add the local handler and saver classes from file 04
- The local classes go in the **Local Types** include

### 5. Projection CDS View
- New → Data Definition
- Name: `ZC_EMPLOYEE`, Template: **Define Transactional Query**
- Paste content from file 05

### 6. Projection Behavior Definition
- New → Behavior Definition
- Source view: `ZC_EMPLOYEE`, Type: **Projection**
- Paste content from file 06

### 7. Service Definition
- New → Other → Business Services → Service Definition
- Name: `ZSD_EMPLOYEE`
- Paste content from file 07

### 8. Service Binding
- New → Other → Business Services → Service Binding
- Name: `ZSB_EMPLOYEE`
- Binding Type: **OData V4 - UI**
- Service Definition: `ZSD_EMPLOYEE`
- Click **Publish** → Click **Preview** to test in Fiori Elements

---

## Features Included

- ✅ Full CRUD (Create, Read, Update, Delete)
- ✅ Field validations: email format, hire date
- ✅ Determination: sets `IsActive = true` and default salary on create
- ✅ Custom actions: `Activate Employee` / `Deactivate Employee`
- ✅ Fiori UI annotations: list report, object page, field groups
- ✅ Criticality coloring for IsActive field (green/red)
- ✅ ETag-based optimistic locking
- ✅ Admin fields: CreatedBy, CreatedAt, LastChangedBy, LastChangedAt

---

## Notes

- The `ZBP_I_EMPLOYEE` class uses **local classes** (handler + saver) per RAP convention.
- All `@Semantics` annotations on the CDS view enable automatic ETag / admin field population by the RAP framework.
- For draft-enabled scenarios, uncomment the draft lines in the behavior definition and add `with draft;` to the table definition.
- Package: use a Z-package with a transport request for development.
