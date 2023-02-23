# batch CfHighlander Component

![cftest](https://github.com/theonestack/hl-component-batch/actions/workflows/rspec.yaml/badge.svg)

<!--- add component description --->

```bash
kurgan add batch
```

## Requirements

## Parameters

| Name | Use | Default | Global | Type | Allowed Values |
| ---- | --- | ------- | ------ | ---- | -------------- |
| EnvironmentName | Tagging | dev | true | String | 
| EnvironmentType | Tagging | development | true | String | ['development','production']
| VpcId | | | false | AWS::EC2::VPC::Id |
| SubnetIds | | | false | CommaDelimitedList |
| TerminateJobsOnUpdate | Specifies whether jobs are automatically terminated when the computer environment infrastructure is updated | false | false | Bool | [true, false]


## Configuration

**compute environments**

this component currently supports fargate and fargate spot compute environments

```yaml
environments:
  Fargate:
    compute_type: FARGATE
    max_vcpus: 100
    type: 'MANAGED'
```

```yaml
environments:
  FargateSpot:
    compute_type: FARGATE_SPOT
    max_vcpus: 10000
    state: 'DISABLED'
```

**job queues**

```yaml
queues:
  Fargate:
    environments:
    - environment: Fargate # reference the name of your compute environment
      order: 1
    priority: 1
```

**tags**

```yaml
tags:
  Locale: AU
```

## Outputs/Exports

| Name | Value | Exported |
| ---- | ----- | -------- |
| ComputeEnvironment | Name of the compute environment | true
| JobQueue | Name of the job queue | true

## Development

```bash
gem install cfhighlander
```

or via docker

```bash
docker pull theonestack/cfhighlander
```

### Testing

Generate cftest

```bash
kurgan test example
```

Run cftest

```bash
cfhighlander cftest -t tests/example.test.yaml
```

or run all tests

```bash
cfhighlander cftest
```

Generate spec tests

```bash
kurgan test example --type spec
```

run spec tests

```bash
gem install rspec
```

```bash
rspec
```