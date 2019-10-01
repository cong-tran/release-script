release script
---
Add executed permission to script by command `chmod +x ./release.sh` 

## Steps
- Add new release to `release-notes.md` file in your project with format
```
## v1.69.0 (2019-06-09)
**Merged pull requests:**
 
- OM-6996 [\#69](https://github.com/twentyci/tw-ea/pull/69)`
```

- Run the script: `./release.sh` OR `/bin/bash release.sh`