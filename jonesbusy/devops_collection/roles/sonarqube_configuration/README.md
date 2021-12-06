# Sonarqube configuration role

Configure a Sonarqube instance using the REST API

## Requirement

- A public accessible Sonarqube instance
- psycopg2 system package (if using postgres features of this role) (Like backup, restore etc)
- psycopg2 pip3 package (if using postgres feature of this role) (Like backup, restore etc)


## Documentation

### Usage

Perform sonarqube configuration with default example projet
```
- name: Sonarqube configuration
    ansible.builtin.include_role:
    name: sonarqube_configuration
```

### Tags

Following tags are available

- permissions
- groups
- users
- properties
- quality_gates
- quality_profiles
- projects

## Variables

`sonarqube_configuration_sonarqube_password` must be set to a value different that default password before running the playbook. Via extra vars or directly on the playbook

Default permissions for user and admin

```
sonarqube_configuration_default_user_permissions: ['user', 'codeviewer', 'scan']
sonarqube_configuration_default_admin_permissions: ['admin', 'issueadmin', 'securityhotspotadmin']
```

### Global server properties

```
sonarqube_configuration_default_global_single_properties:
  - key: sonar.core.serverBaseURL
    value: "{{ sonarqube_configuration_sonarqube_url }}"
  - key: sonar.forceAuthentication
    value: "true"
  - key: sonar.lf.enableGravatar
    value: "true"
  - key: projects.default.visibility
    value: private
  - key: sonar.builtInQualityProfiles.disableNotificationOnUpdate
    value: "true"
```

```
sonarqube_configuration_default_global_multi_properties:
  - key: sonar.global.test.exclusions
    value:
      - "**/pom.xml"
      - "**/node_modules"
```

### Groups

```
sonarqube_configuration_internal_groups:
  - name: sonar-users
    description: Any new users created will automatically join this group
    deleted: false
  - name: sonar-administrators
    description: System administrators
    deleted: false
  - name: example-group
    description: Example group
    deleted: false
```

### Users

```
sonarqube_configuration_users:

  # Global administrators
  - login: admin
    email: ''
    name: admin
    local: true
    deleted: false
    groups:
      - name: sonar-users
        assigned: true
      - name: sonar-administrators
        assigned: true

  # Example local user
  - login: example-user
    email: ''
    local: true
    name: example-user
    password: sonarqube
    deleted: false
    groups:
      - name: example-group
        assigned: true

  - login: example-external-user
    email: ''
    local: false
    name: example-user
    deleted: false
    groups:
      - name: example-group
        assigned: true
```

### Permission template

```
sonarqube_configuration_permission_templates:
  - name: template1
    description: Created automatically via Ansible sonarqube configuration role
    pattern: template1-.*
    deleted: false
    groups:
      - name: sonar-users
        assigned: true
```

### Projets

```
# Default projects
sonarqube_configuration_projects:
  - name: example-projet-created-by-ansible
    key: example-projet-created-by-ansible
    visibility: private
    quality_gate: Sonar way
    deleted: false
    quality_profiles:
      - name: Custom way
        language: java
        deleted: false
    new_code:
      type: NUMBER_OF_DAYS
      value: 1
    permission_template: template1
```

### Quality gates

```
sonarqube_configuration_quality_gates:
  - name: Example projets
    default: false
    deleted: false
  - name: Example New projects
    default: true
    deleted: false
    conditions:
      - metric: security_rating
        error: 1
        op: GT
        deleted: false
      - metric: reliability_rating
        error: 1
        op: GT
        deleted: false
      - metric: security_hotspots_reviewed
        error: 100
        op: LT
        deleted: false
      - metric: coverage
        error: 60
        op: LT
        deleted: false
  - name: Example New projects without coverage
    default: true
    deleted: false
    conditions:
      - metric: security_rating
        error: 1
        op: GT
        deleted: false
      - metric: reliability_rating
        error: 1
        op: GT
        deleted: false
      - metric: security_hotspots_reviewed
        error: 100
        op: LT
        deleted: false
  - name: Example Legacy
    default: false
    deleted: false
    conditions:
      - metric: new_security_rating
        error: 1
        op: GT
        deleted: false
      - metric: new_reliability_rating
        error: 1
        op: GT
        deleted: false
      - metric: new_security_hotspots_reviewed
        error: 100
        op: LT
        deleted: false
      - metric: new_coverage
        error: 60
        op: LT
        deleted: false
```

### Quality profiles

```

```