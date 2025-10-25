# OMSIngestionAPI Migration - Complete Removal

## Overview
**BREAKING CHANGE**: Completely removed OMSIngestionAPI dependencies and migrated to Azure Monitor Data Collection API. This requires new infrastructure deployment before the solution will work.

## Changes Made

### 1. Removed Dependencies
**File**: `/tools/CentralView/requirements.psd1`
- **Removed**: `'OMSIngestionAPI' = '1.6.0'` - No longer used
- **Kept**: `'Az.Monitor' = '5.2.1'` - Required for Data Collection API

**File**: `/setup/IaC/modules/automationaccount.bicep`
- **Removed**: OMSIngestionAPI module deployment from automation account

### 2. Migrated All Data Ingestion Calls
**File**: `/src/Guardrails-Common/GR-Common.psm1`
- **Updated**: `Send-GuardrailsData` function - Now uses Azure Monitor Data Collection API with `Invoke-AzRestMethod`
- **Replaced**: All 6 instances of `Send-OMSAPIIngestionFile` with `Send-GuardrailsData`
- **Authentication**: Uses `Invoke-AzRestMethod` for automatic Azure authentication
- **Required**: `DCE_ENDPOINT` and `DCR_IMMUTABLE_ID` environment variables must be set

**File**: `/tools/CentralView/Modules/ingest-tenantsData/ingest-tenantsData.psm1`
- **Updated**: Central data ingestion to use `Send-GuardrailsData`

**Files**: External account audit modules
- **Updated**: Comments to use `Send-GuardrailsData` syntax

### 3. Complete Infrastructure Templates
**Files**: `/setup/IaC/modules/dataCollectionEndpoint.bicep` and `dataCollectionRules.bicep`
- **Added**: Full Bicep templates for Data Collection Endpoint and Rules
- **Supports**: All log types: GuardrailsCompliance, GuardrailsComplianceException, GRResults, GuardrailsUserRaw, GR2ExternalUsers

## Critical Requirements

### ⚠️ DEPLOYMENT REQUIRED
The solution will **NOT WORK** without deploying the new infrastructure:

1. **Deploy Data Collection Endpoint and Rules**: Use the new Bicep modules
2. **Set Environment Variables**: 
   - `DCE_ENDPOINT` - Data Collection Endpoint URL
   - `DCR_IMMUTABLE_ID` - Data Collection Rule Immutable ID
3. **Update Automation Account**: Ensure managed identity has permissions to write to DCE/DCR

### Prerequisites
- Azure Monitor Data Collection API permissions
- Managed Identity with appropriate roles
- Log Analytics Workspace configured
- Environment variables properly set

## Impact Analysis
- ❌ **Breaking Change** - Requires infrastructure deployment
- ❌ **Old deployments will fail** - OMSIngestionAPI calls removed
- ✅ **Modern ingestion method** - Uses current Azure Monitor API
- ✅ **Future-proof** - Ready for OMSIngestionAPI retirement

## Migration Strategy
**This is a complete migration requiring:**

1. **Before Deployment**: Ensure Log Analytics workspace exists
2. **Deploy Infrastructure**: Run updated Bicep templates to create DCE/DCR
3. **Configure Environment**: Set DCE_ENDPOINT and DCR_IMMUTABLE_ID variables
4. **Verify Permissions**: Ensure managed identity can write to Data Collection API
5. **Test Thoroughly**: All data ingestion will use new API

## Rollback Plan
If issues occur, you must:
1. Revert to previous version with OMSIngestionAPI
2. Or quickly deploy the required Data Collection infrastructure
3. No gradual rollback possible - this is a complete migration