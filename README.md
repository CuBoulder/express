# cu_fit
This is the installation profile all Express and Express Plus sites use.  

New branches should be created from the current dev branch using the Jira issue number the work is most closely tied to (ie FIT-123).  Branches should be merged into dev as soon as basic testing is done.  This will get the code into more issue specific branches any conflicting changes or new issues are more likely to surface before pushing a release.

dev -> FIT-123 -> dev -> release

Critical security issues are committed driectly to release

## Module Manager

The Express Module Manager now includes a report making it very easy to see if a site doesn't have all the modules we expect an Express site to have enabled.  This report is helpful when converting sites from custom to Express Plus, but it's also helpful to deal with forgetful developers who enable or disable a module on prod while trying to debug something.  While they have every intention of going back and reverting the change, that doesn't always happen. 

Module Manager relies on an array of modules to generate this report.  That array must be updated when modules are added or removed from Express or the report will generate fals positives.  We are using a porcess similar to what is required to update Secure Permissions when permission changes are made.  
1. Go to admin/config/development/module-manager/export
2. Copy the array
3. Open cu_module_manager.install 
4. update the array

