CloudFormation do
  batch_tags = {}
  batch_tags[:Environment] = Ref(:EnvironmentName)

  tags = external_parameters.fetch(:tags, {})
  batch_tags.merge(tags)
  batch_tags_list = batch_tags.map {|k,v| {Key: k, Value: v}}

  security_group_rules = external_parameters.fetch(:security_group_rules, [])
  ip_blocks = external_parameters.fetch(:ip_blocks, {})

  EC2_SecurityGroup(:BatchSecurityGroup) {
    GroupDescription FnSub("${EnvironmentName} - Batch compute resources security group")
    VpcId Ref(:VpcId)
    SecurityGroupIngress generate_security_group_rules(security_group_rules, ip_blocks, true) unless (security_group_rules.empty? || ip_blocks.empty?)
    Tags batch_tags_list
  }

  IAM_Role(:BatchServiceRole) {
    AssumeRolePolicyDocument service_assume_role_policy('batch')
    ManagedPolicyArns([
      'arn:aws:iam::aws:policy/service-role/AWSBatchServiceRole'
    ])
    Tags batch_tags_list
  }

  environments = external_parameters.fetch(:environments, {})
  environments.each do |name, properties|
    compute_resources = {
      MaxvCpus: properties['max_vcpus'],
      SecurityGroupIds: Ref(:BatchSecurityGroup),
      Subnets: Ref(:SubnetIds),
      Tags: batch_tags,
      Type: properties.fetch('type', 'MANAGED')
    }

    compute_resources[:MinvCpus] = properties['min_vcpus'] if properties.has_key?('min_vcpus')

    Batch_ComputeEnvironment(:"#{name}ComputeEnvironment") {
      ServiceRole FnGetAtt(:BatchServiceRole, :Arn)
      Type properties.fetch('type', 'MANAGED')
      ComputeResources compute_resources
      State properties.fetch('state', 'ENABLED')
      UpdatePolicy({
        TerminateJobsOnUpdate: Ref(:TerminateJobsOnUpdate)
      })
    }
  end

  queues = external_parameters.fetch(:queues, {})
  queues.each do |name, properties|
    Batch_JobQueue(:"#{name}JobQueue") {
      ComputeEnvironmentOrder properties['environments'].map {|env| {ComputeEnvironment: Ref(:"#{env['environment']}ComputeEnvironment"), Order: env['order']}}
      Priority properties['priority']
      State properties.fetch('state', 'ENABLED')
      Tags batch_tags
    }
  end

end
