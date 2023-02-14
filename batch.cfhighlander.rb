CfhighlanderTemplate do
  Name 'batch'
  Description "batch - #{component_version}"

  DependsOn 'lib-ec2'
  DependsOn 'lib-iam'
  
  Parameters do
    ComponentParam 'EnvironmentName', 'dev', isGlobal: true
    ComponentParam 'EnvironmentType', 'development', allowedValues: ['development','production'], isGlobal: true

    ComponentParam 'VpcId', type: 'AWS::EC2::VPC::Id'
    ComponentParam 'SubnetIds', type: 'CommaDelimitedList'
    ComponentParam 'TerminateJobsOnUpdate', false
  end

end
