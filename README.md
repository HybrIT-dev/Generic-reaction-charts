### Renaming chart values:
```
./renameChart.sh <old-name> <new-name> <path-to-chart>
```
this wil also change the path from `<path-to-chart>/<old-name>` to `<path-to-chart>/<new-name>`. And adjust the parameters along with it.

### To install the reaction charts:
```
helm upgrade --install --debug -n <namespace> <deployment-name> <path-to-chart> -f <path-to-values-file>
```
