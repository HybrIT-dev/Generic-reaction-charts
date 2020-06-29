# Usage
The values.yaml files have to be customized with proper environment variables and cluster relevant data. 
For a project you can have multiple different value files for different environments, this allows you to use the same chart/image for test/acceptance/production.
We recommend using Git Secret for in project/git management of these files.

## Notes about values
- helm charts do not accept <> in them, replace all of these with proper values.
- for pod/deployment naming helm only accepts lowercase and dashes
- ingress -> tls -> secret names are references to a key, for the same host they should match.
- in the ingress -> host the url needs to be without http or https as the nginx ingress will add these
- values.yaml files cannot contain comments, remove these before usage
